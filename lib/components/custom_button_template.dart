import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/utilites/state_containers/state_container.dart';

enum ChosenPage {
  home,
  file,
  keeper,
  media,
  like,
  sell_space,
  finance,
  settings,
  trash,
}

class CustomMenuButton extends StatefulWidget {
  final String icon, title;
  final Function() onTap;
  final ChosenPage page;

  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  CustomMenuButton({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.page,
  });
}

class _ButtonTemplateState extends State<CustomMenuButton> {
  @override
  Widget build(BuildContext context) {
    var isSelected = StateContainer.of(context).choosedPage == widget.page;
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).dividerColor
              : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(7),
        ),
        width: 214,
        height: 44,
        child: TextButton.icon(
          onPressed: widget.onTap,
          label: Text(
            widget.title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).splashColor
                  : Theme.of(context).colorScheme.onBackground,
            ),
          ),
          icon: SvgPicture.asset(
            widget.icon,
            color: isSelected
                ? Theme.of(context).splashColor
                : Theme.of(context).colorScheme.onBackground,
          ),
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            primary: isSelected
                ? Theme.of(context).dividerColor
                : Theme.of(context).primaryColor,
            //onPrimary: Colors.transparent,
            shadowColor: const Color.fromARGB(0, 0, 0, 0),
            side: const BorderSide(
              style: BorderStyle.none,
            ),
            // textStyle: TextStyle(
            //   fontSize: 17,
            //   fontWeight: FontWeight.normal,
            //   color: isSelected
            //       ? Theme.of(context).splashColor
            //       : Theme.of(context).colorScheme.onBackground,
            // ),
          ),
        ),
      ),
    );
  }
}
