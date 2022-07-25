import 'package:equatable/equatable.dart';

class MainUploadInfo extends Equatable {
  final double uploadingFilePercent;
  final bool isUploading;
  final int countOfUploadingFiles;
  final int countOfUploadedFiles;

  const MainUploadInfo({
    this.uploadingFilePercent = 0,
    this.isUploading = false,
    this.countOfUploadingFiles = 0,
    this.countOfUploadedFiles = 0,
  });

  MainUploadInfo copyWith({
    double? uploadingFilePercent,
    bool? isUploading,
    int? countOfUpnloadingFiles,
    int? countOfUpnloadedFiles,
  }) {
    return MainUploadInfo(
      uploadingFilePercent: uploadingFilePercent ?? this.uploadingFilePercent,
      isUploading: isUploading ?? this.isUploading,
      countOfUploadingFiles:
          countOfUpnloadingFiles ?? this.countOfUploadingFiles,
      countOfUploadedFiles: countOfUpnloadedFiles ?? this.countOfUploadedFiles,
    );
  }

  @override
  List<Object?> get props => [
        uploadingFilePercent,
        isUploading,
        countOfUploadingFiles,
        countOfUploadedFiles,
      ];
}
