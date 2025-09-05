// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_service_header.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiServiceHeader {

 Map<String, String>? get headers;
/// Create a copy of ApiServiceHeader
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiServiceHeaderCopyWith<ApiServiceHeader> get copyWith => _$ApiServiceHeaderCopyWithImpl<ApiServiceHeader>(this as ApiServiceHeader, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiServiceHeader&&const DeepCollectionEquality().equals(other.headers, headers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(headers));

@override
String toString() {
  return 'ApiServiceHeader(headers: $headers)';
}


}

/// @nodoc
abstract mixin class $ApiServiceHeaderCopyWith<$Res>  {
  factory $ApiServiceHeaderCopyWith(ApiServiceHeader value, $Res Function(ApiServiceHeader) _then) = _$ApiServiceHeaderCopyWithImpl;
@useResult
$Res call({
 Map<String, String>? headers
});




}
/// @nodoc
class _$ApiServiceHeaderCopyWithImpl<$Res>
    implements $ApiServiceHeaderCopyWith<$Res> {
  _$ApiServiceHeaderCopyWithImpl(this._self, this._then);

  final ApiServiceHeader _self;
  final $Res Function(ApiServiceHeader) _then;

/// Create a copy of ApiServiceHeader
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? headers = freezed,}) {
  return _then(_self.copyWith(
headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiServiceHeader].
extension ApiServiceHeaderPatterns on ApiServiceHeader {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _FormData value)?  formData,TResult Function( Basic value)?  basic,TResult Function( _Data value)?  data,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormData() when formData != null:
return formData(_that);case Basic() when basic != null:
return basic(_that);case _Data() when data != null:
return data(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _FormData value)  formData,required TResult Function( Basic value)  basic,required TResult Function( _Data value)  data,}){
final _that = this;
switch (_that) {
case _FormData():
return formData(_that);case Basic():
return basic(_that);case _Data():
return data(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _FormData value)?  formData,TResult? Function( Basic value)?  basic,TResult? Function( _Data value)?  data,}){
final _that = this;
switch (_that) {
case _FormData() when formData != null:
return formData(_that);case Basic() when basic != null:
return basic(_that);case _Data() when data != null:
return data(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Map<String, String>? headers)?  formData,TResult Function( Map<String, String>? headers)?  basic,TResult Function( Map<String, String>? headers)?  data,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormData() when formData != null:
return formData(_that.headers);case Basic() when basic != null:
return basic(_that.headers);case _Data() when data != null:
return data(_that.headers);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Map<String, String>? headers)  formData,required TResult Function( Map<String, String>? headers)  basic,required TResult Function( Map<String, String>? headers)  data,}) {final _that = this;
switch (_that) {
case _FormData():
return formData(_that.headers);case Basic():
return basic(_that.headers);case _Data():
return data(_that.headers);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Map<String, String>? headers)?  formData,TResult? Function( Map<String, String>? headers)?  basic,TResult? Function( Map<String, String>? headers)?  data,}) {final _that = this;
switch (_that) {
case _FormData() when formData != null:
return formData(_that.headers);case Basic() when basic != null:
return basic(_that.headers);case _Data() when data != null:
return data(_that.headers);case _:
  return null;

}
}

}

/// @nodoc


class _FormData extends ApiServiceHeader {
  const _FormData({final  Map<String, String>? headers}): _headers = headers,super._();
  

 final  Map<String, String>? _headers;
@override Map<String, String>? get headers {
  final value = _headers;
  if (value == null) return null;
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ApiServiceHeader
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormDataCopyWith<_FormData> get copyWith => __$FormDataCopyWithImpl<_FormData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormData&&const DeepCollectionEquality().equals(other._headers, _headers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_headers));

@override
String toString() {
  return 'ApiServiceHeader.formData(headers: $headers)';
}


}

/// @nodoc
abstract mixin class _$FormDataCopyWith<$Res> implements $ApiServiceHeaderCopyWith<$Res> {
  factory _$FormDataCopyWith(_FormData value, $Res Function(_FormData) _then) = __$FormDataCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String>? headers
});




}
/// @nodoc
class __$FormDataCopyWithImpl<$Res>
    implements _$FormDataCopyWith<$Res> {
  __$FormDataCopyWithImpl(this._self, this._then);

  final _FormData _self;
  final $Res Function(_FormData) _then;

/// Create a copy of ApiServiceHeader
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? headers = freezed,}) {
  return _then(_FormData(
headers: freezed == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}

/// @nodoc


class Basic extends ApiServiceHeader {
  const Basic({final  Map<String, String>? headers}): _headers = headers,super._();
  

 final  Map<String, String>? _headers;
@override Map<String, String>? get headers {
  final value = _headers;
  if (value == null) return null;
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ApiServiceHeader
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BasicCopyWith<Basic> get copyWith => _$BasicCopyWithImpl<Basic>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Basic&&const DeepCollectionEquality().equals(other._headers, _headers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_headers));

@override
String toString() {
  return 'ApiServiceHeader.basic(headers: $headers)';
}


}

/// @nodoc
abstract mixin class $BasicCopyWith<$Res> implements $ApiServiceHeaderCopyWith<$Res> {
  factory $BasicCopyWith(Basic value, $Res Function(Basic) _then) = _$BasicCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String>? headers
});




}
/// @nodoc
class _$BasicCopyWithImpl<$Res>
    implements $BasicCopyWith<$Res> {
  _$BasicCopyWithImpl(this._self, this._then);

  final Basic _self;
  final $Res Function(Basic) _then;

/// Create a copy of ApiServiceHeader
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? headers = freezed,}) {
  return _then(Basic(
headers: freezed == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}

/// @nodoc


class _Data extends ApiServiceHeader {
  const _Data({final  Map<String, String>? headers}): _headers = headers,super._();
  

 final  Map<String, String>? _headers;
@override Map<String, String>? get headers {
  final value = _headers;
  if (value == null) return null;
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ApiServiceHeader
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataCopyWith<_Data> get copyWith => __$DataCopyWithImpl<_Data>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Data&&const DeepCollectionEquality().equals(other._headers, _headers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_headers));

@override
String toString() {
  return 'ApiServiceHeader.data(headers: $headers)';
}


}

/// @nodoc
abstract mixin class _$DataCopyWith<$Res> implements $ApiServiceHeaderCopyWith<$Res> {
  factory _$DataCopyWith(_Data value, $Res Function(_Data) _then) = __$DataCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String>? headers
});




}
/// @nodoc
class __$DataCopyWithImpl<$Res>
    implements _$DataCopyWith<$Res> {
  __$DataCopyWithImpl(this._self, this._then);

  final _Data _self;
  final $Res Function(_Data) _then;

/// Create a copy of ApiServiceHeader
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? headers = freezed,}) {
  return _then(_Data(
headers: freezed == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}

// dart format on
