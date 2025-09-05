/// Represents an authentication token pair
class TokenPair {
  const TokenPair({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  TokenPair copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return TokenPair(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

/// Simple storage interface for token persistence
abstract class TokenStorage {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<void> remove(String key);
}

/// In-memory implementation of token storage (fallback)
class InMemoryTokenStorage implements TokenStorage {
  final Map<String, String> _storage = {};

  @override
  Future<String?> getString(String key) async => _storage[key];

  @override
  Future<void> setString(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _storage.remove(key);
  }
}

/// Manages authentication tokens with persistent storage
class TokenManager {
  TokenManager({TokenStorage? storage}) : _storage = storage ?? InMemoryTokenStorage();

  final TokenStorage _storage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiresAtKey = 'token_expires_at';

  /// Get the current token pair
  Future<TokenPair?> get tokenPair async {
    final accessToken = await _storage.getString(_accessTokenKey);
    if (accessToken == null) return null;

    final refreshToken = await _storage.getString(_refreshTokenKey);
    final expiresAtStr = await _storage.getString(_expiresAtKey);
    final expiresAt = expiresAtStr != null
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(expiresAtStr))
        : null;

    return TokenPair(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  /// Set the token pair
  Future<void> setTokenPair(TokenPair tokenPair) async {
    await Future.wait([
      _storage.setString(_accessTokenKey, tokenPair.accessToken),
      if (tokenPair.refreshToken != null)
        _storage.setString(_refreshTokenKey, tokenPair.refreshToken!),
      if (tokenPair.expiresAt != null)
        _storage.setString(
          _expiresAtKey,
          tokenPair.expiresAt!.millisecondsSinceEpoch.toString(),
        ),
    ]);
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.remove(_accessTokenKey),
      _storage.remove(_refreshTokenKey),
      _storage.remove(_expiresAtKey),
    ]);
  }

  /// Check if user is authenticated
  Future<bool> get isAuthenticated async => await tokenPair != null;

  /// Check if current token is expired
  Future<bool> get isTokenExpired async {
    final pair = await tokenPair;
    return pair == null || pair.isExpired;
  }

  /// Get access token directly
  Future<String?> get accessToken async => (await tokenPair)?.accessToken;

  /// Get refresh token directly
  Future<String?> get refreshToken async => (await tokenPair)?.refreshToken;
}
