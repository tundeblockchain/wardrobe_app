// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_profile_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiProfileResponse {

 String get aiProfileId; String get type; String? get label; List<String>? get referenceImages; String? get status; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of AiProfileResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiProfileResponseCopyWith<AiProfileResponse> get copyWith => _$AiProfileResponseCopyWithImpl<AiProfileResponse>(this as AiProfileResponse, _$identity);

  /// Serializes this AiProfileResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiProfileResponse&&(identical(other.aiProfileId, aiProfileId) || other.aiProfileId == aiProfileId)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.referenceImages, referenceImages)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aiProfileId,type,label,const DeepCollectionEquality().hash(referenceImages),status,createdAt,updatedAt);

@override
String toString() {
  return 'AiProfileResponse(aiProfileId: $aiProfileId, type: $type, label: $label, referenceImages: $referenceImages, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AiProfileResponseCopyWith<$Res>  {
  factory $AiProfileResponseCopyWith(AiProfileResponse value, $Res Function(AiProfileResponse) _then) = _$AiProfileResponseCopyWithImpl;
@useResult
$Res call({
 String aiProfileId, String type, String? label, List<String>? referenceImages, String? status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$AiProfileResponseCopyWithImpl<$Res>
    implements $AiProfileResponseCopyWith<$Res> {
  _$AiProfileResponseCopyWithImpl(this._self, this._then);

  final AiProfileResponse _self;
  final $Res Function(AiProfileResponse) _then;

/// Create a copy of AiProfileResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aiProfileId = null,Object? type = null,Object? label = freezed,Object? referenceImages = freezed,Object? status = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
aiProfileId: null == aiProfileId ? _self.aiProfileId : aiProfileId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,referenceImages: freezed == referenceImages ? _self.referenceImages : referenceImages // ignore: cast_nullable_to_non_nullable
as List<String>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AiProfileResponse].
extension AiProfileResponsePatterns on AiProfileResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiProfileResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiProfileResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiProfileResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiProfileResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiProfileResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiProfileResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String aiProfileId,  String type,  String? label,  List<String>? referenceImages,  String? status,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiProfileResponse() when $default != null:
return $default(_that.aiProfileId,_that.type,_that.label,_that.referenceImages,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String aiProfileId,  String type,  String? label,  List<String>? referenceImages,  String? status,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AiProfileResponse():
return $default(_that.aiProfileId,_that.type,_that.label,_that.referenceImages,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String aiProfileId,  String type,  String? label,  List<String>? referenceImages,  String? status,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AiProfileResponse() when $default != null:
return $default(_that.aiProfileId,_that.type,_that.label,_that.referenceImages,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiProfileResponse extends AiProfileResponse {
  const _AiProfileResponse({required this.aiProfileId, required this.type, this.label, this.referenceImages, this.status, required this.createdAt, required this.updatedAt}): super._();
  factory _AiProfileResponse.fromJson(Map<String, dynamic> json) => _$AiProfileResponseFromJson(json);

@override final  String aiProfileId;
@override final  String type;
@override final  String? label;
@override final  List<String>? referenceImages;
@override final  String? status;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of AiProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiProfileResponseCopyWith<_AiProfileResponse> get copyWith => __$AiProfileResponseCopyWithImpl<_AiProfileResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiProfileResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiProfileResponse&&(identical(other.aiProfileId, aiProfileId) || other.aiProfileId == aiProfileId)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.referenceImages, referenceImages)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aiProfileId,type,label,const DeepCollectionEquality().hash(referenceImages),status,createdAt,updatedAt);

@override
String toString() {
  return 'AiProfileResponse(aiProfileId: $aiProfileId, type: $type, label: $label, referenceImages: $referenceImages, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AiProfileResponseCopyWith<$Res> implements $AiProfileResponseCopyWith<$Res> {
  factory _$AiProfileResponseCopyWith(_AiProfileResponse value, $Res Function(_AiProfileResponse) _then) = __$AiProfileResponseCopyWithImpl;
@override @useResult
$Res call({
 String aiProfileId, String type, String? label, List<String>? referenceImages, String? status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$AiProfileResponseCopyWithImpl<$Res>
    implements _$AiProfileResponseCopyWith<$Res> {
  __$AiProfileResponseCopyWithImpl(this._self, this._then);

  final _AiProfileResponse _self;
  final $Res Function(_AiProfileResponse) _then;

/// Create a copy of AiProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aiProfileId = null,Object? type = null,Object? label = freezed,Object? referenceImages = freezed,Object? status = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AiProfileResponse(
aiProfileId: null == aiProfileId ? _self.aiProfileId : aiProfileId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,referenceImages: freezed == referenceImages ? _self.referenceImages : referenceImages // ignore: cast_nullable_to_non_nullable
as List<String>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AiProfileListResponse {

 List<AiProfileResponse> get aiProfiles;
/// Create a copy of AiProfileListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiProfileListResponseCopyWith<AiProfileListResponse> get copyWith => _$AiProfileListResponseCopyWithImpl<AiProfileListResponse>(this as AiProfileListResponse, _$identity);

  /// Serializes this AiProfileListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiProfileListResponse&&const DeepCollectionEquality().equals(other.aiProfiles, aiProfiles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(aiProfiles));

@override
String toString() {
  return 'AiProfileListResponse(aiProfiles: $aiProfiles)';
}


}

/// @nodoc
abstract mixin class $AiProfileListResponseCopyWith<$Res>  {
  factory $AiProfileListResponseCopyWith(AiProfileListResponse value, $Res Function(AiProfileListResponse) _then) = _$AiProfileListResponseCopyWithImpl;
@useResult
$Res call({
 List<AiProfileResponse> aiProfiles
});




}
/// @nodoc
class _$AiProfileListResponseCopyWithImpl<$Res>
    implements $AiProfileListResponseCopyWith<$Res> {
  _$AiProfileListResponseCopyWithImpl(this._self, this._then);

  final AiProfileListResponse _self;
  final $Res Function(AiProfileListResponse) _then;

/// Create a copy of AiProfileListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aiProfiles = null,}) {
  return _then(_self.copyWith(
aiProfiles: null == aiProfiles ? _self.aiProfiles : aiProfiles // ignore: cast_nullable_to_non_nullable
as List<AiProfileResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiProfileListResponse].
extension AiProfileListResponsePatterns on AiProfileListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiProfileListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiProfileListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiProfileListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiProfileListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiProfileListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiProfileListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AiProfileResponse> aiProfiles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiProfileListResponse() when $default != null:
return $default(_that.aiProfiles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AiProfileResponse> aiProfiles)  $default,) {final _that = this;
switch (_that) {
case _AiProfileListResponse():
return $default(_that.aiProfiles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AiProfileResponse> aiProfiles)?  $default,) {final _that = this;
switch (_that) {
case _AiProfileListResponse() when $default != null:
return $default(_that.aiProfiles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiProfileListResponse extends AiProfileListResponse {
  const _AiProfileListResponse({required this.aiProfiles}): super._();
  factory _AiProfileListResponse.fromJson(Map<String, dynamic> json) => _$AiProfileListResponseFromJson(json);

@override final  List<AiProfileResponse> aiProfiles;

/// Create a copy of AiProfileListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiProfileListResponseCopyWith<_AiProfileListResponse> get copyWith => __$AiProfileListResponseCopyWithImpl<_AiProfileListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiProfileListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiProfileListResponse&&const DeepCollectionEquality().equals(other.aiProfiles, aiProfiles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(aiProfiles));

@override
String toString() {
  return 'AiProfileListResponse(aiProfiles: $aiProfiles)';
}


}

/// @nodoc
abstract mixin class _$AiProfileListResponseCopyWith<$Res> implements $AiProfileListResponseCopyWith<$Res> {
  factory _$AiProfileListResponseCopyWith(_AiProfileListResponse value, $Res Function(_AiProfileListResponse) _then) = __$AiProfileListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<AiProfileResponse> aiProfiles
});




}
/// @nodoc
class __$AiProfileListResponseCopyWithImpl<$Res>
    implements _$AiProfileListResponseCopyWith<$Res> {
  __$AiProfileListResponseCopyWithImpl(this._self, this._then);

  final _AiProfileListResponse _self;
  final $Res Function(_AiProfileListResponse) _then;

/// Create a copy of AiProfileListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aiProfiles = null,}) {
  return _then(_AiProfileListResponse(
aiProfiles: null == aiProfiles ? _self.aiProfiles : aiProfiles // ignore: cast_nullable_to_non_nullable
as List<AiProfileResponse>,
  ));
}


}


/// @nodoc
mixin _$CreateAiProfileRequest {

 String get type;
/// Create a copy of CreateAiProfileRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateAiProfileRequestCopyWith<CreateAiProfileRequest> get copyWith => _$CreateAiProfileRequestCopyWithImpl<CreateAiProfileRequest>(this as CreateAiProfileRequest, _$identity);

  /// Serializes this CreateAiProfileRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateAiProfileRequest&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'CreateAiProfileRequest(type: $type)';
}


}

/// @nodoc
abstract mixin class $CreateAiProfileRequestCopyWith<$Res>  {
  factory $CreateAiProfileRequestCopyWith(CreateAiProfileRequest value, $Res Function(CreateAiProfileRequest) _then) = _$CreateAiProfileRequestCopyWithImpl;
@useResult
$Res call({
 String type
});




}
/// @nodoc
class _$CreateAiProfileRequestCopyWithImpl<$Res>
    implements $CreateAiProfileRequestCopyWith<$Res> {
  _$CreateAiProfileRequestCopyWithImpl(this._self, this._then);

  final CreateAiProfileRequest _self;
  final $Res Function(CreateAiProfileRequest) _then;

/// Create a copy of CreateAiProfileRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateAiProfileRequest].
extension CreateAiProfileRequestPatterns on CreateAiProfileRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateAiProfileRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateAiProfileRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateAiProfileRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateAiProfileRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateAiProfileRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateAiProfileRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateAiProfileRequest() when $default != null:
return $default(_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type)  $default,) {final _that = this;
switch (_that) {
case _CreateAiProfileRequest():
return $default(_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type)?  $default,) {final _that = this;
switch (_that) {
case _CreateAiProfileRequest() when $default != null:
return $default(_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateAiProfileRequest implements CreateAiProfileRequest {
  const _CreateAiProfileRequest({this.type = 'PERSONAL'});
  factory _CreateAiProfileRequest.fromJson(Map<String, dynamic> json) => _$CreateAiProfileRequestFromJson(json);

@override@JsonKey() final  String type;

/// Create a copy of CreateAiProfileRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateAiProfileRequestCopyWith<_CreateAiProfileRequest> get copyWith => __$CreateAiProfileRequestCopyWithImpl<_CreateAiProfileRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateAiProfileRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAiProfileRequest&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'CreateAiProfileRequest(type: $type)';
}


}

/// @nodoc
abstract mixin class _$CreateAiProfileRequestCopyWith<$Res> implements $CreateAiProfileRequestCopyWith<$Res> {
  factory _$CreateAiProfileRequestCopyWith(_CreateAiProfileRequest value, $Res Function(_CreateAiProfileRequest) _then) = __$CreateAiProfileRequestCopyWithImpl;
@override @useResult
$Res call({
 String type
});




}
/// @nodoc
class __$CreateAiProfileRequestCopyWithImpl<$Res>
    implements _$CreateAiProfileRequestCopyWith<$Res> {
  __$CreateAiProfileRequestCopyWithImpl(this._self, this._then);

  final _CreateAiProfileRequest _self;
  final $Res Function(_CreateAiProfileRequest) _then;

/// Create a copy of CreateAiProfileRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(_CreateAiProfileRequest(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CreateAiProfileUploadRequest {

 String get contentType; String get purpose;@JsonKey(includeIfNull: false) int? get contentLength;
/// Create a copy of CreateAiProfileUploadRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateAiProfileUploadRequestCopyWith<CreateAiProfileUploadRequest> get copyWith => _$CreateAiProfileUploadRequestCopyWithImpl<CreateAiProfileUploadRequest>(this as CreateAiProfileUploadRequest, _$identity);

  /// Serializes this CreateAiProfileUploadRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateAiProfileUploadRequest&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.contentLength, contentLength) || other.contentLength == contentLength));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentType,purpose,contentLength);

@override
String toString() {
  return 'CreateAiProfileUploadRequest(contentType: $contentType, purpose: $purpose, contentLength: $contentLength)';
}


}

/// @nodoc
abstract mixin class $CreateAiProfileUploadRequestCopyWith<$Res>  {
  factory $CreateAiProfileUploadRequestCopyWith(CreateAiProfileUploadRequest value, $Res Function(CreateAiProfileUploadRequest) _then) = _$CreateAiProfileUploadRequestCopyWithImpl;
@useResult
$Res call({
 String contentType, String purpose,@JsonKey(includeIfNull: false) int? contentLength
});




}
/// @nodoc
class _$CreateAiProfileUploadRequestCopyWithImpl<$Res>
    implements $CreateAiProfileUploadRequestCopyWith<$Res> {
  _$CreateAiProfileUploadRequestCopyWithImpl(this._self, this._then);

  final CreateAiProfileUploadRequest _self;
  final $Res Function(CreateAiProfileUploadRequest) _then;

/// Create a copy of CreateAiProfileUploadRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentType = null,Object? purpose = null,Object? contentLength = freezed,}) {
  return _then(_self.copyWith(
contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,contentLength: freezed == contentLength ? _self.contentLength : contentLength // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateAiProfileUploadRequest].
extension CreateAiProfileUploadRequestPatterns on CreateAiProfileUploadRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateAiProfileUploadRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateAiProfileUploadRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateAiProfileUploadRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateAiProfileUploadRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateAiProfileUploadRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateAiProfileUploadRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contentType,  String purpose, @JsonKey(includeIfNull: false)  int? contentLength)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateAiProfileUploadRequest() when $default != null:
return $default(_that.contentType,_that.purpose,_that.contentLength);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contentType,  String purpose, @JsonKey(includeIfNull: false)  int? contentLength)  $default,) {final _that = this;
switch (_that) {
case _CreateAiProfileUploadRequest():
return $default(_that.contentType,_that.purpose,_that.contentLength);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contentType,  String purpose, @JsonKey(includeIfNull: false)  int? contentLength)?  $default,) {final _that = this;
switch (_that) {
case _CreateAiProfileUploadRequest() when $default != null:
return $default(_that.contentType,_that.purpose,_that.contentLength);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateAiProfileUploadRequest implements CreateAiProfileUploadRequest {
  const _CreateAiProfileUploadRequest({required this.contentType, this.purpose = 'AI_PROFILE_REFERENCE', @JsonKey(includeIfNull: false) this.contentLength});
  factory _CreateAiProfileUploadRequest.fromJson(Map<String, dynamic> json) => _$CreateAiProfileUploadRequestFromJson(json);

@override final  String contentType;
@override@JsonKey() final  String purpose;
@override@JsonKey(includeIfNull: false) final  int? contentLength;

/// Create a copy of CreateAiProfileUploadRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateAiProfileUploadRequestCopyWith<_CreateAiProfileUploadRequest> get copyWith => __$CreateAiProfileUploadRequestCopyWithImpl<_CreateAiProfileUploadRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateAiProfileUploadRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAiProfileUploadRequest&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.contentLength, contentLength) || other.contentLength == contentLength));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentType,purpose,contentLength);

@override
String toString() {
  return 'CreateAiProfileUploadRequest(contentType: $contentType, purpose: $purpose, contentLength: $contentLength)';
}


}

/// @nodoc
abstract mixin class _$CreateAiProfileUploadRequestCopyWith<$Res> implements $CreateAiProfileUploadRequestCopyWith<$Res> {
  factory _$CreateAiProfileUploadRequestCopyWith(_CreateAiProfileUploadRequest value, $Res Function(_CreateAiProfileUploadRequest) _then) = __$CreateAiProfileUploadRequestCopyWithImpl;
@override @useResult
$Res call({
 String contentType, String purpose,@JsonKey(includeIfNull: false) int? contentLength
});




}
/// @nodoc
class __$CreateAiProfileUploadRequestCopyWithImpl<$Res>
    implements _$CreateAiProfileUploadRequestCopyWith<$Res> {
  __$CreateAiProfileUploadRequestCopyWithImpl(this._self, this._then);

  final _CreateAiProfileUploadRequest _self;
  final $Res Function(_CreateAiProfileUploadRequest) _then;

/// Create a copy of CreateAiProfileUploadRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentType = null,Object? purpose = null,Object? contentLength = freezed,}) {
  return _then(_CreateAiProfileUploadRequest(
contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,contentLength: freezed == contentLength ? _self.contentLength : contentLength // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AttachAiProfileImagesRequest {

@JsonKey(includeIfNull: false) String? get objectKey;@JsonKey(includeIfNull: false) List<String>? get objectKeys;
/// Create a copy of AttachAiProfileImagesRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachAiProfileImagesRequestCopyWith<AttachAiProfileImagesRequest> get copyWith => _$AttachAiProfileImagesRequestCopyWithImpl<AttachAiProfileImagesRequest>(this as AttachAiProfileImagesRequest, _$identity);

  /// Serializes this AttachAiProfileImagesRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachAiProfileImagesRequest&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&const DeepCollectionEquality().equals(other.objectKeys, objectKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,objectKey,const DeepCollectionEquality().hash(objectKeys));

@override
String toString() {
  return 'AttachAiProfileImagesRequest(objectKey: $objectKey, objectKeys: $objectKeys)';
}


}

/// @nodoc
abstract mixin class $AttachAiProfileImagesRequestCopyWith<$Res>  {
  factory $AttachAiProfileImagesRequestCopyWith(AttachAiProfileImagesRequest value, $Res Function(AttachAiProfileImagesRequest) _then) = _$AttachAiProfileImagesRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? objectKey,@JsonKey(includeIfNull: false) List<String>? objectKeys
});




}
/// @nodoc
class _$AttachAiProfileImagesRequestCopyWithImpl<$Res>
    implements $AttachAiProfileImagesRequestCopyWith<$Res> {
  _$AttachAiProfileImagesRequestCopyWithImpl(this._self, this._then);

  final AttachAiProfileImagesRequest _self;
  final $Res Function(AttachAiProfileImagesRequest) _then;

/// Create a copy of AttachAiProfileImagesRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? objectKey = freezed,Object? objectKeys = freezed,}) {
  return _then(_self.copyWith(
objectKey: freezed == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String?,objectKeys: freezed == objectKeys ? _self.objectKeys : objectKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachAiProfileImagesRequest].
extension AttachAiProfileImagesRequestPatterns on AttachAiProfileImagesRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachAiProfileImagesRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachAiProfileImagesRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachAiProfileImagesRequest value)  $default,){
final _that = this;
switch (_that) {
case _AttachAiProfileImagesRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachAiProfileImagesRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AttachAiProfileImagesRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? objectKey, @JsonKey(includeIfNull: false)  List<String>? objectKeys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachAiProfileImagesRequest() when $default != null:
return $default(_that.objectKey,_that.objectKeys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? objectKey, @JsonKey(includeIfNull: false)  List<String>? objectKeys)  $default,) {final _that = this;
switch (_that) {
case _AttachAiProfileImagesRequest():
return $default(_that.objectKey,_that.objectKeys);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? objectKey, @JsonKey(includeIfNull: false)  List<String>? objectKeys)?  $default,) {final _that = this;
switch (_that) {
case _AttachAiProfileImagesRequest() when $default != null:
return $default(_that.objectKey,_that.objectKeys);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttachAiProfileImagesRequest implements AttachAiProfileImagesRequest {
  const _AttachAiProfileImagesRequest({@JsonKey(includeIfNull: false) this.objectKey, @JsonKey(includeIfNull: false) this.objectKeys});
  factory _AttachAiProfileImagesRequest.fromJson(Map<String, dynamic> json) => _$AttachAiProfileImagesRequestFromJson(json);

@override@JsonKey(includeIfNull: false) final  String? objectKey;
@override@JsonKey(includeIfNull: false) final  List<String>? objectKeys;

/// Create a copy of AttachAiProfileImagesRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachAiProfileImagesRequestCopyWith<_AttachAiProfileImagesRequest> get copyWith => __$AttachAiProfileImagesRequestCopyWithImpl<_AttachAiProfileImagesRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachAiProfileImagesRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachAiProfileImagesRequest&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&const DeepCollectionEquality().equals(other.objectKeys, objectKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,objectKey,const DeepCollectionEquality().hash(objectKeys));

@override
String toString() {
  return 'AttachAiProfileImagesRequest(objectKey: $objectKey, objectKeys: $objectKeys)';
}


}

/// @nodoc
abstract mixin class _$AttachAiProfileImagesRequestCopyWith<$Res> implements $AttachAiProfileImagesRequestCopyWith<$Res> {
  factory _$AttachAiProfileImagesRequestCopyWith(_AttachAiProfileImagesRequest value, $Res Function(_AttachAiProfileImagesRequest) _then) = __$AttachAiProfileImagesRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? objectKey,@JsonKey(includeIfNull: false) List<String>? objectKeys
});




}
/// @nodoc
class __$AttachAiProfileImagesRequestCopyWithImpl<$Res>
    implements _$AttachAiProfileImagesRequestCopyWith<$Res> {
  __$AttachAiProfileImagesRequestCopyWithImpl(this._self, this._then);

  final _AttachAiProfileImagesRequest _self;
  final $Res Function(_AttachAiProfileImagesRequest) _then;

/// Create a copy of AttachAiProfileImagesRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? objectKey = freezed,Object? objectKeys = freezed,}) {
  return _then(_AttachAiProfileImagesRequest(
objectKey: freezed == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String?,objectKeys: freezed == objectKeys ? _self.objectKeys : objectKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
