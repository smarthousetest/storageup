import 'package:cpp_native/file_typification/file_typification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final Function() pop;

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
          child: Padding(
        padding: const EdgeInsets.only(bottom: 30, top: 30),
        child: Container(
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
      )),
    );
  }

  Widget _pathSection() {
    return BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
      builder: (context, state) {
        return Row(
          children: [
            ..._pathRow(state.previousFolders, state.currentFolder),
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
          return Container();
        }
      },
    );
  }

  List<Widget> _pathRow(List<Folder> folders, Folder? currentFolder) {
    List<Widget> path = [];
    List<Folder?> allPath = [...folders];
    allPath.add(currentFolder);

    var textStyle = TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: kNormalTextFontFamily,
      fontSize: 20,
    );
    for (var i = 0; i < allPath.length; i++) {
      Widget pathWidget = GestureDetector(
        onTap:
            allPath.length == 1 || i == allPath.length - 1 ? null : widget.pop,
        child: MouseRegion(
          cursor: allPath.length == 0 || i == allPath.length - 1
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          child: Text(
            i == 0 ? translate.files : allPath[i]!.name!,
            style: textStyle,
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
    return path;
  }

  Widget _filesGrid(BuildContext context, OpenedFolderState state) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constrains) {
        print('min width ${constrains.smallest.width}');

        return Container(
          child: GridView.builder(
            itemCount: state.objects.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constrains.smallest.width ~/ 110,
              childAspectRatio: (1 / 1.22),
              mainAxisSpacing: 15,
            ),
            itemBuilder: (context, index) {
              return ObjectView(object: state.objects[index]);
            },
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
