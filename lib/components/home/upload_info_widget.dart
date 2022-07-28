import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/main_download_info.dart';
import 'package:storageup/models/main_upload_info.dart';

class UploadInfoWidget extends StatelessWidget {
  const UploadInfoWidget({
    Key? key,
    required this.uploadInfo,
    required this.translate,
  }) : super(key: key);

  final MainUploadInfo uploadInfo;
  final S translate;

  @override
  Widget build(BuildContext context) {
    if (!uploadInfo.isUploading) {
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
                translate.uploading_files,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '${uploadInfo.countOfUploadedFiles} / ${uploadInfo.countOfUploadingFiles}',
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
            percent: uploadInfo.uploadingFilePercent / 100,
            progressColor: Color(0xFF70BBF6),
          ),
        ],
      ),
    );
  }
}
