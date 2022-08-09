import 'dart:developer';
import 'dart:io';

import 'package:cpp_native/cpp_native.dart';
import 'package:cpp_native/models/base_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storageup/components/blur/custom_error_popup.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/files/models/sorting_element.dart';
import 'package:storageup/utilities/state_containers/state_container.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  bool isURL() {
    var urlPattern =
        r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    return RegExp(urlPattern, caseSensitive: false).hasMatch(this);
  }
}

extension FileExtension on File {
  String get name => this.path.split(Platform.pathSeparator).last;
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
  var appPath = await getApplicationSupportDirectory();
  return appPath.path + '/downloads/';
}

///Don't use it with [SortingCriterion.byType]
extension FilesSorting on Iterable<BaseObject> {
  List<BaseObject> getSortedObjects({
    required List<String> parentFoldersId,
    SortingCriterion? criterio,
    SortingDirection direction = SortingDirection.down,
    String? sortingText,
  }) {
    if (sortingText != null && sortingText.isNotEmpty) {
      return _sortByText(
        parentFoldersId: parentFoldersId,
        direction: direction,
        sortingText: sortingText,
      );
    } else if (criterio != null) {
      if (criterio == SortingCriterion.byName) {
        return _sortByName(
          parentFoldersId: parentFoldersId,
          direction: direction,
        );
      } else if (criterio == SortingCriterion.byDateCreated) {
        return _sortByDate(
          parentFoldersId: parentFoldersId,
          direction: direction,
        );
      } else if (criterio == SortingCriterion.bySize) {
        return _sortBySize(
          parentFoldersId: parentFoldersId,
          direction: direction,
        );
      }
    }
    return this
        .where(
          (element) => parentFoldersId
              .any((parentFolderId) => element.parentFolder == parentFolderId),
        )
        .toList();
  }

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

extension UserProficeImage on User? {
  Widget get image {
    Widget image = Container();

    if (this != null && this!.avatars != null && this!.avatars!.isNotEmpty) {
      image = Container(
        height: 46,
        width: 46,
        child: this!.avatars!.first.publicUrl!.isNotEmpty
            ? Image.network(
                this!.avatars!.first.publicUrl ?? "",
                fit: BoxFit.cover,
              )
            : SvgPicture.asset(
                'assets/home_page/default_man.svg',
                fit: BoxFit.fitHeight,
              ),
      );
    } else {
      image = Container(
        height: 46,
        width: 46,
        child: SvgPicture.asset(
          'assets/home_page/default_man.svg',
          fit: BoxFit.fitHeight,
        ),
      );
    }

    return image;
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
  int _size;
  try {
    _size = int.parse(size.toString());
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

Future<void> copyFileToDownloadDir({
  required String filePath,
  required String fileId,
}) async {
  try {
    var file = File(filePath);
    var appDownloadFolderPath = await getDownloadAppFolder();
    await Directory(appDownloadFolderPath).create(recursive: true);
    var copiedFile = await file.copy(appDownloadFolderPath + file.name);

    var isFileCopied = await copiedFile.exists();
    print('copied file existing is $isFileCopied');

    if (isFileCopied) {
      var box = await Hive.openBox(kPathDBName);
      await box.put(fileId, 'downloads/${file.name}');
      print('uploading file succesfully copied to app folder');
    }
  } catch (e) {
    print('cannot copy file with exception: $e');
  }
}

String getErrorReasonDescription({
  required S translate,
  required Enum reason,
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
      return "";
  }
}

///Checks if a popup is shown with an error and if not, shows it
///
///Use this method only under bottom bar
Future<void> showErrorPopUp({
  required BuildContext context,
  required String message,
}) async {
  final tag = 'Extensions: showErrorPopUp -> ';
  final container = StateContainer.of(context);
  final bool canNotShowPopUp = container.isErrorPopUpShowing;
  log('$tag canNotShowPopUp: $canNotShowPopUp');
  if (!canNotShowPopUp) {
    log('$tag will set isErrorPopUpShowing to true');
    StateContainer.of(context).isErrorPopUpShowing = true;
    log('$tag has set isErrorPopUpShowing to true');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlurCustomErrorPopUp(
          middleText: message,
        );
      },
    );

    // dialogFuture.whenComplete(
    //   () =>
    StateContainer.of(context).isErrorPopUpShowing = false;
    // );

    // await dialogFuture;
  }
}
