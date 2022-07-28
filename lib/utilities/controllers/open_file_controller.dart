import 'package:injectable/injectable.dart';
import 'package:open_file/open_file.dart';

@singleton
class OpenFileController {
  OpenFileController();

  final List<String> _recordIds = [];

  void addRecordId(String recordId) {
    _recordIds.add(recordId);
  }

  Future<bool> requestOpenFile(String recordId, String filePath) async {
    if (!_recordIds.contains(recordId)) {
      return false;
    }

    var result = await OpenFile.open(filePath);

    return result.type == ResultType.done;
  }
}
