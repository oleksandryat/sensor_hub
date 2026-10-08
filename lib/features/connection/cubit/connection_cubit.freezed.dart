// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConnectionCubitState {
  ConnectionStatus get status;

  /// Create a copy of ConnectionCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConnectionCubitStateCopyWith<ConnectionCubitState> get copyWith =>
      _$ConnectionCubitStateCopyWithImpl<ConnectionCubitState>(
        this as ConnectionCubitState,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as ConnectionCubitState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConnectionCubitState &&
            (identical(other.status, _this.status) ||
                other.status == _this.status));
  }

  @override
  int get hashCode {
    final _this = this as ConnectionCubitState;
    return Object.hash(runtimeType, _this.status);
  }

  @override
  String toString() {
    final _this = this as ConnectionCubitState;
    return 'ConnectionCubitState(status: ${_this.status})';
  }
}

/// @nodoc
abstract mixin class $ConnectionCubitStateCopyWith<$Res> {
  factory $ConnectionCubitStateCopyWith(
    ConnectionCubitState value,
    $Res Function(ConnectionCubitState) _then,
  ) = _$ConnectionCubitStateCopyWithImpl;
  @useResult
  $Res call({ConnectionStatus status});
}

/// @nodoc
class _$ConnectionCubitStateCopyWithImpl<$Res>
    implements $ConnectionCubitStateCopyWith<$Res> {
  _$ConnectionCubitStateCopyWithImpl(this._self, this._then);

  final ConnectionCubitState _self;
  final $Res Function(ConnectionCubitState) _then;

  /// Create a copy of ConnectionCubitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      ConnectionCubitState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ConnectionStatus,
      ),
    );
  }
}

/// @nodoc

class _ConnectionCubitState implements ConnectionCubitState {
  const _ConnectionCubitState({this.status = ConnectionStatus.disconnected});

  @override
  @JsonKey()
  final ConnectionStatus status;

  /// Create a copy of ConnectionCubitState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConnectionCubitStateCopyWith<_ConnectionCubitState> get copyWith =>
      __$ConnectionCubitStateCopyWithImpl<_ConnectionCubitState>(
        this,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConnectionCubitState &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, status);
  }

  @override
  String toString() {
    return 'ConnectionCubitState(status: $status)';
  }
}

/// @nodoc
abstract mixin class _$ConnectionCubitStateCopyWith<$Res>
    implements $ConnectionCubitStateCopyWith<$Res> {
  factory _$ConnectionCubitStateCopyWith(
    _ConnectionCubitState value,
    $Res Function(_ConnectionCubitState) _then,
  ) = __$ConnectionCubitStateCopyWithImpl;
  @override
  @useResult
  $Res call({ConnectionStatus status});
}

/// @nodoc
class __$ConnectionCubitStateCopyWithImpl<$Res>
    implements _$ConnectionCubitStateCopyWith<$Res> {
  __$ConnectionCubitStateCopyWithImpl(this._self, this._then);

  final _ConnectionCubitState _self;
  final $Res Function(_ConnectionCubitState) _then;

  /// Create a copy of ConnectionCubitState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? status = null}) {
    return _then(
      _ConnectionCubitState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ConnectionStatus,
      ),
    );
  }
}
