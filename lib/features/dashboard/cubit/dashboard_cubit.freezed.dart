// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardState {
  DashboardStatus get status;
  List<Device> get devices;
  ConnectionStatus get connection;
  Set<String> get sending;
  CommandFeedback? get feedback;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DashboardStateCopyWith<DashboardState> get copyWith =>
      _$DashboardStateCopyWithImpl<DashboardState>(
        this as DashboardState,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as DashboardState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DashboardState &&
            (identical(other.status, _this.status) ||
                other.status == _this.status) &&
            const DeepCollectionEquality().equals(
              other.devices,
              _this.devices,
            ) &&
            (identical(other.connection, _this.connection) ||
                other.connection == _this.connection) &&
            const DeepCollectionEquality().equals(
              other.sending,
              _this.sending,
            ) &&
            (identical(other.feedback, _this.feedback) ||
                other.feedback == _this.feedback));
  }

  @override
  int get hashCode {
    final _this = this as DashboardState;
    return Object.hash(
      runtimeType,
      _this.status,
      const DeepCollectionEquality().hash(_this.devices),
      _this.connection,
      const DeepCollectionEquality().hash(_this.sending),
      _this.feedback,
    );
  }

  @override
  String toString() {
    final _this = this as DashboardState;
    return 'DashboardState(status: ${_this.status}, devices: ${_this.devices}, connection: ${_this.connection}, sending: ${_this.sending}, feedback: ${_this.feedback})';
  }
}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
    DashboardState value,
    $Res Function(DashboardState) _then,
  ) = _$DashboardStateCopyWithImpl;
  @useResult
  $Res call({
    DashboardStatus status,
    List<Device> devices,
    ConnectionStatus connection,
    Set<String> sending,
    CommandFeedback? feedback,
  });
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? devices = null,
    Object? connection = null,
    Object? sending = null,
    Object? feedback = freezed,
  }) {
    return _then(
      DashboardState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DashboardStatus,
        devices: null == devices
            ? _self.devices
            : devices // ignore: cast_nullable_to_non_nullable
                  as List<Device>,
        connection: null == connection
            ? _self.connection
            : connection // ignore: cast_nullable_to_non_nullable
                  as ConnectionStatus,
        sending: null == sending
            ? _self.sending
            : sending // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        feedback: freezed == feedback
            ? _self.feedback
            : feedback // ignore: cast_nullable_to_non_nullable
                  as CommandFeedback?,
      ),
    );
  }
}

/// @nodoc

class _DashboardState extends DashboardState {
  const _DashboardState({
    this.status = DashboardStatus.loading,
    List<Device> devices = const [],
    this.connection = ConnectionStatus.disconnected,
    Set<String> sending = const {},
    this.feedback,
  }) : _devices = devices,
       _sending = sending,
       super._();

  @override
  @JsonKey()
  final DashboardStatus status;
  final List<Device> _devices;
  @override
  @JsonKey()
  List<Device> get devices {
    if (_devices is EqualUnmodifiableListView) return _devices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_devices);
  }

  @override
  @JsonKey()
  final ConnectionStatus connection;
  final Set<String> _sending;
  @override
  @JsonKey()
  Set<String> get sending {
    if (_sending is EqualUnmodifiableSetView) return _sending;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_sending);
  }

  @override
  final CommandFeedback? feedback;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DashboardStateCopyWith<_DashboardState> get copyWith =>
      __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DashboardState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.devices, _devices) &&
            (identical(other.connection, connection) ||
                other.connection == connection) &&
            const DeepCollectionEquality().equals(other.sending, _sending) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_devices),
      connection,
      const DeepCollectionEquality().hash(_sending),
      feedback,
    );
  }

  @override
  String toString() {
    return 'DashboardState(status: $status, devices: $devices, connection: $connection, sending: $sending, feedback: $feedback)';
  }
}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res>
    implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(
    _DashboardState value,
    $Res Function(_DashboardState) _then,
  ) = __$DashboardStateCopyWithImpl;
  @override
  @useResult
  $Res call({
    DashboardStatus status,
    List<Device> devices,
    ConnectionStatus connection,
    Set<String> sending,
    CommandFeedback? feedback,
  });
}

/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? devices = null,
    Object? connection = null,
    Object? sending = null,
    Object? feedback = freezed,
  }) {
    return _then(
      _DashboardState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DashboardStatus,
        devices: null == devices
            ? _self._devices
            : devices // ignore: cast_nullable_to_non_nullable
                  as List<Device>,
        connection: null == connection
            ? _self.connection
            : connection // ignore: cast_nullable_to_non_nullable
                  as ConnectionStatus,
        sending: null == sending
            ? _self._sending
            : sending // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        feedback: freezed == feedback
            ? _self.feedback
            : feedback // ignore: cast_nullable_to_non_nullable
                  as CommandFeedback?,
      ),
    );
  }
}
