import 'dart:convert';

import 'package:equatable/equatable.dart';

class Packet extends Equatable {
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? importHash;
  final String? tenant;
  final int? recordsCounter;
  final int? filledSpace;

  const Packet({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    this.importHash,
    this.tenant,
    this.recordsCounter,
    this.filledSpace,
  });

  factory Packet.fromMap(Map<String, dynamic> data) => Packet(
        id: data['id'] as String?,
        createdAt: data['createdAt'] as String?,
        updatedAt: data['updatedAt'] as String?,
        deletedAt: data['deletedAt'] as String?,
        createdBy: data['createdBy'] as String?,
        updatedBy: data['updatedBy'] as String?,
        importHash: data['importHash'] as String?,
        tenant: data['tenant'] as String?,
        recordsCounter: data['recordsCounter'] as int?,
        filledSpace: data['filledSpace'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'importHash': importHash,
        'tenant': tenant,
        'recordsCounter': recordsCounter,
        'filledSpace': filledSpace,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Packet].
  factory Packet.fromJson(Map<String, dynamic> data) {
    return Packet.fromMap(data);
  }

  /// `dart:convert`
  ///
  /// Converts [Packet] to a JSON string.
  String toJson() => json.encode(toMap());

  Packet copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    String? createdBy,
    String? updatedBy,
    String? importHash,
    String? tenant,
    int? recordsCounter,
    int? filledSpace,
  }) {
    return Packet(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      importHash: importHash ?? this.importHash,
      tenant: tenant ?? this.tenant,
      recordsCounter: recordsCounter ?? this.recordsCounter,
      filledSpace: filledSpace ?? this.filledSpace,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      createdAt,
      updatedAt,
      deletedAt,
      createdBy,
      updatedBy,
      importHash,
      tenant,
      recordsCounter,
      filledSpace,
    ];
  }
}
