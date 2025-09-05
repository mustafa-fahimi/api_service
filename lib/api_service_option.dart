import 'package:api_service/api_service.dart';
import 'package:dio/dio.dart';

typedef OnPercentage = void Function(int currentBytes, int totalBytes);

class ApiServiceOption {
  const ApiServiceOption({
    this.query,
    this.onReceiveProgress,
    this.onSendProgress,
    this.header = const ApiServiceHeader.basic(),
    this.responseType = const ApiServiceResponseType.json(),
  });

  final ApiServiceHeader header;
  final Map<String, dynamic>? query;
  final OnPercentage? onReceiveProgress;
  final OnPercentage? onSendProgress;
  final ApiServiceResponseType responseType;
}

extension ApiServiceOptionEx on ApiServiceOption {
  Options get requestOptions => Options(
    responseType: responseType.toDio,
    headers: header.toMap,
  );
}
