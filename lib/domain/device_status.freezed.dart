// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceStatus {
  bool get online;

  /// Create a copy of DeviceStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeviceStatusCopyWith<DeviceStatus> get copyWith =>
      _$DeviceStatusCopyWithImpl<DeviceStatus>(
        this as DeviceStatus,
        _$identity,
      );

  /// Serializes this DeviceStatus to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as DeviceStatus;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeviceStatus &&
            (identical(other.online, _this.online) ||
                other.online == _this.online));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as DeviceStatus;
    return Object.hash(runtimeType, _this.online);
  }

  @override
  String toString() {
    final _this = this as DeviceStatus;
    return 'DeviceStatus(online: ${_this.online})';
  }
}

/// @nodoc
abstract mixin class $DeviceStatusCopyWith<$Res> {
  factory $DeviceStatusCopyWith(
    DeviceStatus value,
    $Res Function(DeviceStatus) _then,
  ) = _$DeviceStatusCopyWithImpl;
  @useResult
  $Res call({bool online});
}

/// @nodoc
class _$DeviceStatusCopyWithImpl<$Res> implements $DeviceStatusCopyWith<$Res> {
  _$DeviceStatusCopyWithImpl(this._self, this._then);

  final DeviceStatus _self;
  final $Res Function(DeviceStatus) _then;

  /// Create a copy of DeviceStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? online = null}) {
    return _then(
      DeviceStatus(
        online: null == online
            ? _self.online
            : online // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _DeviceStatus implements DeviceStatus {
  const _DeviceStatus({required this.online});
  factory _DeviceStatus.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusFromJson(json);

  @override
  final bool online;

  /// Create a copy of DeviceStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeviceStatusCopyWith<_DeviceStatus> get copyWith =>
      __$DeviceStatusCopyWithImpl<_DeviceStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeviceStatusToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeviceStatus &&
            (identical(other.online, online) || other.online == online));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, online);
  }

  @override
  String toString() {
    return 'DeviceStatus(online: $online)';
  }
}

/// @nodoc
abstract mixin class _$DeviceStatusCopyWith<$Res>
    implements $DeviceStatusCopyWith<$Res> {
  factory _$DeviceStatusCopyWith(
    _DeviceStatus value,
    $Res Function(_DeviceStatus) _then,
  ) = __$DeviceStatusCopyWithImpl;
  @override
  @useResult
  $Res call({bool online});
}

/// @nodoc
class __$DeviceStatusCopyWithImpl<$Res>
    implements _$DeviceStatusCopyWith<$Res> {
  __$DeviceStatusCopyWithImpl(this._self, this._then);

  final _DeviceStatus _self;
  final $Res Function(_DeviceStatus) _then;

  /// Create a copy of DeviceStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? online = null}) {
    return _then(
      _DeviceStatus(
        online: null == online
            ? _self.online
            : online // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
