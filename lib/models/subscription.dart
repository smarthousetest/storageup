import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'payment.dart';
import 'tariff.dart';

class Subscription extends Equatable {
  final String? id;
  final Tariff? tariff;
  final String? expireAt;
  final bool? isPayd;
  final Payment? payment;
  final String? owner;

  const Subscription({
    this.id,
    this.tariff,
    this.expireAt,
    this.isPayd,
    this.payment,
    this.owner,
  });

  factory Subscription.fromMap(Map<String, dynamic> data) => Subscription(
        id: data['_id'] as String?,
        tariff: data['tariff'] == null
            ? null
            : Tariff.fromMap(data['tariff'] as Map<String, dynamic>),
        expireAt: data['expireAt'] as String?,
        isPayd: data['isPayd'] as bool?,
        payment: data['payment'] == null
            ? null
            : Payment.fromMap(data['payment'] as Map<String, dynamic>),
        owner: data['owner'] as String?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'tariff': tariff?.toMap(),
        'expireAt': expireAt,
        'isPayd': isPayd,
        'payment': payment?.toMap(),
        'owner': owner,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Subscription].
  factory Subscription.fromJson(String data) {
    return Subscription.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Subscription] to a JSON string.
  String toJson() => json.encode(toMap());

  Subscription copyWith({
    String? id,
    Tariff? tariff,
    String? expireAt,
    bool? isPayd,
    Payment? payment,
    String? owner,
  }) {
    return Subscription(
      id: id ?? this.id,
      tariff: tariff ?? this.tariff,
      expireAt: expireAt ?? this.expireAt,
      isPayd: isPayd ?? this.isPayd,
      payment: payment ?? this.payment,
      owner: owner ?? this.owner,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      tariff,
      expireAt,
      isPayd,
      payment,
      owner,
    ];
  }
}
