import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:os_specification/os_specification.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:io';
import '../../models/download_location.dart';
import '../repositories/space_repository.dart';

const START_UI_PORT = 8500;
const END_UI_PORT = 9000;

class Server {
  final ip = InternetAddress.anyIPv4;
  late final Handler _handler;
  late final Router _router;
  var _os = OsSpecifications.getOs();
  late DownloadLocationsRepository _repository;
  late File localUiServerConfigFile;

  Server() {
    localUiServerConfigFile = File(
        "${_os.supportDir}${Platform.pathSeparator}localUiServerConfigFile");
    if (!localUiServerConfigFile.existsSync()) {
      localUiServerConfigFile.createSync(recursive: true);
    }

    Hive.init(_os.supportDir);
    _router = Router()
      ..get('/', _rootHandler)
      ..get('/set_keeper_id/<old>/<new>', _setNewKeeperId);
    _handler = Pipeline().addHandler(_router);
  }

  void startServer() async {
    for (int port = START_UI_PORT; port < END_UI_PORT; port++) {
      try {
        final server = await serve(_handler, ip, port);
        _repository =
            await GetIt.instance.getAsync<DownloadLocationsRepository>();
        localUiServerConfigFile.writeAsStringSync(
          json.encode({
            "port": port,
          }),
        );
        print('Server listening on port ${server.port}');
        break;
      } catch (e) {
        print('Port $port is busy');
      }
    }
  }

  _rootHandler(Request req) {
    return Response.ok('Welcome to StorageUp UI!\n');
  }

  _setNewKeeperId(Request request, String old_id, String new_id) {
    var downloadLocationInfo = _repository.locationsInfo;
    for (var curLocation in downloadLocationInfo) {
      if (curLocation.idForCompare == old_id) {
        DownloadLocation newLocation =
            curLocation.copyWith(idForCompare: new_id);
        _repository.changelocation(location: newLocation);
        print("Keeper id is changed [$old_id] => [$new_id]");
        return Response.ok("Keeper id is changed [$old_id] => [$new_id]");
      }
    }
    print("Keeper with [$old_id] keeper id doesn't exist");
    return Response.notFound("Keeper with [$old_id] keeper id doesn't exist");
  }
}
