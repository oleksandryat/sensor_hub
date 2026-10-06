import 'device.dart';

abstract interface class DeviceRepository {
  Stream<List<Device>> get devices;

  void start();

  void dispose();
}
