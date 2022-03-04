import 'dart:io';
import 'os_spec.dart';

class Linux extends OsSpecifications {
  Linux();

  static const String appDirPath = '/usr/local/storageup';
  static const String keeperDirPath = '/var/storageup';
  static const String keeperName = 'keeper.exe';

  @override
  int killProcess(String processName) {
    var result = Process.runSync('killall', [processName]);
    return result.exitCode;
  }

  @override
  String getAppLocation() {
    return appDirPath;
  }

  @override
  String setVersion(String version) {
    File(appDirPath).writeAsString(version);
    return version;
  }

  @override
  int startProcess(String processName, bool hide, [List<String> args = const []]) {
    late ProcessResult result;
    if(hide){
      result = Process.runSync('nohup', ['$appDirPath${Platform.pathSeparator}$keeperName &']);
    }else{
      result = Process.runSync('$appDirPath${Platform.pathSeparator}$keeperName', []);
    }
    return result.exitCode;
  }
  //TODO: create method, registers app in linux
  @override
  int registerAppInOs(String appDirPath) {
    return 0;
  }

  @override
  int createShortcuts(String appDirPath) {
    // TODO: implement createShortcuts
    throw UnimplementedError();
  }
}
