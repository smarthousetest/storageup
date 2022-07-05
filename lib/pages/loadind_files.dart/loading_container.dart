import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/pages/loadind_files.dart/loading_container_bloc.dart';
import 'package:storageup/pages/loadind_files.dart/loading_container_state.dart';
import 'package:storageup/utilities/injection.dart';

class LoadingContainer extends StatefulWidget {
  @override
  State<LoadingContainer> createState() => _LoadingContainerState();
}

class _LoadingContainerState extends State<LoadingContainer> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocProvider(
        create: (context) => getIt<LoadingContainerBloc>(),
        child: BlocBuilder<LoadingContainerBloc, LoadingContainerState>(
            builder: (context, state) {
          return Visibility(
            visible: state.uploadInfo.isUploading,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 97,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 2,
                    ),
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _uploadingRow(theme),
                ),
              ),
            ),
          );
        }));
  }

  Widget _uploadingRow(ThemeData theme) {
    return Visibility(
      visible: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 5),
                child: Text(
                  "Идет загрузка · 50%",
                  // translate.uploading,
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 16,
                    color: theme.disabledColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5, top: 5),
                child: Text(
                  "Закрыть",
                  // '${state.uploadInfo.countOfUploadedFiles} / ${state.uploadInfo.countOfUploadingFiles}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    height: 1.8,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 14.0,
                    color: Color(0xFF5A5A5A),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            child: Text(
              "Загруженно файлов 1/1",
              // '${state.uploadInfo.countOfUploadedFiles} / ${state.uploadInfo.countOfUploadingFiles}',
              textAlign: TextAlign.start,
              style: TextStyle(
                height: 1.8,
                fontFamily: kNormalTextFontFamily,
                fontSize: 10.0,
                color: theme.disabledColor.withOpacity(0.5),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          LinearPercentIndicator(
            padding: EdgeInsets.symmetric(horizontal: 4),
            animation: false,
            linearGradient:
                LinearGradient(colors: [Color(0xFF70BBF6), Color(0xFF70BBF6)]),
            backgroundColor: Color(0xFFF1F8FE),
            lineHeight: 5.0,
            alignment: MainAxisAlignment.end,
            percent: 0.5,
            barRadius: Radius.circular(10),
          ),
          SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }
}
