import 'package:api_service/api_service.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ApiServiceImpl implements ApiService {
  ApiServiceImpl({required this.dio, this.interceptors}) {
    dio.interceptors.addAll(interceptors ?? []);
  }

  final List<Interceptor>? interceptors;
  final Dio dio;

  @override
  Future<Either<DioException, Response<T>>> getMethod<T>(
    String endpoint, {
    ApiServiceOption? option = const ApiServiceOption(),
    CancelToken? cancelToken,
  }) async =>
      dio
          .get<T>(
            endpoint,
            options: option!.requestOptions,
            queryParameters: option.query,
            onReceiveProgress: option.onReceiveProgress,
            cancelToken: cancelToken,
          )
          .then((response) => right<DioException, Response<T>>(response))
          .catchError(
            (dynamic e) => left<DioException, Response<T>>(e as DioException),
          );

  @override
  Future<Either<DioException, Response<T>>> deleteMethod<T>(
    String endpoint, {
    ApiServiceOption? option = const ApiServiceOption(),
    dynamic body,
    CancelToken? cancelToken,
  }) async =>
      dio
          .delete<T>(
            endpoint,
            options: option!.requestOptions,
            queryParameters: option.query,
            data: body,
            cancelToken: cancelToken,
          )
          .then((response) => right<DioException, Response<T>>(response))
          .catchError(
            (dynamic e) => left<DioException, Response<T>>(e as DioException),
          );

  @override
  Future<Either<DioException, Response<T>>> postMethod<T>(
    String endpoint, {
    ApiServiceOption? option = const ApiServiceOption(),
    dynamic body,
    CancelToken? cancelToken,
  }) async =>
      dio
          .post<T>(
            endpoint,
            options: option!.requestOptions,
            queryParameters: option.query,
            data: body,
            onSendProgress: option.onSendProgress,
            cancelToken: cancelToken,
          )
          .then((response) => right<DioException, Response<T>>(response))
          .catchError(
            (dynamic e) => left<DioException, Response<T>>(e as DioException),
          );

  @override
  Future<Either<DioException, Response<T>>> putMethod<T>(
    String endpoint, {
    ApiServiceOption? option = const ApiServiceOption(),
    dynamic body,
    CancelToken? cancelToken,
  }) async =>
      dio
          .put<T>(
            endpoint,
            options: option!.requestOptions,
            queryParameters: option.query,
            data: body,
            cancelToken: cancelToken,
          )
          .then((response) => right<DioException, Response<T>>(response))
          .catchError(
            (dynamic e) => left<DioException, Response<T>>(e as DioException),
          );

  @override
  Future<Either<DioException, Response<T>>> patchMethod<T>(
    String endpoint, {
    ApiServiceOption? option = const ApiServiceOption(),
    dynamic body,
    CancelToken? cancelToken,
  }) async =>
      dio
          .patch<T>(
            endpoint,
            options: option!.requestOptions,
            queryParameters: option.query,
            data: body,
            cancelToken: cancelToken,
          )
          .then((response) => right<DioException, Response<T>>(response))
          .catchError(
            (dynamic e) => left<DioException, Response<T>>(e as DioException),
          );
}
