import 'dart:convert';

import 'package:equatable/equatable.dart';

class Keeper extends Equatable {
  final String? id;
  final String? idi;
  final int? online;
  final int? rating;
  final int? space;
  final int? availableSpace;

  const Keeper({
    this.id,
    this.idi,
    this.online,
    this.rating,
    this.space,
    this.availableSpace,
  });

  factory Keeper.fromMap(Map<String, dynamic> data) => Keeper(
        id: data['id'] as String?,
        idi: data['_id'] as String?,
        online: data['online'] as int?,
        rating: data['rating'] as int?,
        space: data['space'] as int?,
        availableSpace: data['availableSpace'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        '_id': idi,
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
    String? idi,
    int? online,
    int? rating,
    int? space,
    int? availableSpace,
  }) {
    return Keeper(
      id: id ?? this.id,
      idi: idi ?? this.idi,
      online: online ?? this.online,
      rating: rating ?? this.rating,
      space: space ?? this.space,
      availableSpace: availableSpace ?? this.availableSpace,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      idi,
      online,
      rating,
      space,
      availableSpace,
    ];
  }
}
