enum SortingCriterion { byName, byDate, byType, bySize }

class SortingElement {
  String text;
  SortingCriterion type;

  SortingElement({
    required this.text,
    required this.type,
  });
}
