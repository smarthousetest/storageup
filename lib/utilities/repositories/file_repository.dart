import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class FilesRepository {
  List<BaseObject>? _files;
  bool _initilizated = false;

  Folder? _filesRootFolder;

  List<BaseObject>? get getFiles {
    return _files;
  }

  final ValueNotifier<Folder?> _valueNotifier = ValueNotifier<Folder?>(null);

  ValueNotifier<Folder?> get getValueNotifier => _valueNotifier;

  void setFiles(List<BaseObject>? files) {
    _initilizated = true;
    _files = files;
  }

  set setRootFolder(Folder? folder) => _valueNotifier.value = folder;

  Folder? get getRootFolder => _valueNotifier.value;

  bool containFiles() {
    return _files != null && _files!.isNotEmpty;
  }

  bool isInitilizated() {
    return _initilizated;
  }
}
