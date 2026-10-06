// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Device {
  String get id;
  Telemetry? get last;
  bool get online;
  DateTime? get lastSeen;
  bool get isStale;

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeviceCopyWith<Device> get copyWith =>
      _$DeviceCopyWithImpl<Device>(this as Device, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as Device;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Device &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.last, _this.last) || other.last == _this.last) &&
            (identical(other.online, _this.online) ||
                other.online == _this.online) &&
            (identical(other.lastSeen, _this.lastSeen) ||
                other.lastSeen == _this.lastSeen) &&
            (identical(other.isStale, _this.isStale) ||
                other.isStale == _this.isStale));
  }

  @override
  int get hashCode {
    final _this = this as Device;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.last,
      _this.online,
      _this.lastSeen,
      _this.isStale,
    );
  }

  @override
  String toString() {
    final _this = this as Device;
    return 'Device(id: ${_this.id}, last: ${_this.last}, online: ${_this.online}, lastSeen: ${_this.lastSeen}, isStale: ${_this.isStale})';
  }
}

/// @nodoc
abstract mixin class $DeviceCopyWith<$Res> {
  factory $DeviceCopyWith(Device value, $Res Function(Device) _then) =
      _$DeviceCopyWithImpl;
  @useResult
  $Res call({
    String id,
    Telemetry? last,
    bool online,
    DateTime? lastSeen,
    bool isStale,
  });

  $TelemetryCopyWith<$Res>? get last;
}

/// @nodoc
class _$DeviceCopyWithImpl<$Res> implements $DeviceCopyWith<$Res> {
  _$DeviceCopyWithImpl(this._self, this._then);

  final Device _self;
  final $Res Function(Device) _then;

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? last = freezed,
    Object? online = null,
    Object? lastSeen = freezed,
    Object? isStale = null,
  }) {
    return _then(
      Device(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        last: freezed == last
            ? _self.last
            : last // ignore: cast_nullable_to_non_nullable
                  as Telemetry?,
        online: null == online
            ? _self.online
            : online // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastSeen: freezed == lastSeen
            ? _self.lastSeen
            : lastSeen // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isStale: null == isStale
            ? _self.isStale
            : isStale // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TelemetryCopyWith<$Res>? get last {
    if (_self.last == null) {
      return null;
    }

    return $TelemetryCopyWith<$Res>(_self.last!, (value) {
      return _then(_self.copyWith(last: value));
    });
  }
}

/// @nodoc

class _Device implements Device {
  const _Device({
    required this.id,
    this.last,
    required this.online,
    this.lastSeen,
    required this.isStale,
  });

  @override
  final String id;
  @override
  final Telemetry? last;
  @override
  final bool online;
  @override
  final DateTime? lastSeen;
  @override
  final bool isStale;

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeviceCopyWith<_Device> get copyWith =>
      __$DeviceCopyWithImpl<_Device>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Device &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.last, last) || other.last == last) &&
            (identical(other.online, online) || other.online == online) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.isStale, isStale) || other.isStale == isStale));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, last, online, lastSeen, isStale);
  }

  @override
  String toString() {
    return 'Device(id: $id, last: $last, online: $online, lastSeen: $lastSeen, isStale: $isStale)';
  }
}

/// @nodoc
abstract mixin class _$DeviceCopyWith<$Res> implements $DeviceCopyWith<$Res> {
  factory _$DeviceCopyWith(_Device value, $Res Function(_Device) _then) =
      __$DeviceCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    Telemetry? last,
    bool online,
    DateTime? lastSeen,
    bool isStale,
  });

  @override
  $TelemetryCopyWith<$Res>? get last;
}

/// @nodoc
class __$DeviceCopyWithImpl<$Res> implements _$DeviceCopyWith<$Res> {
  __$DeviceCopyWithImpl(this._self, this._then);

  final _Device _self;
  final $Res Function(_Device) _then;

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? last = freezed,
    Object? online = null,
    Object? lastSeen = freezed,
    Object? isStale = null,
  }) {
    return _then(
      _Device(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        last: freezed == last
            ? _self.last
            : last // ignore: cast_nullable_to_non_nullable
                  as Telemetry?,
        online: null == online
            ? _self.online
            : online // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastSeen: freezed == lastSeen
            ? _self.lastSeen
            : lastSeen // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isStale: null == isStale
            ? _self.isStale
            : isStale // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TelemetryCopyWith<$Res>? get last {
    if (_self.last == null) {
      return null;
    }

    return $TelemetryCopyWith<$Res>(_self.last!, (value) {
      return _then(_self.copyWith(last: value));
    });
  }
}
