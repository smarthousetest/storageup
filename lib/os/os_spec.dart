abstract class OsSpecifications {
  int killProcess(String processName);

  int startProcess(String processName, bool hide,
      [List<String> args = const []]);

  String getAppLocation();

  String setVersion(String version);

  int registerAppInOs(String appDirPath);

  int createShortcuts(String appDirPath);

  void startProcessDetach(String processName, bool hide,
      [List<String> args = const []]);
}
