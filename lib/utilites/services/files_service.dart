import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/list.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';

import '../injection.dart';

@Injectable()
class FilesService {
  final Dio _dio;
  FilesService(@Named('record_dio') this._dio);

  final TokenRepository _tokenRepository = getIt<TokenRepository>();

  Future<List<Record>?> getRecords() async {
    try {
      String? token = await _tokenRepository.getApiToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.get(
          '/record',
          options: Options(headers: {'Authorization': ' Bearer $token'}),
        );
        ResponseList<Record> parsedResponse = ResponseList.fromJson(
          response.data,
          Record.fromJsonModel,
        );
        return parsedResponse.rows;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseStatus?> deleteRecords(List<String> recordsIds) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      String path = '';

      for (var i = 0; i < recordsIds.length; i++) {
        if (i == 0) path = '/record?';
        if (i != 0) path += '&';

        path += 'ids[]=${recordsIds[i]}';
      }

      if (token != null && token.isNotEmpty && path.isNotEmpty) {
        final response = await _dio.delete(
          path,
          options: Options(headers: {'Authorization': ' Bearer $token'}),
        );
        print(response);

        return ResponseStatus.ok;
      }

      return ResponseStatus.notExecuted;
    } on DioError catch (e) {
      print(e);

      return ResponseStatus.failed;
    }
  }

  Future<ResponseStatus?> deleteFolders(List<String> foldersIds) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      String path = '';

      for (var i = 0; i < foldersIds.length; i++) {
        if (i == 0) path = '/folder?';
        if (i != 0) path += '&';

        path += 'ids[]=${foldersIds[i]}';
      }

      if (token != null && token.isNotEmpty && path.isNotEmpty) {
        final response = await _dio.delete(
          path,
          options: Options(headers: {'Authorization': ' Bearer $token'}),
        );
        print(response);

        return ResponseStatus.ok;
      }

      return ResponseStatus.notExecuted;
    } on DioError catch (e) {
      print(e);

      return ResponseStatus.failed;
    }
  }

  Future<Folder?> getRootFolder() async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var response = await _dio.get(
        '/root',
        options: Options(headers: {'Authorization': ' Bearer $token'}),
      );

      if (response.statusCode == 200) {
        Folder folder = Folder.fromJson(response.data);
        return folder;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Folder?> getFolderById(String id) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var path = '/folder/$id';

      var response = await _dio.get(
        path,
        options: Options(headers: {'Authorization': ' Bearer $token'}),
      );

      if (response.statusCode == 200) {
        var folder = Folder.fromJson(response.data);
        return folder;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<ResponseStatus> createFolder(
      String name, String? parentFolderId) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var query = {
        'data': {
          'name': name,
          'parentFolder': parentFolderId,
        }
      };
      var response = await _dio.post(
        '/folder',
        options: Options(headers: {'Authorization': ' Bearer $token'}),
        data: query,
      );
      if (response.statusCode == 200)
        return ResponseStatus.ok;
      else
        return ResponseStatus.failed;
    } catch (e) {
      print(e);
      return ResponseStatus.failed;
    }
  }

  Future<ResponseStatus> deleteFolder(String id) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var path = '/folder?ids[]=$id';

      var response = await _dio.delete(
        path,
        options: Options(headers: {'Authorization': ' Bearer $token'}),
      );

      if (response.statusCode == 200)
        return ResponseStatus.ok;
      else
        return ResponseStatus.failed;
    } catch (e) {
      print(e);
      return ResponseStatus.failed;
    }
  }

  Future<ResponseStatus> renameFolder(String newName, String folderId) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var path = '/folder/$folderId';

      var data = {
        'data': {
          'name': newName,
        }
      };

      var response = await _dio.put(
        path,
        data: data,
        options: Options(
          headers: {'Authorization': ' Bearer $token'},
        ),
      );

      if (response.statusCode == 200)
        return ResponseStatus.ok;
      else
        return ResponseStatus.failed;
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 403) {
        return ResponseStatus.notExecuted;
      } else {
        return ResponseStatus.failed;
      }
    }
  }

  Future<ResponseStatus> renameRecord(String newName, String recordId) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var path = '/record/$recordId';

      var data = {
        'data': {
          'name': newName,
        }
      };

      var response = await _dio.put(
        path,
        data: data,
        options: Options(
          headers: {'Authorization': ' Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return ResponseStatus.ok;
      } else {
        return ResponseStatus.failed;
      }
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 403) {
        return ResponseStatus.notExecuted;
      } else {
        return ResponseStatus.failed;
      }
    }
  }

  Future<ResponseStatus> moveContentToFolder(
      String folderId, List<String> files) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var data = {
        'data': {
          'records': files,
        }
      };

      var path = '/folder/$folderId/push';

      var response = await _dio.post(
        path,
        options: Options(headers: {'Authorization': ' Bearer $token'}),
        data: data,
      );

      if (response.statusCode == 200)
        return ResponseStatus.ok;
      else
        return ResponseStatus.failed;
    } catch (e) {
      print(e);
      return ResponseStatus.failed;
    }
  }

  Future<ResponseStatus> setFolderFavorite(String id, bool isFavorite) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var data = {
        'isFavorite': isFavorite,
      };

      var response = await _dio.post(
        '/folder/$id/favorite',
        options: Options(headers: {'Authorization': ' Bearer $token'}),
        data: data,
      );

      if (response.statusCode == 200)
        return ResponseStatus.ok;
      else
        return ResponseStatus.failed;
    } catch (e) {
      print(e);
      return ResponseStatus.failed;
    }
  }

  Future<ResponseStatus> setRecordFavorite(String id, bool isFavorite) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var data = {
        'isFavorite': isFavorite,
      };

      var response = await _dio.post(
        '/record/$id/favorite',
        options: Options(headers: {'Authorization': ' Bearer $token'}),
        data: data,
      );

      if (response.statusCode == 200)
        return ResponseStatus.ok;
      else
        return ResponseStatus.failed;
    } catch (e) {
      print(e);
      return ResponseStatus.failed;
    }
  }

  Future<ResponseStatus> setRecentFile(String id, DateTime time) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var data = {
        'accessDate': time.toString(),
      };

      var response = await _dio.post(
        '/record/$id/accessDateCommit',
        options: Options(headers: {'Authorization': ' Bearer $token'}),
        data: data,
      );

      if (response.statusCode == 200)
        return ResponseStatus.ok;
      else
        return ResponseStatus.failed;
    } catch (e) {
      print(e);
      return ResponseStatus.failed;
    }
  }

  Future<List<Record>?> getRecentsRecords() async {
    try {
      String? token = await _tokenRepository.getApiToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.get(
          '/record/recents',
          options: Options(headers: {'Authorization': ' Bearer $token'}),
        );

        if (response.statusCode == 200) {
          //final body = Keeper.fromJson(response);
          List<Record> recents = [];
          (response.data as List).forEach((element) {
            recents.add(Record.fromJson(element));
          });
          return recents;
        }
        // ResponseList<Record> parsedResponse = ResponseList.fromJson(
        //   response.data,
        //   Record.fromJsonModel,
        // );
        // return parsedResponse.rows;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseStatus> moveToFolder({
    required String folderId,
    List<String>? records,
    List<String>? folders,
  }) async {
    try {
      String? token = await _tokenRepository.getApiToken();
      var data = {
        'data': {
          'records': [
            if (records != null) ...records,
          ],
          'folders': [
            if (folders != null) ...folders,
          ],
        }
      };

      var response = await _dio.post(
        '/folder/$folderId/push',
        options: Options(headers: {'Authorization': ' Bearer $token'}),
        data: data,
      );
      if (response.statusCode == 200)
        return ResponseStatus.ok;
      else
        return ResponseStatus.failed;
    } on DioError catch (e) {
      print(e);
      print(e.message);

      return ResponseStatus.failed;
    }
  }

  Future<ResponseStatus> setProfilePic({
    required String url,
    required User user,
  }) async {
    try {
      String? token = await _tokenRepository.getApiToken();
      var data = {
        'data': {
          'firstName': user.firstName,
          'lastName': user.lastName,
          'phoneNumber': user.phoneNumber,
          'avatars': [
            {'publicUrl': url}
          ]
        }
      };
      var path = kServerUrl;
      path += '/api/auth/profile';
      var response = await Dio().put(
        path,
        options: Options(headers: {'Authorization': ' Bearer $token'}),
        data: data,
      );
      if (response.statusCode == 200) {
        return ResponseStatus.ok;
      } else {
        return ResponseStatus.failed;
      }
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 401) {
        return ResponseStatus.declined;
      } else {
        return ResponseStatus.failed;
      }
    }
  }

  Future<String?> uploadProfilePic({required File file}) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      String path = '/file';
      path +=
          '/credentials?filename=${file.path.split('/').last}&storageId=userAvatarsProfiles';

      if (token != null && token.isNotEmpty) {
        final resFileCreate = await _dio.get(
          path,
          options: Options(headers: {'Authorization': ' Bearer $token'}),
        );
        if (resFileCreate.statusCode == 200) {
          var uploadUrl = resFileCreate.data['uploadCredentials']['url'];
          FormData formData = new FormData.fromMap({
            "filename": file.path.split('/').last,
            "file": await MultipartFile.fromFile(file.path),
          });
          var resPublicUrl = await Dio().post(uploadUrl, data: formData);
          print(resPublicUrl);
          if (resPublicUrl.statusCode == 200)
            return resPublicUrl.data as String;
          else
            throw Exception('Upload profile pic ended with problem');
        } else
          throw Exception('Creation file on server ended with problem');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<ResponseStatus> deleteProfilePic({
    required User user,
  }) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var data = {
        'data': {
          'firstName': user.firstName,
          'lastName': user.lastName,
          'phoneNumber': user.phoneNumber,
          'avatars': []
        }
      };
      var path = kServerUrl;
      path += '/api/auth/profile';
      var response = await Dio().put(
        path,
        options: Options(headers: {'Authorization': ' Bearer $token'}),
        data: data,
      );

      if (response.statusCode == 200)
        return ResponseStatus.ok;
      else
        return ResponseStatus.failed;
    } catch (e) {
      print(e);
      return ResponseStatus.failed;
    }
  }

  Future<String?> createRecord(File file) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var numOfParts = file.statSync().size ~/ 10000;
      if (file.statSync().size % 10000 > 0) {
        numOfParts++;
      }

      var query = {
        "data": {
          "name": "${file.path.split('/').last}",
          "path": "",
          "numOfParts": numOfParts,
          "thumbnail": [
            {
              "name": "string",
              "sizeInBytes": 0,
              "privateUrl": "string",
              "publicUrl": "string",
              "new": true
            }
          ],
          "size": file.statSync().size,
          "copyStatus": 0
        }
      };

      var response = await _dio.post(
        '/record',
        data: query,
        options: Options(
          headers: {'Authorization': ' Bearer $token'},
          responseType: ResponseType.plain,
        ),
      );

      print(response);
      return response.data.toString();
    } on DioError catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> getRemoteAppVersion() async {
    for (int i = 0; i < 5; i++) {
      try {
        var response = await _dio.get('https://upstorage.net/apps/version/ui');
        return response.data;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }
}
