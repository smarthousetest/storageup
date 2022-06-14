import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/packet/packet.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/packet_repository.dart';
import 'package:upstorage_desktop/utilites/services/subscription_service.dart';

@Injectable()
class PacketController {
  PacketRepository _repository =
      getIt<PacketRepository>(instanceName: 'packet_repo');

  SubscriptionService _subService = getIt<SubscriptionService>();

  PacketController() {
    if (!_repository.containPacketInfo()) {
      _subService.getPacketInfo();
    }
  }

  Future<Packet?> updatePacket() async {
    await _subService.getPacketInfo();
    return _repository.getPacketInfo;
  }

  Future<Packet?> get getPacket async => _repository.getPacketInfo;

  ValueNotifier<Packet?> getValueNotifier() => _repository.getValueNotifier;

  set setPacketInfo(Packet packet) => _repository.setPacketInfo = packet;
}
