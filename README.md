# Flutter API Service

A robust Flutter API service package built on top of the Dio HTTP client, featuring comprehensive token management and clean error handling using functional programming principles.

## Features

- ✅ **Functional Error Handling**: Uses fpdart's `Either` monad for type-safe error handling
- ✅ **Token Management**: Automatic token handling with refresh capability
- ✅ **Type Safety**: Leverages Freezed for type-safe unions and data models
- ✅ **Clean Architecture**: Well-structured abstraction over Dio's complexity
- ✅ **HTTP Methods Support**: GET, POST, PUT, DELETE, PATCH
- ✅ **Flexible Configuration**: Custom headers, query parameters, and progress callbacks
- ✅ **Automatic Token Injection**: Bearer tokens automatically added to requests
- ✅ **Token Refresh**: Automatic token refresh on 401 responses

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  api_service: ^2.0.0
```

### Optional: For Token Persistence

If you want to persist tokens using shared_preferences:

```yaml
dependencies:
  shared_preferences: ^2.2.2
```

## Basic Usage

### Without Authentication

If your API doesn't require authentication, simply omit token-related parameters:

```dart
import 'package:api_service/api_service.dart';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.example.com',
  ));

  // No token management - just basic API calls
  final apiService = ApiServiceImpl(dio: dio);

  // Make a GET request
  final result = await apiService.getMethod('/users');

  result.fold(
    (error) => print('Error: $error'),
    (response) => print('Success: ${response.data}'),
  );
}
```

### With Authentication

For APIs that require authentication, provide token management parameters:

## Token Management

### Setting Up Token Management

```dart
final apiService = ApiServiceImpl(
  dio: dio,
  tokenRefreshCallback: _refreshToken,
  onTokenExpired: _handleTokenExpired,
);

// Set initial tokens
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

## Advanced Features

### Custom Token Storage

```dart
class CustomTokenStorage implements TokenStorage {
  @override
  Future<String?> getString(String key) async {
    // Your custom storage logic
  }

  @override
  Future<void> setString(String key, String value) async {
    // Your custom storage logic
  }

  @override
  Future<void> remove(String key) async {
    // Your custom storage logic
  }
}

final customStorage = CustomTokenStorage();
final tokenManager = TokenManager(storage: customStorage);
```

### Automatic Token Refresh

The package automatically handles token refresh when:
1. A request returns 401 Unauthorized
2. A refresh token is available
3. The `tokenRefreshCallback` is provided

The original request is automatically retried with the new token.

## Advanced Usage

### Custom Token Storage

For advanced users who need custom token storage (e.g., encrypted storage, custom persistence logic):

```dart
import 'package:api_service/api_service.dart'; // Includes TokenManager and TokenStorage

class CustomTokenStorage implements TokenStorage {
  @override
  Future<String?> getString(String key) async {
    // Your custom storage logic
  }

  @override
  Future<void> setString(String key, String value) async {
    // Your custom storage logic
  }

  @override
  Future<void> remove(String key) async {
    // Your custom storage logic
  }
}

final customStorage = CustomTokenStorage();
final tokenManager = TokenManager(storage: customStorage);
```

### Custom Interceptors

If you need to build custom interceptors or modify the token handling behavior:

```dart
import 'package:api_service/api_service.dart'; // Includes TokenInterceptor

// You can extend or modify TokenInterceptor for custom behavior
class CustomTokenInterceptor extends TokenInterceptor {
  // Custom implementation
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
