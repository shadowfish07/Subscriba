import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/currency_select/currency_select_view.dart';
import 'package:subscriba/src/database/model.dart';
import 'package:subscriba/src/settings/settings_model.dart';
import 'package:subscriba/src/util/file_helper.dart';

var logger = Logger(
  filter: ProductionFilter(),
);

// Function to compare two versions
int compareVersion(String version1, String version2) {
  List<String> nums1 = version1.split(".");
  List<String> nums2 = version2.split(".");
  int n1 = nums1.length, n2 = nums2.length;

  // compare versions
  int i1, i2;
  for (int i = 0; i < n1 || i < n2; i++) {
    i1 = i < n1 ? int.parse(nums1[i]) : 0;
    i2 = i < n2 ? int.parse(nums2[i]) : 0;
    if (i1 != i2) {
      return i1 > i2 ? 1 : -1;
    }
  }

  // the versions are equal
  return 0;
}

// Function to check if the current version needs to update
bool needUpdate(String currentVersion, String serverVersion) {
  // If the current version is less than the server version, return true
  return compareVersion(currentVersion, serverVersion) == -1;
}

class AboutView extends StatelessWidget {
  static const routeName = '/about';

  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [_AppInfo(), _Settings()],
    ));
  }
}

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

class _AppInfo extends StatelessWidget {
  const _AppInfo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 100.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: const Image(
                width: 100,
                image: AssetImage('assets/images/play_store_512.png')),
          ), // Replace 'images/app_icon.png' with the path of app logo
          const SizedBox(height: 20.0),
          Text(
            "Subscriba",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10.0),
          FutureBuilder(
              future: getAppVersion(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                return Text(
                  "v${snapshot.data}",
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }),
          const SizedBox(height: 30.0),
          // Add more ListTile for more settings
        ],
      ),
    );
  }
}

class _Settings extends StatelessWidget {
  const _Settings();

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);
    Future<void> showLoadingDialog() {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(20.0), // 添加内间距
                child: const Row(
                  // 对话框中的布局为一行
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                      // 添加一些间距
                      padding: EdgeInsets.only(left: 16),
                    ),
                    Text("Importing..."), // 你可以在此处添加一些自定义的文本
                  ],
                ),
              ),
            );
          });
    }

    return Column(
      children: [
        const _CheckForUpdate(),
        ListTile(
          leading: const Icon(Icons.currency_exchange),
          title: const Text('Default currency'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Observer(builder: (context) {
                return Text(settingsModel.defaultCurrency.ISOCode);
              }),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () async {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CurrencySelectView(
                          selectedCurrency: settingsModel.defaultCurrency,
                        )));
            if (result != null) {
              settingsModel.updateDefaultCurrency(result);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.file_upload),
          title: const Text('Export data'),
          onTap: () async {
            final data = await BaseModalProvider.export();
            FileHelper.createAndShareTempFile(jsonEncode(data), "output.json");
          },
        ),
        ListTile(
          leading: const Icon(Icons.file_download),
          title: const Text('Import data'),
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              try {
                showLoadingDialog();
                File file = File(result.files.single.path!);
                String jsonString = await file.readAsString();
                await BaseModalProvider.import(jsonDecode(jsonString));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully Imported'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Importing Failed'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } finally {
                Navigator.of(context).pop();
              }
            }
          },
        ),
      ],
    );
  }
}

class _CheckForUpdate extends StatefulWidget {
  const _CheckForUpdate({
    super.key,
  });

  @override
  _CheckForUpdateState createState() => _CheckForUpdateState();
}

Future<void> downloadFile(
    String url, String filename, Function(int, int?) onProgress) async {
  var request = await HttpClient().getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response,
      onBytesReceived: onProgress);
  File file = File(filename);
  await file.writeAsBytes(bytes);
}

class _CheckForUpdateState extends State<_CheckForUpdate> {
  bool _isLoading = false;
  String? latestVersion;
  double? downloadProgress;
  String? url;
  bool isNeedUpdate = false;

  Future<String> downloadAPK() async {
    safeSetState(() {
      downloadProgress = 0;
    });
    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/$latestVersion-subscriba.apk";
    await downloadFile(url!, path, (current, total) {
      if (total == null) {
        safeSetState(() {
          downloadProgress = -1;
        });
        return;
      }

      safeSetState(() {
        downloadProgress = current / total;
      });
    });
    return path;
  }

  Future<bool> tryGrantPermission() async {
    if (await Permission.requestInstallPackages.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> installAPK(String path) async {
    await OpenFile.open(path);
    safeSetState(() {
      downloadProgress = null;
      isNeedUpdate = false;
      url = null;
      latestVersion = null;
    });
  }

  void safeSetState(void Function() fn) {
    if (mounted) {
      setState(fn);
    }
  }

  Future<void> getLatestVersion() async {
    safeSetState(() {
      _isLoading = true;
    });

    try {
      var response = await http
          .get(Uri.https('subscrik-update-uxuaswgvnk.cn-hongkong.fcapp.run'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 500) {
        logger.e("Failed to obtain version information(500)",
            error: response.body, stackTrace: StackTrace.current);
        showSnackBar(
            'Failed to obtain version information, please try again later.');
        return;
      }

      if (response.statusCode == 403) {
        logger.e("Failed to obtain version information(403)",
            error: response.body, stackTrace: StackTrace.current);
        showSnackBar(
            'Failed to obtain version information, please try again later.');
        return;
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final currentVersion = await getAppVersion();
        safeSetState(() {
          latestVersion = data['latestVersion'];
          url = data['url'];
          isNeedUpdate = latestVersion == null
              ? false
              : needUpdate(currentVersion, latestVersion!);
        });
      }
    } on TimeoutException catch (e) {
      logger.e("Failed to obtain version information(timeout)",
          error: e, stackTrace: StackTrace.current);
      showSnackBar(
          'Failed to obtain version information due to a network timeout. Please try again later.');
    } catch (e) {
      logger.e("Failed to obtain version information",
          error: e, stackTrace: StackTrace.current);
      showSnackBar(
          'Failed to obtain version information, please try again later.');
    } finally {
      safeSetState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLatestVersion();
  }

  showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    onTap() async {
      if (downloadProgress != null &&
          downloadProgress! >= 0 &&
          downloadProgress! < 1) {
        return;
      }

      if (url != null &&
          isNeedUpdate &&
          latestVersion != null &&
          downloadProgress != 1) {
        try {
          final path = await downloadAPK();

          if (await tryGrantPermission()) {
            await installAPK(path);
          } else {
            showSnackBar('Permission denied');
          }
          return;
        } catch (e) {
          showSnackBar(
              'Failed to obtain version information, please try again later.');
          return;
        }
      }

      getLatestVersion();
    }

    return ListTile(
      leading: const Icon(Icons.update),
      title: const Text('Check for updates'),
      trailing: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ))
          : downloadProgress != null
              ? downloadProgress == -1
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Downloading"),
                        SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(downloadProgress == 1
                            ? "Downloaded"
                            : "Downloading"),
                        const SizedBox(width: 8),
                        SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: downloadProgress,
                            ))
                      ],
                    )
              : isNeedUpdate
                  ? Text('Latest version $latestVersion')
                  : latestVersion == null
                      ? null
                      : const Text("Up to date"),
      onTap: onTap,
    );
  }
}
