import 'package:flutter/material.dart';
import 'package:storageup/pages/files/models/sorting_element.dart';

class StateSortedContainer extends StatefulWidget {
  final Widget child;

  StateSortedContainer({
    required this.child,
  });

  static StateSortedContainerState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InheritedStateSortedContainer>())!.data;
  }

  @override
  StateSortedContainerState createState() => new StateSortedContainerState();
}

class StateSortedContainerState extends State<StateSortedContainer> {
  SortingCriterion _sortedCriterion = SortingCriterion.byDateCreated;
  SortingCriterion get sortedCriterion => _sortedCriterion;
  SortingDirection _direction = SortingDirection.down;
  SortingDirection get direction => _direction;
  String _search = '';
  String get search => _search;
  bool _sortedActionButton = false;
  bool get sortedActionButton => _sortedActionButton;

  @override
  Widget build(BuildContext context) {
    return _InheritedStateSortedContainer(
      data: this,
      child: widget.child,
    );
  }

  void newSortedCriterion(SortingCriterion newSortedCriterion) {
    setState(() {
      _sortedCriterion = newSortedCriterion;
    });
  }

  void newSortedDirection(SortingDirection direction) {
    setState(() {
      _direction = direction;
    });
  }

  void actionForButton() {
    setState(() {
      _sortedActionButton = !sortedActionButton;
    });
  }

  void searchAction(String search) {
    setState(() {
      _search = search;
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
