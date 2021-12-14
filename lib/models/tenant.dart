import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/settings.dart';

class Tenant {
  Plan? plan;
  PlanStatus? planStatus;
  String? sId;
  String? name;
  String? url;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;
  Settings? settings;

  Tenant({
    this.plan,
    this.planStatus,
    this.sId,
    this.name,
    this.url,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.id,
    this.settings,
  });

  Tenant.fromJson(Map<String, dynamic> json) {
    plan = mapJsonToPlan(json['plan']);
    planStatus = mapJsonToPlanStatus(json['planStatus']);
    sId = json['_id'];
    name = json['name'];
    url = json['url'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan'] = mapPlanToJson(this.plan);
    data['planStatus'] = mapPlanStatusToJson(this.planStatus);
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['url'] = this.url;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    if (this.settings != null) {
      data['settings'] = this.settings?.toJson();
    }
    return data;
  }
}
