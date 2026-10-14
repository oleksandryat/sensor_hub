// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExportState {
  ExportStatus get status;
  int get deviceCount;
  ShareOutcome? get outcome;
  String? get error;

  /// Create a copy of ExportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExportStateCopyWith<ExportState> get copyWith =>
      _$ExportStateCopyWithImpl<ExportState>(this as ExportState, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as ExportState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExportState &&
            (identical(other.status, _this.status) ||
                other.status == _this.status) &&
            (identical(other.deviceCount, _this.deviceCount) ||
                other.deviceCount == _this.deviceCount) &&
            (identical(other.outcome, _this.outcome) ||
                other.outcome == _this.outcome) &&
            (identical(other.error, _this.error) ||
                other.error == _this.error));
  }

  @override
  int get hashCode {
    final _this = this as ExportState;
    return Object.hash(
      runtimeType,
      _this.status,
      _this.deviceCount,
      _this.outcome,
      _this.error,
    );
  }

  @override
  String toString() {
    final _this = this as ExportState;
    return 'ExportState(status: ${_this.status}, deviceCount: ${_this.deviceCount}, outcome: ${_this.outcome}, error: ${_this.error})';
  }
}

/// @nodoc
abstract mixin class $ExportStateCopyWith<$Res> {
  factory $ExportStateCopyWith(
    ExportState value,
    $Res Function(ExportState) _then,
  ) = _$ExportStateCopyWithImpl;
  @useResult
  $Res call({
    ExportStatus status,
    int deviceCount,
    ShareOutcome? outcome,
    String? error,
  });
}

/// @nodoc
class _$ExportStateCopyWithImpl<$Res> implements $ExportStateCopyWith<$Res> {
  _$ExportStateCopyWithImpl(this._self, this._then);

  final ExportState _self;
  final $Res Function(ExportState) _then;

  /// Create a copy of ExportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? deviceCount = null,
    Object? outcome = freezed,
    Object? error = freezed,
  }) {
    return _then(
      ExportState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ExportStatus,
        deviceCount: null == deviceCount
            ? _self.deviceCount
            : deviceCount // ignore: cast_nullable_to_non_nullable
                  as int,
        outcome: freezed == outcome
            ? _self.outcome
            : outcome // ignore: cast_nullable_to_non_nullable
                  as ShareOutcome?,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _ExportState implements ExportState {
  const _ExportState({
    this.status = ExportStatus.idle,
    this.deviceCount = 0,
    this.outcome,
    this.error,
  });

  @override
  @JsonKey()
  final ExportStatus status;
  @override
  @JsonKey()
  final int deviceCount;
  @override
  final ShareOutcome? outcome;
  @override
  final String? error;

  /// Create a copy of ExportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExportStateCopyWith<_ExportState> get copyWith =>
      __$ExportStateCopyWithImpl<_ExportState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExportState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.deviceCount, deviceCount) ||
                other.deviceCount == deviceCount) &&
            (identical(other.outcome, outcome) || other.outcome == outcome) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, status, deviceCount, outcome, error);
  }

  @override
  String toString() {
    return 'ExportState(status: $status, deviceCount: $deviceCount, outcome: $outcome, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$ExportStateCopyWith<$Res>
    implements $ExportStateCopyWith<$Res> {
  factory _$ExportStateCopyWith(
    _ExportState value,
    $Res Function(_ExportState) _then,
  ) = __$ExportStateCopyWithImpl;
  @override
  @useResult
  $Res call({
    ExportStatus status,
    int deviceCount,
    ShareOutcome? outcome,
    String? error,
  });
}

/// @nodoc
class __$ExportStateCopyWithImpl<$Res> implements _$ExportStateCopyWith<$Res> {
  __$ExportStateCopyWithImpl(this._self, this._then);

  final _ExportState _self;
  final $Res Function(_ExportState) _then;

  /// Create a copy of ExportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? deviceCount = null,
    Object? outcome = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _ExportState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ExportStatus,
        deviceCount: null == deviceCount
            ? _self.deviceCount
            : deviceCount // ignore: cast_nullable_to_non_nullable
                  as int,
        outcome: freezed == outcome
            ? _self.outcome
            : outcome // ignore: cast_nullable_to_non_nullable
                  as ShareOutcome?,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
