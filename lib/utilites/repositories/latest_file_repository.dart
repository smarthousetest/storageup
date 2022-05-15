import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/models/file.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/latest_file.dart';

const _latestFileBoxName = 'latestFileBox';

@lazySingleton
class LatestFileRepository {
  late List<LatestFile> _latestFileInfo;
  late Box<LatestFile> _latestFileBox;

  @factoryMethod
  static Future<LatestFileRepository> create() async {
    //Hive.deleteFromDisk();

    Hive.registerAdapter(LatestFileAdapter());
    Hive.registerAdapter(RecordAdapter());
    Hive.registerAdapter(FileAdapter());

    WidgetsFlutterBinding.ensureInitialized();
    final appPath = await getApplicationDocumentsDirectory();

    Hive.init(appPath.path);

    final box = await Hive.openBox<LatestFile>(_latestFileBoxName);
    //box.deleteFromDisk();
    return LatestFileRepository._(latestFileBox: box);
  }

  LatestFileRepository._({required Box<LatestFile> latestFileBox}) {
    _latestFileBox = latestFileBox;
    _latestFileInfo = _latestFileBox.values.toList();

    _latestFileBox.watch().listen((event) {
      final key = event.key;
      final value = event.value;

      if (_latestFileInfo.any((element) => element.latestFile.id == key)) {
        final currentLocationInfoIndex = _latestFileInfo
            .indexWhere((element) => element.latestFile.id == key);

        if (event.deleted)
          _latestFileInfo.removeAt(currentLocationInfoIndex);
        else
          _latestFileInfo[currentLocationInfoIndex] = value;
      } else {
        if (value != null) {
          _latestFileInfo.add(value);
        }
      }
    });
  }

  List<LatestFile> get getLatestFile => _latestFileBox.values.toList();

  // set setlocationsInfo(List<DownloadLocation> locationsInfo) =>
  //     _locationsInfo = locationsInfo;

  ValueListenable<Box<LatestFile>> getLatestFilesValueListenable() {
    return _latestFileBox.listenable();
  }

  Future<void> addFiles({
    required List<Record> latestFile,
  }) async {
    final List<LatestFile> latestFileInfo =
        latestFile.map((e) => LatestFile(latestFile: e)).toList();

    await _latestFileBox.clear();

    _latestFileBox.addAll(
      latestFileInfo,
    );
  }

  Future<void> deleteFile({required int id}) async {
    // final Map<dynamic, DownloadLocation> mapKey = _locationsBox.toMap();
    // dynamic deletingKey;
    // mapKey.forEach((key, value) {
    //   if (value.id == id) {
    //     deletingKey = key;
    //   }
    // });
    // if (deletingKey != null) {
    await _latestFileBox.delete(id);
    // }
  }
}
