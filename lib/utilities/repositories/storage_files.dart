import 'package:cpp_native/models/file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:os_specification/os_specification.dart';
import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/record.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:storageup/utilities/errors/local_storage.errors.dart';

const _objectsBoxName = 'LocalStorage.objectsBox.name';
const _relationsBoxName = 'LocalStorage.relationsBox.name';

const mediaRootFolderKey = 'LocalStorage.mediaRootFolderKey';
const filesRootFolderKey = 'LocalStorage.filesRootFolderKey';
const shimmerKey = 'LocalStorage.shimmer';

@lazySingleton
class LocalStorage {
  Box<BaseObject> _objectsBox;
  Box<List<String>> _relationsBox;

  List<BaseObject> _objectsToDelete = [];

  Box<BaseObject> get getObjectsBox => _objectsBox;
  List<BaseObject> get getObjectsToDelete => _objectsToDelete;

  @factoryMethod
  static Future<LocalStorage> create() async {
    print('Hive initialized');

    Hive.registerAdapter(FileAdapter());
    // Hive.registerAdapter(BaseObjectAdapter());
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
    // _objectsBox.toMap().forEach((key, value) {
    //   // final parentRelations = _relationsBox.get(value.parentFolder);
    //   // final hasParentReference = !(parentRelations?.contains(value.id) ?? true);
    //   // if (hasParentReference) {
    //   //   _objectsBox.delete(key);
    //   // } else
    //   if (value.isInProgress || value.loadPercent != null) {
    //     if (value is Folder) {
    //       final newValue = value.copyWith(
    //         loadPercent: null,
    //       );

    //       _objectsBox.put(key, newValue);
    //     } else if (value is Record) {
    //       final newValue = value.copyWith(
    //         loadPercent: null,
    //         isInProgress: false,
    //       );

    //       _objectsBox.put(key, newValue);
    //     }
    //   }
    // });

    _objectsToDelete.addAll(_objectsBox.values.where((element) =>
        element.isInProgress ||
        element.loadPercent != null ||
        element.endedWithException));

    _removeShimmer();
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

  List<String>? getObjectsIdsFromFolder(String folderId) {
    if (folderId != '-1') return _relationsBox.get(folderId);

    final mediaRootFolder = getObjectsIdsFromFolder(mediaRootFolderKey)![0];

    List<String>? objectsId = [];

    final objects = getObjectsIdsFromFolder(mediaRootFolder);

    objects?.forEach((element) {
      if (element != '-1') {
        final records = getObjectsIdsFromFolder(element);
        if (records != null && records.isNotEmpty) objectsId.addAll(records);
      }
    });

    return objectsId;
  }

  ///Helps get media or files root folder id using
  ///one of default strings provided in this class
  ///[filesRootFolderKey] or [mediaRootFolderKey]
  ///Do not use this to get any other ralations!
  String? getRootFolderId(String key) {
    final folderId = _relationsBox.get(key);

    if (folderId != null) {
      return folderId.first;
    } else {
      return null;
    }
  }

  BaseObject? getObject(String id) {
    final object = _objectsBox.get(id);

    return object;
  }

  void setObject(BaseObject object) {
    _objectsBox.put(object.id, object);

    final folderChilds = _relationsBox.get(object.parentFolder);

    if (folderChilds == null) {
      _relationsBox.put(object.parentFolder, [object.id]);
    } else {
      if (folderChilds.contains(object.id)) return;

      folderChilds.add(object.id);

      _relationsBox.put(object.parentFolder, folderChilds);
    }
  }

  void setShimmerToFolder(String folderId) {
    if (!_objectsBox.containsKey(shimmerKey)) {
      var shimmer = Record(
        id: shimmerKey,
        name: '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',
        size: 999999999999999999,
        mimeType: '',
        folder: folderId,
        createdAt: DateTime.now(),
      );

      _objectsBox.put(shimmerKey, shimmer);
    } else {
      final _shimmer = _objectsBox.get(shimmerKey);

      final shimmer = (_shimmer as Record);

      if (shimmer.parentFolder != folderId) {
        final updatedShimmer = _shimmer.copyWith(folder: folderId);

        _objectsBox.put(shimmerKey, updatedShimmer);

        if (_relationsBox.containsKey(folderId)) {
          final folderReferences = _relationsBox.get(folderId);

          if (folderReferences == null || folderReferences.isEmpty) {
            _relationsBox.put(folderId, [shimmerKey]);
          } else if (!folderReferences.contains(shimmerKey)) {
            folderReferences.add(shimmerKey);

            _relationsBox.put(folderId, folderReferences);
          }
        }
      }
    }
  }

  void removeShimmerFromFolderIfNecessary(String folderId) {
    if (_objectsBox.containsKey(shimmerKey)) {
      final shimmer = _objectsBox.get(shimmerKey);

      if (shimmer!.parentFolder == folderId) {
        final updatedShimmer = (shimmer as Record).copyWith(
          folder: 'empty',
          createdAt: DateTime.now(),
        );
        // _objectsBox.delete(shimmerKey);
        _objectsBox.put(shimmerKey, updatedShimmer);

        if (_relationsBox.containsKey(folderId)) {
          final folderRelations = _relationsBox.get(folderId);

          if (folderRelations != null && folderRelations.contains(shimmerKey)) {
            folderRelations.remove(shimmerKey);

            _relationsBox.put(folderId, folderRelations);
          }
        }
      }
    }
  }

  Future<void> _removeShimmer() async {
    if (_objectsBox.containsKey(shimmerKey)) {
      final shimmer = _objectsBox.get(shimmerKey);

      if (shimmer != null && shimmer.parentFolder != null) {
        removeShimmerFromFolderIfNecessary(shimmer.parentFolder!);
      }
    }
  }

  List<BaseObject> getObjectsWhere(bool Function(BaseObject) test) {
    return _objectsBox.values.where(test).toList();
  }

  Future<void> deleteObjectById(String id) async {
    final object = _objectsBox.get(id);

    if (object != null) {
      if (object is Record) {
        deleteRecord(object);
      } else if (object is Folder) {
        deleteFolder(object);
      }
    }
  }

  void deleteRecord(Record record) {
    final parentFolderId = record.parentFolder;

    _deleteReference(parentFolderId: parentFolderId, id: record.id);

    if (_objectsBox.containsKey(record.id)) {
      _objectsBox.delete(record.id);
    }
  }

  void deleteFolder(Folder folder) {
    final parentFolderId = folder.parentFolder;

    _deleteReference(parentFolderId: parentFolderId, id: folder.id);

    if (_relationsBox.containsKey(folder.id)) {
      final relatedObjectsId = _relationsBox.get(folder.id);

      relatedObjectsId?.forEach((element) {
        _objectsBox.delete(element);
      });
    }

    _objectsBox.delete(folder.id);
  }

  void _deleteReference({
    required String? parentFolderId,
    required String id,
  }) {
    if (_relationsBox.keys.contains(parentFolderId)) {
      final parentFolderReferences = _relationsBox.get(parentFolderId);
      if (parentFolderReferences != null &&
          parentFolderReferences.contains(id)) {
        parentFolderReferences.remove(id);

        _relationsBox.put(parentFolderId, parentFolderReferences);
      }
    }
  }

  ValueListenable<Box<BaseObject>> getObjectsBoxListenable(
    List<String>? objectsId,
  ) {
    final listenable = _objectsBox.listenable(keys: objectsId);

    return listenable;
  }

  ValueListenable<Box<List<String>>> getRelationsBoxListenable(
    String? folderId,
  ) {
    final keys = folderId == null ? null : [folderId];
    final listenable = _relationsBox.listenable(keys: keys);

    return listenable;
  }

  Stream<BoxEvent> getObjectsBoxEventStream(String? key) {
    return _objectsBox.watch(key: key);
  }

  Stream<BoxEvent> getRelationsBoxEventSteam(String? key) {
    return _relationsBox.watch(key: key);
  }

  void moveContentToFolder(String folderId, List<String> objectsIds) {
    if (objectsIds.isNotEmpty) {
      for (var objectId in objectsIds) {
        _removeReferencesByObjectId(objectId);

        _changeParentReferenceInObject(objectId, folderId);

        addRelation(objectId, folderId);
      }
    }
  }

  void _changeParentReferenceInObject(String objectId, String parentFolderId) {
    final object = _objectsBox.get(objectId);

    if (object != null) {
      BaseObject updatedObject;

      if (object is Record) {
        updatedObject = object.copyWith(folder: parentFolderId);
      } else {
        updatedObject =
            (object as Folder).copyWith(parentFolder: parentFolderId);
      }

      _objectsBox.put(objectId, updatedObject);
    }
  }

  void _removeReferencesByObjectId(String objectId) {
    final objectsMap = _relationsBox.toMap();
    try {
      final previousReferenceEntrie = objectsMap.entries
          .firstWhere((entrie) => entrie.value.contains(objectId));

      final previousReferenceKey = previousReferenceEntrie.key;

      final previousRelations = _relationsBox.get(previousReferenceKey);

      previousRelations?.remove(objectId);

      if (previousRelations != null)
        _relationsBox.put(previousReferenceKey, previousRelations);
    } catch (e) {
      throw ObjectsReferenceNotFound();
    }
  }

  List<String>? getReferencesById(String id) {
    return _relationsBox.get(id);
  }

  Future<void> clearAll() async {
    await _objectsBox.clear();
    if (!_objectsBox.isOpen) {
      await _objectsBox.close();
    }
    await _relationsBox.clear();

    if (!_relationsBox.isOpen) {
      await _relationsBox.close();
    }
  }
}
