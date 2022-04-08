import 'dart:convert';

import 'package:equatable/equatable.dart';

class Avatar extends Equatable {
  final String? name;
  final int? sizeInBytes;
  final String? privateUrl;
  final String? publicUrl;
  final bool? now;

  const Avatar({
    this.name,
    this.sizeInBytes,
    this.privateUrl,
    this.publicUrl,
    this.now,
  });

  factory Avatar.fromMap(Map<String, dynamic> data) => Avatar(
        name: data['name'] as String?,
        sizeInBytes: data['sizeInBytes'] as int?,
        privateUrl: data['privateUrl'] as String?,
        publicUrl: data['publicUrl'] as String?,
        now: data['new'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'sizeInBytes': sizeInBytes,
        'privateUrl': privateUrl,
        'publicUrl': publicUrl,
        'new': now,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Avatar].
  factory Avatar.fromJson(String data) {
    return Avatar.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Avatar] to a JSON string.
  String toJson() => json.encode(toMap());

  Avatar copyWith({
    String? name,
    int? sizeInBytes,
    String? privateUrl,
    String? publicUrl,
    bool? now,
  }) {
    return Avatar(
      name: name ?? this.name,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      privateUrl: privateUrl ?? this.privateUrl,
      publicUrl: publicUrl ?? this.publicUrl,
      now: now ?? this.now,
    );
  }

  @override
  List<Object?> get props {
    return [
      name,
      sizeInBytes,
      privateUrl,
      publicUrl,
      now,
    ];
  }
}
