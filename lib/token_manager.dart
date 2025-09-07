import 'package:api_service/token_pair.dart';
import 'package:database_service/database_service.dart';
import 'package:database_service/nosql/secure_storage/secure_storage_service_impl.dart';

class TokenManager {
  TokenManager._();

  static TokenManager? _instance;
  static TokenManager get instance {
    _instance ??= TokenManager._();
    return _instance!;
  }

  late final SecureStorageService _storage;

  Future<void> initialize() async {
    _storage = SecureStorageServiceImpl();
    await _storage.initialize();
  }

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiresAtKey = 'token_expires_at';

  Future<TokenPair?> get tokenPair async {
    final accessToken = await _storage.read(_accessTokenKey);
    if (accessToken == null) return null;

    final refreshToken = await _storage.read(_refreshTokenKey);
    final expiresAtStr = await _storage.read(_expiresAtKey);
    final expiresAt = expiresAtStr != null
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(expiresAtStr))
        : null;

    return TokenPair(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  Future<void> setTokenPair(TokenPair tokenPair) async {
    final batch = <String, String>{_accessTokenKey: tokenPair.accessToken};

    if (tokenPair.refreshToken != null) {
      batch[_refreshTokenKey] = tokenPair.refreshToken!;
    }

    if (tokenPair.expiresAt != null) {
      batch[_expiresAtKey] = tokenPair.expiresAt!.millisecondsSinceEpoch
          .toString();
    }

    await _storage.writeBatch(batch);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(_accessTokenKey),
      _storage.delete(_refreshTokenKey),
      _storage.delete(_expiresAtKey),
    ]);
  }

  Future<bool> get isAuthenticated async {
    return await tokenPair != null;
  }

  Future<bool> get isTokenExpired async {
    final pair = await tokenPair;
    return pair == null || pair.isExpired;
  }

  Future<String?> get accessToken async {
    return (await tokenPair)?.accessToken;
  }

  Future<String?> get refreshToken async {
    return (await tokenPair)?.refreshToken;
  }

  Future<void> clearAllSecureData() async {
    await _storage.deleteAll();
  }
}
