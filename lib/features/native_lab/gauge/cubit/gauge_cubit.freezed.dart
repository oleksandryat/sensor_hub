// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gauge_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GaugeState {
  GaugeStatus get status;
  double get value;
  String? get error;

  /// Create a copy of GaugeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GaugeStateCopyWith<GaugeState> get copyWith =>
      _$GaugeStateCopyWithImpl<GaugeState>(this as GaugeState, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as GaugeState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GaugeState &&
            (identical(other.status, _this.status) ||
                other.status == _this.status) &&
            (identical(other.value, _this.value) ||
                other.value == _this.value) &&
            (identical(other.error, _this.error) ||
                other.error == _this.error));
  }

  @override
  int get hashCode {
    final _this = this as GaugeState;
    return Object.hash(runtimeType, _this.status, _this.value, _this.error);
  }

  @override
  String toString() {
    final _this = this as GaugeState;
    return 'GaugeState(status: ${_this.status}, value: ${_this.value}, error: ${_this.error})';
  }
}

/// @nodoc
abstract mixin class $GaugeStateCopyWith<$Res> {
  factory $GaugeStateCopyWith(
    GaugeState value,
    $Res Function(GaugeState) _then,
  ) = _$GaugeStateCopyWithImpl;
  @useResult
  $Res call({GaugeStatus status, double value, String? error});
}

/// @nodoc
class _$GaugeStateCopyWithImpl<$Res> implements $GaugeStateCopyWith<$Res> {
  _$GaugeStateCopyWithImpl(this._self, this._then);

  final GaugeState _self;
  final $Res Function(GaugeState) _then;

  /// Create a copy of GaugeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? value = null,
    Object? error = freezed,
  }) {
    return _then(
      GaugeState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as GaugeStatus,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _GaugeState implements GaugeState {
  const _GaugeState({
    this.status = GaugeStatus.idle,
    this.value = 0.0,
    this.error,
  });

  @override
  @JsonKey()
  final GaugeStatus status;
  @override
  @JsonKey()
  final double value;
  @override
  final String? error;

  /// Create a copy of GaugeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GaugeStateCopyWith<_GaugeState> get copyWith =>
      __$GaugeStateCopyWithImpl<_GaugeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GaugeState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, status, value, error);
  }

  @override
  String toString() {
    return 'GaugeState(status: $status, value: $value, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$GaugeStateCopyWith<$Res>
    implements $GaugeStateCopyWith<$Res> {
  factory _$GaugeStateCopyWith(
    _GaugeState value,
    $Res Function(_GaugeState) _then,
  ) = __$GaugeStateCopyWithImpl;
  @override
  @useResult
  $Res call({GaugeStatus status, double value, String? error});
}

/// @nodoc
class __$GaugeStateCopyWithImpl<$Res> implements _$GaugeStateCopyWith<$Res> {
  __$GaugeStateCopyWithImpl(this._self, this._then);

  final _GaugeState _self;
  final $Res Function(_GaugeState) _then;

  /// Create a copy of GaugeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? value = null,
    Object? error = freezed,
  }) {
    return _then(
      _GaugeState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as GaugeStatus,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
