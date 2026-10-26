// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anomaly_detector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnomalyReading {
  double get mean;
  double get stdDev;
  double get zScore;
  bool get isAnomaly;

  /// Create a copy of AnomalyReading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AnomalyReadingCopyWith<AnomalyReading> get copyWith =>
      _$AnomalyReadingCopyWithImpl<AnomalyReading>(
        this as AnomalyReading,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as AnomalyReading;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AnomalyReading &&
            (identical(other.mean, _this.mean) || other.mean == _this.mean) &&
            (identical(other.stdDev, _this.stdDev) ||
                other.stdDev == _this.stdDev) &&
            (identical(other.zScore, _this.zScore) ||
                other.zScore == _this.zScore) &&
            (identical(other.isAnomaly, _this.isAnomaly) ||
                other.isAnomaly == _this.isAnomaly));
  }

  @override
  int get hashCode {
    final _this = this as AnomalyReading;
    return Object.hash(
      runtimeType,
      _this.mean,
      _this.stdDev,
      _this.zScore,
      _this.isAnomaly,
    );
  }

  @override
  String toString() {
    final _this = this as AnomalyReading;
    return 'AnomalyReading(mean: ${_this.mean}, stdDev: ${_this.stdDev}, zScore: ${_this.zScore}, isAnomaly: ${_this.isAnomaly})';
  }
}

/// @nodoc
abstract mixin class $AnomalyReadingCopyWith<$Res> {
  factory $AnomalyReadingCopyWith(
    AnomalyReading value,
    $Res Function(AnomalyReading) _then,
  ) = _$AnomalyReadingCopyWithImpl;
  @useResult
  $Res call({double mean, double stdDev, double zScore, bool isAnomaly});
}

/// @nodoc
class _$AnomalyReadingCopyWithImpl<$Res>
    implements $AnomalyReadingCopyWith<$Res> {
  _$AnomalyReadingCopyWithImpl(this._self, this._then);

  final AnomalyReading _self;
  final $Res Function(AnomalyReading) _then;

  /// Create a copy of AnomalyReading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mean = null,
    Object? stdDev = null,
    Object? zScore = null,
    Object? isAnomaly = null,
  }) {
    return _then(
      AnomalyReading(
        mean: null == mean
            ? _self.mean
            : mean // ignore: cast_nullable_to_non_nullable
                  as double,
        stdDev: null == stdDev
            ? _self.stdDev
            : stdDev // ignore: cast_nullable_to_non_nullable
                  as double,
        zScore: null == zScore
            ? _self.zScore
            : zScore // ignore: cast_nullable_to_non_nullable
                  as double,
        isAnomaly: null == isAnomaly
            ? _self.isAnomaly
            : isAnomaly // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _AnomalyReading implements AnomalyReading {
  const _AnomalyReading({
    required this.mean,
    required this.stdDev,
    required this.zScore,
    required this.isAnomaly,
  });

  @override
  final double mean;
  @override
  final double stdDev;
  @override
  final double zScore;
  @override
  final bool isAnomaly;

  /// Create a copy of AnomalyReading
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AnomalyReadingCopyWith<_AnomalyReading> get copyWith =>
      __$AnomalyReadingCopyWithImpl<_AnomalyReading>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AnomalyReading &&
            (identical(other.mean, mean) || other.mean == mean) &&
            (identical(other.stdDev, stdDev) || other.stdDev == stdDev) &&
            (identical(other.zScore, zScore) || other.zScore == zScore) &&
            (identical(other.isAnomaly, isAnomaly) ||
                other.isAnomaly == isAnomaly));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, mean, stdDev, zScore, isAnomaly);
  }

  @override
  String toString() {
    return 'AnomalyReading(mean: $mean, stdDev: $stdDev, zScore: $zScore, isAnomaly: $isAnomaly)';
  }
}

/// @nodoc
abstract mixin class _$AnomalyReadingCopyWith<$Res>
    implements $AnomalyReadingCopyWith<$Res> {
  factory _$AnomalyReadingCopyWith(
    _AnomalyReading value,
    $Res Function(_AnomalyReading) _then,
  ) = __$AnomalyReadingCopyWithImpl;
  @override
  @useResult
  $Res call({double mean, double stdDev, double zScore, bool isAnomaly});
}

/// @nodoc
class __$AnomalyReadingCopyWithImpl<$Res>
    implements _$AnomalyReadingCopyWith<$Res> {
  __$AnomalyReadingCopyWithImpl(this._self, this._then);

  final _AnomalyReading _self;
  final $Res Function(_AnomalyReading) _then;

  /// Create a copy of AnomalyReading
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mean = null,
    Object? stdDev = null,
    Object? zScore = null,
    Object? isAnomaly = null,
  }) {
    return _then(
      _AnomalyReading(
        mean: null == mean
            ? _self.mean
            : mean // ignore: cast_nullable_to_non_nullable
                  as double,
        stdDev: null == stdDev
            ? _self.stdDev
            : stdDev // ignore: cast_nullable_to_non_nullable
                  as double,
        zScore: null == zScore
            ? _self.zScore
            : zScore // ignore: cast_nullable_to_non_nullable
                  as double,
        isAnomaly: null == isAnomaly
            ? _self.isAnomaly
            : isAnomaly // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
