import 'package:cpp_native/models/folder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:storageup/models/packet/packet.dart';
import 'package:storageup/models/subscription.dart';
import 'package:storageup/models/tariff.dart';
import 'package:storageup/models/user.dart';

class FinanceState extends Equatable {
  final User? user;
  final Subscription? sub;
  final List<Tariff> allSub;
  final Folder? rootFolders;
  final ValueNotifier<User?>? valueNotifier;

  final ValueNotifier<Subscription?>? packetNotifier;
  final FormzStatus statusHttpRequest;

  FinanceState({
    this.user,
    this.rootFolders,
    this.sub,
    this.allSub = const [],
    this.valueNotifier,
    this.packetNotifier,
    this.statusHttpRequest = FormzStatus.pure,
  });

  FinanceState copyWith({
    User? user,
    Subscription? sub,
    Folder? rootFolders,
    List<Tariff>? allSub,
    ValueNotifier<User?>? valueNotifier,
    ValueNotifier<Subscription?>? packetNotifier,
    FormzStatus? statusHttpRequest,
  }) {
    return FinanceState(
      user: user ?? this.user,
      rootFolders: rootFolders ?? this.rootFolders,
      sub: sub ?? this.sub,
      allSub: allSub ?? this.allSub,
      valueNotifier: valueNotifier ?? this.valueNotifier,
      packetNotifier: packetNotifier ?? this.packetNotifier,
      statusHttpRequest: statusHttpRequest ?? FormzStatus.pure,
    );
  }

  @override
  List<Object?> get props => [
        user,
        sub,
        allSub,
        rootFolders,
        valueNotifier,
        packetNotifier,
        statusHttpRequest,
      ];
}
