// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_info_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceInfoState {
  DeviceInfoStatus get status;
  DeviceInfoSource get source;
  NativeDeviceInfo? get info;
  String? get error;

  /// Create a copy of DeviceInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeviceInfoStateCopyWith<DeviceInfoState> get copyWith =>
      _$DeviceInfoStateCopyWithImpl<DeviceInfoState>(
        this as DeviceInfoState,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as DeviceInfoState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeviceInfoState &&
            (identical(other.status, _this.status) ||
                other.status == _this.status) &&
            (identical(other.source, _this.source) ||
                other.source == _this.source) &&
            (identical(other.info, _this.info) || other.info == _this.info) &&
            (identical(other.error, _this.error) ||
                other.error == _this.error));
  }

  @override
  int get hashCode {
    final _this = this as DeviceInfoState;
    return Object.hash(
      runtimeType,
      _this.status,
      _this.source,
      _this.info,
      _this.error,
    );
  }

  @override
  String toString() {
    final _this = this as DeviceInfoState;
    return 'DeviceInfoState(status: ${_this.status}, source: ${_this.source}, info: ${_this.info}, error: ${_this.error})';
  }
}

/// @nodoc
abstract mixin class $DeviceInfoStateCopyWith<$Res> {
  factory $DeviceInfoStateCopyWith(
    DeviceInfoState value,
    $Res Function(DeviceInfoState) _then,
  ) = _$DeviceInfoStateCopyWithImpl;
  @useResult
  $Res call({
    DeviceInfoStatus status,
    DeviceInfoSource source,
    NativeDeviceInfo? info,
    String? error,
  });
}

/// @nodoc
class _$DeviceInfoStateCopyWithImpl<$Res>
    implements $DeviceInfoStateCopyWith<$Res> {
  _$DeviceInfoStateCopyWithImpl(this._self, this._then);

  final DeviceInfoState _self;
  final $Res Function(DeviceInfoState) _then;

  /// Create a copy of DeviceInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? source = null,
    Object? info = freezed,
    Object? error = freezed,
  }) {
    return _then(
      DeviceInfoState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DeviceInfoStatus,
        source: null == source
            ? _self.source
            : source // ignore: cast_nullable_to_non_nullable
                  as DeviceInfoSource,
        info: freezed == info
            ? _self.info
            : info // ignore: cast_nullable_to_non_nullable
                  as NativeDeviceInfo?,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _DeviceInfoState implements DeviceInfoState {
  const _DeviceInfoState({
    this.status = DeviceInfoStatus.loading,
    this.source = DeviceInfoSource.methodChannel,
    this.info,
    this.error,
  });

  @override
  @JsonKey()
  final DeviceInfoStatus status;
  @override
  @JsonKey()
  final DeviceInfoSource source;
  @override
  final NativeDeviceInfo? info;
  @override
  final String? error;

  /// Create a copy of DeviceInfoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeviceInfoStateCopyWith<_DeviceInfoState> get copyWith =>
      __$DeviceInfoStateCopyWithImpl<_DeviceInfoState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeviceInfoState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.info, info) || other.info == info) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, status, source, info, error);
  }

  @override
  String toString() {
    return 'DeviceInfoState(status: $status, source: $source, info: $info, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$DeviceInfoStateCopyWith<$Res>
    implements $DeviceInfoStateCopyWith<$Res> {
  factory _$DeviceInfoStateCopyWith(
    _DeviceInfoState value,
    $Res Function(_DeviceInfoState) _then,
  ) = __$DeviceInfoStateCopyWithImpl;
  @override
  @useResult
  $Res call({
    DeviceInfoStatus status,
    DeviceInfoSource source,
    NativeDeviceInfo? info,
    String? error,
  });
}

/// @nodoc
class __$DeviceInfoStateCopyWithImpl<$Res>
    implements _$DeviceInfoStateCopyWith<$Res> {
  __$DeviceInfoStateCopyWithImpl(this._self, this._then);

  final _DeviceInfoState _self;
  final $Res Function(_DeviceInfoState) _then;

  /// Create a copy of DeviceInfoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? source = null,
    Object? info = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _DeviceInfoState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DeviceInfoStatus,
        source: null == source
            ? _self.source
            : source // ignore: cast_nullable_to_non_nullable
                  as DeviceInfoSource,
        info: freezed == info
            ? _self.info
            : info // ignore: cast_nullable_to_non_nullable
                  as NativeDeviceInfo?,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
