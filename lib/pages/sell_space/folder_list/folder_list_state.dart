import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:storageup/models/download_location.dart';
import 'package:storageup/models/keeper/keeper.dart';
import 'package:storageup/models/user.dart';

class FolderListState extends Equatable {
  final User? user;
  final List<DownloadLocation> locationsInfo;
  final List<Keeper>? keepers;
  final List<Keeper> localKeepers;
  final List<Keeper> serverKeepers;
  final List<String> localPaths;
  final bool sleepStatus;
  final FormzStatus statusHttpRequest;
  final bool needToValidatePopup;

  FolderListState({
    this.user,
    this.locationsInfo = const [],
    this.keepers,
    this.localKeepers = const [],
    this.serverKeepers = const [],
    this.localPaths = const [],
    this.sleepStatus = true,
    this.statusHttpRequest = FormzStatus.pure,
    this.needToValidatePopup = false,
  });

  FolderListState copyWith({
    User? user,
    List<DownloadLocation>? locationsInfo,
    List<Keeper>? keepers,
    List<Keeper>? localKeeper,
    List<Keeper>? serverKeeper,
    List<String>? localPath,
    bool? sleepStatus,
    FormzStatus? statusHttpRequest,
    bool? needToValidatePopup,
  }) {
    return FolderListState(
      user: user ?? this.user,
      locationsInfo: locationsInfo ?? this.locationsInfo,
      keepers: keepers ?? this.keepers,
      localKeepers: localKeeper ?? this.localKeepers,
      serverKeepers: serverKeeper ?? this.serverKeepers,
      localPaths: localPath ?? this.localPaths,
      sleepStatus: sleepStatus ?? this.sleepStatus,
      statusHttpRequest: statusHttpRequest ?? FormzStatus.pure,
      needToValidatePopup: needToValidatePopup ?? true,
    );
  }

  @override
  List<Object?> get props => [
        user,
        locationsInfo,
        keepers,
        localKeepers,
        serverKeepers,
        localPaths,
        sleepStatus,
        statusHttpRequest,
        needToValidatePopup,
      ];
}
