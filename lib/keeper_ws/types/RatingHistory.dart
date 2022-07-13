import 'dart:convert';

/// rating : 0
/// date : "string"

RatingHistory ratingHistoryFromJson(String str) => RatingHistory.fromJson(json.decode(str));
String ratingHistoryToJson(RatingHistory data) => json.encode(data.toJson());
class RatingHistory {
  RatingHistory({
      this.rating, 
      this.date,});

  RatingHistory.fromJson(dynamic json) {
    rating = json['rating'];
    date = json['date'];
  }
  int? rating;
  String? date;
RatingHistory copyWith({  int? rating,
  String? date,
}) => RatingHistory(  rating: rating ?? this.rating,
  date: date ?? this.date,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rating'] = rating;
    map['date'] = date;
    return map;
  }

}