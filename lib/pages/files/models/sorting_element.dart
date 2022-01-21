enum SortingCriterion { byName, byDateCreated, byDateViewed, byType, bySize }

class SortingElement {
  String text;
  SortingCriterion type;

  SortingElement({
    required this.text,
    required this.type,
  });
}
