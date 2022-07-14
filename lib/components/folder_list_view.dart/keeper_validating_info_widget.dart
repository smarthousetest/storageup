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
  }) : super(key: key);

  final Keeper keeper;
  final String localPath;
  final List<CustomPopupMenuController> popupControllers;

  @override
  State<KeeperValidatingInfoWidget> createState() =>
      _KeeperValidatingInfoWidgetState();
}

class _KeeperValidatingInfoWidgetState
    extends State<KeeperValidatingInfoWidget> {
  final translate = getIt<S>();

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
              'На данный момент проверяется надежность вашего принимающего устройства. Проверка может занять до 3 часов.',
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
                  value: 75,
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
                    'Оставшееся время проверки',
                    style: TextStyle(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '5 часов 23 минуты',
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
}
