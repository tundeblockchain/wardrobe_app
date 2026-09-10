// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiProfile {

 String get id; AiProfileType get type; String? get label; List<String> get referenceImages; AiProfileStatus get status; String? get previewImageUrl; AiProfileBodyContext get bodyContext; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of AiProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiProfileCopyWith<AiProfile> get copyWith => _$AiProfileCopyWithImpl<AiProfile>(this as AiProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.referenceImages, referenceImages)&&(identical(other.status, status) || other.status == status)&&(identical(other.previewImageUrl, previewImageUrl) || other.previewImageUrl == previewImageUrl)&&(identical(other.bodyContext, bodyContext) || other.bodyContext == bodyContext)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,label,const DeepCollectionEquality().hash(referenceImages),status,previewImageUrl,bodyContext,createdAt,updatedAt);

@override
String toString() {
  return 'AiProfile(id: $id, type: $type, label: $label, referenceImages: $referenceImages, status: $status, previewImageUrl: $previewImageUrl, bodyContext: $bodyContext, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AiProfileCopyWith<$Res>  {
  factory $AiProfileCopyWith(AiProfile value, $Res Function(AiProfile) _then) = _$AiProfileCopyWithImpl;
@useResult
$Res call({
 String id, AiProfileType type, String? label, List<String> referenceImages, AiProfileStatus status, String? previewImageUrl, AiProfileBodyContext bodyContext, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$AiProfileCopyWithImpl<$Res>
    implements $AiProfileCopyWith<$Res> {
  _$AiProfileCopyWithImpl(this._self, this._then);

  final AiProfile _self;
  final $Res Function(AiProfile) _then;

/// Create a copy of AiProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? label = freezed,Object? referenceImages = null,Object? status = null,Object? previewImageUrl = freezed,Object? bodyContext = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AiProfileType,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,referenceImages: null == referenceImages ? _self.referenceImages : referenceImages // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiProfileStatus,previewImageUrl: freezed == previewImageUrl ? _self.previewImageUrl : previewImageUrl // ignore: cast_nullable_to_non_nullable
as String?,bodyContext: null == bodyContext ? _self.bodyContext : bodyContext // ignore: cast_nullable_to_non_nullable
as AiProfileBodyContext,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AiProfile].
extension AiProfilePatterns on AiProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiProfile value)  $default,){
final _that = this;
switch (_that) {
case _AiProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiProfile value)?  $default,){
final _that = this;
switch (_that) {
case _AiProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AiProfileType type,  String? label,  List<String> referenceImages,  AiProfileStatus status,  String? previewImageUrl,  AiProfileBodyContext bodyContext,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiProfile() when $default != null:
return $default(_that.id,_that.type,_that.label,_that.referenceImages,_that.status,_that.previewImageUrl,_that.bodyContext,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AiProfileType type,  String? label,  List<String> referenceImages,  AiProfileStatus status,  String? previewImageUrl,  AiProfileBodyContext bodyContext,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AiProfile():
return $default(_that.id,_that.type,_that.label,_that.referenceImages,_that.status,_that.previewImageUrl,_that.bodyContext,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AiProfileType type,  String? label,  List<String> referenceImages,  AiProfileStatus status,  String? previewImageUrl,  AiProfileBodyContext bodyContext,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AiProfile() when $default != null:
return $default(_that.id,_that.type,_that.label,_that.referenceImages,_that.status,_that.previewImageUrl,_that.bodyContext,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _AiProfile extends AiProfile {
  const _AiProfile({required this.id, required this.type, this.label, this.referenceImages = const [], this.status = AiProfileStatus.ready, this.previewImageUrl, this.bodyContext = AiProfileBodyContext.empty, required this.createdAt, required this.updatedAt}): super._();
  

@override final  String id;
@override final  AiProfileType type;
@override final  String? label;
@override@JsonKey() final  List<String> referenceImages;
@override@JsonKey() final  AiProfileStatus status;
@override final  String? previewImageUrl;
@override@JsonKey() final  AiProfileBodyContext bodyContext;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of AiProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiProfileCopyWith<_AiProfile> get copyWith => __$AiProfileCopyWithImpl<_AiProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.referenceImages, referenceImages)&&(identical(other.status, status) || other.status == status)&&(identical(other.previewImageUrl, previewImageUrl) || other.previewImageUrl == previewImageUrl)&&(identical(other.bodyContext, bodyContext) || other.bodyContext == bodyContext)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,label,const DeepCollectionEquality().hash(referenceImages),status,previewImageUrl,bodyContext,createdAt,updatedAt);

@override
String toString() {
  return 'AiProfile(id: $id, type: $type, label: $label, referenceImages: $referenceImages, status: $status, previewImageUrl: $previewImageUrl, bodyContext: $bodyContext, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AiProfileCopyWith<$Res> implements $AiProfileCopyWith<$Res> {
  factory _$AiProfileCopyWith(_AiProfile value, $Res Function(_AiProfile) _then) = __$AiProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, AiProfileType type, String? label, List<String> referenceImages, AiProfileStatus status, String? previewImageUrl, AiProfileBodyContext bodyContext, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$AiProfileCopyWithImpl<$Res>
    implements _$AiProfileCopyWith<$Res> {
  __$AiProfileCopyWithImpl(this._self, this._then);

  final _AiProfile _self;
  final $Res Function(_AiProfile) _then;

/// Create a copy of AiProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? label = freezed,Object? referenceImages = null,Object? status = null,Object? previewImageUrl = freezed,Object? bodyContext = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AiProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AiProfileType,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,referenceImages: null == referenceImages ? _self.referenceImages : referenceImages // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiProfileStatus,previewImageUrl: freezed == previewImageUrl ? _self.previewImageUrl : previewImageUrl // ignore: cast_nullable_to_non_nullable
as String?,bodyContext: null == bodyContext ? _self.bodyContext : bodyContext // ignore: cast_nullable_to_non_nullable
as AiProfileBodyContext,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
