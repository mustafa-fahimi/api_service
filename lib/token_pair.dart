import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_pair.freezed.dart';

@freezed
abstract class TokenPair with _$TokenPair {
  const TokenPair._();

  const factory TokenPair({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) = _TokenPair;

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}
