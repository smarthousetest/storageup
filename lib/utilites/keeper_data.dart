import 'dart:convert';

class KeeperData {
  Data? data;

  KeeperData([
    String? name = null,
    String? connectionType = null,
    int? space = null,
    int? avarageSpeed = null,
    String? version = null,
  ]) {
    data = Data(
      avarageSpeed: avarageSpeed,
      connectionType: connectionType,
      name: name,
      space: space,
      version: version,
    );
  }

  String? toJson() {
    if (data?.toJson() == null) {
      return null;
    } else {
      return json.encode({"data": json.encode(data)});
    }
  }
}

class Data {
  String? name;
  String? connectionType;
  int? space;
  int? avarageSpeed;
  String? version;

  Data({
    this.name,
    this.avarageSpeed,
    this.connectionType,
    this.space,
    this.version,
  });

  String? toJson() {
    Map<String, dynamic>? _data = Map<String, dynamic>();
    if (name != null) {
      _data["name"] = name;
    }
    if (connectionType != null) {
      _data["connectionType"] = connectionType;
    }
    if (space != null) {
      _data["space"] = space;
    }
    if (avarageSpeed != null) {
      _data["avarageSpeed"] = avarageSpeed;
    }
    if (version != null) {
      _data["version"] = version;
    }
    if (_data.isEmpty) {
      return null;
    } else {
      return json.encode(_data);
    }
  }
}
