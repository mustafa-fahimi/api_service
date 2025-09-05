import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_service_response_type.freezed.dart';

@freezed
sealed class ApiServiceResponseType with _$ApiServiceResponseType {
  const ApiServiceResponseType._();
  
  const factory ApiServiceResponseType.json() = _Json;

  const factory ApiServiceResponseType.stream() = _Stream;

  const factory ApiServiceResponseType.plain() = _Plain;

  const factory ApiServiceResponseType.bytes() = _Bytes;
}

extension ApiServiceResponseTypeEx on ApiServiceResponseType {
  ResponseType get toDio => switch (this) {
    _Json() => ResponseType.json,
    _Stream() => ResponseType.stream,
    _Plain() => ResponseType.plain,
    _Bytes() => ResponseType.bytes,
  };
}
