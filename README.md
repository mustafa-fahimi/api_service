# Flutter API Service

A robust Flutter API service package built on top of the Dio HTTP client, featuring comprehensive secure token management and clean error handling using functional programming principles.

## Features

- ✅ **Functional Error Handling**: Uses fpdart's `Either` monad for type-safe error handling
- ✅ **Secure Token Management**: Automatic token handling with secure persistent storage
- ✅ **Type Safety**: Leverages Freezed for type-safe unions and data models
- ✅ **Clean Architecture**: Well-structured abstraction over Dio's complexity
- ✅ **HTTP Methods Support**: GET, POST, PUT, DELETE, PATCH
- ✅ **Flexible Configuration**: Custom headers, query parameters, and progress callbacks
- ✅ **Automatic Token Injection**: Bearer tokens automatically added to requests
- ✅ **Token Refresh**: Automatic token refresh on 401 responses
- ✅ **Cross-Platform Security**: Uses Flutter Secure Storage for token persistence

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  api_service: ^2.0.0
  database_service: ^2.0.0  # Required for secure token storage
```

### Secure Token Persistence

The package now uses secure storage by default for token persistence. No additional setup is required - tokens are automatically stored securely using the integrated `database_service` package with Flutter Secure Storage.

## Basic Usage

### Basic Setup

```dart
import 'package:api_service/api_service.dart';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.example.com',
  ));

  // Create API service with secure token management
  final apiService = ApiServiceImpl(dio: dio);
  
  // Initialize secure storage (required)
  await apiService.initialize();

  // Make a GET request
  final result = await apiService.getMethod('/users');

  result.fold(
    (error) => print('Error: $error'),
    (response) => print('Success: ${response.data}'),
  );
}
```

### With Authentication

For APIs that require authentication, provide token refresh callback and handle token expiration:

## Token Management

### Setting Up Token Management

```dart
final apiService = ApiServiceImpl(
  dio: dio,
  tokenRefreshCallback: _refreshToken,
  onTokenExpired: _handleTokenExpired,
);

// Initialize secure storage
await apiService.initialize();

// Set initial tokens (automatically stored securely)
final tokenPair = TokenPair(
  accessToken: 'your_access_token',
  refreshToken: 'your_refresh_token',
  expiresAt: DateTime.now().add(Duration(hours: 1)),
);

await apiService.setTokens(tokenPair);
```

### Token Refresh Implementation

```dart
Future<Either<String, TokenPair>> _refreshToken(String refreshToken) async {
  try {
    final response = await Dio().post(
      'https://api.example.com/auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    return right(TokenPair(
      accessToken: response.data['accessToken'],
      refreshToken: response.data['refreshToken'],
      expiresAt: DateTime.now().add(Duration(hours: 1)),
    ));
  } catch (e) {
    return left('Refresh failed: $e');
  }
}

void _handleTokenExpired() {
  // Handle token expiration (logout, navigate to login, etc.)
  print('Token expired. Please log in again.');
}
```

### Token Management Methods

```dart
// Check authentication status
final isAuthenticated = await apiService.isAuthenticated;

// Check if token is expired
final isExpired = await apiService.isTokenExpired;

// Get current tokens
final currentTokens = await apiService.currentTokens;

// Clear tokens (logout)
await apiService.clearTokens();
```

## HTTP Methods

All HTTP methods are supported with consistent error handling:

```dart
// GET request
final getResult = await apiService.getMethod('/users');

// POST request
final postResult = await apiService.postMethod('/users', body: {'name': 'John'});

// PUT request
final putResult = await apiService.putMethod('/users/1', body: {'name': 'Jane'});

// DELETE request
final deleteResult = await apiService.deleteMethod('/users/1');

// PATCH request
final patchResult = await apiService.patchMethod('/users/1', body: {'age': 30});
```

## Request Configuration

```dart
final result = await apiService.getMethod(
  '/users',
  option: ApiServiceOption(
    query: {'page': '1', 'limit': '10'},
    header: ApiServiceHeader.basic(), // or .formData()
  ),
  cancelToken: CancelToken(),
);
```

## Error Handling

All methods return `Either<DioException, Response<T>>`:

```dart
final result = await apiService.getMethod('/users');

result.fold(
  (dioException) {
    // Handle error
    print('Error: ${dioException.message}');
    print('Status: ${dioException.response?.statusCode}');
  },
  (response) {
    // Handle success
    print('Data: ${response.data}');
    print('Status: ${response.statusCode}');
  },
);
```

## Secure Token Storage

### Automatic Secure Persistence

Tokens are automatically stored securely using:
- **iOS**: Keychain with `first_unlock` accessibility
- **Android**: Encrypted SharedPreferences
- **macOS**: Keychain with `first_unlock` accessibility  
- **Windows**: Credential Store API

### Security Features

- All tokens are encrypted at rest
- Platform-specific secure storage mechanisms
- Automatic cleanup on logout
- Batch operations for better performance

```dart
// Tokens are automatically stored securely
await apiService.setTokens(tokenPair);

// Check token status
final isAuthenticated = await apiService.isAuthenticated;
final isExpired = await apiService.isTokenExpired;

// Clear all tokens securely
await apiService.clearTokens();
```

### Automatic Token Refresh

The package automatically handles token refresh when:
1. A request returns 401 Unauthorized
2. A refresh token is available
3. The `tokenRefreshCallback` is provided

The original request is automatically retried with the new token, and refreshed tokens are automatically stored securely.

## Migration from v1.x

If you're upgrading from a previous version:

1. **Remove** any custom `TokenStorage` implementations
2. **Add** `database_service` dependency to your `pubspec.yaml`
3. **Call** `await apiService.initialize()` before using the service
4. **Remove** any manual token storage setup - it's now handled automatically

```dart
// Before (v1.x)
final apiService = ApiServiceImpl(
  dio: dio,
  tokenManager: TokenManager(storage: customStorage),
);

// After (v2.x)
final apiService = ApiServiceImpl(dio: dio);
await apiService.initialize(); // New required step
```

## Platform Support

| Platform | Secure Storage | Notes |
|----------|----------------|-------|
| iOS | ✅ Keychain | Uses first_unlock accessibility |
| Android | ✅ Encrypted SharedPreferences | AES encryption enabled |
| macOS | ✅ Keychain | Uses first_unlock accessibility |
| Windows | ✅ Credential Store | Native Windows security |
| Web | ❌ | Not supported for security reasons |

## Security Considerations

- **Never log tokens**: The package automatically handles secure storage without exposing tokens in logs
- **Token rotation**: Implement proper token refresh logic to maintain security
- **Cleanup on logout**: Always call `clearTokens()` when users log out
- **Network security**: Use HTTPS endpoints only for token-related operations

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Dependencies

- `dio`: HTTP client
- `fpdart`: Functional programming utilities
- `database_service`: Secure storage wrapper
- `flutter_secure_storage`: Platform-specific secure storage (via database_service)
