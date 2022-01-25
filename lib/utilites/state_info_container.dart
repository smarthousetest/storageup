import 'package:flutter/material.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/pages/files/models/sorting_element.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_cubit.dart';

class StateInfoContainer extends StatefulWidget {
  final Widget child;

  StateInfoContainer({
    required this.child,
  });

  static StateInfoContainerState? of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<_InheritedStateInfoContainer>())
        ?.data;
  }

  @override
  StateInfoContainerState createState() => new StateInfoContainerState();
}

class StateInfoContainerState extends State<StateInfoContainer> {
  BaseObject? get object => _object;
  BaseObject? _object;
  SortingCriterion _sortedCriterion = SortingCriterion.byType;
  SortingCriterion get sortedCriterion => _sortedCriterion;
  SortingDirection _direction = SortingDirection.neutral;
  SortingDirection get direction => _direction;
  String? _search;
  String? get search => _search;

  @override
  Widget build(BuildContext context) {
    return _InheritedStateInfoContainer(
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

  void setInfoObject(BaseObject? object) {
    setState(() {
      _object = object;
    });
  }
}

class _InheritedStateInfoContainer extends InheritedWidget {
  final StateInfoContainerState data;

  _InheritedStateInfoContainer({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateInfoContainer old) => true;
}
