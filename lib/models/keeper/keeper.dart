import 'dart:convert';

import 'package:equatable/equatable.dart';

class Keeper extends Equatable {
  final String? id;
  final String? name;
  final int? online;
  final bool? isRebooting;
  final int? rating;
  final int? space;
  final int? availableSpace;
  final String? dirPath;
  final bool? sleepStatus;
  final int? usedSpace;

  const Keeper({
    this.id,
    this.name,
    this.online,
    this.isRebooting = false,
    this.rating,
    this.space,
    this.availableSpace,
    this.dirPath,
    this.sleepStatus,
    this.usedSpace,
  });

  factory Keeper.fromMap(Map<String, dynamic> data) => Keeper(
        id: data['id'] as String?,
        name: data['name'] as String?,
        online: data['online'] as int?,
        rating: data['rating'] as int?,
        space: data['space'] as int?,
        availableSpace: data['availableSpace'] as int?,
        sleepStatus: data['sleepStatus'] as bool?,
        usedSpace: data['usedSpace'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'online': online,
        'rating': rating,
        'space': space,
        'availableSpace': availableSpace,
        'sleepStatus': sleepStatus,
        'usedSpace': usedSpace,
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
    bool? isRebooting,
    int? rating,
    int? space,
    int? availableSpace,
    String? dirPath,
    bool? sleepStatus,
    int? usedSpace,
  }) {
    return Keeper(
      id: id ?? this.id,
      name: name ?? this.name,
      online: online ?? this.online,
      isRebooting: isRebooting ?? this.isRebooting,
      rating: rating ?? this.rating,
      space: space ?? this.space,
      availableSpace: availableSpace ?? this.availableSpace,
      dirPath: dirPath ?? this.dirPath,
      sleepStatus: sleepStatus ?? this.sleepStatus,
      usedSpace: usedSpace ?? this.usedSpace,
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
      sleepStatus,
      usedSpace,
      isRebooting,
    ];
  }

  @override
  String toString() {
    return 'Keeper{id: $id, name: $name, online: $online, isRebooting: $isRebooting, rating: $rating, space: $space,'
        ' availableSpace: $availableSpace, dirPath: $dirPath, sleepStatus: $sleepStatus, usedSpace: $usedSpace}';
  }
}
