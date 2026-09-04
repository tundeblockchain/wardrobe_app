// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateUploadRequest {

 String get contentType; String get purpose;
/// Create a copy of CreateUploadRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateUploadRequestCopyWith<CreateUploadRequest> get copyWith => _$CreateUploadRequestCopyWithImpl<CreateUploadRequest>(this as CreateUploadRequest, _$identity);

  /// Serializes this CreateUploadRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateUploadRequest&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.purpose, purpose) || other.purpose == purpose));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentType,purpose);

@override
String toString() {
  return 'CreateUploadRequest(contentType: $contentType, purpose: $purpose)';
}


}

/// @nodoc
abstract mixin class $CreateUploadRequestCopyWith<$Res>  {
  factory $CreateUploadRequestCopyWith(CreateUploadRequest value, $Res Function(CreateUploadRequest) _then) = _$CreateUploadRequestCopyWithImpl;
@useResult
$Res call({
 String contentType, String purpose
});




}
/// @nodoc
class _$CreateUploadRequestCopyWithImpl<$Res>
    implements $CreateUploadRequestCopyWith<$Res> {
  _$CreateUploadRequestCopyWithImpl(this._self, this._then);

  final CreateUploadRequest _self;
  final $Res Function(CreateUploadRequest) _then;

/// Create a copy of CreateUploadRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentType = null,Object? purpose = null,}) {
  return _then(_self.copyWith(
contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateUploadRequest].
extension CreateUploadRequestPatterns on CreateUploadRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateUploadRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateUploadRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateUploadRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateUploadRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateUploadRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateUploadRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contentType,  String purpose)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateUploadRequest() when $default != null:
return $default(_that.contentType,_that.purpose);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contentType,  String purpose)  $default,) {final _that = this;
switch (_that) {
case _CreateUploadRequest():
return $default(_that.contentType,_that.purpose);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contentType,  String purpose)?  $default,) {final _that = this;
switch (_that) {
case _CreateUploadRequest() when $default != null:
return $default(_that.contentType,_that.purpose);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateUploadRequest implements CreateUploadRequest {
  const _CreateUploadRequest({required this.contentType, this.purpose = 'WARDROBE_ITEM'});
  factory _CreateUploadRequest.fromJson(Map<String, dynamic> json) => _$CreateUploadRequestFromJson(json);

@override final  String contentType;
@override@JsonKey() final  String purpose;

/// Create a copy of CreateUploadRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateUploadRequestCopyWith<_CreateUploadRequest> get copyWith => __$CreateUploadRequestCopyWithImpl<_CreateUploadRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateUploadRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateUploadRequest&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.purpose, purpose) || other.purpose == purpose));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentType,purpose);

@override
String toString() {
  return 'CreateUploadRequest(contentType: $contentType, purpose: $purpose)';
}


}

/// @nodoc
abstract mixin class _$CreateUploadRequestCopyWith<$Res> implements $CreateUploadRequestCopyWith<$Res> {
  factory _$CreateUploadRequestCopyWith(_CreateUploadRequest value, $Res Function(_CreateUploadRequest) _then) = __$CreateUploadRequestCopyWithImpl;
@override @useResult
$Res call({
 String contentType, String purpose
});




}
/// @nodoc
class __$CreateUploadRequestCopyWithImpl<$Res>
    implements _$CreateUploadRequestCopyWith<$Res> {
  __$CreateUploadRequestCopyWithImpl(this._self, this._then);

  final _CreateUploadRequest _self;
  final $Res Function(_CreateUploadRequest) _then;

/// Create a copy of CreateUploadRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentType = null,Object? purpose = null,}) {
  return _then(_CreateUploadRequest(
contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UploadTicketResponse {

 String get uploadUrl; String get objectKey; int get expiresIn;
/// Create a copy of UploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadTicketResponseCopyWith<UploadTicketResponse> get copyWith => _$UploadTicketResponseCopyWithImpl<UploadTicketResponse>(this as UploadTicketResponse, _$identity);

  /// Serializes this UploadTicketResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadTicketResponse&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uploadUrl,objectKey,expiresIn);

@override
String toString() {
  return 'UploadTicketResponse(uploadUrl: $uploadUrl, objectKey: $objectKey, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class $UploadTicketResponseCopyWith<$Res>  {
  factory $UploadTicketResponseCopyWith(UploadTicketResponse value, $Res Function(UploadTicketResponse) _then) = _$UploadTicketResponseCopyWithImpl;
@useResult
$Res call({
 String uploadUrl, String objectKey, int expiresIn
});




}
/// @nodoc
class _$UploadTicketResponseCopyWithImpl<$Res>
    implements $UploadTicketResponseCopyWith<$Res> {
  _$UploadTicketResponseCopyWithImpl(this._self, this._then);

  final UploadTicketResponse _self;
  final $Res Function(UploadTicketResponse) _then;

/// Create a copy of UploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uploadUrl = null,Object? objectKey = null,Object? expiresIn = null,}) {
  return _then(_self.copyWith(
uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,objectKey: null == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadTicketResponse].
extension UploadTicketResponsePatterns on UploadTicketResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadTicketResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadTicketResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadTicketResponse value)  $default,){
final _that = this;
switch (_that) {
case _UploadTicketResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadTicketResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UploadTicketResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uploadUrl,  String objectKey,  int expiresIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadTicketResponse() when $default != null:
return $default(_that.uploadUrl,_that.objectKey,_that.expiresIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uploadUrl,  String objectKey,  int expiresIn)  $default,) {final _that = this;
switch (_that) {
case _UploadTicketResponse():
return $default(_that.uploadUrl,_that.objectKey,_that.expiresIn);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uploadUrl,  String objectKey,  int expiresIn)?  $default,) {final _that = this;
switch (_that) {
case _UploadTicketResponse() when $default != null:
return $default(_that.uploadUrl,_that.objectKey,_that.expiresIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UploadTicketResponse extends UploadTicketResponse {
  const _UploadTicketResponse({required this.uploadUrl, required this.objectKey, required this.expiresIn}): super._();
  factory _UploadTicketResponse.fromJson(Map<String, dynamic> json) => _$UploadTicketResponseFromJson(json);

@override final  String uploadUrl;
@override final  String objectKey;
@override final  int expiresIn;

/// Create a copy of UploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadTicketResponseCopyWith<_UploadTicketResponse> get copyWith => __$UploadTicketResponseCopyWithImpl<_UploadTicketResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadTicketResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadTicketResponse&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uploadUrl,objectKey,expiresIn);

@override
String toString() {
  return 'UploadTicketResponse(uploadUrl: $uploadUrl, objectKey: $objectKey, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class _$UploadTicketResponseCopyWith<$Res> implements $UploadTicketResponseCopyWith<$Res> {
  factory _$UploadTicketResponseCopyWith(_UploadTicketResponse value, $Res Function(_UploadTicketResponse) _then) = __$UploadTicketResponseCopyWithImpl;
@override @useResult
$Res call({
 String uploadUrl, String objectKey, int expiresIn
});




}
/// @nodoc
class __$UploadTicketResponseCopyWithImpl<$Res>
    implements _$UploadTicketResponseCopyWith<$Res> {
  __$UploadTicketResponseCopyWithImpl(this._self, this._then);

  final _UploadTicketResponse _self;
  final $Res Function(_UploadTicketResponse) _then;

/// Create a copy of UploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uploadUrl = null,Object? objectKey = null,Object? expiresIn = null,}) {
  return _then(_UploadTicketResponse(
uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,objectKey: null == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
