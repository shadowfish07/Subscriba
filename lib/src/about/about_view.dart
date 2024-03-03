import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:subscriba/src/database/model.dart';
import 'package:subscriba/src/util/file_helper.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [_AppInfo(), _Settings()],
    ));
  }
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
          Text(
            "v1.0.0",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
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
        ListTile(
          leading: const Icon(Icons.file_upload),
          title: const Text('导出数据'),
          onTap: () async {
            final data = await BaseModalProvider.export();
            debugPrint(jsonEncode(data));
            FileHelper.createAndShareTempFile(jsonEncode(data), "output.json");
          },
        ),
        ListTile(
          leading: const Icon(Icons.file_download),
          title: const Text('导入数据'),
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
