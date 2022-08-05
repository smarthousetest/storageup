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

    double totalSizeInMB = 0;
    List<RemoveCandidateFile> removeCandidates = [];

    await for (var item
        in appDownloadFolder.list(recursive: true, followLinks: false)) {
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
        if (item is File) {
          double itemSize = item.lengthSync() / 1024 / 1024;
          totalSizeInMB += itemSize;

          removeCandidates.add(
            RemoveCandidateFile(
              filePath: item.path,
              size: itemSize,
              lastAccessed: itemStat.accessed,
            ),
          );
        }
        print('Should not be deleted');
      }
    }

    print('Total cache size in MB: ${totalSizeInMB}');

    removeCandidates.sort(((a, b) {
      return a.lastAccessed.compareTo(b.lastAccessed);
    }));

    if (totalSizeInMB >= kCleanStartSizeInMB) {
      for (var item in removeCandidates) {
        if (totalSizeInMB < kCleanStartSizeInMB) {
          break;
        }

        try {
          File(item.filePath).deleteSync();
          print(
            'Cleaned ${item.filePath} with size ${item.size} MB and last accessed ${item.lastAccessed}',
          );
        } on Exception catch (e) {
          print('File is not deleted $e');
        }

        totalSizeInMB -= item.size;
      }
    } else {
      print(
          'No additional cleanup required: ${totalSizeInMB} < ${kCleanStartSizeInMB}');
    }
  }
}

class RemoveCandidateFile {
  final String filePath;
  final double size;
  final DateTime lastAccessed;

  RemoveCandidateFile(
      {required this.filePath, required this.size, required this.lastAccessed});
}
