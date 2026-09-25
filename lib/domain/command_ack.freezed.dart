// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'command_ack.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommandAck {
  String get cmdId;
  bool get ok;
  String? get error;

  /// Create a copy of CommandAck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CommandAckCopyWith<CommandAck> get copyWith =>
      _$CommandAckCopyWithImpl<CommandAck>(this as CommandAck, _$identity);

  /// Serializes this CommandAck to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as CommandAck;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CommandAck &&
            (identical(other.cmdId, _this.cmdId) ||
                other.cmdId == _this.cmdId) &&
            (identical(other.ok, _this.ok) || other.ok == _this.ok) &&
            (identical(other.error, _this.error) ||
                other.error == _this.error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as CommandAck;
    return Object.hash(runtimeType, _this.cmdId, _this.ok, _this.error);
  }

  @override
  String toString() {
    final _this = this as CommandAck;
    return 'CommandAck(cmdId: ${_this.cmdId}, ok: ${_this.ok}, error: ${_this.error})';
  }
}

/// @nodoc
abstract mixin class $CommandAckCopyWith<$Res> {
  factory $CommandAckCopyWith(
    CommandAck value,
    $Res Function(CommandAck) _then,
  ) = _$CommandAckCopyWithImpl;
  @useResult
  $Res call({String cmdId, bool ok, String? error});
}

/// @nodoc
class _$CommandAckCopyWithImpl<$Res> implements $CommandAckCopyWith<$Res> {
  _$CommandAckCopyWithImpl(this._self, this._then);

  final CommandAck _self;
  final $Res Function(CommandAck) _then;

  /// Create a copy of CommandAck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cmdId = null,
    Object? ok = null,
    Object? error = freezed,
  }) {
    return _then(
      CommandAck(
        cmdId: null == cmdId
            ? _self.cmdId
            : cmdId // ignore: cast_nullable_to_non_nullable
                  as String,
        ok: null == ok
            ? _self.ok
            : ok // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _CommandAck implements CommandAck {
  const _CommandAck({
    required this.cmdId,
    required this.ok,
    required this.error,
  });
  factory _CommandAck.fromJson(Map<String, dynamic> json) =>
      _$CommandAckFromJson(json);

  @override
  final String cmdId;
  @override
  final bool ok;
  @override
  final String? error;

  /// Create a copy of CommandAck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CommandAckCopyWith<_CommandAck> get copyWith =>
      __$CommandAckCopyWithImpl<_CommandAck>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CommandAckToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CommandAck &&
            (identical(other.cmdId, cmdId) || other.cmdId == cmdId) &&
            (identical(other.ok, ok) || other.ok == ok) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, cmdId, ok, error);
  }

  @override
  String toString() {
    return 'CommandAck(cmdId: $cmdId, ok: $ok, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$CommandAckCopyWith<$Res>
    implements $CommandAckCopyWith<$Res> {
  factory _$CommandAckCopyWith(
    _CommandAck value,
    $Res Function(_CommandAck) _then,
  ) = __$CommandAckCopyWithImpl;
  @override
  @useResult
  $Res call({String cmdId, bool ok, String? error});
}

/// @nodoc
class __$CommandAckCopyWithImpl<$Res> implements _$CommandAckCopyWith<$Res> {
  __$CommandAckCopyWithImpl(this._self, this._then);

  final _CommandAck _self;
  final $Res Function(_CommandAck) _then;

  /// Create a copy of CommandAck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cmdId = null,
    Object? ok = null,
    Object? error = freezed,
  }) {
    return _then(
      _CommandAck(
        cmdId: null == cmdId
            ? _self.cmdId
            : cmdId // ignore: cast_nullable_to_non_nullable
                  as String,
        ok: null == ok
            ? _self.ok
            : ok // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
