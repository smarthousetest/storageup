import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/components/custom_arc_indicator.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/components/custom_percent_indicator.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/download_location.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_bloc.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_event.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_state.dart';
import 'package:upstorage_desktop/pages/sell_space/space_view.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:upstorage_desktop/components/blur/keeper_delete_confirm.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/utilites/state_containers/state_container.dart';

class FolderList extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  FolderList({Key? key}) : super(key: key);
}

class _ButtonTemplateState extends State<FolderList> {
  List<Keeper> locationsInfo = [];
  List<CustomPopupMenuController> _popupControllers = [];

  void _initiatingControllers(FolderListState state) {
    if (_popupControllers.isEmpty) {
      locationsInfo.forEach((element) {
        _popupControllers.add(CustomPopupMenuController());
      });
    }
  }

  var customPopupMenuController = CustomPopupMenuController();
  S translate = getIt<S>();
  var bloc = FolderListBloc();

  @override
  void deactivate() {
    // TODO: implement deactivate
    bloc.close();
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc..add(FolderListPageOpened()),
      child: BlocBuilder<FolderListBloc, FolderListState>(
        builder: (context, state) {
          _initiatingControllers(state);
          locationsInfo = state.localKeepers;
          return SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                state.localKeepers.isNotEmpty
                    ? _thisKeeper(context, state)
                    : Container(),
                state.serverKeepers.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: _otherKeeper(context, state),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _thisKeeper(
    BuildContext context,
    FolderListState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Text(
            translate.this_computer,
            maxLines: 1,
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontFamily: kNormalTextFontFamily,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        LayoutBuilder(
          builder: (context, constrains) {
            var countOnElementsInRow = constrains.maxWidth ~/ 354;
            final elementsWidthWithoutSpacing =
                constrains.maxWidth - countOnElementsInRow * 20;
            final actualElementsWidth = countOnElementsInRow * 354;
            if (actualElementsWidth > elementsWidthWithoutSpacing) {
              countOnElementsInRow--;
            }
            return BlocBuilder<FolderListBloc, FolderListState>(
              builder: (context, state) {
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: state.localKeepers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: countOnElementsInRow,
                    mainAxisExtent: 345,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    var keeper = state.localKeepers[index];
                    var localPath = state.localPaths[index];

                    return _keeperInfo(context, keeper, localPath);
                  },
                );
              },
            );
          },
        )
      ],
    );
  }

  Widget _keeperInfo(
    BuildContext context,
    Keeper keeper,
    String localPath,
  ) {
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
                    keeper.name!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 18,
                    ),
                  ),
                ),
                Spacer(),
                BlocBuilder<FolderListBloc, FolderListState>(
                  builder: (context, state) {
                    if (state.localKeepers.length != _popupControllers.length) {
                      final controller = CustomPopupMenuController();
                      _popupControllers.add(controller);
                    }
                    return CustomPopupMenu(
                      pressType: PressType.singleClick,
                      barrierColor: Colors.transparent,
                      showArrow: false,
                      horizontalMargin: 10,
                      verticalMargin: 0,
                      controller:
                          _popupControllers[state.localKeepers.indexOf(keeper)],
                      menuBuilder: () {
                        return KeeperPopupMenuActions(
                          theme: Theme.of(context),
                          translate: translate,
                          onTap: (action) async {
                            _popupControllers[
                                    state.localKeepers.indexOf(keeper)]
                                .hideMenu();
                            if (action == KeeperAction.change) {
                              var changeKeeper;
                              for (var element in state.locationsInfo) {
                                if (element.keeperId == keeper.id) {
                                  changeKeeper = element;
                                  break;
                                }
                              }
                              SpaceInheritedWidget.of(context)
                                  .state
                                  .changePageIndex(1, changeKeeper);
                            } else {
                              var result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BlurDeleteKeeper();
                                },
                              );
                              if (result) {
                                var deleteKeeper;
                                for (var element in state.locationsInfo) {
                                  if (element.keeperId == keeper.id) {
                                    deleteKeeper = element;
                                    break;
                                  }
                                }
                                if (deleteKeeper != null) {
                                  context.read<FolderListBloc>().add(
                                      DeleteLocation(location: deleteKeeper));
                                }
                              }
                              setState(() {});
                            }
                          },
                        );
                      },
                      child: Container(
                        height: 29,
                        width: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/space_sell/dots.svg',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 310),
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                localPath,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 14,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _keeperIndicator(context, keeper),
                // Spacer(),
                _keeperProperties(context, keeper),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _keeperIndicator(BuildContext context, Keeper? keeper) {
    double percentSpace;
    var keeperAllSpace = keeper?.space;
    var usedSpace = keeper?.usedSpace;
    if (keeper != null && keeperAllSpace != null && usedSpace != null) {
      percentSpace = 100 / (keeperAllSpace / (usedSpace)).toDouble();
    } else {
      percentSpace = 0;
    }

    return Container(
      width: 146,
      padding: const EdgeInsets.only(left: 20.0, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                child: CircularArc(
                  value: keeper?.rating?.toDouble() ?? 0,
                ),
              ),
            ],
          ),
          Align(
            alignment: FractionalOffset.center,
            child: Text(
              translate.level_of_confidence,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).disabledColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${keeper?.rating ?? 0}%",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2?.color,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 16,
                ),
              ),
              Text(
                translate.of_percent,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.subtitle1?.color,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Stack(
              children: [
                Container(
                    child: PercentArc(
                  value: percentSpace,
                )),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: FractionalOffset.center,
            child: Text(
              translate.space,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).disabledColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 185),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  usedSpace != null
                      ? fileSize(usedSpace, translate, 0)
                      : "null",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline2?.color,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 16,
                  ),
                ),
                Text(
                  " из ${fileSize(keeperAllSpace, translate, 0)}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle1?.color,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _keeperProperties(
    BuildContext context,
    Keeper keeper,
  ) {
    return Container(
      width: 167,
      padding: const EdgeInsets.only(left: 45.0, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: FractionalOffset.centerLeft,
            child: Text(
              translate.downloating,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).disabledColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 98,
            height: 28,
            decoration: BoxDecoration(
              color: keeper.online == 1
                  ? Theme.of(context).selectedRowColor
                  : Color(0xFFFFE0DE),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                keeper.online == 1
                    ? "• ${translate.active}"
                    : "• ${translate.inactive}",
                style: TextStyle(
                  color: keeper.online == 1
                      ? Color(0xFF25B885)
                      : Theme.of(context).indicatorColor,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            translate.loading,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).disabledColor,
              fontFamily: kNormalTextFontFamily,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          keeper.online == 1
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BlocBuilder<FolderListBloc, FolderListState>(
                      builder: (context, state) {
                        var valueSwitch = keeper.sleepStatus;
                        if (valueSwitch != null && keeper.online == 1) {
                          valueSwitch = !valueSwitch;
                        }

                        return FlutterSwitch(
                          value: valueSwitch ?? true,
                          height: 20.0,
                          width: 40.0,
                          onToggle: (_) {
                            context
                                .read<FolderListBloc>()
                                .add(SleepStatus(keeper: keeper));
                          },
                          toggleSize: 16,
                          padding: 2,
                          activeColor: Theme.of(context).splashColor,
                          inactiveColor: Theme.of(context).canvasColor,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        keeper.sleepStatus == false && keeper.online == 1
                            ? translate.on
                            : translate.off,
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                )
              : BlocBuilder<FolderListBloc, FolderListState>(
                  builder: (context, state) {
                    var kk = state.localKeepers
                        .firstWhere((element) => element.name == keeper.name);
                    return GestureDetector(
                      onTap: () {
                        if (!kk.isRebooting!) {
                          print("Press reboot keeper");
                          DownloadLocation? rebootedKeeper;
                          for (var location in state.locationsInfo) {
                            if (location.keeperId == keeper.id) {
                              rebootedKeeper = location;
                              break;
                            }
                          }
                          if (rebootedKeeper != null) {
                            context
                                .read<FolderListBloc>()
                                .add(KeeperReboot(location: rebootedKeeper));
                          }
                        }
                      },
                      child: (kk.isRebooting!)
                          ? Container(
                              child: CircularProgressIndicator(),
                              width: 24,
                              height: 24)
                          : MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                width: 119,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Theme.of(context).splashColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/space_sell/refresh.svg',
                                        color: Theme.of(context).splashColor,
                                      ),
                                      Text(
                                        translate.reboot,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Theme.of(context).splashColor,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    );
                  },
                ),
          SizedBox(
            height: 20,
          ),
          Text(
            translate.ern_pay_day,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).disabledColor,
              fontFamily: kNormalTextFontFamily,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "0 Р",
            maxLines: 1,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).textTheme.headline2?.color,
              fontFamily: kNormalTextFontFamily,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            translate.learn_more,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).splashColor,
              fontFamily: kNormalTextFontFamily,
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _otherKeeper(
    BuildContext context,
    FolderListState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Text(
            translate.other_computers,
            maxLines: 1,
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontFamily: kNormalTextFontFamily,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        LayoutBuilder(
          builder: (context, constrains) {
            var countOnElementsInRow = constrains.maxWidth ~/ 354;
            final elementsWidthWithoutSpacing =
                constrains.maxWidth - countOnElementsInRow * 20;
            final actualElementsWidth = countOnElementsInRow * 354;
            if (actualElementsWidth > elementsWidthWithoutSpacing) {
              countOnElementsInRow--;
            }
            return GridView.builder(
              shrinkWrap: true,
              itemCount: state.serverKeepers.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: countOnElementsInRow,
                mainAxisExtent: 345,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                var keeper = state.serverKeepers[index];
                return _otherKeeperInfo(context, keeper);
              },
            );
          },
        )
      ],
    );
  }

  Widget _otherKeeperInfo(BuildContext context, Keeper keeper) {
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
        padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 200),
              child: Text(
                keeper.name!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _keeperIndicator(context, keeper),
                _otherKeeperProperties(context, keeper),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherKeeperProperties(BuildContext context, Keeper keeper) {
    return Container(
      width: 190,
      padding: const EdgeInsets.only(left: 45.0, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: FractionalOffset.centerLeft,
            child: Text(
              translate.downloating,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).disabledColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 98,
            height: 28,
            decoration: BoxDecoration(
              color: keeper.online == 1
                  ? Theme.of(context).selectedRowColor
                  : Color(0xFFFFE0DE),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                keeper.online == 1
                    ? "• ${translate.active}"
                    : "• ${translate.inactive}",
                style: TextStyle(
                  color: keeper.online == 1
                      ? Color(0xFF25B885)
                      : Theme.of(context).indicatorColor,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            translate.loading,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).disabledColor,
              fontFamily: kNormalTextFontFamily,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 119,
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Theme.of(context).canvasColor,
                width: 1.5,
              ),
            ),
            child: Center(
                child: Row(
              children: [
                SvgPicture.asset(
                  'assets/space_sell/refresh.svg',
                ),
                Text(
                  translate.reboot,
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 14,
                  ),
                ),
              ],
            )),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            translate.ern_pay_day,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).disabledColor,
              fontFamily: kNormalTextFontFamily,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "0 Р",
            maxLines: 1,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).textTheme.headline2?.color,
              fontFamily: kNormalTextFontFamily,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            translate.reboot_keeper,
            maxLines: 2,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontFamily: kNormalTextFontFamily,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Padding listDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Divider(
        height: 1,
        color: Theme.of(context).cardColor,
      ),
    );
  }
}

class KeeperPopupMenuActions extends StatefulWidget {
  KeeperPopupMenuActions({
    required this.theme,
    required this.translate,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final ThemeData theme;
  final S translate;
  final Function(KeeperAction) onTap;

  @override
  _KeeperPopupMenuActionsState createState() => _KeeperPopupMenuActionsState();
}

class _KeeperPopupMenuActionsState extends State<KeeperPopupMenuActions> {
  int ind = -1;

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: 14,
      color: Theme.of(context).disabledColor,
    );
    var mainColor = widget.theme.colorScheme.onSecondary;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: mainColor,
            spreadRadius: 3,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: IntrinsicWidth(
            child: Column(
              children: [
                GestureDetector(
                  onTapDown: (_) {
                    widget.onTap(KeeperAction.change);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 0;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 0 ? mainColor : null,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/file_page/file_options/rename.png',
                            height: 20,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.change,
                            style: style,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                GestureDetector(
                  onTapDown: (_) {
                    widget.onTap(KeeperAction.delete);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 1;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 1
                          ? widget.theme.indicatorColor.withOpacity(0.1)
                          : null,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/options/trash.svg',
                            height: 20,
                            color: widget.theme.indicatorColor,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.delete,
                            style: style.copyWith(
                                color: Theme.of(context).errorColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
