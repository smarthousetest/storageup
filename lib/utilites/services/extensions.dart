import 'dart:developer';
import 'dart:io';

import 'package:cpp_native/cpp_native.dart';
import 'package:cpp_native/models/base_object.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/pages/files/models/sorting_element.dart';
import 'package:upstorage_desktop/utilites/state_containers/state_container.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  /// Convert relative path to absolute
  Future<String> toLocalPath() async {
    final downloadFolder = await getDownloadAppFolder();

    return downloadFolder + this;
  }
}

extension FileExtension on File {
  String get name => this.path.split('/').last;
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject!.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}

Future<String> getDownloadAppFolder() async {
  var appPath = await getApplicationDocumentsDirectory();
  return appPath.path + '/downloads/';
}

/// if ErrorType is ErrorType.other errorReason should be provided
// String getErrorText(
//   S translate,
//   ErrorType errorType,
//   ErrorReason? errorReason,
// ) {
//   switch (errorType) {
//     case ErrorType.noInternet:
//       return translate.no_internet;
//     case ErrorType.technicalError:
//       return translate.technical_error;
//     case ErrorType.other:
//       return getErrorReasonDescription(
//         translate: translate,
//         reason: errorReason!,
//       );
//   }
// }

String getErrorReasonDescription({
  required S translate,
  required ErrorReason reason,
}) {
  switch (reason) {
    case ErrorReason.internalServerError:
      return translate.internal_server_error;
    case ErrorReason.noAvailableKeepers:
      return translate.no_available_keepers;
    case ErrorReason.noAvailableProxy:
      return translate.no_available_proxy;
    case ErrorReason.noAvailableSpace:
      return translate.no_available_space;
    case ErrorReason.nullFile:
      return translate.null_file;
    case ErrorReason.noInternetConnection:
      return translate.no_internet;
    default:
      return '';
  }
}

///Checks if a popup is shown with an error and if not, shows it
///
///Use this method only under bottom bar
Future<void> showErrorPopUp({
  required BuildContext context,
  required Widget popUp,
}) async {
  final tag = 'Extensions: showErrorPopUp -> ';
  final container = StateContainer.of(context);
  final bool canNotShowPopUp = container.isErrorPopUpShowing;
  log('$tag canNotShowPopUp: $canNotShowPopUp');
  if (!canNotShowPopUp) {
    log('$tag will set isErrorPopUpShowing to true');
    StateContainer.of(context).isErrorPopUpShowing = true;
    log('$tag has set isErrorPopUpShowing to true');
    /*final dialogFuture =*/ await showDialog(
      context: context,
      builder: (context) {
        return popUp;
      },
    );

    // dialogFuture.whenComplete(
    //   () =>
    StateContainer.of(context).isErrorPopUpShowing = false;
    // );
    // BottomBarView.setLoading(context, false);

    // await dialogFuture;
  }
}

///Don't use it with [SortingCriterion.byType]
extension FilesSorting on Iterable<BaseObject> {
  // List<BaseObject> getSortedObjects({
  //   required List<String> parentFoldersId,
  //   SortingCriterion? criterio,
  //   SortingDirection direction = SortingDirection.down,
  //   String? sortingText,
  // }) {
  //   if (sortingText != null) {
  //     return _sortByText(
  //       parentFoldersId: parentFoldersId,
  //       direction: direction,
  //       sortingText: sortingText,
  //     );
  //   } else if (criterio != null) {
  //     if (criterio == SortingCriterion.byName) {
  //       return _sortByName(
  //         parentFoldersId: parentFoldersId,
  //         direction: direction,
  //       );
  //     } else if (criterio == SortingCriterion.byDate) {
  //       return _sortByDate(
  //         parentFoldersId: parentFoldersId,
  //         direction: direction,
  //       );
  //     } else if (criterio == SortingCriterion.bySize) {
  //       return _sortBySize(
  //         parentFoldersId: parentFoldersId,
  //         direction: direction,
  //       );
  //     }
  //   }
  //   return this
  //       .where(
  //         (element) => parentFoldersId
  //             .any((parentFolderId) => element.parentFolder == parentFolderId),
  //       )
  //       .toList();
  // }

  Map<String, List<BaseObject>> getObjectsSortedByTypes({
    required String parentFolderId,
    SortingDirection direction = SortingDirection.down,
  }) {
    final objects =
        this.where((element) => element.parentFolder == parentFolderId);

    Map<String, List<BaseObject>> groupedFiles = {};

    objects.forEach((element) {
      String key;
      if (element.extension == null) {
        key = 'folder';
      } else {
        key = element.extension!.toLowerCase();
      }

      if (groupedFiles.containsKey(key)) {
        groupedFiles[key]?.add(element);
      } else {
        groupedFiles[key] = [element];
      }
    });

    if (direction == SortingDirection.up)
      return groupedFiles;
    else
      return groupedFiles
          .map((key, value) => MapEntry(key, value.reversed.toList()));
  }

  Map<DateTime, List<BaseObject>> getObjectsSortedByTime({
    required String parentFolderId,
    SortingDirection direction = SortingDirection.down,
  }) {
    final objects =
        this.where((element) => element.parentFolder == parentFolderId);

    Map<DateTime, List<BaseObject>> groupedObjects = {};

    objects.forEach((element) {
      var date = DateTime.utc(
        element.createdAt!.year,
        element.createdAt!.month,
      );
      if (groupedObjects.containsKey(date)) {
        groupedObjects[date]?.add(element);
      } else {
        groupedObjects[date] = [element];
      }
    });

    if (direction == SortingDirection.up)
      return groupedObjects;
    else
      return groupedObjects
          .map((key, value) => MapEntry(key, value.reversed.toList()));
  }

  Map<DateTime, List<BaseObject>> getObjectsSortedByTimeFromMultipleFolders({
    required List<String> parentFoldersId,
    SortingDirection direction = SortingDirection.down,
  }) {
    final objects = this.where((element) => parentFoldersId
        .any((parentFolderId) => parentFolderId == element.parentFolder));

    Map<DateTime, List<BaseObject>> groupedObjects = {};

    objects.forEach((element) {
      var date = DateTime.utc(
        element.createdAt!.year,
        element.createdAt!.month,
      );
      if (groupedObjects.containsKey(date)) {
        groupedObjects[date]?.add(element);
      } else {
        groupedObjects[date] = [element];
      }
    });

    if (direction == SortingDirection.up)
      return groupedObjects;
    else
      return groupedObjects
          .map((key, value) => MapEntry(key, value.reversed.toList()));
  }

  List<BaseObject> _sortBySize({
    required List<String> parentFoldersId,
    required SortingDirection direction,
  }) {
    final objects = this
        .where((element) => parentFoldersId
            .any((parentFolderId) => element.parentFolder == parentFolderId))
        .toList();

    objects.sort((a, b) {
      return a.size.compareTo(b.size);
    });

    if (direction == SortingDirection.up)
      return objects;
    else
      return objects.reversed.toList();
  }

  List<BaseObject> _sortByDate({
    required List<String> parentFoldersId,
    required SortingDirection direction,
  }) {
    final objects = this
        .where((element) => parentFoldersId
            .any((parentFolderId) => parentFolderId == element.parentFolder))
        .toList();

    objects.sort((a, b) {
      if (a.createdAt != null && b.createdAt != null) {
        return a.createdAt!.compareTo(b.createdAt!);
      } else if (a.createdAt == null && b.createdAt == null) {
        return a.id.compareTo(b.id);
      } else
        return a.createdAt == null ? 0 : 1;
    });

    if (direction == SortingDirection.up)
      return objects;
    else
      return objects.reversed.toList();
  }

  List<BaseObject> _sortByName({
    required List<String> parentFoldersId,
    required SortingDirection direction,
  }) {
    final objects = this
        .where((element) => parentFoldersId
            .any((parentFolderId) => element.parentFolder == parentFolderId))
        .toList();

    objects.sort((a, b) {
      if (a.name != null && b.name != null) {
        return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
      } else if (a.name == null && b.name == null) {
        return a.id.compareTo(b.id);
      } else
        return a.name == null ? 0 : 1;
    });
    if (direction == SortingDirection.up)
      return objects;
    else
      return objects.reversed.toList();
  }

  List<BaseObject> _sortByText({
    required List<String> parentFoldersId,
    required SortingDirection direction,
    required String sortingText,
  }) {
    bool _checkCreatedAt(BaseObject object) {
      return (object.createdAt != null &&
          DateFormat.yMd(Intl.getCurrentLocale())
              .format(object.createdAt!)
              .toString()
              .toLowerCase()
              .contains(sortingText.toLowerCase()));
    }

    bool _checkName(BaseObject object) {
      return (object.name != null &&
          object.name!.toLowerCase().contains(sortingText.toLowerCase()));
    }

    bool _checkExtension(BaseObject object) {
      return (object.extension != null &&
          object.extension!.toLowerCase().contains(sortingText.toLowerCase()));
    }

    final objects = this
        .where((element) =>
            parentFoldersId.any(
                (parentFolderId) => element.parentFolder == parentFolderId) &&
            (_checkCreatedAt(element) ||
                _checkName(element) ||
                _checkExtension(element)))
        .toList();
    if (direction == SortingDirection.up)
      return objects;
    else
      return objects.reversed.toList();
  }
}

String fileSize(dynamic size, S translate, [int round = 2]) {
  /** 
   * [size] can be passed as number or as string
   *
   * the optional parameter [round] specifies the number 
   * of digits after comma/point (default is 2)
   */
  var divider = 1024;
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  int _size;
  try {
    _size = int.parse(size.toString());
    //.replaceAll(regex, ''));
  } catch (e) {
    throw ArgumentError('Can not parse the size parameter: $e');
  }

  if (_size < divider) {
    return translate.b(_size);
  }

  if (_size < divider * divider && _size % divider == 0) {
    return translate.kb((_size / divider).toStringAsFixed(0));
  }

  if (_size < divider * divider) {
    return translate.kb((_size / divider).toStringAsFixed(round));
  }

  if (_size < divider * divider * divider && _size % divider == 0) {
    return translate.mb((_size / (divider * divider)).toStringAsFixed(0));
  }

  if (_size < divider * divider * divider) {
    return translate.mb((_size / divider / divider).toStringAsFixed(round));
  }

  if (_size < divider * divider * divider * divider && _size % divider == 0) {
    return translate
        .gb((_size / (divider * divider * divider)).toStringAsFixed(0));
  }

  if (_size < divider * divider * divider * divider) {
    return translate
        .gb((_size / divider / divider / divider).toStringAsFixed(round));
  }

  if (_size < divider * divider * divider * divider * divider &&
      _size % divider == 0) {
    num r = _size / divider / divider / divider / divider;
    return translate.tb(r.toStringAsFixed(0));
  }

  if (_size < divider * divider * divider * divider * divider) {
    num r = _size / divider / divider / divider / divider;
    return translate.tb(r.toStringAsFixed(round));
  }

  if (_size < divider * divider * divider * divider * divider * divider &&
      _size % divider == 0) {
    num r = _size / divider / divider / divider / divider / divider;
    return translate.pb(r.toStringAsFixed(0));
  } else {
    num r = _size / divider / divider / divider / divider / divider;
    return translate.pb(r.toStringAsFixed(round));
  }
}

extension LinedString on Map<String, dynamic> {
  String toLinedString() {
    String result = '';

    this.entries.forEach((element) {
      result = result + '${element.key}: ${element.value}\n';
    });

    return result;
  }
}

String _pattern = '|@|';

// Future<bool> isItLoadedFromThisDevice(String uniqueId) async {
//   final deviceId = await getDeviceId();

//   if (deviceId == null) return false;

//   try {
//     final loadedDeviceId = uniqueId.split(_pattern).first;

//     return loadedDeviceId == deviceId;
//   } catch (_) {
//     return false;
//   }
// }

// Future<String?> findMediaOnDevice(Record record) async {
//   final isLoadedFromThisDevice =
//       await isItLoadedFromThisDevice(record.uniqueId!);

//   if (!isLoadedFromThisDevice) return null;

//   final localId = await record.uniqueId!.uniqueIdToLocal();

//   if (localId == null) return null;

//   return await MediaAssetsHelper().getMediaById(id: localId);
// }
