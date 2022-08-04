import 'dart:io';
import 'dart:isolate';
import 'package:storageup/constants.dart';
import 'package:storageup/utilities/extensions.dart';

class CacheCleanerService {
  Future<void> cleanInIsolate() async {
    String appDownloadFolder = await getDownloadAppFolder();

    if (!await Directory(appDownloadFolder).exists()) {
      return;
    }

    await Isolate.spawn((String appDownloadFolderPath) async {
      await clean(appDownloadFolderPath);
    }, appDownloadFolder);
  }

  Future<void> clean(String appDownloadFolderPath) async {
    Directory appDownloadFolder = Directory(appDownloadFolderPath);
    DateTime currentTime = DateTime.now();

    await for (var item in appDownloadFolder.list(recursive: true)) {
      var itemStat = await item.stat();
      var timeAfterLastAccess = currentTime.difference(itemStat.accessed);

      print(item.path);
      print(itemStat);
      print(timeAfterLastAccess);

      if (timeAfterLastAccess > kCleanCachedFileAfterNotAccessedDuration) {
        print('Item should be deleted');
        if (item is File) {
          try {
            await item.delete();
            print('File is deleted');
          } on Exception catch (e) {
            print('File is not deleted $e');
          }
        }
      } else {
        print('Should not be deleted');
      }
    }
  }
}
