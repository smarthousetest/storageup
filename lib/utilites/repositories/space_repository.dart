import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';

const _downloadLocationsBoxName = 'donwnloadLocationsBox';

@lazySingleton
class DownloadLocationsRepository {
  late List<DownloadLocation> _locationsInfo;
  late Box<DownloadLocation> _locationsBox;

  @factoryMethod
  static Future<DownloadLocationsRepository> create() async {
    //Hive.deleteFromDisk();
    Hive.registerAdapter(DownloadLocationAdapter());

    final box = await Hive.openBox<DownloadLocation>(_downloadLocationsBoxName);
    //box.deleteFromDisk();
    return DownloadLocationsRepository._(locationsBox: box);
  }

  DownloadLocationsRepository._({required Box<DownloadLocation> locationsBox}) {
    _locationsBox = locationsBox;
    _locationsInfo = _locationsBox.values.toList();

    _locationsBox.watch().listen((event) {
      final key = event.key;
      final value = event.value;

      if (_locationsInfo.any((element) => element.id == key)) {
        final currentLocationInfoIndex =
            _locationsInfo.indexWhere((element) => element.id == key);

        if (event.deleted)
          _locationsInfo.removeAt(currentLocationInfoIndex);
        else
          _locationsInfo[currentLocationInfoIndex] = value;
      } else {
        _locationsInfo.add(value);
      }
    });
  }

  List<DownloadLocation> get getlocationsInfo => _locationsBox.values.toList();

  // set setlocationsInfo(List<DownloadLocation> locationsInfo) =>
  //     _locationsInfo = locationsInfo;

  void createLocation(
      {required String path,
      required int countOfGb,
      required String name,
      required String idForCompare}) {
    var lastKey;
    try {
      lastKey = _locationsBox.keys.last;
    } catch (e) {
      lastKey = 0;
    }

    final downloadLocation = DownloadLocation(
      dirPath: path,
      countGb: countOfGb,
      id: lastKey != null ? lastKey + 1 : 0,
      name: name,
      idForCompare: idForCompare,
    );

    _locationsBox.put(
      downloadLocation.id,
      downloadLocation,
    );
  }

  void changelocation({required DownloadLocation location}) {
    _locationsBox.put(location.id, location);
  }

  Future<void> deleteLocation({required int id}) async {
    // final Map<dynamic, DownloadLocation> mapKey = _locationsBox.toMap();
    // dynamic deletingKey;
    // mapKey.forEach((key, value) {
    //   if (value.id == id) {
    //     deletingKey = key;
    //   }
    // });
    // if (deletingKey != null) {
    await _locationsBox.delete(id);
    // }
  }
}
