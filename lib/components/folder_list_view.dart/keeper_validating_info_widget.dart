import 'dart:async';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:storageup/components/folder_list_view.dart/validate_keeper_progress_inidcator.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/keeper/keeper.dart';
import 'package:storageup/utilities/injection.dart';

class KeeperValidatingInfoWidget extends StatefulWidget {
  const KeeperValidatingInfoWidget({
    Key? key,
    required this.keeper,
    required this.localPath,
    required this.popupControllers,
    required this.validDate,
    required this.onValidateEnd,
  }) : super(key: key);

  final Keeper keeper;
  final String localPath;
  final List<CustomPopupMenuController> popupControllers;
  final DateTime validDate;
  final VoidCallback onValidateEnd;

  @override
  State<KeeperValidatingInfoWidget> createState() =>
      _KeeperValidatingInfoWidgetState();
}

class _KeeperValidatingInfoWidgetState
    extends State<KeeperValidatingInfoWidget> {
  final translate = getIt<S>();
  Duration timeLeft = Duration(hours: 3);
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      var nowDateTime = DateTime.now();
      timeLeft = widget.validDate.difference(nowDateTime);

      if (timeLeft < Duration.zero) {
        widget.onValidateEnd();
        timeLeft = Duration.zero;
      }

      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 345,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 2,
        ),
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    widget.keeper.name!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 310),
              padding: const EdgeInsets.only(top: 6, bottom: 10),
              child: Text(
                widget.localPath,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              translate.we_validating_your_keeper,
              style: TextStyle(
                color: Theme.of(context).disabledColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                height: 130,
                width: 130,
                child: ValidateKeeperProgressIndicator(
                  value: (1 -
                          (timeLeft.inSeconds / Duration(hours: 3).inSeconds)) *
                      100,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Column(
                children: [
                  Text(
                    translate.remaining_validation_time,
                    style: TextStyle(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    _humanReadableTimeLeft(timeLeft),
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.headline2?.color),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _humanReadableTimeLeft(Duration timeLeft) {
    String time = '';

    if (timeLeft.inHours >= 1) {
      time += '${translate.many_hours(timeLeft.inHours)} ';
    }

    time +=
        translate.many_minutes(timeLeft.inMinutes % Duration.minutesPerHour);

    return time;
  }
}
