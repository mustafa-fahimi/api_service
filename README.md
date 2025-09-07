# API Service Wrapper

A Flutter package that provides a clean wrapper around Dio with secure token management and functional error handling.

## Features

- 🔐 **Secure Token Management** - Automatic token refresh and secure storage
- 🛡️ **Functional Error Handling** - Uses `Either` monad for type-safe error handling
- 📡 **HTTP Methods Support** - GET, POST, PUT, DELETE, PATCH
- ⚙️ **Flexible Configuration** - Custom headers, query parameters, and request options

## Installation

```yaml
dependencies:
  api_service_wrapper: 1.0.0
```

## Quick Start

```dart
import 'package:api_service_wrapper/api_service_wrapper.dart';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
  final apiService = ASWImplementation(dio: dio);

  await apiService.initialize();

  // Make requests
  final result = await apiService.getMethod('/users');
  result.fold(
    (error) => print('Error: $error'),
    (response) => print('Success: ${response.data}'),
  );
}
```

## Authentication

```dart
final apiService = ASWImplementation(
  dio: dio,
  tokenRefreshCallback: _refreshToken,
  onTokenExpired: _handleTokenExpired,
);

await apiService.initialize();

// Set tokens
final tokenPair = ASWTokenPair(
  accessToken: 'your_access_token',
  refreshToken: 'your_refresh_token',
  expiresAt: DateTime.now().add(Duration(hours: 1)),
);
await apiService.setTokens(tokenPair);

// Check status
final isAuth = await apiService.isAuthenticated;
final isExpired = await apiService.isTokenExpired;
```

## HTTP Methods

```dart
// All methods return Either<DioException, Response<T>>

// GET
final getResult = await apiService.getMethod('/users');

// POST
final postResult = await apiService.postMethod('/users', body: {'name': 'John'});

// PUT
final putResult = await apiService.putMethod('/users/1', body: {'name': 'Jane'});

// DELETE
final deleteResult = await apiService.deleteMethod('/users/1');

// PATCH
final patchResult = await apiService.patchMethod('/users/1', body: {'age': 30});
```

## Request Configuration

```dart
final result = await apiService.getMethod(
  '/users',
  option: ASWOption(
    query: {'page': '1', 'limit': '10'},
    header: ASWHeader.basic(),
  ),
  cancelToken: CancelToken(),
);
```

## Dependencies

- `dio`: HTTP client
- `fpdart`: Functional programming utilities
- `database_service_wrapper`: Secure storage wrapper
- `flutter_secure_storage`: Platform-specific secure storage
