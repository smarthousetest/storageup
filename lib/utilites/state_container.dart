import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';

class StateContainer extends StatefulWidget {
  final Widget child;

  StateContainer({
    required this.child,
  });

  static StateContainerState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>())!.data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  var _choosedPage = ChosenPage.home;
  var _locale = Locale('ru');
  ChosenPage get choosedPage => _choosedPage;
  Locale get locale => _locale;

  String? _choosedFilesFolderId;
  String? get choosedFilesFolderId => _choosedFilesFolderId;
  String? _choosedMediaFolderId;
  String? get choosedMediaFolderId => _choosedMediaFolderId;

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  void changePage(ChosenPage newPage) {
    setState(() {
      _choosedPage = newPage;
    });
  }

  void changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  void changeChoosedMediaFolderId(String? folderId) {
    setState(() {
      _choosedMediaFolderId = folderId;
    });
  }

  void changeChoosedFilesFolderId(String? folderId) {
    setState(() {
      _choosedFilesFolderId = folderId;
    });
    log('new folder id is $folderId');
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
