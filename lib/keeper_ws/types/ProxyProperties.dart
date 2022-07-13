import 'RatingHistory.dart';
import 'dart:convert';

/// id : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// createdAt : "string"
/// updatedAt : "string"
/// deletedAt : "string"
/// createdBy : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// updatedBy : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// importHash : "string"
/// tenant : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// name : "string"
/// token : "string"
/// session : "string"
/// online : 0
/// proxyIP : "string"
/// proxyPORT : 0
/// onlineDate : "string"
/// rating : 0
/// ratingHistory : [{"rating":0,"date":"string"}]
/// isRatingHistoryComplete : true
/// connectionType : "direct"
/// connection : "string"
/// space : 0
/// availableSpace : 0
/// avarageSpeed : 0

ProxyProperties proxyPropertiesFromJson(String str) => ProxyProperties.fromJson(json.decode(str));
String proxyPropertiesToJson(ProxyProperties data) => json.encode(data.toJson());
class ProxyProperties {
  ProxyProperties({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt, 
      this.createdBy, 
      this.updatedBy, 
      this.importHash, 
      this.tenant, 
      this.name, 
      this.token, 
      this.session, 
      this.online, 
      this.proxyIP, 
      this.proxyPORT, 
      this.onlineDate, 
      this.rating, 
      this.ratingHistory, 
      this.isRatingHistoryComplete, 
      this.connectionType, 
      this.connection, 
      this.space, 
      this.availableSpace, 
      this.avarageSpeed,});

  ProxyProperties.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    importHash = json['importHash'];
    tenant = json['tenant'];
    name = json['name'];
    token = json['token'];
    session = json['session'];
    online = json['online'];
    proxyIP = json['proxyIP'];
    proxyPORT = json['proxyPORT'];
    onlineDate = json['onlineDate'];
    rating = json['rating'];
    if (json['ratingHistory'] != null) {
      ratingHistory = [];
      json['ratingHistory'].forEach((v) {
        ratingHistory?.add(RatingHistory.fromJson(v));
      });
    }
    isRatingHistoryComplete = json['isRatingHistoryComplete'];
    connectionType = json['connectionType'];
    connection = json['connection'];
    space = json['space'];
    availableSpace = json['availableSpace'];
    avarageSpeed = json['avarageSpeed'];
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdBy;
  String? updatedBy;
  String? importHash;
  String? tenant;
  String? name;
  String? token;
  String? session;
  int? online;
  String? proxyIP;
  int? proxyPORT;
  String? onlineDate;
  int? rating;
  List<RatingHistory>? ratingHistory;
  bool? isRatingHistoryComplete;
  String? connectionType;
  String? connection;
  int? space;
  int? availableSpace;
  int? avarageSpeed;
ProxyProperties copyWith({  String? id,
  String? createdAt,
  String? updatedAt,
  String? deletedAt,
  String? createdBy,
  String? updatedBy,
  String? importHash,
  String? tenant,
  String? name,
  String? token,
  String? session,
  int? online,
  String? proxyIP,
  int? proxyPORT,
  String? onlineDate,
  int? rating,
  List<RatingHistory>? ratingHistory,
  bool? isRatingHistoryComplete,
  String? connectionType,
  String? connection,
  int? space,
  int? availableSpace,
  int? avarageSpeed,
}) => ProxyProperties(  id: id ?? this.id,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  deletedAt: deletedAt ?? this.deletedAt,
  createdBy: createdBy ?? this.createdBy,
  updatedBy: updatedBy ?? this.updatedBy,
  importHash: importHash ?? this.importHash,
  tenant: tenant ?? this.tenant,
  name: name ?? this.name,
  token: token ?? this.token,
  session: session ?? this.session,
  online: online ?? this.online,
  proxyIP: proxyIP ?? this.proxyIP,
  proxyPORT: proxyPORT ?? this.proxyPORT,
  onlineDate: onlineDate ?? this.onlineDate,
  rating: rating ?? this.rating,
  ratingHistory: ratingHistory ?? this.ratingHistory,
  isRatingHistoryComplete: isRatingHistoryComplete ?? this.isRatingHistoryComplete,
  connectionType: connectionType ?? this.connectionType,
  connection: connection ?? this.connection,
  space: space ?? this.space,
  availableSpace: availableSpace ?? this.availableSpace,
  avarageSpeed: avarageSpeed ?? this.avarageSpeed,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['deletedAt'] = deletedAt;
    map['createdBy'] = createdBy;
    map['updatedBy'] = updatedBy;
    map['importHash'] = importHash;
    map['tenant'] = tenant;
    map['name'] = name;
    map['token'] = token;
    map['session'] = session;
    map['online'] = online;
    map['proxyIP'] = proxyIP;
    map['proxyPORT'] = proxyPORT;
    map['onlineDate'] = onlineDate;
    map['rating'] = rating;
    if (ratingHistory != null) {
      map['ratingHistory'] = ratingHistory?.map((v) => v.toJson()).toList();
    }
    map['isRatingHistoryComplete'] = isRatingHistoryComplete;
    map['connectionType'] = connectionType;
    map['connection'] = connection;
    map['space'] = space;
    map['availableSpace'] = availableSpace;
    map['avarageSpeed'] = avarageSpeed;
    return map;
  }

}