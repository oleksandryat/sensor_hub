import 'package:freezed_annotation/freezed_annotation.dart';

part 'stored_credentials.freezed.dart';

@freezed
abstract class StoredCredentials with _$StoredCredentials {
  const factory StoredCredentials({
    required String username,
    required String password,
  }) = _StoredCredentials;
}
