// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stored_credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoredCredentials {
  String get username;
  String get password;

  /// Create a copy of StoredCredentials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StoredCredentialsCopyWith<StoredCredentials> get copyWith =>
      _$StoredCredentialsCopyWithImpl<StoredCredentials>(
        this as StoredCredentials,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as StoredCredentials;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StoredCredentials &&
            (identical(other.username, _this.username) ||
                other.username == _this.username) &&
            (identical(other.password, _this.password) ||
                other.password == _this.password));
  }

  @override
  int get hashCode {
    final _this = this as StoredCredentials;
    return Object.hash(runtimeType, _this.username, _this.password);
  }

  @override
  String toString() {
    final _this = this as StoredCredentials;
    return 'StoredCredentials(username: ${_this.username}, password: ${_this.password})';
  }
}

/// @nodoc
abstract mixin class $StoredCredentialsCopyWith<$Res> {
  factory $StoredCredentialsCopyWith(
    StoredCredentials value,
    $Res Function(StoredCredentials) _then,
  ) = _$StoredCredentialsCopyWithImpl;
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class _$StoredCredentialsCopyWithImpl<$Res>
    implements $StoredCredentialsCopyWith<$Res> {
  _$StoredCredentialsCopyWithImpl(this._self, this._then);

  final StoredCredentials _self;
  final $Res Function(StoredCredentials) _then;

  /// Create a copy of StoredCredentials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null, Object? password = null}) {
    return _then(
      StoredCredentials(
        username: null == username
            ? _self.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _self.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _StoredCredentials implements StoredCredentials {
  const _StoredCredentials({required this.username, required this.password});

  @override
  final String username;
  @override
  final String password;

  /// Create a copy of StoredCredentials
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StoredCredentialsCopyWith<_StoredCredentials> get copyWith =>
      __$StoredCredentialsCopyWithImpl<_StoredCredentials>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StoredCredentials &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, username, password);
  }

  @override
  String toString() {
    return 'StoredCredentials(username: $username, password: $password)';
  }
}

/// @nodoc
abstract mixin class _$StoredCredentialsCopyWith<$Res>
    implements $StoredCredentialsCopyWith<$Res> {
  factory _$StoredCredentialsCopyWith(
    _StoredCredentials value,
    $Res Function(_StoredCredentials) _then,
  ) = __$StoredCredentialsCopyWithImpl;
  @override
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class __$StoredCredentialsCopyWithImpl<$Res>
    implements _$StoredCredentialsCopyWith<$Res> {
  __$StoredCredentialsCopyWithImpl(this._self, this._then);

  final _StoredCredentials _self;
  final $Res Function(_StoredCredentials) _then;

  /// Create a copy of StoredCredentials
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? username = null, Object? password = null}) {
    return _then(
      _StoredCredentials(
        username: null == username
            ? _self.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _self.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
