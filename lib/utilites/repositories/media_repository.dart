import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/base_object.dart';

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
