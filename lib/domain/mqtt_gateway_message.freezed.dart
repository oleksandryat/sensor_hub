// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mqtt_gateway_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MqttGatewayMessage {
  String get topic;
  String get payload;

  /// Create a copy of MqttGatewayMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MqttGatewayMessageCopyWith<MqttGatewayMessage> get copyWith =>
      _$MqttGatewayMessageCopyWithImpl<MqttGatewayMessage>(
        this as MqttGatewayMessage,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as MqttGatewayMessage;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MqttGatewayMessage &&
            (identical(other.topic, _this.topic) ||
                other.topic == _this.topic) &&
            (identical(other.payload, _this.payload) ||
                other.payload == _this.payload));
  }

  @override
  int get hashCode {
    final _this = this as MqttGatewayMessage;
    return Object.hash(runtimeType, _this.topic, _this.payload);
  }

  @override
  String toString() {
    final _this = this as MqttGatewayMessage;
    return 'MqttGatewayMessage(topic: ${_this.topic}, payload: ${_this.payload})';
  }
}

/// @nodoc
abstract mixin class $MqttGatewayMessageCopyWith<$Res> {
  factory $MqttGatewayMessageCopyWith(
    MqttGatewayMessage value,
    $Res Function(MqttGatewayMessage) _then,
  ) = _$MqttGatewayMessageCopyWithImpl;
  @useResult
  $Res call({String topic, String payload});
}

/// @nodoc
class _$MqttGatewayMessageCopyWithImpl<$Res>
    implements $MqttGatewayMessageCopyWith<$Res> {
  _$MqttGatewayMessageCopyWithImpl(this._self, this._then);

  final MqttGatewayMessage _self;
  final $Res Function(MqttGatewayMessage) _then;

  /// Create a copy of MqttGatewayMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? topic = null, Object? payload = null}) {
    return _then(
      MqttGatewayMessage(
        topic: null == topic
            ? _self.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
        payload: null == payload
            ? _self.payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _MqttGatewayMessage implements MqttGatewayMessage {
  const _MqttGatewayMessage({required this.topic, required this.payload});

  @override
  final String topic;
  @override
  final String payload;

  /// Create a copy of MqttGatewayMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MqttGatewayMessageCopyWith<_MqttGatewayMessage> get copyWith =>
      __$MqttGatewayMessageCopyWithImpl<_MqttGatewayMessage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MqttGatewayMessage &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.payload, payload) || other.payload == payload));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, topic, payload);
  }

  @override
  String toString() {
    return 'MqttGatewayMessage(topic: $topic, payload: $payload)';
  }
}

/// @nodoc
abstract mixin class _$MqttGatewayMessageCopyWith<$Res>
    implements $MqttGatewayMessageCopyWith<$Res> {
  factory _$MqttGatewayMessageCopyWith(
    _MqttGatewayMessage value,
    $Res Function(_MqttGatewayMessage) _then,
  ) = __$MqttGatewayMessageCopyWithImpl;
  @override
  @useResult
  $Res call({String topic, String payload});
}

/// @nodoc
class __$MqttGatewayMessageCopyWithImpl<$Res>
    implements _$MqttGatewayMessageCopyWith<$Res> {
  __$MqttGatewayMessageCopyWithImpl(this._self, this._then);

  final _MqttGatewayMessage _self;
  final $Res Function(_MqttGatewayMessage) _then;

  /// Create a copy of MqttGatewayMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? topic = null, Object? payload = null}) {
    return _then(
      _MqttGatewayMessage(
        topic: null == topic
            ? _self.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
        payload: null == payload
            ? _self.payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
