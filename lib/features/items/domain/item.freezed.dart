// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Item {

 String get id; String get wardrobeId; String get name; ItemCategory get category; String? get subcategory; List<String> get colours; String? get brand; String? get originalImageKey; String? get processedImageKey; ItemProcessingStatus get processingStatus; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.id, id) || other.id == id)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&const DeepCollectionEquality().equals(other.colours, colours)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.originalImageKey, originalImageKey) || other.originalImageKey == originalImageKey)&&(identical(other.processedImageKey, processedImageKey) || other.processedImageKey == processedImageKey)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,wardrobeId,name,category,subcategory,const DeepCollectionEquality().hash(colours),brand,originalImageKey,processedImageKey,processingStatus,createdAt,updatedAt);

@override
String toString() {
  return 'Item(id: $id, wardrobeId: $wardrobeId, name: $name, category: $category, subcategory: $subcategory, colours: $colours, brand: $brand, originalImageKey: $originalImageKey, processedImageKey: $processedImageKey, processingStatus: $processingStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 String id, String wardrobeId, String name, ItemCategory category, String? subcategory, List<String> colours, String? brand, String? originalImageKey, String? processedImageKey, ItemProcessingStatus processingStatus, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ItemCopyWithImpl<$Res>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._self, this._then);

  final Item _self;
  final $Res Function(Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? wardrobeId = null,Object? name = null,Object? category = null,Object? subcategory = freezed,Object? colours = null,Object? brand = freezed,Object? originalImageKey = freezed,Object? processedImageKey = freezed,Object? processingStatus = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ItemCategory,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as String?,colours: null == colours ? _self.colours : colours // ignore: cast_nullable_to_non_nullable
as List<String>,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,originalImageKey: freezed == originalImageKey ? _self.originalImageKey : originalImageKey // ignore: cast_nullable_to_non_nullable
as String?,processedImageKey: freezed == processedImageKey ? _self.processedImageKey : processedImageKey // ignore: cast_nullable_to_non_nullable
as String?,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ItemProcessingStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Item].
extension ItemPatterns on Item {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Item value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Item value)  $default,){
final _that = this;
switch (_that) {
case _Item():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Item value)?  $default,){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String wardrobeId,  String name,  ItemCategory category,  String? subcategory,  List<String> colours,  String? brand,  String? originalImageKey,  String? processedImageKey,  ItemProcessingStatus processingStatus,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.id,_that.wardrobeId,_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.originalImageKey,_that.processedImageKey,_that.processingStatus,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String wardrobeId,  String name,  ItemCategory category,  String? subcategory,  List<String> colours,  String? brand,  String? originalImageKey,  String? processedImageKey,  ItemProcessingStatus processingStatus,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Item():
return $default(_that.id,_that.wardrobeId,_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.originalImageKey,_that.processedImageKey,_that.processingStatus,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String wardrobeId,  String name,  ItemCategory category,  String? subcategory,  List<String> colours,  String? brand,  String? originalImageKey,  String? processedImageKey,  ItemProcessingStatus processingStatus,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.id,_that.wardrobeId,_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.originalImageKey,_that.processedImageKey,_that.processingStatus,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Item implements Item {
  const _Item({required this.id, required this.wardrobeId, required this.name, required this.category, this.subcategory, this.colours = const [], this.brand, this.originalImageKey, this.processedImageKey, this.processingStatus = ItemProcessingStatus.ready, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String wardrobeId;
@override final  String name;
@override final  ItemCategory category;
@override final  String? subcategory;
@override@JsonKey() final  List<String> colours;
@override final  String? brand;
@override final  String? originalImageKey;
@override final  String? processedImageKey;
@override@JsonKey() final  ItemProcessingStatus processingStatus;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCopyWith<_Item> get copyWith => __$ItemCopyWithImpl<_Item>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.id, id) || other.id == id)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&const DeepCollectionEquality().equals(other.colours, colours)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.originalImageKey, originalImageKey) || other.originalImageKey == originalImageKey)&&(identical(other.processedImageKey, processedImageKey) || other.processedImageKey == processedImageKey)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,wardrobeId,name,category,subcategory,const DeepCollectionEquality().hash(colours),brand,originalImageKey,processedImageKey,processingStatus,createdAt,updatedAt);

@override
String toString() {
  return 'Item(id: $id, wardrobeId: $wardrobeId, name: $name, category: $category, subcategory: $subcategory, colours: $colours, brand: $brand, originalImageKey: $originalImageKey, processedImageKey: $processedImageKey, processingStatus: $processingStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String wardrobeId, String name, ItemCategory category, String? subcategory, List<String> colours, String? brand, String? originalImageKey, String? processedImageKey, ItemProcessingStatus processingStatus, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(this._self, this._then);

  final _Item _self;
  final $Res Function(_Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? wardrobeId = null,Object? name = null,Object? category = null,Object? subcategory = freezed,Object? colours = null,Object? brand = freezed,Object? originalImageKey = freezed,Object? processedImageKey = freezed,Object? processingStatus = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Item(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ItemCategory,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as String?,colours: null == colours ? _self.colours : colours // ignore: cast_nullable_to_non_nullable
as List<String>,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,originalImageKey: freezed == originalImageKey ? _self.originalImageKey : originalImageKey // ignore: cast_nullable_to_non_nullable
as String?,processedImageKey: freezed == processedImageKey ? _self.processedImageKey : processedImageKey // ignore: cast_nullable_to_non_nullable
as String?,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ItemProcessingStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
