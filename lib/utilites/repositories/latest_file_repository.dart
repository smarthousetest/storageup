// import 'package:cpp_native/cpp_native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/models/file.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/latest_file.dart';
import 'package:os_specification/os_specification.dart';

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
    var os = OsSpecifications.getOs();
    Hive.init(os.appDirPath.substring(0, os.appDirPath.length - 1));

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

  List<LatestFile> get getLatestFile => _latestFileInfo;

  // set setlocationsInfo(List<DownloadLocation> locationsInfo) =>
  //     _locationsInfo = locationsInfo;

  ValueListenable<Box<LatestFile>> getLatestFilesValueListenable() {
    return _latestFileBox.listenable();
  }

  void addFile({
    required Record latestFile,
  }) {
    //_latestFileBox.clear();
    final latestFileInfo = LatestFile(
      latestFile: latestFile,
    );

    _latestFileBox.add(
      latestFileInfo,
    );

    if (_latestFileBox.values.length > 5) {
      deleteFile(id: _latestFileBox.values.toList()[0].key);
    }
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
