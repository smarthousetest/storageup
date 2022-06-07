import 'package:hive/hive.dart';
import 'package:os_specification/os_specification.dart';

class KeeperRepository {
  KeeperRepository() {
    var os = OsSpecifications.getOs();
    Hive.init(os.supportDir);
  }

  Box? box;

  Future<Box?> initBox() async {
    if (box != null) {
      if(!box!.isOpen) {
        return await Hive.openBox('KeeperLocation');
      }else{
        return box;
      }
    }
    return null;
  }

}






