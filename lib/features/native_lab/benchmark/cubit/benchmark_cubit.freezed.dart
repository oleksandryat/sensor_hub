// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'benchmark_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BenchmarkResult {
  BenchmarkMechanism get mechanism;
  LatencyStats get stats;

  /// Create a copy of BenchmarkResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BenchmarkResultCopyWith<BenchmarkResult> get copyWith =>
      _$BenchmarkResultCopyWithImpl<BenchmarkResult>(
        this as BenchmarkResult,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as BenchmarkResult;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BenchmarkResult &&
            (identical(other.mechanism, _this.mechanism) ||
                other.mechanism == _this.mechanism) &&
            (identical(other.stats, _this.stats) ||
                other.stats == _this.stats));
  }

  @override
  int get hashCode {
    final _this = this as BenchmarkResult;
    return Object.hash(runtimeType, _this.mechanism, _this.stats);
  }

  @override
  String toString() {
    final _this = this as BenchmarkResult;
    return 'BenchmarkResult(mechanism: ${_this.mechanism}, stats: ${_this.stats})';
  }
}

/// @nodoc
abstract mixin class $BenchmarkResultCopyWith<$Res> {
  factory $BenchmarkResultCopyWith(
    BenchmarkResult value,
    $Res Function(BenchmarkResult) _then,
  ) = _$BenchmarkResultCopyWithImpl;
  @useResult
  $Res call({BenchmarkMechanism mechanism, LatencyStats stats});

  $LatencyStatsCopyWith<$Res> get stats;
}

/// @nodoc
class _$BenchmarkResultCopyWithImpl<$Res>
    implements $BenchmarkResultCopyWith<$Res> {
  _$BenchmarkResultCopyWithImpl(this._self, this._then);

  final BenchmarkResult _self;
  final $Res Function(BenchmarkResult) _then;

  /// Create a copy of BenchmarkResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mechanism = null, Object? stats = null}) {
    return _then(
      BenchmarkResult(
        mechanism: null == mechanism
            ? _self.mechanism
            : mechanism // ignore: cast_nullable_to_non_nullable
                  as BenchmarkMechanism,
        stats: null == stats
            ? _self.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as LatencyStats,
      ),
    );
  }

  /// Create a copy of BenchmarkResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LatencyStatsCopyWith<$Res> get stats {
    return $LatencyStatsCopyWith<$Res>(_self.stats, (value) {
      return _then(_self.copyWith(stats: value));
    });
  }
}

/// @nodoc

class _BenchmarkResult implements BenchmarkResult {
  const _BenchmarkResult({required this.mechanism, required this.stats});

  @override
  final BenchmarkMechanism mechanism;
  @override
  final LatencyStats stats;

  /// Create a copy of BenchmarkResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BenchmarkResultCopyWith<_BenchmarkResult> get copyWith =>
      __$BenchmarkResultCopyWithImpl<_BenchmarkResult>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BenchmarkResult &&
            (identical(other.mechanism, mechanism) ||
                other.mechanism == mechanism) &&
            (identical(other.stats, stats) || other.stats == stats));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, mechanism, stats);
  }

  @override
  String toString() {
    return 'BenchmarkResult(mechanism: $mechanism, stats: $stats)';
  }
}

/// @nodoc
abstract mixin class _$BenchmarkResultCopyWith<$Res>
    implements $BenchmarkResultCopyWith<$Res> {
  factory _$BenchmarkResultCopyWith(
    _BenchmarkResult value,
    $Res Function(_BenchmarkResult) _then,
  ) = __$BenchmarkResultCopyWithImpl;
  @override
  @useResult
  $Res call({BenchmarkMechanism mechanism, LatencyStats stats});

  @override
  $LatencyStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$BenchmarkResultCopyWithImpl<$Res>
    implements _$BenchmarkResultCopyWith<$Res> {
  __$BenchmarkResultCopyWithImpl(this._self, this._then);

  final _BenchmarkResult _self;
  final $Res Function(_BenchmarkResult) _then;

  /// Create a copy of BenchmarkResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? mechanism = null, Object? stats = null}) {
    return _then(
      _BenchmarkResult(
        mechanism: null == mechanism
            ? _self.mechanism
            : mechanism // ignore: cast_nullable_to_non_nullable
                  as BenchmarkMechanism,
        stats: null == stats
            ? _self.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as LatencyStats,
      ),
    );
  }

  /// Create a copy of BenchmarkResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LatencyStatsCopyWith<$Res> get stats {
    return $LatencyStatsCopyWith<$Res>(_self.stats, (value) {
      return _then(_self.copyWith(stats: value));
    });
  }
}

/// @nodoc
mixin _$BenchmarkState {
  BenchmarkStatus get status;
  List<BenchmarkResult> get results;
  String? get error;

  /// Create a copy of BenchmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BenchmarkStateCopyWith<BenchmarkState> get copyWith =>
      _$BenchmarkStateCopyWithImpl<BenchmarkState>(
        this as BenchmarkState,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as BenchmarkState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BenchmarkState &&
            (identical(other.status, _this.status) ||
                other.status == _this.status) &&
            const DeepCollectionEquality().equals(
              other.results,
              _this.results,
            ) &&
            (identical(other.error, _this.error) ||
                other.error == _this.error));
  }

  @override
  int get hashCode {
    final _this = this as BenchmarkState;
    return Object.hash(
      runtimeType,
      _this.status,
      const DeepCollectionEquality().hash(_this.results),
      _this.error,
    );
  }

  @override
  String toString() {
    final _this = this as BenchmarkState;
    return 'BenchmarkState(status: ${_this.status}, results: ${_this.results}, error: ${_this.error})';
  }
}

/// @nodoc
abstract mixin class $BenchmarkStateCopyWith<$Res> {
  factory $BenchmarkStateCopyWith(
    BenchmarkState value,
    $Res Function(BenchmarkState) _then,
  ) = _$BenchmarkStateCopyWithImpl;
  @useResult
  $Res call({
    BenchmarkStatus status,
    List<BenchmarkResult> results,
    String? error,
  });
}

/// @nodoc
class _$BenchmarkStateCopyWithImpl<$Res>
    implements $BenchmarkStateCopyWith<$Res> {
  _$BenchmarkStateCopyWithImpl(this._self, this._then);

  final BenchmarkState _self;
  final $Res Function(BenchmarkState) _then;

  /// Create a copy of BenchmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? results = null,
    Object? error = freezed,
  }) {
    return _then(
      BenchmarkState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BenchmarkStatus,
        results: null == results
            ? _self.results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<BenchmarkResult>,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _BenchmarkState extends BenchmarkState {
  const _BenchmarkState({
    this.status = BenchmarkStatus.idle,
    List<BenchmarkResult> results = const [],
    this.error,
  }) : _results = results,
       super._();

  @override
  @JsonKey()
  final BenchmarkStatus status;
  final List<BenchmarkResult> _results;
  @override
  @JsonKey()
  List<BenchmarkResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  final String? error;

  /// Create a copy of BenchmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BenchmarkStateCopyWith<_BenchmarkState> get copyWith =>
      __$BenchmarkStateCopyWithImpl<_BenchmarkState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BenchmarkState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.results, _results) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_results),
      error,
    );
  }

  @override
  String toString() {
    return 'BenchmarkState(status: $status, results: $results, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$BenchmarkStateCopyWith<$Res>
    implements $BenchmarkStateCopyWith<$Res> {
  factory _$BenchmarkStateCopyWith(
    _BenchmarkState value,
    $Res Function(_BenchmarkState) _then,
  ) = __$BenchmarkStateCopyWithImpl;
  @override
  @useResult
  $Res call({
    BenchmarkStatus status,
    List<BenchmarkResult> results,
    String? error,
  });
}

/// @nodoc
class __$BenchmarkStateCopyWithImpl<$Res>
    implements _$BenchmarkStateCopyWith<$Res> {
  __$BenchmarkStateCopyWithImpl(this._self, this._then);

  final _BenchmarkState _self;
  final $Res Function(_BenchmarkState) _then;

  /// Create a copy of BenchmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? results = null,
    Object? error = freezed,
  }) {
    return _then(
      _BenchmarkState(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BenchmarkStatus,
        results: null == results
            ? _self._results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<BenchmarkResult>,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
