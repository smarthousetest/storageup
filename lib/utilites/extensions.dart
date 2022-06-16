import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/user.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  bool isURL() {
    var urlPattern = r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    return RegExp(urlPattern, caseSensitive: false).hasMatch(this);
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
      return renderObject!.paintBounds.shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}

Future<String> getDownloadAppFolder() async {
  var appPath = await getApplicationDocumentsDirectory();
  return appPath.path + '/downloads/';
}

extension UserProficeImage on User? {
  Widget get image {
    Widget image = Container();

    if (this != null && this!.avatars != null && this!.avatars!.isNotEmpty) {
      image = Container(
        height: 46,
        width: 46,
        child: Image.network(
          this!.avatars!.first.publicUrl ?? "",
          fit: BoxFit.cover,
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
    return translate.gb((_size / (divider * divider * divider)).toStringAsFixed(0));
  }

  if (_size < divider * divider * divider * divider) {
    return translate.gb((_size / divider / divider / divider).toStringAsFixed(round));
  }

  if (_size < divider * divider * divider * divider * divider && _size % divider == 0) {
    num r = _size / divider / divider / divider / divider;
    return translate.tb(r.toStringAsFixed(0));
  }

  if (_size < divider * divider * divider * divider * divider) {
    num r = _size / divider / divider / divider / divider;
    return translate.tb(r.toStringAsFixed(round));
  }

  if (_size < divider * divider * divider * divider * divider * divider && _size % divider == 0) {
    num r = _size / divider / divider / divider / divider / divider;
    return translate.pb(r.toStringAsFixed(0));
  } else {
    num r = _size / divider / divider / divider / divider / divider;
    return translate.pb(r.toStringAsFixed(round));
  }
}
