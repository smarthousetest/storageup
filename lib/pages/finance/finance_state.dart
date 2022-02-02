import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/subscription.dart';
import 'package:upstorage_desktop/models/tariff.dart';
import 'package:upstorage_desktop/models/user.dart';

class FinanceState extends Equatable {
  final User? user;
  final Subscription? sub;
  final List<Tariff> allSub;
  final Folder? rootFolders;

  FinanceState({
    this.user,
    this.rootFolders,
    this.sub,
    this.allSub = const [],
  });

  FinanceState copyWith({
    User? user,
    Subscription? sub,
    Folder? rootFolders,
    List<Tariff>? allSub,
  }) {
    return FinanceState(
      user: user ?? this.user,
      rootFolders: rootFolders ?? this.rootFolders,
      sub: sub ?? this.sub,
      allSub: allSub ?? this.allSub,
    );
  }

  @override
  List<Object?> get props => [user, sub, allSub, rootFolders];
}
