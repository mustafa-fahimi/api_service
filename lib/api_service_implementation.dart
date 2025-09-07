import 'package:api_service/api_service.dart';
import 'package:api_service/token_pair.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

enum HttpMethod { get, post, put, delete, patch }

class ApiServiceImpl implements ApiService {
  ApiServiceImpl({
    required this.dio,
    this.interceptors,
    this.tokenRefreshCallback,
    this.onTokenExpired,
  }) : _tokenManager = TokenManager.instance {
    final allInterceptors = [...?interceptors];

    if (!allInterceptors.any(
      (interceptor) => interceptor is TokenInterceptor,
    )) {
      allInterceptors.add(
        TokenInterceptor(
          tokenManager: _tokenManager,
          tokenRefreshCallback: tokenRefreshCallback,
          onTokenExpired: onTokenExpired,
        ),
      );
    }

    dio.interceptors.addAll(allInterceptors);
  }

  final List<Interceptor>? interceptors;
  final Dio dio;
  final TokenManager _tokenManager;
  final Future<Either<String, TokenPair>> Function(String refreshToken)?
  tokenRefreshCallback;
  final VoidCallback? onTokenExpired;

  @override
  Future<void> initialize() async {
    await _tokenManager.initialize();
  }

  Future<Either<DioException, Response<T>>> _performRequest<T>(
    HttpMethod method,
    String endpoint, {
    ApiServiceOption? option = const ApiServiceOption(),
    dynamic body,
    CancelToken? cancelToken,
  }) {
    final future = switch (method) {
      HttpMethod.get => dio.get<T>(
        endpoint,
        options: option!.requestOptions,
        queryParameters: option.query,
        onReceiveProgress: option.onReceiveProgress,
        cancelToken: cancelToken,
      ),
      HttpMethod.post => dio.post<T>(
        endpoint,
        options: option!.requestOptions,
        queryParameters: option.query,
        data: body,
        onSendProgress: option.onSendProgress,
        cancelToken: cancelToken,
      ),
      HttpMethod.put => dio.put<T>(
        endpoint,
        options: option!.requestOptions,
        queryParameters: option.query,
        data: body,
        onSendProgress: option.onSendProgress,
        cancelToken: cancelToken,
      ),
      HttpMethod.delete => dio.delete<T>(
        endpoint,
        options: option!.requestOptions,
        queryParameters: option.query,
        data: body,
        cancelToken: cancelToken,
      ),
      HttpMethod.patch => dio.patch<T>(
        endpoint,
        options: option!.requestOptions,
        queryParameters: option.query,
        data: body,
        onSendProgress: option.onSendProgress,
        cancelToken: cancelToken,
      ),
    };

    return future
        .then((response) => right<DioException, Response<T>>(response))
        .catchError(
          (dynamic e) => left<DioException, Response<T>>(e as DioException),
        );
  }

  @override
  Future<Either<DioException, Response<T>>> getMethod<T>(
    String endpoint, {
    ApiServiceOption? option = const ApiServiceOption(),
    CancelToken? cancelToken,
  }) => _performRequest(
    HttpMethod.get,
    endpoint,
    option: option,
    cancelToken: cancelToken,
  );

  @override
  Future<Either<DioException, Response<T>>> deleteMethod<T>(
    String endpoint, {
    ApiServiceOption? option = const ApiServiceOption(),
    dynamic body,
    CancelToken? cancelToken,
  }) => _performRequest(
    HttpMethod.delete,
    endpoint,
    option: option,
    body: body,
    cancelToken: cancelToken,
  );

  @override
  Future<Either<DioException, Response<T>>> postMethod<T>(
    String endpoint, {
    ApiServiceOption? option = const ApiServiceOption(),
    dynamic body,
    CancelToken? cancelToken,
  }) => _performRequest(
    HttpMethod.post,
    endpoint,
    option: option,
    body: body,
    cancelToken: cancelToken,
  );

  @override
  Future<Either<DioException, Response<T>>> putMethod<T>(
    String endpoint, {
    ApiServiceOption? option = const ApiServiceOption(),
    dynamic body,
    CancelToken? cancelToken,
  }) => _performRequest(
    HttpMethod.put,
    endpoint,
    option: option,
    body: body,
    cancelToken: cancelToken,
  );

  @override
  Future<Either<DioException, Response<T>>> patchMethod<T>(
    String endpoint, {
    ApiServiceOption? option = const ApiServiceOption(),
    dynamic body,
    CancelToken? cancelToken,
  }) => _performRequest(
    HttpMethod.patch,
    endpoint,
    option: option,
    body: body,
    cancelToken: cancelToken,
  );

  @override
  Future<void> setTokens(TokenPair tokenPair) =>
      _tokenManager.setTokenPair(tokenPair);

  @override
  Future<void> clearTokens() => _tokenManager.clearTokens();

  @override
  Future<TokenPair?> get currentTokens => _tokenManager.tokenPair;

  @override
  Future<bool> get isAuthenticated => _tokenManager.isAuthenticated;

  @override
  Future<bool> get isTokenExpired => _tokenManager.isTokenExpired;
}
