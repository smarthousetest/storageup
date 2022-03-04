import 'dart:io';
import 'os_spec.dart';

class Windows extends OsSpecifications {
  late String appDirPath;
  static const String keeperName = 'keeper.exe';
  static const String hideKeeperName = 'start_keeper.exe';
  static const String storageupName = 'storageup.exe';
  static const String updateName = 'ups_update.exe';
  static const String hideUpdateName = 'start_ups_update.exe';

  Windows() {
    String result = getAppLocation();
    if (result.isNotEmpty) {
      appDirPath = result;
    }
  }

  @override
  int killProcess(String processName) {
    var result = Process.runSync('Taskkill', ['/IM', processName, '/F']);
    return result.exitCode;
  }

  @override
  String getAppLocation() {
    var result = Process.runSync('reg', [
      'query',
      'HKCU${Platform.pathSeparator}Software${Platform.pathSeparator}StorageUp',
      '/v',
      'DirPath'
    ]);
    if (result.exitCode == 0) {
      String dirPath = result.stdout.split(' ').last;
      return dirPath.substring(0, dirPath.length - 4);
    } else {
      return '';
    }
  }

  @override
  String setVersion(String version) {
    Process.runSync(
        'reg',
        'add HKCU${Platform.pathSeparator}Software${Platform.pathSeparator}StorageUp /v DisplayVersion /t REG_SZ /d $version /f'
            .split(' '));
    Process.runSync(
        'reg',
        'add HKCU${Platform.pathSeparator}SOFTWARE${Platform.pathSeparator}Microsoft${Platform.pathSeparator}Windows${Platform.pathSeparator}CurrentVersion${Platform.pathSeparator}Uninstall${Platform.pathSeparator}StorageUp /v DisplayVersion /t REG_SZ /d $version /f'
            .split(' '));
    File(appDirPath).writeAsString(version);
    return version;
  }

  @override
  int startProcess(String processName, bool hide, [List<String> args = const []]) {
    late ProcessResult result;
    switch (processName) {
      case 'keeper':
        if (hide) {
          result = Process.runSync(
              '$appDirPath${Platform.pathSeparator}$hideKeeperName', []);
        } else {
          result = Process.runSync(
              '$appDirPath${Platform.pathSeparator}$keeperName', []);
        }
        break;
      case 'storageup':
        result = Process.runSync(
            '$appDirPath${Platform.pathSeparator}$storageupName', []);
        break;
      case 'ups_update':
        if (hide) {
          result = Process.runSync(
              '$appDirPath${Platform.pathSeparator}$hideUpdateName', []);
        } else {
          result = Process.runSync(
              '$appDirPath${Platform.pathSeparator}$updateName', []);
        }
        break;
    }
    return result.exitCode;
  }

  @override
  int registerAppInOs(String appDirPath) {
    var result = Process.runSync('.${Platform.pathSeparator}install.bat', ['$appDirPath${Platform.pathSeparator}StorageUp${Platform.pathSeparator}']);
    return result.exitCode;
  }

  @override
  int createShortcuts(String appDirPath) {
    var result = Process.runSync('powershell.exe', ['cscript', '.${Platform.pathSeparator}create_shortcuts.vbs', '$appDirPath${Platform.pathSeparator}StorageUp']);
    return result.exitCode;
  }

  @override
  void startProcessDetach(String processName, bool hide, [List<String> args = const []]) {
    switch (processName) {
      case 'keeper':
        if (hide) {
          Process.runSync(
              '$appDirPath${Platform.pathSeparator}$hideKeeperName', []);
        } else {
          Process.runSync(
              '$appDirPath${Platform.pathSeparator}$keeperName', []);
        }
        break;
      case 'storageup':
        Process.runSync(
            '$appDirPath${Platform.pathSeparator}$storageupName', []);
        break;
      case 'ups_update':
        if (hide) {
          Process.runSync(
              '$appDirPath${Platform.pathSeparator}$hideUpdateName', []);
        } else {
          Process.runSync(
              '$appDirPath${Platform.pathSeparator}$updateName', []);
        }
        break;
    }
  }
}
