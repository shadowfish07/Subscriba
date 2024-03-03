import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileHelper {
  static Future<void> createAndShareTempFile(
      String textToShare, String fileName) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');

    await file.writeAsString(textToShare);

    Share.shareXFiles([XFile(file.path)]);
  }
}
