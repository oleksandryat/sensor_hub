// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'command_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommandResult {
  String get cmdId;

  /// Create a copy of CommandResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CommandResultCopyWith<CommandResult> get copyWith =>
      _$CommandResultCopyWithImpl<CommandResult>(
        this as CommandResult,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as CommandResult;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CommandResult &&
            (identical(other.cmdId, _this.cmdId) ||
                other.cmdId == _this.cmdId));
  }

  @override
  int get hashCode {
    final _this = this as CommandResult;
    return Object.hash(runtimeType, _this.cmdId);
  }

  @override
  String toString() {
    final _this = this as CommandResult;
    return 'CommandResult(cmdId: ${_this.cmdId})';
  }
}

/// @nodoc
abstract mixin class $CommandResultCopyWith<$Res> {
  factory $CommandResultCopyWith(
    CommandResult value,
    $Res Function(CommandResult) _then,
  ) = _$CommandResultCopyWithImpl;
  @useResult
  $Res call({String cmdId});
}

/// @nodoc
class _$CommandResultCopyWithImpl<$Res>
    implements $CommandResultCopyWith<$Res> {
  _$CommandResultCopyWithImpl(this._self, this._then);

  final CommandResult _self;
  final $Res Function(CommandResult) _then;

  /// Create a copy of CommandResult
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

class _Succeeded implements CommandResult {
  const _Succeeded({required this.cmdId});

  @override
  final String cmdId;

  /// Create a copy of CommandResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SucceededCopyWith<_Succeeded> get copyWith =>
      __$SucceededCopyWithImpl<_Succeeded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Succeeded &&
            (identical(other.cmdId, cmdId) || other.cmdId == cmdId));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, cmdId);
  }

  @override
  String toString() {
    return 'CommandResult.succeeded(cmdId: $cmdId)';
  }
}

/// @nodoc
abstract mixin class _$SucceededCopyWith<$Res>
    implements $CommandResultCopyWith<$Res> {
  factory _$SucceededCopyWith(
    _Succeeded value,
    $Res Function(_Succeeded) _then,
  ) = __$SucceededCopyWithImpl;
  @override
  @useResult
  $Res call({String cmdId});
}

/// @nodoc
class __$SucceededCopyWithImpl<$Res> implements _$SucceededCopyWith<$Res> {
  __$SucceededCopyWithImpl(this._self, this._then);

  final _Succeeded _self;
  final $Res Function(_Succeeded) _then;

  /// Create a copy of CommandResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? cmdId = null}) {
    return _then(
      _Succeeded(
        cmdId: null == cmdId
            ? _self.cmdId
            : cmdId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _Failed implements CommandResult {
  const _Failed({required this.cmdId, required this.error});

  @override
  final String cmdId;
  final String error;

  /// Create a copy of CommandResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FailedCopyWith<_Failed> get copyWith =>
      __$FailedCopyWithImpl<_Failed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Failed &&
            (identical(other.cmdId, cmdId) || other.cmdId == cmdId) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, cmdId, error);
  }

  @override
  String toString() {
    return 'CommandResult.failed(cmdId: $cmdId, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$FailedCopyWith<$Res>
    implements $CommandResultCopyWith<$Res> {
  factory _$FailedCopyWith(_Failed value, $Res Function(_Failed) _then) =
      __$FailedCopyWithImpl;
  @override
  @useResult
  $Res call({String cmdId, String error});
}

/// @nodoc
class __$FailedCopyWithImpl<$Res> implements _$FailedCopyWith<$Res> {
  __$FailedCopyWithImpl(this._self, this._then);

  final _Failed _self;
  final $Res Function(_Failed) _then;

  /// Create a copy of CommandResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? cmdId = null, Object? error = null}) {
    return _then(
      _Failed(
        cmdId: null == cmdId
            ? _self.cmdId
            : cmdId // ignore: cast_nullable_to_non_nullable
                  as String,
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _TimedOut implements CommandResult {
  const _TimedOut({required this.cmdId});

  @override
  final String cmdId;

  /// Create a copy of CommandResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TimedOutCopyWith<_TimedOut> get copyWith =>
      __$TimedOutCopyWithImpl<_TimedOut>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TimedOut &&
            (identical(other.cmdId, cmdId) || other.cmdId == cmdId));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, cmdId);
  }

  @override
  String toString() {
    return 'CommandResult.timedOut(cmdId: $cmdId)';
  }
}

/// @nodoc
abstract mixin class _$TimedOutCopyWith<$Res>
    implements $CommandResultCopyWith<$Res> {
  factory _$TimedOutCopyWith(_TimedOut value, $Res Function(_TimedOut) _then) =
      __$TimedOutCopyWithImpl;
  @override
  @useResult
  $Res call({String cmdId});
}

/// @nodoc
class __$TimedOutCopyWithImpl<$Res> implements _$TimedOutCopyWith<$Res> {
  __$TimedOutCopyWithImpl(this._self, this._then);

  final _TimedOut _self;
  final $Res Function(_TimedOut) _then;

  /// Create a copy of CommandResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? cmdId = null}) {
    return _then(
      _TimedOut(
        cmdId: null == cmdId
            ? _self.cmdId
            : cmdId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
