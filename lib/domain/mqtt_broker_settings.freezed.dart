// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mqtt_broker_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MqttBrokerSettings {
  String get host;
  int get port;
  String get clientId;
  String get username;
  String get password;

  /// Create a copy of MqttBrokerSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MqttBrokerSettingsCopyWith<MqttBrokerSettings> get copyWith =>
      _$MqttBrokerSettingsCopyWithImpl<MqttBrokerSettings>(
        this as MqttBrokerSettings,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as MqttBrokerSettings;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MqttBrokerSettings &&
            (identical(other.host, _this.host) || other.host == _this.host) &&
            (identical(other.port, _this.port) || other.port == _this.port) &&
            (identical(other.clientId, _this.clientId) ||
                other.clientId == _this.clientId) &&
            (identical(other.username, _this.username) ||
                other.username == _this.username) &&
            (identical(other.password, _this.password) ||
                other.password == _this.password));
  }

  @override
  int get hashCode {
    final _this = this as MqttBrokerSettings;
    return Object.hash(
      runtimeType,
      _this.host,
      _this.port,
      _this.clientId,
      _this.username,
      _this.password,
    );
  }

  @override
  String toString() {
    final _this = this as MqttBrokerSettings;
    return 'MqttBrokerSettings(host: ${_this.host}, port: ${_this.port}, clientId: ${_this.clientId}, username: ${_this.username}, password: ${_this.password})';
  }
}

/// @nodoc
abstract mixin class $MqttBrokerSettingsCopyWith<$Res> {
  factory $MqttBrokerSettingsCopyWith(
    MqttBrokerSettings value,
    $Res Function(MqttBrokerSettings) _then,
  ) = _$MqttBrokerSettingsCopyWithImpl;
  @useResult
  $Res call({
    String host,
    int port,
    String clientId,
    String username,
    String password,
  });
}

/// @nodoc
class _$MqttBrokerSettingsCopyWithImpl<$Res>
    implements $MqttBrokerSettingsCopyWith<$Res> {
  _$MqttBrokerSettingsCopyWithImpl(this._self, this._then);

  final MqttBrokerSettings _self;
  final $Res Function(MqttBrokerSettings) _then;

  /// Create a copy of MqttBrokerSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? port = null,
    Object? clientId = null,
    Object? username = null,
    Object? password = null,
  }) {
    return _then(
      MqttBrokerSettings(
        host: null == host
            ? _self.host
            : host // ignore: cast_nullable_to_non_nullable
                  as String,
        port: null == port
            ? _self.port
            : port // ignore: cast_nullable_to_non_nullable
                  as int,
        clientId: null == clientId
            ? _self.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _self.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _self.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _MqttBrokerSettings implements MqttBrokerSettings {
  const _MqttBrokerSettings({
    required this.host,
    required this.port,
    required this.clientId,
    required this.username,
    required this.password,
  });

  @override
  final String host;
  @override
  final int port;
  @override
  final String clientId;
  @override
  final String username;
  @override
  final String password;

  /// Create a copy of MqttBrokerSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MqttBrokerSettingsCopyWith<_MqttBrokerSettings> get copyWith =>
      __$MqttBrokerSettingsCopyWithImpl<_MqttBrokerSettings>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MqttBrokerSettings &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, host, port, clientId, username, password);
  }

  @override
  String toString() {
    return 'MqttBrokerSettings(host: $host, port: $port, clientId: $clientId, username: $username, password: $password)';
  }
}

/// @nodoc
abstract mixin class _$MqttBrokerSettingsCopyWith<$Res>
    implements $MqttBrokerSettingsCopyWith<$Res> {
  factory _$MqttBrokerSettingsCopyWith(
    _MqttBrokerSettings value,
    $Res Function(_MqttBrokerSettings) _then,
  ) = __$MqttBrokerSettingsCopyWithImpl;
  @override
  @useResult
  $Res call({
    String host,
    int port,
    String clientId,
    String username,
    String password,
  });
}

/// @nodoc
class __$MqttBrokerSettingsCopyWithImpl<$Res>
    implements _$MqttBrokerSettingsCopyWith<$Res> {
  __$MqttBrokerSettingsCopyWithImpl(this._self, this._then);

  final _MqttBrokerSettings _self;
  final $Res Function(_MqttBrokerSettings) _then;

  /// Create a copy of MqttBrokerSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? host = null,
    Object? port = null,
    Object? clientId = null,
    Object? username = null,
    Object? password = null,
  }) {
    return _then(
      _MqttBrokerSettings(
        host: null == host
            ? _self.host
            : host // ignore: cast_nullable_to_non_nullable
                  as String,
        port: null == port
            ? _self.port
            : port // ignore: cast_nullable_to_non_nullable
                  as int,
        clientId: null == clientId
            ? _self.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _self.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _self.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
