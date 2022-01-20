import 'package:flutter/material.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/models/base_object.dart';

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

  @override
  Widget build(BuildContext context) {
    return _InheritedStateInfoContainer(
      data: this,
      child: widget.child,
    );
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
