import 'package:database_service/database_service.dart';
import 'package:database_service/nosql/secure_storage/secure_storage_service_impl.dart';

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

class SecureTokenStorage {
  SecureTokenStorage._();
  
  static SecureTokenStorage? _instance;
  static SecureTokenStorage get instance {
    _instance ??= SecureTokenStorage._();
    return _instance!;
  }
  
  late final SecureStorageService _secureStorage;
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _secureStorage = SecureStorageServiceImpl();
      await _secureStorage.initialize();
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize secure token storage: $e');
    }
  }
  
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception('SecureTokenStorage not initialized. Call initialize() first.');
    }
  }
  
  Future<void> setString(String key, String value) async {
    _ensureInitialized();
    try {
      await _secureStorage.write(key, value);
    } catch (e) {
      throw Exception('Failed to store token data: $e');
    }
  }
  
  Future<String?> getString(String key) async {
    _ensureInitialized();
    try {
      return await _secureStorage.read(key);
    } catch (e) {
      throw Exception('Failed to retrieve token data: $e');
    }
  }
  
  Future<void> remove(String key) async {
    _ensureInitialized();
    try {
      await _secureStorage.delete(key);
    } catch (e) {
      throw Exception('Failed to remove token data: $e');
    }
  }
  
  Future<void> setBatch(Map<String, String> data) async {
    _ensureInitialized();
    try {
      await _secureStorage.writeBatch(data);
    } catch (e) {
      throw Exception('Failed to store token batch data: $e');
    }
  }
  
  Future<bool> containsKey(String key) async {
    _ensureInitialized();
    try {
      return await _secureStorage.containsKey(key);
    } catch (e) {
      throw Exception('Failed to check token key existence: $e');
    }
  }
  
  Future<void> clearAll() async {
    _ensureInitialized();
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw Exception('Failed to clear all token data: $e');
    }
  }
}

class TokenManager {
  TokenManager._();
  
  static TokenManager? _instance;
  static TokenManager get instance {
    _instance ??= TokenManager._();
    return _instance!;
  }
  
  final SecureTokenStorage _storage = SecureTokenStorage.instance;
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _storage.initialize();
    _isInitialized = true;
  }
  
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception('TokenManager not initialized. Call initialize() first.');
    }
  }

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiresAtKey = 'token_expires_at';

  Future<TokenPair?> get tokenPair async {
    _ensureInitialized();
    
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

  Future<void> setTokenPair(TokenPair tokenPair) async {
    _ensureInitialized();
    
    final batch = <String, String>{
      _accessTokenKey: tokenPair.accessToken,
    };
    
    if (tokenPair.refreshToken != null) {
      batch[_refreshTokenKey] = tokenPair.refreshToken!;
    }
    
    if (tokenPair.expiresAt != null) {
      batch[_expiresAtKey] = tokenPair.expiresAt!.millisecondsSinceEpoch.toString();
    }
    
    await _storage.setBatch(batch);
  }

  Future<void> clearTokens() async {
    _ensureInitialized();
    
    await Future.wait([
      _storage.remove(_accessTokenKey),
      _storage.remove(_refreshTokenKey),
      _storage.remove(_expiresAtKey),
    ]);
  }

  Future<bool> get isAuthenticated async {
    _ensureInitialized();
    return await tokenPair != null;
  }

  Future<bool> get isTokenExpired async {
    _ensureInitialized();
    final pair = await tokenPair;
    return pair == null || pair.isExpired;
  }

  Future<String?> get accessToken async {
    _ensureInitialized();
    return (await tokenPair)?.accessToken;
  }

  Future<String?> get refreshToken async {
    _ensureInitialized();
    return (await tokenPair)?.refreshToken;
  }
  
  Future<void> clearAllSecureData() async {
    _ensureInitialized();
    await _storage.clearAll();
  }
}
