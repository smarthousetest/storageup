import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/record.dart';
import 'package:flutter/material.dart';

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
  Record? get record => _record;
  Record? _record;
  bool _open = false;
  bool? get open => _open;

  @override
  Widget build(BuildContext context) {
    return _InheritedStateInfoContainer(
      data: this,
      child: widget.child,
    );
  }

  void setInfoRecord(Record? record) {
    setState(() {
      _record = record;
    });
  }

  void setInfoObject(BaseObject? object) {
    setState(() {
      _object = object;
    });
  }

  // void openFile() {
  //   setState(() {
  //     _open = !_open;
  //   });
  // }
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
