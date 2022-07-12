import 'dart:io';

import 'package:flutter/material.dart';
import 'package:os_specification/os_specification.dart';

const kNormalTextFontFamily = 'Lato';
const int PADDING_SIZE = 30;
const int HEIGHT_TOP_FIND_BLOCK = 46;
const int HEIGHT_BOTTOM_BLOCK = 372;
const kPathDBName = 'file_path_db';

/// Only domain <storageup.net> works, other domains crash application
final String domainName = readFromFileDomainName();

final kServerUrl = 'https://$domainName';
//Shared Prefs constants
const kIsFirstOpeningApp = 'is_first_opening_app';
const kIsAutouploadEnabled = 'is_autoupload_enabled';

//Colors

const kLightGreenColor = Color(0xFF59D7AB);
const kPurpleColor = Color(0xFF868FFF);

const GB = 1024 * 1024 * 1024;
const kNeedSendEmail = false;

String readFromFileDomainName() {
  var os = OsSpecifications.getOs();
  if (os.appDirPath.isEmpty) {
    os.appDirPath = '${Directory.current.path}${Platform.pathSeparator}';
  }
  var domainNameFile = File(
    '${os.appDirPath}domainName',
  );
  if (!domainNameFile.existsSync()) {
    return "upstorage.net";
  } else {
    return domainNameFile.readAsStringSync().trim();
  }
}
