import 'package:flutter/foundation.dart';
import 'package:storageup/models/packet/packet.dart';

class PacketRepository {
  Packet? _packetInfo;

  final ValueNotifier<Packet?> _valueNotifier = ValueNotifier<Packet?>(null);

  ValueNotifier<Packet?> get getValueNotifier => _valueNotifier;

  bool containPacketInfo() {
    return _packetInfo != null;
  }

  Packet? get getPacketInfo => _valueNotifier.value;

  set setPacketInfo(Packet? packetInfo) => _valueNotifier.value = packetInfo;
}
