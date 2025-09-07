import 'package:api_service/api_service.dart';
import 'package:api_service/token_pair.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

abstract class ApiService {
  Future<void> initialize();

  Future<Either<DioException, Response<T>>> getMethod<T>(
    String endpoint, {
    ApiServiceOption? option,
    CancelToken? cancelToken,
  });

  Future<Either<DioException, Response<T>>> putMethod<T>(
    String endpoint, {
    ApiServiceOption? option,
    dynamic body,
    CancelToken? cancelToken,
  });

  Future<Either<DioException, Response<T>>> deleteMethod<T>(
    String endpoint, {
    ApiServiceOption? option,
    dynamic body,
    CancelToken? cancelToken,
  });

  Future<Either<DioException, Response<T>>> postMethod<T>(
    String endpoint, {
    ApiServiceOption? option,
    dynamic body,
    CancelToken? cancelToken,
  });

  Future<Either<DioException, Response<T>>> patchMethod<T>(
    String endpoint, {
    ApiServiceOption? option,
    dynamic body,
    CancelToken? cancelToken,
  });

  Future<void> setTokens(TokenPair tokenPair);

  Future<void> clearTokens();

  Future<TokenPair?> get currentTokens;

  Future<bool> get isAuthenticated;

  Future<bool> get isTokenExpired;
}
