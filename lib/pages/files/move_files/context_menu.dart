import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:after_layout/after_layout.dart';

/// Show a [ContextMenu] on the given [BuildContext]. For other parameters, see [ContextMenu].
void showContextMenu(
  Offset offset,
  BuildContext context,
  ContextMenuBuilder builder,
  verticalPadding,
  width,
) {
  showModal(
    context: context,
    configuration: FadeScaleTransitionConfiguration(
      barrierColor: Colors.transparent,
    ),
    builder: (context) => ContextMenu(
      position: offset,
      builder: builder,
      verticalPadding: verticalPadding,
      width: width,
    ),
  );
}

/// The [ContextMenuArea] is the way to use a [ContextMenu]
///
/// It listens for right click and long press and executes [showContextMenu]
/// with the corresponding location [Offset].

class ContextMenuArea extends StatelessWidget {
  /// The widget displayed inside the [ContextMenuArea]
  final Widget child;

  /// Builds a [List] of items to be displayed in an opened [ContextMenu]
  ///
  /// Usually, a [ListTile] might be the way to go.
  final ContextMenuBuilder builder;

  /// The padding value at the top an bottom between the edge of the [ContextMenu] and the first / last item
  final double verticalPadding;

  /// The width for the [ContextMenu]. 320 by default according to Material Design specs.
  final double width;

  const ContextMenuArea({
    Key? key,
    required this.child,
    required this.builder,
    this.verticalPadding = 0,
    this.width = 190,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) => showContextMenu(
        details.globalPosition,
        context,
        builder,
        verticalPadding,
        width,
      ),
      onLongPressStart: (details) => showContextMenu(
        details.globalPosition,
        context,
        builder,
        verticalPadding,
        width,
      ),
      child: child,
    );
  }
}

typedef ContextMenuBuilder = List<Widget> Function(BuildContext context);

const double _kMinTileHeight = 40;

/// The actual [ContextMenu] to be displayed
///
/// You will most likely use [showContextMenu] to manually display a [ContextMenu].
///
/// If you just want to use a normal [ContextMenu], please use [ContextMenuArea].

class ContextMenu extends StatefulWidget {
  /// The [Offset] from coordinate origin the [ContextMenu] will be displayed at.
  final Offset position;

  /// The builder for the items to be displayed. [ListTile] is very useful in most cases.
  final ContextMenuBuilder builder;

  /// The padding value at the top an bottom between the edge of the [ContextMenu] and the first / last item
  final double verticalPadding;

  /// The width for the [ContextMenu]. 320 by default according to Material Design specs.
  final double width;

  const ContextMenu({
    Key? key,
    required this.position,
    required this.builder,
    this.verticalPadding = 8,
    this.width = 190,
  }) : super(key: key);

  @override
  _ContextMenuState createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  Map<ValueKey, double> _heights = Map();

  @override
  Widget build(BuildContext context) {
    final children = widget.builder(context);

    double height = 2 * widget.verticalPadding;

    _heights.values.forEach((element) {
      height += element;
    });

    final heightsNotAvailable = children.length - _heights.length;
    height += heightsNotAvailable * _kMinTileHeight;

    if (height > MediaQuery.of(context).size.height)
      height = MediaQuery.of(context).size.height;

    double paddingLeft = widget.position.dx;
    double paddingTop = widget.position.dy;
    double paddingRight =
        MediaQuery.of(context).size.width - widget.position.dx - widget.width;
    if (paddingRight < 0) {
      paddingLeft += paddingRight;
      paddingRight = 0;
    }
    double paddingBottom =
        MediaQuery.of(context).size.height - widget.position.dy - height;
    if (paddingBottom < 0) {
      paddingTop += paddingBottom;
      paddingBottom = 0;
    }
    return AnimatedPadding(
      padding: EdgeInsets.fromLTRB(
        paddingLeft,
        paddingTop,
        paddingRight,
        paddingBottom,
      ),
      duration: _kShortDuration,
      child: SizedBox.shrink(
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: Colors.transparent,
              child: ListView(
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
                children: children
                    .map(
                      (e) => _GrowingWidget(
                        child: e,
                        onHeightChange: (height) {
                          setState(() {
                            _heights[ValueKey(e)] = height;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _kShortDuration = Duration(milliseconds: 75);

class _GrowingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<double> onHeightChange;

  const _GrowingWidget(
      {Key? key, required this.child, required this.onHeightChange})
      : super(key: key);

  @override
  __GrowingWidgetState createState() => __GrowingWidgetState();
}

class __GrowingWidgetState extends State<_GrowingWidget> with AfterLayoutMixin {
  GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
      key: _key,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final newHeight = _key.currentContext!.size!.height;
    widget.onHeightChange.call(newHeight);
  }
}
