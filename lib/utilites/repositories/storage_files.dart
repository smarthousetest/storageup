import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:os_specification/os_specification.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/file.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';

const _objectsBoxName = 'LocalStorage.objectsBox.name';
const _relationsBoxName = 'LocalStorage.relationsBox.name';

const mediaRootFolderKey = 'LocalStorage.mediaRootFolderKey';
const filesRootFolderKey = 'LocalStorage.filesRootFolderKey';
const shimmerKey = 'LocalStorage.shimmer';

class LocalStorage {
  Box<BaseObject> _objectsBox;
  Box<List<String>> _relationsBox;

  List<BaseObject> _objectsToDelete = [];

  Box<BaseObject> get getObjectsBox => _objectsBox;

  @factoryMethod
  static Future<LocalStorage> create() async {
    print('Hive initialized');

    Hive.registerAdapter(FileAdapter());
    Hive.registerAdapter(RecordAdapter());
    Hive.registerAdapter(FolderAdapter());

    WidgetsFlutterBinding.ensureInitialized();
    var os = OsSpecifications.getOs();
    Hive.init(os.supportDir);

    final objectsBox = await Hive.openBox<BaseObject>(_objectsBoxName);
    final relationsBox = await Hive.openBox<List<String>>(_relationsBoxName);

    return LocalStorage._(
      objectsBox: objectsBox,
      relationsBox: relationsBox,
    );
  }

  Future<void> init() async {
    _objectsBox = await Hive.openBox<BaseObject>(_objectsBoxName);
    _relationsBox = await Hive.openBox<List<String>>(_relationsBoxName);
  }

  LocalStorage._({
    required Box<BaseObject> objectsBox,
    required Box<List<String>> relationsBox,
  })  : _objectsBox = objectsBox,
        _relationsBox = relationsBox {
    _objectsToDelete.addAll(_objectsBox.values.where((element) => element.isInProgress || element.loadPercent != null || element.endedWithException));
  }

  ///Adding [Folder] and it's childs to local storage
  ///
  ///If this folder is root, then need to provide one String key:
  ///[filesRootFolderKey] or [mediaRootFolderKey]
  void addFolder({required Folder folder, String? rootKey}) {
    final childsList = List<String>.empty(growable: true);

    folder.records?.forEach((record) {
      childsList.add(record.id);

      if (_objectsBox.containsKey(record.id)) {
        final recordFromDB = _objectsBox.get(record.id) as Record;

        _objectsBox.put(record.id, record.copyWith(path: recordFromDB.path));
      } else {
        _objectsBox.put(record.id, record);
      }
    });

    folder.folders?.forEach((folder) {
      childsList.add(folder.id);

      _objectsBox.put(folder.id, folder);
    });

    final relations = _relationsBox.get(folder.id);

    if (relations != null && relations.isNotEmpty) {
      if (relations != childsList) {
        relations.forEach((element) {
          if (!childsList.contains(element)) {
            _objectsBox.delete(element);
          }
        });
      }
    }

    _relationsBox.put(folder.id, childsList);

    final hiveFolderModel = folder.toHiveModel();

    _objectsBox.put(hiveFolderModel.id, hiveFolderModel);

    addRelation(folder.id, folder.parentFolder!);

    if (rootKey != null) {
      _relationsBox.put(rootKey, [folder.id]);
    }
  }

  void addRelation(String id, String parentFolderId) {
    final objectsList = _relationsBox.get(parentFolderId);

    if (objectsList != null && !objectsList.contains(id)) {
      objectsList.add(id);

      _relationsBox.put(parentFolderId, objectsList);
    } else if (objectsList == null) {
      _relationsBox.put(parentFolderId, [id]);
    }
  }
}
