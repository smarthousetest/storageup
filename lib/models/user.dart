import 'package:cpp_native/models/file.dart';
import 'package:storageup/models/tenant_user.dart';

class User {
  bool? emailVerified;
  String? sId;
  String? email;
  String? firstName;
  String? fullName;
  List<File>? avatars;
  List<TenantUser>? tenants;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? emailVerificationTokenExpiresAt;
  String? updatedBy;
  String? lastName;
  String? phoneNumber;
  String? passwordResetTokenExpiresAt;
  String? jwtTokenInvalidBefore;
  String? id;

  User({
    this.emailVerified,
    this.sId,
    this.email,
    this.firstName,
    this.fullName,
    this.avatars,
    this.tenants,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.emailVerificationTokenExpiresAt,
    this.updatedBy,
    this.lastName,
    this.phoneNumber,
    this.passwordResetTokenExpiresAt,
    this.jwtTokenInvalidBefore,
    this.id,
  });

  static User empty() {
    return User();
  }

  User.fromJson(Map<String, dynamic> json) {
    emailVerified = json['emailVerified'];
    sId = json['_id'];
    email = json['email'];
    firstName = json['firstName'] ?? email?.split('@').first;
    fullName = json['fullName'];
    if (json['avatars'] != null) {
      avatars = [];
      json['avatars'].forEach((v) {
        avatars?.add(File.fromJson(v));
      });
    }
    if (json['tenants'] != null) {
      tenants = [];
      json['tenants'].forEach((v) {
        tenants?.add(TenantUser.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    emailVerificationTokenExpiresAt = json['emailVerificationTokenExpiresAt'];
    updatedBy = json['updatedBy'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    passwordResetTokenExpiresAt = json['passwordResetTokenExpiresAt'];
    jwtTokenInvalidBefore = json['jwtTokenInvalidBefore'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailVerified'] = this.emailVerified;
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['fullName'] = this.fullName;
    if (this.avatars != null) {
      data['avatars'] = this.avatars?.map((v) => v.toJson()).toList();
    }
    if (this.tenants != null) {
      data['tenants'] = this.tenants?.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['emailVerificationTokenExpiresAt'] =
        this.emailVerificationTokenExpiresAt;
    data['updatedBy'] = this.updatedBy;
    data['lastName'] = this.lastName;
    data['phoneNumber'] = this.phoneNumber;
    data['passwordResetTokenExpiresAt'] = this.passwordResetTokenExpiresAt;
    data['jwtTokenInvalidBefore'] = this.jwtTokenInvalidBefore;
    data['id'] = this.id;
    return data;
  }
}
