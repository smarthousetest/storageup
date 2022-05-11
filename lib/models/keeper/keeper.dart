import 'dart:convert';

import 'package:equatable/equatable.dart';

class Keeper extends Equatable {
  final String? id;

  final String? name;
  final int? online;
  final int? rating;
  final int? space;
  final int? availableSpace;
  final String? dirPath;

  const Keeper({
    this.id,
    this.name,
    this.online,
    this.rating,
    this.space,
    this.availableSpace,
    this.dirPath,
  });

  factory Keeper.fromMap(Map<String, dynamic> data) => Keeper(
        id: data['id'] as String?,
        name: data['name'] as String?,
        online: data['online'] as int?,
        rating: data['rating'] as int?,
        space: data['space'] as int?,
        availableSpace: data['availableSpace'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'online': online,
        'rating': rating,
        'space': space,
        'availableSpace': availableSpace,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Keeper].
  factory Keeper.fromJson(String data) {
    return Keeper.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Keeper] to a JSON string.
  String toJson() => json.encode(toMap());

  Keeper copyWith({
    String? id,
    String? name,
    int? online,
    int? rating,
    int? space,
    int? availableSpace,
    String? dirPath,
  }) {
    return Keeper(
      id: id ?? this.id,
      name: name ?? this.name,
      online: online ?? this.online,
      rating: rating ?? this.rating,
      space: space ?? this.space,
      availableSpace: availableSpace ?? this.availableSpace,
      dirPath: dirPath ?? this.dirPath,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      online,
      rating,
      space,
      availableSpace,
      dirPath,
    ];
  }
}
