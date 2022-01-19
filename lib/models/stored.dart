import 'package:flutter/foundation.dart';

@immutable
class Part {
  final List<String>? locations;
  final String? id;
  final int? position;
  final String? hash;
  final int? size;
  final int? copyCount;
  final String? tenant;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  const Part({
    this.locations,
    this.id,
    this.position,
    this.hash,
    this.size,
    this.copyCount,
    this.tenant,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Stored(locations: $locations, id: $id, position: $position, hash: $hash, size: $size, copyCount: $copyCount, tenant: $tenant, createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, id: $id)';
  }

  factory Part.fromJson(Map<String, dynamic> json) => Part(
        locations: (json['locations'] as List<dynamic>?)?.cast(),
        id: json['_id'] as String?,
        position: json['position'] as int?,
        hash: json['hash'] as String?,
        size: json['size'] as int?,
        copyCount: json['copyCount'] as int?,
        tenant: json['tenant'] as String?,
        createdBy: json['createdBy'] as String?,
        updatedBy: json['updatedBy'] as String?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'locations': locations,
        '_id': id,
        'position': position,
        'hash': hash,
        'size': size,
        'copyCount': copyCount,
        'tenant': tenant,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
        'id': id,
      };

  Part copyWith({
    List<String>? locations,
    String? id,
    int? position,
    String? hash,
    int? size,
    int? copyCount,
    String? tenant,
    String? createdBy,
    String? updatedBy,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return Part(
      locations: locations ?? this.locations,
      id: id ?? this.id,
      position: position ?? this.position,
      hash: hash ?? this.hash,
      size: size ?? this.size,
      copyCount: copyCount ?? this.copyCount,
      tenant: tenant ?? this.tenant,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Part &&
        other.id == id &&
        other.position == position &&
        other.hash == hash &&
        other.size == size &&
        other.copyCount == copyCount &&
        other.tenant == tenant &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v &&
        other.id == id &&
        listEquals(other.locations, locations);
  }

  @override
  int get hashCode =>
      locations.hashCode ^
      id.hashCode ^
      position.hashCode ^
      hash.hashCode ^
      size.hashCode ^
      copyCount.hashCode ^
      tenant.hashCode ^
      createdBy.hashCode ^
      updatedBy.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode ^
      id.hashCode;
}
