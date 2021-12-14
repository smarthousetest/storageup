class ResponseList<T> {
  final List<T>? rows;
  final int? count;

  ResponseList({
    this.rows,
    this.count,
  });

  factory ResponseList.fromJson(
    Map<String, dynamic> json,
    Function(Map<String, dynamic>) fromJsonModel,
  ) =>
      ResponseList(
        rows: List<T>.from(
          (json['rows'] as List<dynamic>).map(
            (e) => fromJsonModel(e as Map<String, dynamic>),
          ),
        ),
        count: json['count'] as int?,
      );
}
