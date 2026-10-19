// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_events_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PingResult {
  PingCodec get codec;
  int get payloadSize;
  LatencyStats get stats;

  /// Create a copy of PingResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PingResultCopyWith<PingResult> get copyWith =>
      _$PingResultCopyWithImpl<PingResult>(this as PingResult, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as PingResult;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PingResult &&
            (identical(other.codec, _this.codec) ||
                other.codec == _this.codec) &&
            (identical(other.payloadSize, _this.payloadSize) ||
                other.payloadSize == _this.payloadSize) &&
            (identical(other.stats, _this.stats) ||
                other.stats == _this.stats));
  }

  @override
  int get hashCode {
    final _this = this as PingResult;
    return Object.hash(
      runtimeType,
      _this.codec,
      _this.payloadSize,
      _this.stats,
    );
  }

  @override
  String toString() {
    final _this = this as PingResult;
    return 'PingResult(codec: ${_this.codec}, payloadSize: ${_this.payloadSize}, stats: ${_this.stats})';
  }
}

/// @nodoc
abstract mixin class $PingResultCopyWith<$Res> {
  factory $PingResultCopyWith(
    PingResult value,
    $Res Function(PingResult) _then,
  ) = _$PingResultCopyWithImpl;
  @useResult
  $Res call({PingCodec codec, int payloadSize, LatencyStats stats});

  $LatencyStatsCopyWith<$Res> get stats;
}

/// @nodoc
class _$PingResultCopyWithImpl<$Res> implements $PingResultCopyWith<$Res> {
  _$PingResultCopyWithImpl(this._self, this._then);

  final PingResult _self;
  final $Res Function(PingResult) _then;

  /// Create a copy of PingResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codec = null,
    Object? payloadSize = null,
    Object? stats = null,
  }) {
    return _then(
      PingResult(
        codec: null == codec
            ? _self.codec
            : codec // ignore: cast_nullable_to_non_nullable
                  as PingCodec,
        payloadSize: null == payloadSize
            ? _self.payloadSize
            : payloadSize // ignore: cast_nullable_to_non_nullable
                  as int,
        stats: null == stats
            ? _self.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as LatencyStats,
      ),
    );
  }

  /// Create a copy of PingResult
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

class _PingResult implements PingResult {
  const _PingResult({
    required this.codec,
    required this.payloadSize,
    required this.stats,
  });

  @override
  final PingCodec codec;
  @override
  final int payloadSize;
  @override
  final LatencyStats stats;

  /// Create a copy of PingResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PingResultCopyWith<_PingResult> get copyWith =>
      __$PingResultCopyWithImpl<_PingResult>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PingResult &&
            (identical(other.codec, codec) || other.codec == codec) &&
            (identical(other.payloadSize, payloadSize) ||
                other.payloadSize == payloadSize) &&
            (identical(other.stats, stats) || other.stats == stats));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, codec, payloadSize, stats);
  }

  @override
  String toString() {
    return 'PingResult(codec: $codec, payloadSize: $payloadSize, stats: $stats)';
  }
}

/// @nodoc
abstract mixin class _$PingResultCopyWith<$Res>
    implements $PingResultCopyWith<$Res> {
  factory _$PingResultCopyWith(
    _PingResult value,
    $Res Function(_PingResult) _then,
  ) = __$PingResultCopyWithImpl;
  @override
  @useResult
  $Res call({PingCodec codec, int payloadSize, LatencyStats stats});

  @override
  $LatencyStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$PingResultCopyWithImpl<$Res> implements _$PingResultCopyWith<$Res> {
  __$PingResultCopyWithImpl(this._self, this._then);

  final _PingResult _self;
  final $Res Function(_PingResult) _then;

  /// Create a copy of PingResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? codec = null,
    Object? payloadSize = null,
    Object? stats = null,
  }) {
    return _then(
      _PingResult(
        codec: null == codec
            ? _self.codec
            : codec // ignore: cast_nullable_to_non_nullable
                  as PingCodec,
        payloadSize: null == payloadSize
            ? _self.payloadSize
            : payloadSize // ignore: cast_nullable_to_non_nullable
                  as int,
        stats: null == stats
            ? _self.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as LatencyStats,
      ),
    );
  }

  /// Create a copy of PingResult
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
mixin _$SystemEventsState {
  /// Newest first.
  List<SystemEvent> get events;
  PingStatus get pingStatus;
  List<PingResult> get results;
  String? get error;

  /// Create a copy of SystemEventsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SystemEventsStateCopyWith<SystemEventsState> get copyWith =>
      _$SystemEventsStateCopyWithImpl<SystemEventsState>(
        this as SystemEventsState,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as SystemEventsState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SystemEventsState &&
            const DeepCollectionEquality().equals(other.events, _this.events) &&
            (identical(other.pingStatus, _this.pingStatus) ||
                other.pingStatus == _this.pingStatus) &&
            const DeepCollectionEquality().equals(
              other.results,
              _this.results,
            ) &&
            (identical(other.error, _this.error) ||
                other.error == _this.error));
  }

  @override
  int get hashCode {
    final _this = this as SystemEventsState;
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_this.events),
      _this.pingStatus,
      const DeepCollectionEquality().hash(_this.results),
      _this.error,
    );
  }

  @override
  String toString() {
    final _this = this as SystemEventsState;
    return 'SystemEventsState(events: ${_this.events}, pingStatus: ${_this.pingStatus}, results: ${_this.results}, error: ${_this.error})';
  }
}

/// @nodoc
abstract mixin class $SystemEventsStateCopyWith<$Res> {
  factory $SystemEventsStateCopyWith(
    SystemEventsState value,
    $Res Function(SystemEventsState) _then,
  ) = _$SystemEventsStateCopyWithImpl;
  @useResult
  $Res call({
    List<SystemEvent> events,
    PingStatus pingStatus,
    List<PingResult> results,
    String? error,
  });
}

/// @nodoc
class _$SystemEventsStateCopyWithImpl<$Res>
    implements $SystemEventsStateCopyWith<$Res> {
  _$SystemEventsStateCopyWithImpl(this._self, this._then);

  final SystemEventsState _self;
  final $Res Function(SystemEventsState) _then;

  /// Create a copy of SystemEventsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? events = null,
    Object? pingStatus = null,
    Object? results = null,
    Object? error = freezed,
  }) {
    return _then(
      SystemEventsState(
        events: null == events
            ? _self.events
            : events // ignore: cast_nullable_to_non_nullable
                  as List<SystemEvent>,
        pingStatus: null == pingStatus
            ? _self.pingStatus
            : pingStatus // ignore: cast_nullable_to_non_nullable
                  as PingStatus,
        results: null == results
            ? _self.results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<PingResult>,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _SystemEventsState implements SystemEventsState {
  const _SystemEventsState({
    List<SystemEvent> events = const [],
    this.pingStatus = PingStatus.idle,
    List<PingResult> results = const [],
    this.error,
  }) : _events = events,
       _results = results;

  /// Newest first.
  final List<SystemEvent> _events;

  /// Newest first.
  @override
  @JsonKey()
  List<SystemEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  @JsonKey()
  final PingStatus pingStatus;
  final List<PingResult> _results;
  @override
  @JsonKey()
  List<PingResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  final String? error;

  /// Create a copy of SystemEventsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SystemEventsStateCopyWith<_SystemEventsState> get copyWith =>
      __$SystemEventsStateCopyWithImpl<_SystemEventsState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SystemEventsState &&
            const DeepCollectionEquality().equals(other.events, _events) &&
            (identical(other.pingStatus, pingStatus) ||
                other.pingStatus == pingStatus) &&
            const DeepCollectionEquality().equals(other.results, _results) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_events),
      pingStatus,
      const DeepCollectionEquality().hash(_results),
      error,
    );
  }

  @override
  String toString() {
    return 'SystemEventsState(events: $events, pingStatus: $pingStatus, results: $results, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$SystemEventsStateCopyWith<$Res>
    implements $SystemEventsStateCopyWith<$Res> {
  factory _$SystemEventsStateCopyWith(
    _SystemEventsState value,
    $Res Function(_SystemEventsState) _then,
  ) = __$SystemEventsStateCopyWithImpl;
  @override
  @useResult
  $Res call({
    List<SystemEvent> events,
    PingStatus pingStatus,
    List<PingResult> results,
    String? error,
  });
}

/// @nodoc
class __$SystemEventsStateCopyWithImpl<$Res>
    implements _$SystemEventsStateCopyWith<$Res> {
  __$SystemEventsStateCopyWithImpl(this._self, this._then);

  final _SystemEventsState _self;
  final $Res Function(_SystemEventsState) _then;

  /// Create a copy of SystemEventsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? events = null,
    Object? pingStatus = null,
    Object? results = null,
    Object? error = freezed,
  }) {
    return _then(
      _SystemEventsState(
        events: null == events
            ? _self._events
            : events // ignore: cast_nullable_to_non_nullable
                  as List<SystemEvent>,
        pingStatus: null == pingStatus
            ? _self.pingStatus
            : pingStatus // ignore: cast_nullable_to_non_nullable
                  as PingStatus,
        results: null == results
            ? _self._results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<PingResult>,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
