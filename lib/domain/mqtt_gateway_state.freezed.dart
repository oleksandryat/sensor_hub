// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mqtt_gateway_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MqttGatewayState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MqttGatewayState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MqttGatewayState()';
  }
}

/// @nodoc
class $MqttGatewayStateCopyWith<$Res> {
  $MqttGatewayStateCopyWith(
    MqttGatewayState _,
    $Res Function(MqttGatewayState) __,
  );
}

/// Adds pattern-matching-related methods to [MqttGatewayState].
extension MqttGatewayStatePatterns on MqttGatewayState {
  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connecting value) connecting,
    required TResult Function(_Connected value) connected,
    required TResult Function(_Disconnected value) disconnected,
  }) {
    final _that = this;
    switch (_that) {
      case _Connecting():
        return connecting(_that);
      case _Connected():
        return connected(_that);
      case _Disconnected():
        return disconnected(_that);
    }
  }
}

/// @nodoc

class _Connecting implements MqttGatewayState {
  const _Connecting();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Connecting);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MqttGatewayState.connecting()';
  }
}

/// @nodoc

class _Connected implements MqttGatewayState {
  const _Connected();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Connected);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MqttGatewayState.connected()';
  }
}

/// @nodoc

class _Disconnected implements MqttGatewayState {
  const _Disconnected({required this.reason});

  final MqttDisconnectReason reason;

  /// Create a copy of MqttGatewayState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DisconnectedCopyWith<_Disconnected> get copyWith =>
      __$DisconnectedCopyWithImpl<_Disconnected>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Disconnected &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, reason);
  }

  @override
  String toString() {
    return 'MqttGatewayState.disconnected(reason: $reason)';
  }
}

/// @nodoc
abstract mixin class _$DisconnectedCopyWith<$Res>
    implements $MqttGatewayStateCopyWith<$Res> {
  factory _$DisconnectedCopyWith(
    _Disconnected value,
    $Res Function(_Disconnected) _then,
  ) = __$DisconnectedCopyWithImpl;
  @useResult
  $Res call({MqttDisconnectReason reason});
}

/// @nodoc
class __$DisconnectedCopyWithImpl<$Res>
    implements _$DisconnectedCopyWith<$Res> {
  __$DisconnectedCopyWithImpl(this._self, this._then);

  final _Disconnected _self;
  final $Res Function(_Disconnected) _then;

  /// Create a copy of MqttGatewayState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? reason = null}) {
    return _then(
      _Disconnected(
        reason: null == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as MqttDisconnectReason,
      ),
    );
  }
}
