// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;
Command _$CommandFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'reboot':
      return _Reboot.fromJson(json);
    case 'setInterval':
      return _SetInterval.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'type',
        'Command',
        'Invalid union type "${json['type']}"!',
      );
  }
}

/// @nodoc
mixin _$Command {
  String get cmdId;

  /// Create a copy of Command
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CommandCopyWith<Command> get copyWith =>
      _$CommandCopyWithImpl<Command>(this as Command, _$identity);

  /// Serializes this Command to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as Command;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Command &&
            (identical(other.cmdId, _this.cmdId) ||
                other.cmdId == _this.cmdId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as Command;
    return Object.hash(runtimeType, _this.cmdId);
  }

  @override
  String toString() {
    final _this = this as Command;
    return 'Command(cmdId: ${_this.cmdId})';
  }
}

/// @nodoc
abstract mixin class $CommandCopyWith<$Res> {
  factory $CommandCopyWith(Command value, $Res Function(Command) _then) =
      _$CommandCopyWithImpl;
  @useResult
  $Res call({String cmdId});
}

/// @nodoc
class _$CommandCopyWithImpl<$Res> implements $CommandCopyWith<$Res> {
  _$CommandCopyWithImpl(this._self, this._then);

  final Command _self;
  final $Res Function(Command) _then;

  /// Create a copy of Command
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cmdId = null}) {
    return _then(
      _self.copyWith(
        cmdId: null == cmdId
            ? _self.cmdId
            : cmdId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _Reboot implements Command {
  const _Reboot({required this.cmdId, String? $type})
    : $type = $type ?? 'reboot';
  factory _Reboot.fromJson(Map<String, dynamic> json) => _$RebootFromJson(json);

  @override
  final String cmdId;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of Command
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RebootCopyWith<_Reboot> get copyWith =>
      __$RebootCopyWithImpl<_Reboot>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RebootToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Reboot &&
            (identical(other.cmdId, cmdId) || other.cmdId == cmdId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, cmdId);
  }

  @override
  String toString() {
    return 'Command.reboot(cmdId: $cmdId)';
  }
}

/// @nodoc
abstract mixin class _$RebootCopyWith<$Res> implements $CommandCopyWith<$Res> {
  factory _$RebootCopyWith(_Reboot value, $Res Function(_Reboot) _then) =
      __$RebootCopyWithImpl;
  @override
  @useResult
  $Res call({String cmdId});
}

/// @nodoc
class __$RebootCopyWithImpl<$Res> implements _$RebootCopyWith<$Res> {
  __$RebootCopyWithImpl(this._self, this._then);

  final _Reboot _self;
  final $Res Function(_Reboot) _then;

  /// Create a copy of Command
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? cmdId = null}) {
    return _then(
      _Reboot(
        cmdId: null == cmdId
            ? _self.cmdId
            : cmdId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _SetInterval implements Command {
  const _SetInterval({
    required this.cmdId,
    required this.seconds,
    String? $type,
  }) : $type = $type ?? 'setInterval';
  factory _SetInterval.fromJson(Map<String, dynamic> json) =>
      _$SetIntervalFromJson(json);

  @override
  final String cmdId;
  final int seconds;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of Command
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SetIntervalCopyWith<_SetInterval> get copyWith =>
      __$SetIntervalCopyWithImpl<_SetInterval>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SetIntervalToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SetInterval &&
            (identical(other.cmdId, cmdId) || other.cmdId == cmdId) &&
            (identical(other.seconds, seconds) || other.seconds == seconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, cmdId, seconds);
  }

  @override
  String toString() {
    return 'Command.setInterval(cmdId: $cmdId, seconds: $seconds)';
  }
}

/// @nodoc
abstract mixin class _$SetIntervalCopyWith<$Res>
    implements $CommandCopyWith<$Res> {
  factory _$SetIntervalCopyWith(
    _SetInterval value,
    $Res Function(_SetInterval) _then,
  ) = __$SetIntervalCopyWithImpl;
  @override
  @useResult
  $Res call({String cmdId, int seconds});
}

/// @nodoc
class __$SetIntervalCopyWithImpl<$Res> implements _$SetIntervalCopyWith<$Res> {
  __$SetIntervalCopyWithImpl(this._self, this._then);

  final _SetInterval _self;
  final $Res Function(_SetInterval) _then;

  /// Create a copy of Command
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? cmdId = null, Object? seconds = null}) {
    return _then(
      _SetInterval(
        cmdId: null == cmdId
            ? _self.cmdId
            : cmdId // ignore: cast_nullable_to_non_nullable
                  as String,
        seconds: null == seconds
            ? _self.seconds
            : seconds // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
