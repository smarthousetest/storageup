import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/main_download_info.dart';

class DownloadInfoWidget extends StatelessWidget {
  const DownloadInfoWidget({
    Key? key,
    required this.downloadInfo,
    required this.translate,
  }) : super(key: key);

  final MainDownloadInfo downloadInfo;
  final S translate;

  @override
  Widget build(BuildContext context) {
    if (!downloadInfo.isDownloading) {
      return SizedBox.shrink();
    }

    return Container(
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate.downloading_files,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '${downloadInfo.countOfDownloadedFiles} / ${downloadInfo.countOfDownloadingFiles}',
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
            percent: downloadInfo.downloadingFilePercent / 100,
            progressColor: Color(0xFF70BBF6),
          ),
        ],
      ),
    );
  }
}
