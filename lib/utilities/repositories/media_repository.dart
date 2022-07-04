import 'package:cpp_native/models/base_object.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MediaRepository {
  List<BaseObject>? _folders;
  String? mediaRootFolderId;

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
