import 'package:injectable/injectable.dart';
import 'package:storageup/models/base_object.dart';
import 'package:storageup/models/folder.dart';

@Injectable()
class FilesRepository {
  List<BaseObject>? _files;
  bool _initilizated = false;

  Folder? _filesRootFolder;

  List<BaseObject>? get getFiles {
    return _files;
  }

  void setFiles(List<BaseObject>? files) {
    _initilizated = true;
    _files = files;
  }

  set setRootFolder(Folder? folder) => _filesRootFolder = folder;

  Folder? get getRootFolder => _filesRootFolder;

  bool containFiles() {
    return _files != null && _files!.isNotEmpty;
  }

  bool isInitilizated() {
    return _initilizated;
  }
}
