// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outfit_render.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OutfitRender {

 OutfitRenderStatus get status; String get aiProfileId; String? get imageKey; String? get imageUrl; String? get error;
/// Create a copy of OutfitRender
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutfitRenderCopyWith<OutfitRender> get copyWith => _$OutfitRenderCopyWithImpl<OutfitRender>(this as OutfitRender, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutfitRender&&(identical(other.status, status) || other.status == status)&&(identical(other.aiProfileId, aiProfileId) || other.aiProfileId == aiProfileId)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,aiProfileId,imageKey,imageUrl,error);

@override
String toString() {
  return 'OutfitRender(status: $status, aiProfileId: $aiProfileId, imageKey: $imageKey, imageUrl: $imageUrl, error: $error)';
}


}

/// @nodoc
abstract mixin class $OutfitRenderCopyWith<$Res>  {
  factory $OutfitRenderCopyWith(OutfitRender value, $Res Function(OutfitRender) _then) = _$OutfitRenderCopyWithImpl;
@useResult
$Res call({
 OutfitRenderStatus status, String aiProfileId, String? imageKey, String? imageUrl, String? error
});




}
/// @nodoc
class _$OutfitRenderCopyWithImpl<$Res>
    implements $OutfitRenderCopyWith<$Res> {
  _$OutfitRenderCopyWithImpl(this._self, this._then);

  final OutfitRender _self;
  final $Res Function(OutfitRender) _then;

/// Create a copy of OutfitRender
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? aiProfileId = null,Object? imageKey = freezed,Object? imageUrl = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OutfitRenderStatus,aiProfileId: null == aiProfileId ? _self.aiProfileId : aiProfileId // ignore: cast_nullable_to_non_nullable
as String,imageKey: freezed == imageKey ? _self.imageKey : imageKey // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OutfitRender].
extension OutfitRenderPatterns on OutfitRender {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutfitRender value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutfitRender() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutfitRender value)  $default,){
final _that = this;
switch (_that) {
case _OutfitRender():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutfitRender value)?  $default,){
final _that = this;
switch (_that) {
case _OutfitRender() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OutfitRenderStatus status,  String aiProfileId,  String? imageKey,  String? imageUrl,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutfitRender() when $default != null:
return $default(_that.status,_that.aiProfileId,_that.imageKey,_that.imageUrl,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OutfitRenderStatus status,  String aiProfileId,  String? imageKey,  String? imageUrl,  String? error)  $default,) {final _that = this;
switch (_that) {
case _OutfitRender():
return $default(_that.status,_that.aiProfileId,_that.imageKey,_that.imageUrl,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OutfitRenderStatus status,  String aiProfileId,  String? imageKey,  String? imageUrl,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _OutfitRender() when $default != null:
return $default(_that.status,_that.aiProfileId,_that.imageKey,_that.imageUrl,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _OutfitRender extends OutfitRender {
  const _OutfitRender({required this.status, required this.aiProfileId, this.imageKey, this.imageUrl, this.error}): super._();
  

@override final  OutfitRenderStatus status;
@override final  String aiProfileId;
@override final  String? imageKey;
@override final  String? imageUrl;
@override final  String? error;

/// Create a copy of OutfitRender
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutfitRenderCopyWith<_OutfitRender> get copyWith => __$OutfitRenderCopyWithImpl<_OutfitRender>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutfitRender&&(identical(other.status, status) || other.status == status)&&(identical(other.aiProfileId, aiProfileId) || other.aiProfileId == aiProfileId)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,aiProfileId,imageKey,imageUrl,error);

@override
String toString() {
  return 'OutfitRender(status: $status, aiProfileId: $aiProfileId, imageKey: $imageKey, imageUrl: $imageUrl, error: $error)';
}


}

/// @nodoc
abstract mixin class _$OutfitRenderCopyWith<$Res> implements $OutfitRenderCopyWith<$Res> {
  factory _$OutfitRenderCopyWith(_OutfitRender value, $Res Function(_OutfitRender) _then) = __$OutfitRenderCopyWithImpl;
@override @useResult
$Res call({
 OutfitRenderStatus status, String aiProfileId, String? imageKey, String? imageUrl, String? error
});




}
/// @nodoc
class __$OutfitRenderCopyWithImpl<$Res>
    implements _$OutfitRenderCopyWith<$Res> {
  __$OutfitRenderCopyWithImpl(this._self, this._then);

  final _OutfitRender _self;
  final $Res Function(_OutfitRender) _then;

/// Create a copy of OutfitRender
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? aiProfileId = null,Object? imageKey = freezed,Object? imageUrl = freezed,Object? error = freezed,}) {
  return _then(_OutfitRender(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OutfitRenderStatus,aiProfileId: null == aiProfileId ? _self.aiProfileId : aiProfileId // ignore: cast_nullable_to_non_nullable
as String,imageKey: freezed == imageKey ? _self.imageKey : imageKey // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
