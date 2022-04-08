import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class BaseObject extends Equatable {
  int size;
  String id;
  String? name;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? extension;
  bool isChoosed;
  bool favorite;

  BaseObject({
    required this.size,
    this.createdAt,
    this.createdBy,
    required this.id,
    this.name,
    this.updatedAt,
    this.updatedBy,
    this.extension,
    this.isChoosed = false,
    required this.favorite,
  });

  @override
  List<Object?> get props => [
        size,
        id,
        createdAt,
        createdBy,
        favorite,
        name,
        updatedAt,
        updatedBy,
        extension,
        isChoosed,
        favorite,
      ];
}

/*abstract class ExtentionFind {
  String GetElementObjectFunction();
}*/
