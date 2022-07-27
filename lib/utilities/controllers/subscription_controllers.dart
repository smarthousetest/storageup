import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/models/subscription.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/repositories/subscription_repository.dart';
import 'package:storageup/utilities/services/subscription_service.dart';

@Injectable()
class SubscriptionController {
  SubscriptionRepository _repository =
      getIt<SubscriptionRepository>(instanceName: 'subscription_repo');

  SubscriptionService _subService = getIt<SubscriptionService>();

  SubscriptionController() {
    if (!_repository.containSubscriptionInfo()) {
      _subService.getCurrentSubscription();
    }
  }

  Future<Subscription?> updateSubscription() async {
    await _subService.getCurrentSubscription();
    return _repository.getSubscriptionInfo;
  }

  Future<Subscription?> get getSubscription async =>
      _repository.getSubscriptionInfo;

  ValueNotifier<Subscription?> getValueNotifier() =>
      _repository.getValueNotifier;

  set setSubscriptionInfo(Subscription subscription) =>
      _repository.setSubscriptionInfo = subscription;
}
