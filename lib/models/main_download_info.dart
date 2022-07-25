import 'package:equatable/equatable.dart';

class MainDownloadInfo extends Equatable {
  final double downloadingFilePercent;
  final bool isDownloading;
  final int countOfDownloadingFiles;
  final int countOfDownloadedFiles;

  const MainDownloadInfo({
    this.downloadingFilePercent = 0,
    this.isDownloading = false,
    this.countOfDownloadingFiles = 0,
    this.countOfDownloadedFiles = 0,
  });

  MainDownloadInfo copyWith({
    double? downloadingFilePercent,
    bool? isDownloading,
    int? countOfDownloadingFiles,
    int? countOfDownloadedFiles,
  }) {
    return MainDownloadInfo(
      downloadingFilePercent:
          downloadingFilePercent ?? this.downloadingFilePercent,
      isDownloading: isDownloading ?? this.isDownloading,
      countOfDownloadingFiles:
          countOfDownloadingFiles ?? this.countOfDownloadingFiles,
      countOfDownloadedFiles:
          countOfDownloadedFiles ?? this.countOfDownloadedFiles,
    );
  }

  @override
  List<Object?> get props => [
        downloadingFilePercent,
        isDownloading,
        countOfDownloadingFiles,
        countOfDownloadedFiles,
      ];
}
