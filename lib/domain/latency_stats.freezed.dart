// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'latency_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LatencyStats {
  int get count;
  Duration get min;
  Duration get median;
  Duration get p95;
  Duration get max;

  /// Create a copy of LatencyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LatencyStatsCopyWith<LatencyStats> get copyWith =>
      _$LatencyStatsCopyWithImpl<LatencyStats>(
        this as LatencyStats,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as LatencyStats;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LatencyStats &&
            (identical(other.count, _this.count) ||
                other.count == _this.count) &&
            (identical(other.min, _this.min) || other.min == _this.min) &&
            (identical(other.median, _this.median) ||
                other.median == _this.median) &&
            (identical(other.p95, _this.p95) || other.p95 == _this.p95) &&
            (identical(other.max, _this.max) || other.max == _this.max));
  }

  @override
  int get hashCode {
    final _this = this as LatencyStats;
    return Object.hash(
      runtimeType,
      _this.count,
      _this.min,
      _this.median,
      _this.p95,
      _this.max,
    );
  }

  @override
  String toString() {
    final _this = this as LatencyStats;
    return 'LatencyStats(count: ${_this.count}, min: ${_this.min}, median: ${_this.median}, p95: ${_this.p95}, max: ${_this.max})';
  }
}

/// @nodoc
abstract mixin class $LatencyStatsCopyWith<$Res> {
  factory $LatencyStatsCopyWith(
    LatencyStats value,
    $Res Function(LatencyStats) _then,
  ) = _$LatencyStatsCopyWithImpl;
  @useResult
  $Res call({
    int count,
    Duration min,
    Duration median,
    Duration p95,
    Duration max,
  });
}

/// @nodoc
class _$LatencyStatsCopyWithImpl<$Res> implements $LatencyStatsCopyWith<$Res> {
  _$LatencyStatsCopyWithImpl(this._self, this._then);

  final LatencyStats _self;
  final $Res Function(LatencyStats) _then;

  /// Create a copy of LatencyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? min = null,
    Object? median = null,
    Object? p95 = null,
    Object? max = null,
  }) {
    return _then(
      LatencyStats(
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        min: null == min
            ? _self.min
            : min // ignore: cast_nullable_to_non_nullable
                  as Duration,
        median: null == median
            ? _self.median
            : median // ignore: cast_nullable_to_non_nullable
                  as Duration,
        p95: null == p95
            ? _self.p95
            : p95 // ignore: cast_nullable_to_non_nullable
                  as Duration,
        max: null == max
            ? _self.max
            : max // ignore: cast_nullable_to_non_nullable
                  as Duration,
      ),
    );
  }
}

/// @nodoc

class _LatencyStats implements LatencyStats {
  const _LatencyStats({
    required this.count,
    required this.min,
    required this.median,
    required this.p95,
    required this.max,
  });

  @override
  final int count;
  @override
  final Duration min;
  @override
  final Duration median;
  @override
  final Duration p95;
  @override
  final Duration max;

  /// Create a copy of LatencyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LatencyStatsCopyWith<_LatencyStats> get copyWith =>
      __$LatencyStatsCopyWithImpl<_LatencyStats>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LatencyStats &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.median, median) || other.median == median) &&
            (identical(other.p95, p95) || other.p95 == p95) &&
            (identical(other.max, max) || other.max == max));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, count, min, median, p95, max);
  }

  @override
  String toString() {
    return 'LatencyStats(count: $count, min: $min, median: $median, p95: $p95, max: $max)';
  }
}

/// @nodoc
abstract mixin class _$LatencyStatsCopyWith<$Res>
    implements $LatencyStatsCopyWith<$Res> {
  factory _$LatencyStatsCopyWith(
    _LatencyStats value,
    $Res Function(_LatencyStats) _then,
  ) = __$LatencyStatsCopyWithImpl;
  @override
  @useResult
  $Res call({
    int count,
    Duration min,
    Duration median,
    Duration p95,
    Duration max,
  });
}

/// @nodoc
class __$LatencyStatsCopyWithImpl<$Res>
    implements _$LatencyStatsCopyWith<$Res> {
  __$LatencyStatsCopyWithImpl(this._self, this._then);

  final _LatencyStats _self;
  final $Res Function(_LatencyStats) _then;

  /// Create a copy of LatencyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? count = null,
    Object? min = null,
    Object? median = null,
    Object? p95 = null,
    Object? max = null,
  }) {
    return _then(
      _LatencyStats(
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        min: null == min
            ? _self.min
            : min // ignore: cast_nullable_to_non_nullable
                  as Duration,
        median: null == median
            ? _self.median
            : median // ignore: cast_nullable_to_non_nullable
                  as Duration,
        p95: null == p95
            ? _self.p95
            : p95 // ignore: cast_nullable_to_non_nullable
                  as Duration,
        max: null == max
            ? _self.max
            : max // ignore: cast_nullable_to_non_nullable
                  as Duration,
      ),
    );
  }
}
