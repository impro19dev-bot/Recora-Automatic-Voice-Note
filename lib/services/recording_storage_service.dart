import 'dart:io';

import 'package:path_provider/path_provider.dart';

class RecordingStorageService {
  static const _folderName = 'recora_notes';

  Future<Directory> getRecordingsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/$_folderName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<String> createRecordingPath() async {
    final dir = await getRecordingsDirectory();
    final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    return '${dir.path}/$fileName';
  }

  Future<bool> fileExists(String path) async {
    return File(path).exists();
  }

  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
