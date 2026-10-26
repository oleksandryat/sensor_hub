// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_sensor_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhoneSensorState {
  PhoneSensorStatus get status;
  AccelerometerSample? get sample;
  AnomalyReading? get reading;
  int get anomalyCount;
  bool get publishing;
  bool get connected;
  String? get error;

  /// Create a copy of PhoneSensorState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PhoneSensorStateCopyWith<PhoneSensorState> get copyWith =>
      _$PhoneSensorStateCopyWithImpl<PhoneSensorState>(
        this as PhoneSensorState,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as PhoneSensorState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PhoneSensorState &&
            (identical(other.status, _this.status) ||
                other.status == _this.status) &&
            (identical(other.sample, _this.sample) ||
                other.sample == _this.sample) &&
            (identical(other.reading, _this.reading) ||
                other.reading == _this.reading) &&
            (identical(other.anomalyCount, _this.anomalyCount) ||
                other.anomalyCount == _this.anomalyCount) &&
            (identical(other.publishing, _this.publishing) ||
                other.publishing == _this.publishing) &&
            (identical(other.connected, _this.connected) ||
                other.connected == _this.connected) &&
            (identical(other.error, _this.error) ||
                other.error == _this.error));
  }

  @override
  int get hashCode {
    final _this = this as PhoneSensorState;
    return Object.hash(
      runtimeType,
      _this.status,
      _this.sample,
      _this.reading,
      _this.anomalyCount,
      _this.publishing,
      _this.connected,
      _this.error,
    );
  }

  @override
  String toString() {
    final _this = this as PhoneSensorState;
    return 'PhoneSensorState(status: ${_this.status}, sample: ${_this.sample}, reading: ${_this.reading}, anomalyCount: ${_this.anomalyCount}, publishing: ${_this.publishing}, connected: ${_this.connected}, error: ${_this.error})';
  }
}

/// @nodoc
abstract mixin class $PhoneSensorStateCopyWith<$Res> {
  factory $PhoneSensorStateCopyWith(
    PhoneSensorState value,
    $Res Function(PhoneSensorState) _then,
  ) = _$PhoneSensorStateCopyWithImpl;
  @useResult
  $Res call({
    PhoneSensorStatus status,
    AccelerometerSample? sample,
    AnomalyReading? reading,
    int anomalyCount,
    bool publishing,
    bool connected,
    String? error,
  });

  $AnomalyReadingCopyWith<$Res>? get reading;
}

/// @nodoc
class _$PhoneSensorStateCopyWithImpl<$Res>
    implements $PhoneSensorStateCopyWith<$Res> {
  _$PhoneSensorStateCopyWithImpl(this._self, this._then);

  final PhoneSensorState _self;
  final $Res Function(PhoneSensorState) _then;

  /// Create a copy of PhoneSensorState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? sample = freezed,
    Object? reading = freezed,
    Object? anomalyCount = null,
    Object? publishing = null,
    Object? connected = null,
    Object? error = freezed,
  }) {
    return _then(
      PhoneSensorState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PhoneSensorStatus,
        sample: freezed == sample
            ? _self.sample
            : sample // ignore: cast_nullable_to_non_nullable
                  as AccelerometerSample?,
        reading: freezed == reading
            ? _self.reading
            : reading // ignore: cast_nullable_to_non_nullable
                  as AnomalyReading?,
        anomalyCount: null == anomalyCount
            ? _self.anomalyCount
            : anomalyCount // ignore: cast_nullable_to_non_nullable
                  as int,
        publishing: null == publishing
            ? _self.publishing
            : publishing // ignore: cast_nullable_to_non_nullable
                  as bool,
        connected: null == connected
            ? _self.connected
            : connected // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }

  /// Create a copy of PhoneSensorState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnomalyReadingCopyWith<$Res>? get reading {
    if (_self.reading == null) {
      return null;
    }

    return $AnomalyReadingCopyWith<$Res>(_self.reading!, (value) {
      return _then(_self.copyWith(reading: value));
    });
  }
}

/// @nodoc

class _PhoneSensorState implements PhoneSensorState {
  const _PhoneSensorState({
    this.status = PhoneSensorStatus.idle,
    this.sample,
    this.reading,
    this.anomalyCount = 0,
    this.publishing = false,
    this.connected = false,
    this.error,
  });

  @override
  @JsonKey()
  final PhoneSensorStatus status;
  @override
  final AccelerometerSample? sample;
  @override
  final AnomalyReading? reading;
  @override
  @JsonKey()
  final int anomalyCount;
  @override
  @JsonKey()
  final bool publishing;
  @override
  @JsonKey()
  final bool connected;
  @override
  final String? error;

  /// Create a copy of PhoneSensorState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PhoneSensorStateCopyWith<_PhoneSensorState> get copyWith =>
      __$PhoneSensorStateCopyWithImpl<_PhoneSensorState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PhoneSensorState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sample, sample) || other.sample == sample) &&
            (identical(other.reading, reading) || other.reading == reading) &&
            (identical(other.anomalyCount, anomalyCount) ||
                other.anomalyCount == anomalyCount) &&
            (identical(other.publishing, publishing) ||
                other.publishing == publishing) &&
            (identical(other.connected, connected) ||
                other.connected == connected) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      status,
      sample,
      reading,
      anomalyCount,
      publishing,
      connected,
      error,
    );
  }

  @override
  String toString() {
    return 'PhoneSensorState(status: $status, sample: $sample, reading: $reading, anomalyCount: $anomalyCount, publishing: $publishing, connected: $connected, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$PhoneSensorStateCopyWith<$Res>
    implements $PhoneSensorStateCopyWith<$Res> {
  factory _$PhoneSensorStateCopyWith(
    _PhoneSensorState value,
    $Res Function(_PhoneSensorState) _then,
  ) = __$PhoneSensorStateCopyWithImpl;
  @override
  @useResult
  $Res call({
    PhoneSensorStatus status,
    AccelerometerSample? sample,
    AnomalyReading? reading,
    int anomalyCount,
    bool publishing,
    bool connected,
    String? error,
  });

  @override
  $AnomalyReadingCopyWith<$Res>? get reading;
}

/// @nodoc
class __$PhoneSensorStateCopyWithImpl<$Res>
    implements _$PhoneSensorStateCopyWith<$Res> {
  __$PhoneSensorStateCopyWithImpl(this._self, this._then);

  final _PhoneSensorState _self;
  final $Res Function(_PhoneSensorState) _then;

  /// Create a copy of PhoneSensorState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? sample = freezed,
    Object? reading = freezed,
    Object? anomalyCount = null,
    Object? publishing = null,
    Object? connected = null,
    Object? error = freezed,
  }) {
    return _then(
      _PhoneSensorState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PhoneSensorStatus,
        sample: freezed == sample
            ? _self.sample
            : sample // ignore: cast_nullable_to_non_nullable
                  as AccelerometerSample?,
        reading: freezed == reading
            ? _self.reading
            : reading // ignore: cast_nullable_to_non_nullable
                  as AnomalyReading?,
        anomalyCount: null == anomalyCount
            ? _self.anomalyCount
            : anomalyCount // ignore: cast_nullable_to_non_nullable
                  as int,
        publishing: null == publishing
            ? _self.publishing
            : publishing // ignore: cast_nullable_to_non_nullable
                  as bool,
        connected: null == connected
            ? _self.connected
            : connected // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }

  /// Create a copy of PhoneSensorState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnomalyReadingCopyWith<$Res>? get reading {
    if (_self.reading == null) {
      return null;
    }

    return $AnomalyReadingCopyWith<$Res>(_self.reading!, (value) {
      return _then(_self.copyWith(reading: value));
    });
  }
}
