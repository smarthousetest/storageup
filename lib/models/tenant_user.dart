import 'package:storageup/models/enums.dart';
import 'package:storageup/models/tenant.dart';

class TenantUser {
  List<String>? roles;
  String? sId;
  Tenant? tenant;
  Status? status;
  String? updatedAt;
  String? createdAt;
  String? id;

  TenantUser({
    this.roles,
    this.sId,
    this.tenant,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  TenantUser.fromJson(Map<String, dynamic> json) {
    roles = json['roles'].cast<String>();
    sId = json['_id'];
    tenant = json['tenant'] != null ? new Tenant.fromJson(json['tenant']) : null;
    status = mapJsonToStatus(json['status']);
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roles'] = this.roles;
    data['_id'] = this.sId;
    if (this.tenant != null) {
      data['tenant'] = this.tenant?.toJson();
    }
    data['status'] = mapStatusToJson(this.status);
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
