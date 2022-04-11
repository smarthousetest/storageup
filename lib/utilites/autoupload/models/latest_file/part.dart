import 'package:hive/hive.dart';
part 'part.g.dart';

@HiveType(typeId: 5)
class Part extends HiveObject {
  @HiveField(0)
  List<String>? locations;
  @HiveField(1)
  String? id;
  @HiveField(2)
  int? position;
  @HiveField(3)
  String? hash;
  @HiveField(4)
  int? size;
  @HiveField(5)
  int? copyCount;
  @HiveField(6)
  String? tenant;
  @HiveField(7)
  String? createdBy;
  @HiveField(8)
  String? updatedBy;
  @HiveField(9)
  String? createdAt;
  @HiveField(10)
  String? updatedAt;
  @HiveField(11)
  int? v;

  Part({
    this.locations,
    String? id,
    this.position,
    this.hash,
    this.size,
    this.copyCount,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.tenant,
    this.updatedAt,
    this.v,
  });

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
  String toString() {
    return 'locations: $locations,  id: $id, position: $position, hash: $hash, size: $size, copyCount: $copyCount, tenant: $tenant,  createdBy: $createdBy,  updatedBy: $updatedBy, createdAt: $createdAt ,  updatedAt: $updatedAt, v: $v';
  }
}
