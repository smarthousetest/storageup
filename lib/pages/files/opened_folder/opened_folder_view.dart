import 'package:cpp_native/file_typification/file_typification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_cubit.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class OpenedFolderView extends StatefulWidget {
  OpenedFolderView({
    Key? key,
    required this.currentFolder,
    required this.previousFolders,
    required this.pop,
    required this.push,
  }) : super(key: key);

  final Folder? currentFolder;
  final List<Folder> previousFolders;
  final Function(Widget) push;
  final Function(int) pop;

  @override
  _OpenedFolderViewState createState() => _OpenedFolderViewState();
}

class _OpenedFolderViewState extends State<OpenedFolderView> {
  S translate = getIt<S>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OpenedFolderCubit()
        ..init(
          widget.currentFolder,
          widget.previousFolders,
        ),
      child: Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromARGB(25, 23, 69, 139),
                  blurRadius: 4,
                  offset: Offset(1, 4))
            ],
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _pathSection(),
              Divider(
                color: Theme.of(context).dividerColor,
              ),
              _filesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pathSection() {
    return BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
      builder: (context, state) {
        return Row(
          // crossAxisAlignment: CrossAxisAlignment.baseline,
          // textBaseline: TextBaseline.alphabetic,
          children: [
            _pathRow(state.previousFolders, state.currentFolder),
            Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              iconSize: 30,
              onPressed: () {
                context
                    .read<OpenedFolderCubit>()
                    .changeRepresentation(FilesRepresentation.table);
              },
              icon: SvgPicture.asset(
                'assets/file_page/list.svg',
                color: state.representation == FilesRepresentation.table
                    ? Theme.of(context).splashColor
                    : Theme.of(context).toggleButtonsTheme.color,
              ),
            ),
            IconButton(
              iconSize: 30,
              onPressed: () {
                context
                    .read<OpenedFolderCubit>()
                    .changeRepresentation(FilesRepresentation.grid);
              },
              icon: SvgPicture.asset(
                'assets/file_page/block.svg',
                color: state.representation == FilesRepresentation.grid
                    ? Theme.of(context).splashColor
                    : Theme.of(context).toggleButtonsTheme.color,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _filesSection() {
    return BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
      builder: (context, state) {
        if (state.representation == FilesRepresentation.grid) {
          return _filesGrid(context, state);
        } else {
          return _filesList(context, state);
        }
      },
    );
  }

  Widget _pathRow(List<Folder> folders, Folder? currentFolder) {
    List<Widget> path = [];
    List<Folder?> allPath = [...folders];
    allPath.add(currentFolder);

    var textStyle = TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: kNormalTextFontFamily,
      fontSize: 20,
    );
    for (var i = 0; i < allPath.length; i++) {
      var countOfPop = allPath.length - 1 - i;
      Widget pathWidget = GestureDetector(
        onTap: allPath.length == 1 || i == allPath.length - 1
            ? null
            : () {
                widget.pop(countOfPop);
              },
        child: MouseRegion(
          cursor: allPath.length == 0 || i == allPath.length - 1
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          child: Text(
            i == 0 ? translate.files : allPath[i]!.name!,
            style: i == allPath.length - 1
                ? textStyle.copyWith(
                    color: Theme.of(context).textTheme.headline2?.color)
                : textStyle,
          ),
        ),
      );

      path.add(pathWidget);

      if (i != allPath.length - 1) {
        var seporator = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '/',
            style: textStyle,
          ),
        );

        path.add(seporator);
      }
    }
    return Row(
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: path,
    );
  }

  Widget _filesGrid(BuildContext context, OpenedFolderState state) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constrains) {
        print('min width ${constrains.smallest.width}');

        return Container(
          child: GridView.builder(
            itemCount: state.objects.length,
            shrinkWrap: true,
            controller: ScrollController(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constrains.smallest.width ~/ 110,
              childAspectRatio: (1 / 1.22),
              mainAxisSpacing: 15,
            ),
            itemBuilder: (context, index) {
              Function() onTap;
              var obj = state.objects[index];
              if (obj is Folder) {
                onTap = () {
                  widget.push(
                    OpenedFolderView(
                      currentFolder: obj,
                      previousFolders: [
                        ...state.previousFolders,
                        state.currentFolder!
                      ],
                      pop: widget.pop,
                      push: widget.push,
                    ),
                  );
                };
              } else {
                onTap = () {
                  print('file tapped');
                };
              }
              return GestureDetector(
                onTap: onTap,
                child: ObjectView(object: obj),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _filesList(BuildContext context, OpenedFolderState state) {
    TextStyle style = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: kNormalTextFontFamily,
    );
    TextStyle cellTextStyle = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontFamily: kNormalTextFontFamily,
    );

    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              DataColumn(
                label: Container(
                  width: constraints.maxWidth * 0.50,
                  child: Text(
                    translate.name,
                    style: style,
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  width: constraints.maxWidth * 0.1,
                  child: Text(
                    translate.format,
                    style: style,
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  width: constraints.maxWidth * 0.1,
                  child: Text(
                    translate.date,
                    style: style,
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  width: constraints.maxWidth * 0.22,
                  child: Text(
                    translate.size,
                    style: style,
                  ),
                ),
              ),
            ],
            rows: state.objects.map((e) {
              String? type = '';
              bool isFile = false;
              if (e is Record) {
                var record = e;
                isFile = true;
                if (record.thumbnail != null && record.thumbnail!.isNotEmpty) {
                  type =
                      FileAttribute().getFilesType(record.name!.toLowerCase());
                }
              }
              return DataRow(cells: [
                DataCell(Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      isFile
                          ? type.isNotEmpty
                              ? 'assets/file_icons/${type}_s.png'
                              : 'assets/file_icons/unexpected_s.png'
                          : 'assets/file_icons/folder.png',
                      fit: BoxFit.contain,
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        e.name ?? '',
                        style: cellTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Spacer(),
                    BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            context.read<OpenedFolderCubit>().setFavorite(e);
                          },
                          child: Image.asset(
                            e.favorite
                                ? 'assets/file_page/favorite.png'
                                : 'assets/file_page/not_favorite.png',
                            height: 18,
                            width: 18,
                          ),
                        );
                      },
                    )
                  ],
                )),
                DataCell(Text('a')),
                DataCell(Text('a')),
                DataCell(Text('a')),
              ]);
            }).toList(),
          ),
        );
      }),
    );
  }
}

class ObjectView extends StatelessWidget {
  const ObjectView({Key? key, required this.object}) : super(key: key);
  final BaseObject object;
  @override
  Widget build(BuildContext context) {
    String? type = '';
    bool isFile = false;
    // List<Widget> indicators = [Container()];
    if (object is Record) {
      var record = object as Record;
      isFile = true;
      // print(record.thumbnail?.first.publicUrl);
      if (record.thumbnail != null &&
              record.thumbnail!
                  .isNotEmpty /*&&
          record.thumbnail!.first.name!.contains('.')*/
          ) {
        type = FileAttribute().getFilesType(
            record.name!.toLowerCase()); //record.thumbnail?.first.name;
        // print(type);
      }

      // if (record.loadPercent != null && record.loadPercent != 99) {
      //   indicators = [
      //     Visibility(
      //       child: CircularProgressIndicator(
      //         value: record.loadPercent! / 100,
      //       ),
      //     ),
      //     CircularProgressIndicator.adaptive(),
      //   ];
      // }
    }
    return LayoutBuilder(
      builder: (context, constrains) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 90,
            // width: constrains.minHeight - 17,
            width: 80,
            child: isFile && type != 'image'
                ? type!.isNotEmpty
                    ? Image.asset(
                        'assets/file_icons/$type.png',
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        'assets/file_icons/files.png',
                        fit: BoxFit.contain,
                      )
                : type == 'image'
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          (object as Record).thumbnail!.first.publicUrl!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Image.asset(
                        'assets/file_icons/folder.png',
                        fit: BoxFit.contain,
                      ),
          ),
          Text(
            object.name ?? '',
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: kNormalTextFontFamily,
              fontSize: 14,
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}
