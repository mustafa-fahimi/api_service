import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_service_header.freezed.dart';

@freezed
sealed class ApiServiceHeader with _$ApiServiceHeader {
  const ApiServiceHeader._();
  
  const factory ApiServiceHeader.formData({Map<String, String>? headers}) =
      _FormData;

  const factory ApiServiceHeader.basic({Map<String, String>? headers}) = Basic;

  const factory ApiServiceHeader.data({Map<String, String>? headers}) = _Data;
}

extension ApiServiceHeaderEx on ApiServiceHeader {
  Map<String, String> get toMap {
    final headers = switch (this) {
      _FormData(headers: final h) => h,
      Basic(headers: final h) => h,
      _Data(headers: final h) => h,
    };
    
    final map = <String, String>{
      'accept': 'application/json',
      'content-type': switch (this) {
        _FormData() => 'multipart/form-data; boundary=something',
        Basic() => 'application/json; charset=utf-8',
        _Data() => 'application/json; charset=utf-8',
      },
    };
    if (headers != null && headers.isNotEmpty) map.addAll(headers);
    return map;
  }
}
