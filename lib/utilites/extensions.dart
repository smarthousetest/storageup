import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
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
