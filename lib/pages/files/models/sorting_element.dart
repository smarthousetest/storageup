enum SortingCriterion {
  byName,
  byDateCreated,
  byType,
  bySize,
}

enum SortingDirection {
  neutral,
  up,
  down,
}

class SortingElement {
  String text;
  SortingCriterion type;

  SortingElement({
    required this.text,
    required this.type,
  });
}
