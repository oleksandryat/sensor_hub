part of 'phone_sensor_cubit.dart';

enum PhoneSensorStatus { idle, streaming, error }

@freezed
abstract class PhoneSensorState with _$PhoneSensorState {
  const factory PhoneSensorState({
    @Default(PhoneSensorStatus.idle) PhoneSensorStatus status,
    AccelerometerSample? sample,
    AnomalyReading? reading,
    @Default(0) int anomalyCount,
    @Default(false) bool publishing,
    @Default(false) bool connected,
    String? error,
  }) = _PhoneSensorState;
}
