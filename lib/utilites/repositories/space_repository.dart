import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:os_specification/os_specification.dart';
import 'package:upstorage_desktop/models/download_location.dart';

const _downloadLocationsBoxName = 'donwnloadLocationsBox';

@lazySingleton
class DownloadLocationsRepository {
  late List<DownloadLocation> _locationsInfo;
  late Box<DownloadLocation> _locationsBox;

  @factoryMethod
  static Future<DownloadLocationsRepository> create() async {
    Hive.registerAdapter(DownloadLocationAdapter());
    WidgetsFlutterBinding.ensureInitialized();
    var os = OsSpecifications.getOs();
    Hive.init(os.supportDir);
    final box = await Hive.openBox<DownloadLocation>(_downloadLocationsBoxName);
    return DownloadLocationsRepository._(locationsBox: box);
  }

  DownloadLocationsRepository._({required Box<DownloadLocation> locationsBox}) {
    _locationsBox = locationsBox;
    _locationsInfo = _locationsBox.values.toList();

    _locationsBox.watch().listen(
      (event) {
        final key = event.key;
        final value = event.value;

        if (_locationsInfo.any((element) => element.id == key)) {
          final currentLocationInfoIndex = _locationsInfo.indexWhere((element) => element.id == key);

          if (event.deleted) {
            _locationsInfo.removeAt(currentLocationInfoIndex);
          } else {
            _locationsInfo[currentLocationInfoIndex] = value;
          }
        } else {
          _locationsInfo.add(value);
        }
      },
    );
  }

  List<DownloadLocation> get locationsInfo => _locationsBox.values.toList();

  ValueListenable<Box<DownloadLocation>> get getDownloadLocationsValueListenable => _locationsBox.listenable();

  int createLocation({
    required String path,
    required int countOfGb,
    required String name,
    required String idForCompare,
  }) {
    var lastKey;
    try {
      lastKey = _locationsBox.keys.last;
    } catch (e) {}

    final downloadLocation = DownloadLocation(
      dirPath: path,
      countGb: countOfGb,
      id: lastKey != null ? lastKey + 1 : 0,
      name: name,
      keeperId: idForCompare,
    );

    _locationsBox.put(
      downloadLocation.id,
      downloadLocation,
    );
    return downloadLocation.id;
  }

  void changeLocation({required DownloadLocation location}) {
    _locationsBox.put(location.id, location);
  }

  Future<void> deleteLocation({required int id}) async {
    final Map<dynamic, DownloadLocation> mapKey = _locationsBox.toMap();
    dynamic deletingKey;
    mapKey.forEach((key, value) {
      if (value.id == id) {
        deletingKey = key;
      }
    });
    if (deletingKey != null) {
      await _locationsBox.delete(deletingKey);
    }
  }
}
