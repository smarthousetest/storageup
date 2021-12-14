import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:upstorage_desktop/pages/sell_space/space_view.dart';

import 'folder_list.dart';
import 'keeper_info.dart';
import 'package:cpp_native/cpp_native.dart';
import 'package:dio/dio.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';

Future<String> getKeeperId(String? bearerToken, int freeSpace) async {
  while (true) {
    try {
      Response response = await Dio().post(
        'https://upstorage.net/api/tenant/12/keeper',
        options: Options(headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': ' application/json',
        }),
        data: json.encode({
          'data': {
            'connectionType': 'direct',
            'space': (freeSpace * (1024 ^ 3)),
            'avarageSpeed': 0,
          }
        }),
      );
      Map<String, dynamic> jsonDecode = response.data;
      if (!Directory('./keepers').existsSync()) {
        Directory('${Directory.current.path}/keepers').createSync();
      }
      if (!File('${Directory.current.path}/keepers/${jsonDecode['id']}.txt')
          .existsSync()) {
        File keeperIdFile =
            File('${Directory.current.path}/keepers/${jsonDecode['id']}.txt');
        keeperIdFile.createSync();
        keeperIdFile.writeAsStringSync(jsonDecode['id']);
      }
      print(jsonDecode['id']);
      return jsonDecode['id'];
    } on DioError catch (e) {
      print(e);
    }
  }
}

Future<bool> startKeeper(
    String pathToDir, List<KeeperInfo> list, int freeSpace) async {
  if (list.contains(pathToDir)) {
    return false;
  } else {
    String? bearerToken = await TokenRepository().getApiToken();
    String keeperId = await getKeeperId(bearerToken, freeSpace);
    if (bearerToken != null) {
      CppNative cpp = CppNative();
      listOfDirsKeepers.add(KeeperInfo(
          dirPath: pathToDir,
          dateTime: DateFormat.yMd().format(DateTime.now()),
          name: null,
          size: freeSpace,
          trustLevel: 16));
      // keeperList.add(FolderList(listOfDirsKeepers.last));
      cpp.receiver(keeperId, bearerToken);
    }
    return true;
  }
}
