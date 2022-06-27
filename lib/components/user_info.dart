import 'package:flutter/material.dart';
import 'package:storageup/components/custom_button_template.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/utilities/state_containers/state_container.dart';
import 'package:storageup/utilities/extensions.dart';

class UserInfo extends StatelessWidget {
  const UserInfo(
      {Key? key,
      required this.user,
      required this.isExtended,
      required this.padding,
      required this.textInfoConstraints})
      : super(key: key);

  final User? user;
  final bool isExtended;
  final EdgeInsets padding;
  final BoxConstraints textInfoConstraints;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        StateContainer.of(context).changePage(ChosenPage.settings);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          children: [
            Padding(
              padding: padding,
              child: Container(
                height: 46,
                // width: 46,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: GestureDetector(
                      onTap: () {
                        StateContainer.of(context)
                            .changePage(ChosenPage.settings);
                      },
                      child: user.image),
                ),
              ),
            ),
            if (isExtended)
              Container(
                constraints: textInfoConstraints,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        user?.firstName ??
                            user?.email?.split('@').first ??
                            'Name',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).bottomAppBarColor,
                        ),
                      ),
                    ),
                    Text(
                      user?.email ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).bottomAppBarColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
