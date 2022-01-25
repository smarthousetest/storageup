import 'package:flutter/material.dart';
import 'package:upstorage_desktop/pages/files/models/sorting_element.dart';

class StateSortedContainer extends StatefulWidget {
  final Widget child;

  StateSortedContainer({
    required this.child,
  });

  static StateSortedContainerState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<
            _InheritedStateSortedContainer>())!
        .data;
  }

  @override
  StateSortedContainerState createState() => new StateSortedContainerState();
}

class StateSortedContainerState extends State<StateSortedContainer> {
  SortingCriterion _sortedCriterion = SortingCriterion.byType;
  SortingCriterion get sortedCriterion => _sortedCriterion;
  SortingDirection _direction = SortingDirection.neutral;
  SortingDirection get direction => _direction;
  String? _search;
  String? get search => _search;

  @override
  Widget build(BuildContext context) {
    return _InheritedStateSortedContainer(
      data: this,
      child: widget.child,
    );
  }

  void newSortedCriterion(
      SortingCriterion newSortedCriterion, SortingDirection direction) {
    setState(() {
      _sortedCriterion = newSortedCriterion;
      _direction = direction;
    });
  }
}

class _InheritedStateSortedContainer extends InheritedWidget {
  final StateSortedContainerState data;

  _InheritedStateSortedContainer({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateSortedContainer old) => true;
}
