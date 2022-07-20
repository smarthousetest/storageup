import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MediaRepository {
  List<BaseObject>? _folders;
  String? mediaRootFolderId;

  final ValueNotifier<Folder?> _valueNotifier = ValueNotifier<Folder?>(null);

  ValueNotifier<Folder?> get getValueNotifier => _valueNotifier;

  set setMediaRootFolder(Folder? folder) => _valueNotifier.value = folder;

  Folder? get getMediaRootFolder => _valueNotifier.value;

  bool containMedia() {
    return _folders != null && _folders!.isNotEmpty;
  }

  List<BaseObject>? getMedia() {
    return _folders;
  }

  void setMedia(List<BaseObject>? media) {
    _folders = media;
  }
}
