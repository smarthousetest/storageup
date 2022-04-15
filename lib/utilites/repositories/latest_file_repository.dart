import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
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
      _latestFileInfo.add(value);
    });
  }

  List<LatestFile> get getLatestFile => _latestFileInfo;

  // set setlocationsInfo(List<DownloadLocation> locationsInfo) =>
  //     _locationsInfo = locationsInfo;

  void addFile({
    required Record latestFile,
  }) {
    final latestFileInfo = LatestFile(
      latestFile: latestFile,
    );

    if (_latestFileInfo.isEmpty ||
        (_latestFileInfo.last.latestFile.id != latestFile.id)) {
      _latestFileBox.add(
        latestFileInfo,
      );
    }

    if (_latestFileBox.values.length > 3) {
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
