import 'dart:convert';

import 'package:equatable/equatable.dart';

class Tariff extends Equatable {
  final String? id;
  final String? level;
  final int? priceRub;
  final int? priceUsd;
  final int? priceEur;
  final int? spaceGb;

  const Tariff({
    this.id,
    this.level,
    this.priceRub,
    this.priceUsd,
    this.priceEur,
    this.spaceGb,
  });

  factory Tariff.fromMap(Map<String, dynamic> data) => Tariff(
        id: data['_id'] as String?,
        level: data['level'] as String?,
        priceRub: data['price_RUB'] as int?,
        priceUsd: data['price_USD'] as int?,
        priceEur: data['price_EUR'] as int?,
        spaceGb: data['spaceGb'] as int?,
      );
  static List<Tariff> fromJsonList(List<Map<String, dynamic>> list) {
    return list.map((e) => Tariff.fromMap(e)).toList();
  }

  Map<String, dynamic> toMap() => {
        '_id': id,
        'level': level,
        'price_RUB': priceRub,
        'price_USD': priceUsd,
        'price_EUR': priceEur,
        'spaceGb': spaceGb,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Tariff].
  factory Tariff.fromJson(String data) {
    return Tariff.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Tariff] to a JSON string.
  String toJson() => json.encode(toMap());

  Tariff copyWith({
    String? id,
    String? level,
    int? priceRub,
    int? priceUsd,
    int? priceEur,
    int? spaceGb,
  }) {
    return Tariff(
      id: id ?? this.id,
      level: level ?? this.level,
      priceRub: priceRub ?? this.priceRub,
      priceUsd: priceUsd ?? this.priceUsd,
      priceEur: priceEur ?? this.priceEur,
      spaceGb: spaceGb ?? this.spaceGb,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      level,
      priceRub,
      priceUsd,
      priceEur,
      spaceGb,
    ];
  }
}
