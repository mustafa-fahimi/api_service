import 'package:api_service/src/api_service_option.dart';
import 'package:api_service/src/token_manager.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

abstract class ApiService {
  ///perform a http get request
  Future<Either<DioException, Response<T>>> getMethod<T>(
    String endpoint, {
    ApiServiceOption? option,
    CancelToken? cancelToken,
  });

  ///perform a http put request
  Future<Either<DioException, Response<T>>> putMethod<T>(
    String endpoint, {
    ApiServiceOption? option,
    dynamic body,
    CancelToken? cancelToken,
  });

  ///perform a http delete request
  Future<Either<DioException, Response<T>>> deleteMethod<T>(
    String endpoint, {
    ApiServiceOption? option,
    dynamic body,
    CancelToken? cancelToken,
  });

  ///perform a http post request
  Future<Either<DioException, Response<T>>> postMethod<T>(
    String endpoint, {
    ApiServiceOption? option,
    dynamic body,
    CancelToken? cancelToken,
  });

  ///perform a http patch request
  Future<Either<DioException, Response<T>>> patchMethod<T>(
    String endpoint, {
    ApiServiceOption? option,
    dynamic body,
    CancelToken? cancelToken,
  });

  /// Set authentication tokens
  Future<void> setTokens(TokenPair tokenPair);

  /// Clear authentication tokens
  Future<void> clearTokens();

  /// Get current token pair
  Future<TokenPair?> get currentTokens;

  /// Check if user is authenticated
  Future<bool> get isAuthenticated;

  /// Check if current token is expired
  Future<bool> get isTokenExpired;
}
