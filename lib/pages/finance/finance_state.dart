import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:storageup/models/folder.dart';
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

  final ValueNotifier<Packet?>? packetNotifier;

  FinanceState({
    this.user,
    this.rootFolders,
    this.sub,
    this.allSub = const [],
    this.valueNotifier,
    this.packetNotifier,
  });

  FinanceState copyWith({
    User? user,
    Subscription? sub,
    Folder? rootFolders,
    List<Tariff>? allSub,
    ValueNotifier<User?>? valueNotifier,
    ValueNotifier<Packet?>? packetNotifier,
  }) {
    return FinanceState(
      user: user ?? this.user,
      rootFolders: rootFolders ?? this.rootFolders,
      sub: sub ?? this.sub,
      allSub: allSub ?? this.allSub,
      valueNotifier: valueNotifier ?? this.valueNotifier,
      packetNotifier: packetNotifier ?? this.packetNotifier,
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
      ];
}
