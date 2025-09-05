import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import 'token_manager.dart';

/// Interceptor that automatically adds authentication tokens to requests
class TokenInterceptor extends Interceptor {
  TokenInterceptor({
    required this.tokenManager,
    this.tokenRefreshCallback,
    this.onTokenExpired,
  });

  final TokenManager tokenManager;
  final Future<Either<String, TokenPair>> Function(String refreshToken)?
      tokenRefreshCallback;
  final VoidCallback? onTokenExpired;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add access token to request headers if available
    final accessToken = await tokenManager.accessToken;
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is due to token expiration (401 Unauthorized)
    if (err.response?.statusCode == 401 && tokenRefreshCallback != null) {
      final refreshToken = await tokenManager.refreshToken;

      if (refreshToken != null) {
        try {
          // Attempt to refresh the token
          final refreshResult = await tokenRefreshCallback!(refreshToken);

          await refreshResult.fold(
            (error) async {
              // Token refresh failed, clear tokens and call expired callback
              await tokenManager.clearTokens();
              onTokenExpired?.call();
              // Pass the original error
              handler.next(err);
            },
            (newTokenPair) async {
              // Token refresh succeeded, update tokens and retry the request
              await tokenManager.setTokenPair(newTokenPair);

              // Retry the original request with new token
              final retryOptions = err.requestOptions;
              retryOptions.headers['Authorization'] =
                  'Bearer ${newTokenPair.accessToken}';

              try {
                final retryResponse = await Dio().fetch(retryOptions);
                handler.resolve(retryResponse);
              } catch (retryError) {
                handler.next(err);
              }
            },
          );
        } catch (refreshError) {
          // Handle refresh error
          await tokenManager.clearTokens();
          onTokenExpired?.call();
          handler.next(err);
        }
      } else {
        // No refresh token available
        await tokenManager.clearTokens();
        onTokenExpired?.call();
        handler.next(err);
      }
    } else {
      // Not a token-related error, pass it through
      handler.next(err);
    }
  }
}
