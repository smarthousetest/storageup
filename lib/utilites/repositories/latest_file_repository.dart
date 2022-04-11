import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/latest_file.dart';

const _latestFileBoxName = 'latestFileBox';

@lazySingleton
class LatestFileRepository {
  late List<LatestFile> _fileInfo;
  late Box<LatestFile> _fileBox;

  @factoryMethod
  static Future<LatestFileRepository> create() async {
    //Hive.deleteFromDisk();
    Hive.registerAdapter(LatestFileAdapter());

    final box = await Hive.openBox<LatestFile>(_latestFileBoxName);

    return LatestFileRepository._(fileBox: box);
  }

  LatestFileRepository._({required Box<LatestFile> fileBox}) {
    _fileBox = fileBox;
    _fileInfo = _fileBox.values.toList();

    _fileBox.watch().listen((event) {
      final key = event.key;
      final value = event.value;

      if (_fileInfo.any((element) => element.id == key)) {
        final currentFileInfoIndex =
            _fileInfo.indexWhere((element) => element.id == key);

        if (event.deleted)
          _fileInfo.removeAt(currentFileInfoIndex);
        else
          _fileInfo[currentFileInfoIndex] = value;
      } else {
        _fileInfo.add(value);
      }
    });
  }

  List<LatestFile> get getLatestFile => _fileInfo;

  void addFile({
    required Record file,
  }) {
    var lastKey;
    try {
      lastKey = _fileBox.keys.last;
    } catch (e) {
      lastKey = 0;
    }

    final latestFile = LatestFile(
      latestFile: file,
      id: lastKey != null ? lastKey + 1 : 0,
    );

    _fileBox.put(
      latestFile.id,
      latestFile,
    );
  }

  // void changelocation({required LatestFile location}) {
  //   _fileBox.put(location.id, location);
  // }

  Future<void> deleteLocation({required int id}) async {
    // final Map<dynamic, DownloadLocation> mapKey = _locationsBox.toMap();
    // dynamic deletingKey;
    // mapKey.forEach((key, value) {
    //   if (value.id == id) {
    //     deletingKey = key;
    //   }
    // });
    // if (deletingKey != null) {
    await _fileBox.delete(id);
    // }
  }
}
