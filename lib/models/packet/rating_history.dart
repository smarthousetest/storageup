import 'dart:convert';

import 'package:equatable/equatable.dart';

class RatingHistory extends Equatable {
  final int? rating;
  final String? date;

  const RatingHistory({this.rating, this.date});

  factory RatingHistory.fromMap(Map<String, dynamic> data) => RatingHistory(
        rating: data['rating'] as int?,
        date: data['date'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'rating': rating,
        'date': date,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RatingHistory].
  factory RatingHistory.fromJson(String data) {
    return RatingHistory.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RatingHistory] to a JSON string.
  String toJson() => json.encode(toMap());

  RatingHistory copyWith({
    int? rating,
    String? date,
  }) {
    return RatingHistory(
      rating: rating ?? this.rating,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [rating, date];
}
