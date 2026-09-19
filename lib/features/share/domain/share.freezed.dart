// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Share {

 String get token; ShareResourceType get resourceType; String get wardrobeId; String? get itemId; String? get outfitId; String get sharePath; DateTime get expiresAt; DateTime get createdAt;
/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareCopyWith<Share> get copyWith => _$ShareCopyWithImpl<Share>(this as Share, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Share&&(identical(other.token, token) || other.token == token)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.outfitId, outfitId) || other.outfitId == outfitId)&&(identical(other.sharePath, sharePath) || other.sharePath == sharePath)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,token,resourceType,wardrobeId,itemId,outfitId,sharePath,expiresAt,createdAt);

@override
String toString() {
  return 'Share(token: $token, resourceType: $resourceType, wardrobeId: $wardrobeId, itemId: $itemId, outfitId: $outfitId, sharePath: $sharePath, expiresAt: $expiresAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ShareCopyWith<$Res>  {
  factory $ShareCopyWith(Share value, $Res Function(Share) _then) = _$ShareCopyWithImpl;
@useResult
$Res call({
 String token, ShareResourceType resourceType, String wardrobeId, String? itemId, String? outfitId, String sharePath, DateTime expiresAt, DateTime createdAt
});




}
/// @nodoc
class _$ShareCopyWithImpl<$Res>
    implements $ShareCopyWith<$Res> {
  _$ShareCopyWithImpl(this._self, this._then);

  final Share _self;
  final $Res Function(Share) _then;

/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? resourceType = null,Object? wardrobeId = null,Object? itemId = freezed,Object? outfitId = freezed,Object? sharePath = null,Object? expiresAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as ShareResourceType,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,outfitId: freezed == outfitId ? _self.outfitId : outfitId // ignore: cast_nullable_to_non_nullable
as String?,sharePath: null == sharePath ? _self.sharePath : sharePath // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Share].
extension SharePatterns on Share {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Share value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Share() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Share value)  $default,){
final _that = this;
switch (_that) {
case _Share():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Share value)?  $default,){
final _that = this;
switch (_that) {
case _Share() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  ShareResourceType resourceType,  String wardrobeId,  String? itemId,  String? outfitId,  String sharePath,  DateTime expiresAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Share() when $default != null:
return $default(_that.token,_that.resourceType,_that.wardrobeId,_that.itemId,_that.outfitId,_that.sharePath,_that.expiresAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  ShareResourceType resourceType,  String wardrobeId,  String? itemId,  String? outfitId,  String sharePath,  DateTime expiresAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Share():
return $default(_that.token,_that.resourceType,_that.wardrobeId,_that.itemId,_that.outfitId,_that.sharePath,_that.expiresAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  ShareResourceType resourceType,  String wardrobeId,  String? itemId,  String? outfitId,  String sharePath,  DateTime expiresAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Share() when $default != null:
return $default(_that.token,_that.resourceType,_that.wardrobeId,_that.itemId,_that.outfitId,_that.sharePath,_that.expiresAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Share implements Share {
  const _Share({required this.token, required this.resourceType, required this.wardrobeId, this.itemId, this.outfitId, required this.sharePath, required this.expiresAt, required this.createdAt});
  

@override final  String token;
@override final  ShareResourceType resourceType;
@override final  String wardrobeId;
@override final  String? itemId;
@override final  String? outfitId;
@override final  String sharePath;
@override final  DateTime expiresAt;
@override final  DateTime createdAt;

/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShareCopyWith<_Share> get copyWith => __$ShareCopyWithImpl<_Share>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Share&&(identical(other.token, token) || other.token == token)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.outfitId, outfitId) || other.outfitId == outfitId)&&(identical(other.sharePath, sharePath) || other.sharePath == sharePath)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,token,resourceType,wardrobeId,itemId,outfitId,sharePath,expiresAt,createdAt);

@override
String toString() {
  return 'Share(token: $token, resourceType: $resourceType, wardrobeId: $wardrobeId, itemId: $itemId, outfitId: $outfitId, sharePath: $sharePath, expiresAt: $expiresAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ShareCopyWith<$Res> implements $ShareCopyWith<$Res> {
  factory _$ShareCopyWith(_Share value, $Res Function(_Share) _then) = __$ShareCopyWithImpl;
@override @useResult
$Res call({
 String token, ShareResourceType resourceType, String wardrobeId, String? itemId, String? outfitId, String sharePath, DateTime expiresAt, DateTime createdAt
});




}
/// @nodoc
class __$ShareCopyWithImpl<$Res>
    implements _$ShareCopyWith<$Res> {
  __$ShareCopyWithImpl(this._self, this._then);

  final _Share _self;
  final $Res Function(_Share) _then;

/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? resourceType = null,Object? wardrobeId = null,Object? itemId = freezed,Object? outfitId = freezed,Object? sharePath = null,Object? expiresAt = null,Object? createdAt = null,}) {
  return _then(_Share(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as ShareResourceType,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,outfitId: freezed == outfitId ? _self.outfitId : outfitId // ignore: cast_nullable_to_non_nullable
as String?,sharePath: null == sharePath ? _self.sharePath : sharePath // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
