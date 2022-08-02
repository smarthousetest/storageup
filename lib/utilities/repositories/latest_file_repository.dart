// import 'package:cpp_native/cpp_native.dart';
import 'package:cpp_native/models/file.dart';
import 'package:cpp_native/models/record.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:os_specification/os_specification.dart';

const _latestFileBoxName = 'latestFileBox';

@lazySingleton
class LatestFileRepository {
  late List<Record> _latestFileInfo;
  late Box<Record> _latestFileBox;

  @factoryMethod
  static Future<LatestFileRepository> create() async {
    //Hive.deleteFromDisk();

    if (!Hive.isAdapterRegistered(7) && !Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(RecordAdapter());
      Hive.registerAdapter(FileAdapter());
    }

    WidgetsFlutterBinding.ensureInitialized();
    var os = OsSpecifications.getOs();
    Hive.init(os.supportDir);

    final latestFileBox = await Hive.openBox<Record>(_latestFileBoxName);
    //box.deleteFromDisk();
    return LatestFileRepository._(latestFileBox: latestFileBox);
  }

  Future<void> init() async {
    _latestFileBox = await Hive.openBox<Record>(_latestFileBoxName);
  }

  LatestFileRepository._({required Box<Record> latestFileBox}) {
    _latestFileBox = latestFileBox;
    _latestFileInfo = _latestFileBox.values.toList();

    _latestFileBox.watch().listen((event) {
      final key = event.key;
      final value = event.value;

      if (_latestFileInfo.any((element) => element.id == key)) {
        final currentLocationInfoIndex =
            _latestFileInfo.indexWhere((element) => element.id == key);

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

  List<Record> get getLatestFile => _latestFileBox.values.toList();

  // set setlocationsInfo(List<DownloadLocation> locationsInfo) =>
  //     _locationsInfo = locationsInfo;

  ValueListenable<Box<Record>> getLatestFilesValueListenable() {
    return _latestFileBox.listenable();
  }

  Future<void> addFiles({
    required List<Record> latestFile,
  }) async {
    final List<Record> latestFileInfo = latestFile.map((e) => e).toList();

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
