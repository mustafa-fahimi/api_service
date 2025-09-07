import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import 'token_manager.dart';

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
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await tokenManager.accessToken;
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && tokenRefreshCallback != null) {
      final refreshToken = await tokenManager.refreshToken;

      if (refreshToken != null) {
        try {
          final refreshResult = await tokenRefreshCallback!(refreshToken);

          await refreshResult.fold(
            (error) async {
              await tokenManager.clearTokens();
              onTokenExpired?.call();
              handler.next(err);
            },
            (newTokenPair) async {
              await tokenManager.setTokenPair(newTokenPair);

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
          await tokenManager.clearTokens();
          onTokenExpired?.call();
          handler.next(err);
        }
      } else {
        await tokenManager.clearTokens();
        onTokenExpired?.call();
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
