import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/upload_media.dart';

import 'models/upload_state.dart';

class UploadMediaRepo {
  late Box<UploadMedia> _box;

  Future<UploadMediaRepo> init() async {
    var pathBD = await getApplicationSupportDirectory();
    Hive.init(pathBD.path);
    Hive.registerAdapter(AutouploadStateAdapter());
    Hive.registerAdapter(UploadMediaAdapter());
    _box = await Hive.openBox('files_hashes');
    return this;
  }

  Stream<BoxEvent> listen() {
    return _box.watch();
  }

  Stream<BoxEvent> listenByKey(dynamic key) {
    return _box.watch(key: key);
  }

  Map<dynamic, UploadMedia> getAllDB() {
    return _box.toMap();
  }

  bool containsIndex(int index) {
    return _box.containsKey(index);
  }

  void addMedia(String id) {
    _box.add(
        UploadMedia(nativeStorageId: id, state: AutouploadState.notSended));
  }

  UploadMedia? getUploadMedia(int index) {
    return _box.get(index);
  }

  List<int> getKeys() {
    return _box.keys.map((item) => item as int).toList();
  }

  Future<void> deleteKey(int index) async {
    await _box.delete(index);
  }

  Future<void> clearDB() async {
    await _box.clear();
  }

  List<UploadMedia> getValues() {
    return _box.values.toList();
  }

  Future<void> update(int index, UploadMedia media) async {
    await _box.putAt(index, media);
  }
}
