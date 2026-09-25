// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telemetry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Telemetry {
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime get ts;
  double get value;
  String get unit;

  /// Create a copy of Telemetry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TelemetryCopyWith<Telemetry> get copyWith =>
      _$TelemetryCopyWithImpl<Telemetry>(this as Telemetry, _$identity);

  /// Serializes this Telemetry to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as Telemetry;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Telemetry &&
            (identical(other.ts, _this.ts) || other.ts == _this.ts) &&
            (identical(other.value, _this.value) ||
                other.value == _this.value) &&
            (identical(other.unit, _this.unit) || other.unit == _this.unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as Telemetry;
    return Object.hash(runtimeType, _this.ts, _this.value, _this.unit);
  }

  @override
  String toString() {
    final _this = this as Telemetry;
    return 'Telemetry(ts: ${_this.ts}, value: ${_this.value}, unit: ${_this.unit})';
  }
}

/// @nodoc
abstract mixin class $TelemetryCopyWith<$Res> {
  factory $TelemetryCopyWith(Telemetry value, $Res Function(Telemetry) _then) =
      _$TelemetryCopyWithImpl;
  @useResult
  $Res call({
    @JsonKey(fromJson: _fromJson, toJson: _toJson) DateTime ts,
    double value,
    String unit,
  });
}

/// @nodoc
class _$TelemetryCopyWithImpl<$Res> implements $TelemetryCopyWith<$Res> {
  _$TelemetryCopyWithImpl(this._self, this._then);

  final Telemetry _self;
  final $Res Function(Telemetry) _then;

  /// Create a copy of Telemetry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ts = null, Object? value = null, Object? unit = null}) {
    return _then(
      Telemetry(
        ts: null == ts
            ? _self.ts
            : ts // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _self.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _Telemetry implements Telemetry {
  const _Telemetry({
    @JsonKey(fromJson: _fromJson, toJson: _toJson) required this.ts,
    required this.value,
    required this.unit,
  });
  factory _Telemetry.fromJson(Map<String, dynamic> json) =>
      _$TelemetryFromJson(json);

  @override
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime ts;
  @override
  final double value;
  @override
  final String unit;

  /// Create a copy of Telemetry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TelemetryCopyWith<_Telemetry> get copyWith =>
      __$TelemetryCopyWithImpl<_Telemetry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TelemetryToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Telemetry &&
            (identical(other.ts, ts) || other.ts == ts) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, ts, value, unit);
  }

  @override
  String toString() {
    return 'Telemetry(ts: $ts, value: $value, unit: $unit)';
  }
}

/// @nodoc
abstract mixin class _$TelemetryCopyWith<$Res>
    implements $TelemetryCopyWith<$Res> {
  factory _$TelemetryCopyWith(
    _Telemetry value,
    $Res Function(_Telemetry) _then,
  ) = __$TelemetryCopyWithImpl;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _fromJson, toJson: _toJson) DateTime ts,
    double value,
    String unit,
  });
}

/// @nodoc
class __$TelemetryCopyWithImpl<$Res> implements _$TelemetryCopyWith<$Res> {
  __$TelemetryCopyWithImpl(this._self, this._then);

  final _Telemetry _self;
  final $Res Function(_Telemetry) _then;

  /// Create a copy of Telemetry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? ts = null, Object? value = null, Object? unit = null}) {
    return _then(
      _Telemetry(
        ts: null == ts
            ? _self.ts
            : ts // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _self.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
