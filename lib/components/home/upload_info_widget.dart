import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:storageup/pages/home/home_bloc.dart';
import 'package:storageup/pages/home/home_state.dart';

class UploadInfoWidget extends StatelessWidget {
  const UploadInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 30,
      bottom: 20,
      child: Container(
        height: 68,
        width: 500,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFFF1F8FE)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(25, 23, 69, 139),
              blurRadius: 6,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Идет загрузка файлов',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${state.uploadInfo.countOfUploadedFiles} / ${state.uploadInfo.countOfUploadingFiles}',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  animation: false,
                  backgroundColor: Color(0xFFF7F9FB),
                  lineHeight: 4.0,
                  barRadius: Radius.circular(7),
                  alignment: MainAxisAlignment.end,
                  percent: state.uploadInfo.uploadingFilePercent / 100,
                  progressColor: Color(0xFF70BBF6),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
