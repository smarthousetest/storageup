import 'package:flutter/foundation.dart';
import 'package:storageup/models/subscription.dart';

class SubscriptionRepository {
  Subscription? _subscriptionInfo;

  final ValueNotifier<Subscription?> _valueNotifier =
      ValueNotifier<Subscription?>(null);

  ValueNotifier<Subscription?> get getValueNotifier => _valueNotifier;

  bool containSubscriptionInfo() {
    return _subscriptionInfo != null;
  }

  Subscription? get getSubscriptionInfo => _valueNotifier.value;

  set setSubscriptionInfo(Subscription? subscriptionInfo) =>
      _valueNotifier.value = subscriptionInfo;
}
