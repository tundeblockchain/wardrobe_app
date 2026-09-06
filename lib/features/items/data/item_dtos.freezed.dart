// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemImageResponse {

 String get originalKey; String? get processedKey;
/// Create a copy of ItemImageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemImageResponseCopyWith<ItemImageResponse> get copyWith => _$ItemImageResponseCopyWithImpl<ItemImageResponse>(this as ItemImageResponse, _$identity);

  /// Serializes this ItemImageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemImageResponse&&(identical(other.originalKey, originalKey) || other.originalKey == originalKey)&&(identical(other.processedKey, processedKey) || other.processedKey == processedKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,originalKey,processedKey);

@override
String toString() {
  return 'ItemImageResponse(originalKey: $originalKey, processedKey: $processedKey)';
}


}

/// @nodoc
abstract mixin class $ItemImageResponseCopyWith<$Res>  {
  factory $ItemImageResponseCopyWith(ItemImageResponse value, $Res Function(ItemImageResponse) _then) = _$ItemImageResponseCopyWithImpl;
@useResult
$Res call({
 String originalKey, String? processedKey
});




}
/// @nodoc
class _$ItemImageResponseCopyWithImpl<$Res>
    implements $ItemImageResponseCopyWith<$Res> {
  _$ItemImageResponseCopyWithImpl(this._self, this._then);

  final ItemImageResponse _self;
  final $Res Function(ItemImageResponse) _then;

/// Create a copy of ItemImageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originalKey = null,Object? processedKey = freezed,}) {
  return _then(_self.copyWith(
originalKey: null == originalKey ? _self.originalKey : originalKey // ignore: cast_nullable_to_non_nullable
as String,processedKey: freezed == processedKey ? _self.processedKey : processedKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemImageResponse].
extension ItemImageResponsePatterns on ItemImageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemImageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemImageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemImageResponse value)  $default,){
final _that = this;
switch (_that) {
case _ItemImageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemImageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ItemImageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String originalKey,  String? processedKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemImageResponse() when $default != null:
return $default(_that.originalKey,_that.processedKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String originalKey,  String? processedKey)  $default,) {final _that = this;
switch (_that) {
case _ItemImageResponse():
return $default(_that.originalKey,_that.processedKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String originalKey,  String? processedKey)?  $default,) {final _that = this;
switch (_that) {
case _ItemImageResponse() when $default != null:
return $default(_that.originalKey,_that.processedKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemImageResponse implements ItemImageResponse {
  const _ItemImageResponse({required this.originalKey, this.processedKey});
  factory _ItemImageResponse.fromJson(Map<String, dynamic> json) => _$ItemImageResponseFromJson(json);

@override final  String originalKey;
@override final  String? processedKey;

/// Create a copy of ItemImageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemImageResponseCopyWith<_ItemImageResponse> get copyWith => __$ItemImageResponseCopyWithImpl<_ItemImageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemImageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemImageResponse&&(identical(other.originalKey, originalKey) || other.originalKey == originalKey)&&(identical(other.processedKey, processedKey) || other.processedKey == processedKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,originalKey,processedKey);

@override
String toString() {
  return 'ItemImageResponse(originalKey: $originalKey, processedKey: $processedKey)';
}


}

/// @nodoc
abstract mixin class _$ItemImageResponseCopyWith<$Res> implements $ItemImageResponseCopyWith<$Res> {
  factory _$ItemImageResponseCopyWith(_ItemImageResponse value, $Res Function(_ItemImageResponse) _then) = __$ItemImageResponseCopyWithImpl;
@override @useResult
$Res call({
 String originalKey, String? processedKey
});




}
/// @nodoc
class __$ItemImageResponseCopyWithImpl<$Res>
    implements _$ItemImageResponseCopyWith<$Res> {
  __$ItemImageResponseCopyWithImpl(this._self, this._then);

  final _ItemImageResponse _self;
  final $Res Function(_ItemImageResponse) _then;

/// Create a copy of ItemImageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originalKey = null,Object? processedKey = freezed,}) {
  return _then(_ItemImageResponse(
originalKey: null == originalKey ? _self.originalKey : originalKey // ignore: cast_nullable_to_non_nullable
as String,processedKey: freezed == processedKey ? _self.processedKey : processedKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ItemAiResponse {

 String? get detectedCategory; String? get detectedSubcategory; List<String>? get detectedColours; bool? get backgroundRemoved; String? get processedImageKey;
/// Create a copy of ItemAiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemAiResponseCopyWith<ItemAiResponse> get copyWith => _$ItemAiResponseCopyWithImpl<ItemAiResponse>(this as ItemAiResponse, _$identity);

  /// Serializes this ItemAiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemAiResponse&&(identical(other.detectedCategory, detectedCategory) || other.detectedCategory == detectedCategory)&&(identical(other.detectedSubcategory, detectedSubcategory) || other.detectedSubcategory == detectedSubcategory)&&const DeepCollectionEquality().equals(other.detectedColours, detectedColours)&&(identical(other.backgroundRemoved, backgroundRemoved) || other.backgroundRemoved == backgroundRemoved)&&(identical(other.processedImageKey, processedImageKey) || other.processedImageKey == processedImageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,detectedCategory,detectedSubcategory,const DeepCollectionEquality().hash(detectedColours),backgroundRemoved,processedImageKey);

@override
String toString() {
  return 'ItemAiResponse(detectedCategory: $detectedCategory, detectedSubcategory: $detectedSubcategory, detectedColours: $detectedColours, backgroundRemoved: $backgroundRemoved, processedImageKey: $processedImageKey)';
}


}

/// @nodoc
abstract mixin class $ItemAiResponseCopyWith<$Res>  {
  factory $ItemAiResponseCopyWith(ItemAiResponse value, $Res Function(ItemAiResponse) _then) = _$ItemAiResponseCopyWithImpl;
@useResult
$Res call({
 String? detectedCategory, String? detectedSubcategory, List<String>? detectedColours, bool? backgroundRemoved, String? processedImageKey
});




}
/// @nodoc
class _$ItemAiResponseCopyWithImpl<$Res>
    implements $ItemAiResponseCopyWith<$Res> {
  _$ItemAiResponseCopyWithImpl(this._self, this._then);

  final ItemAiResponse _self;
  final $Res Function(ItemAiResponse) _then;

/// Create a copy of ItemAiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? detectedCategory = freezed,Object? detectedSubcategory = freezed,Object? detectedColours = freezed,Object? backgroundRemoved = freezed,Object? processedImageKey = freezed,}) {
  return _then(_self.copyWith(
detectedCategory: freezed == detectedCategory ? _self.detectedCategory : detectedCategory // ignore: cast_nullable_to_non_nullable
as String?,detectedSubcategory: freezed == detectedSubcategory ? _self.detectedSubcategory : detectedSubcategory // ignore: cast_nullable_to_non_nullable
as String?,detectedColours: freezed == detectedColours ? _self.detectedColours : detectedColours // ignore: cast_nullable_to_non_nullable
as List<String>?,backgroundRemoved: freezed == backgroundRemoved ? _self.backgroundRemoved : backgroundRemoved // ignore: cast_nullable_to_non_nullable
as bool?,processedImageKey: freezed == processedImageKey ? _self.processedImageKey : processedImageKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemAiResponse].
extension ItemAiResponsePatterns on ItemAiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemAiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemAiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemAiResponse value)  $default,){
final _that = this;
switch (_that) {
case _ItemAiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemAiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ItemAiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? detectedCategory,  String? detectedSubcategory,  List<String>? detectedColours,  bool? backgroundRemoved,  String? processedImageKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemAiResponse() when $default != null:
return $default(_that.detectedCategory,_that.detectedSubcategory,_that.detectedColours,_that.backgroundRemoved,_that.processedImageKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? detectedCategory,  String? detectedSubcategory,  List<String>? detectedColours,  bool? backgroundRemoved,  String? processedImageKey)  $default,) {final _that = this;
switch (_that) {
case _ItemAiResponse():
return $default(_that.detectedCategory,_that.detectedSubcategory,_that.detectedColours,_that.backgroundRemoved,_that.processedImageKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? detectedCategory,  String? detectedSubcategory,  List<String>? detectedColours,  bool? backgroundRemoved,  String? processedImageKey)?  $default,) {final _that = this;
switch (_that) {
case _ItemAiResponse() when $default != null:
return $default(_that.detectedCategory,_that.detectedSubcategory,_that.detectedColours,_that.backgroundRemoved,_that.processedImageKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemAiResponse extends ItemAiResponse {
  const _ItemAiResponse({this.detectedCategory, this.detectedSubcategory, this.detectedColours, this.backgroundRemoved, this.processedImageKey}): super._();
  factory _ItemAiResponse.fromJson(Map<String, dynamic> json) => _$ItemAiResponseFromJson(json);

@override final  String? detectedCategory;
@override final  String? detectedSubcategory;
@override final  List<String>? detectedColours;
@override final  bool? backgroundRemoved;
@override final  String? processedImageKey;

/// Create a copy of ItemAiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemAiResponseCopyWith<_ItemAiResponse> get copyWith => __$ItemAiResponseCopyWithImpl<_ItemAiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemAiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemAiResponse&&(identical(other.detectedCategory, detectedCategory) || other.detectedCategory == detectedCategory)&&(identical(other.detectedSubcategory, detectedSubcategory) || other.detectedSubcategory == detectedSubcategory)&&const DeepCollectionEquality().equals(other.detectedColours, detectedColours)&&(identical(other.backgroundRemoved, backgroundRemoved) || other.backgroundRemoved == backgroundRemoved)&&(identical(other.processedImageKey, processedImageKey) || other.processedImageKey == processedImageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,detectedCategory,detectedSubcategory,const DeepCollectionEquality().hash(detectedColours),backgroundRemoved,processedImageKey);

@override
String toString() {
  return 'ItemAiResponse(detectedCategory: $detectedCategory, detectedSubcategory: $detectedSubcategory, detectedColours: $detectedColours, backgroundRemoved: $backgroundRemoved, processedImageKey: $processedImageKey)';
}


}

/// @nodoc
abstract mixin class _$ItemAiResponseCopyWith<$Res> implements $ItemAiResponseCopyWith<$Res> {
  factory _$ItemAiResponseCopyWith(_ItemAiResponse value, $Res Function(_ItemAiResponse) _then) = __$ItemAiResponseCopyWithImpl;
@override @useResult
$Res call({
 String? detectedCategory, String? detectedSubcategory, List<String>? detectedColours, bool? backgroundRemoved, String? processedImageKey
});




}
/// @nodoc
class __$ItemAiResponseCopyWithImpl<$Res>
    implements _$ItemAiResponseCopyWith<$Res> {
  __$ItemAiResponseCopyWithImpl(this._self, this._then);

  final _ItemAiResponse _self;
  final $Res Function(_ItemAiResponse) _then;

/// Create a copy of ItemAiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? detectedCategory = freezed,Object? detectedSubcategory = freezed,Object? detectedColours = freezed,Object? backgroundRemoved = freezed,Object? processedImageKey = freezed,}) {
  return _then(_ItemAiResponse(
detectedCategory: freezed == detectedCategory ? _self.detectedCategory : detectedCategory // ignore: cast_nullable_to_non_nullable
as String?,detectedSubcategory: freezed == detectedSubcategory ? _self.detectedSubcategory : detectedSubcategory // ignore: cast_nullable_to_non_nullable
as String?,detectedColours: freezed == detectedColours ? _self.detectedColours : detectedColours // ignore: cast_nullable_to_non_nullable
as List<String>?,backgroundRemoved: freezed == backgroundRemoved ? _self.backgroundRemoved : backgroundRemoved // ignore: cast_nullable_to_non_nullable
as bool?,processedImageKey: freezed == processedImageKey ? _self.processedImageKey : processedImageKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ItemResponse {

 String get itemId; String get wardrobeId; String get name; String get category; String? get subcategory; List<String>? get colours; String? get brand; ItemImageResponse? get image; String? get imageKey; String? get originalImageUrl; String? get processedImageUrl; String? get processingStatus; String? get processingError; String? get failureReason; String? get errorMessage; ItemAiResponse? get ai; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemResponseCopyWith<ItemResponse> get copyWith => _$ItemResponseCopyWithImpl<ItemResponse>(this as ItemResponse, _$identity);

  /// Serializes this ItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemResponse&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&const DeepCollectionEquality().equals(other.colours, colours)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey)&&(identical(other.originalImageUrl, originalImageUrl) || other.originalImageUrl == originalImageUrl)&&(identical(other.processedImageUrl, processedImageUrl) || other.processedImageUrl == processedImageUrl)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.processingError, processingError) || other.processingError == processingError)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.ai, ai) || other.ai == ai)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,wardrobeId,name,category,subcategory,const DeepCollectionEquality().hash(colours),brand,image,imageKey,originalImageUrl,processedImageUrl,processingStatus,processingError,failureReason,errorMessage,ai,createdAt,updatedAt);

@override
String toString() {
  return 'ItemResponse(itemId: $itemId, wardrobeId: $wardrobeId, name: $name, category: $category, subcategory: $subcategory, colours: $colours, brand: $brand, image: $image, imageKey: $imageKey, originalImageUrl: $originalImageUrl, processedImageUrl: $processedImageUrl, processingStatus: $processingStatus, processingError: $processingError, failureReason: $failureReason, errorMessage: $errorMessage, ai: $ai, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ItemResponseCopyWith<$Res>  {
  factory $ItemResponseCopyWith(ItemResponse value, $Res Function(ItemResponse) _then) = _$ItemResponseCopyWithImpl;
@useResult
$Res call({
 String itemId, String wardrobeId, String name, String category, String? subcategory, List<String>? colours, String? brand, ItemImageResponse? image, String? imageKey, String? originalImageUrl, String? processedImageUrl, String? processingStatus, String? processingError, String? failureReason, String? errorMessage, ItemAiResponse? ai, DateTime createdAt, DateTime updatedAt
});


$ItemImageResponseCopyWith<$Res>? get image;$ItemAiResponseCopyWith<$Res>? get ai;

}
/// @nodoc
class _$ItemResponseCopyWithImpl<$Res>
    implements $ItemResponseCopyWith<$Res> {
  _$ItemResponseCopyWithImpl(this._self, this._then);

  final ItemResponse _self;
  final $Res Function(ItemResponse) _then;

/// Create a copy of ItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? wardrobeId = null,Object? name = null,Object? category = null,Object? subcategory = freezed,Object? colours = freezed,Object? brand = freezed,Object? image = freezed,Object? imageKey = freezed,Object? originalImageUrl = freezed,Object? processedImageUrl = freezed,Object? processingStatus = freezed,Object? processingError = freezed,Object? failureReason = freezed,Object? errorMessage = freezed,Object? ai = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as String?,colours: freezed == colours ? _self.colours : colours // ignore: cast_nullable_to_non_nullable
as List<String>?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ItemImageResponse?,imageKey: freezed == imageKey ? _self.imageKey : imageKey // ignore: cast_nullable_to_non_nullable
as String?,originalImageUrl: freezed == originalImageUrl ? _self.originalImageUrl : originalImageUrl // ignore: cast_nullable_to_non_nullable
as String?,processedImageUrl: freezed == processedImageUrl ? _self.processedImageUrl : processedImageUrl // ignore: cast_nullable_to_non_nullable
as String?,processingStatus: freezed == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as String?,processingError: freezed == processingError ? _self.processingError : processingError // ignore: cast_nullable_to_non_nullable
as String?,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,ai: freezed == ai ? _self.ai : ai // ignore: cast_nullable_to_non_nullable
as ItemAiResponse?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemImageResponseCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $ItemImageResponseCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}/// Create a copy of ItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemAiResponseCopyWith<$Res>? get ai {
    if (_self.ai == null) {
    return null;
  }

  return $ItemAiResponseCopyWith<$Res>(_self.ai!, (value) {
    return _then(_self.copyWith(ai: value));
  });
}
}


/// Adds pattern-matching-related methods to [ItemResponse].
extension ItemResponsePatterns on ItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _ItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String wardrobeId,  String name,  String category,  String? subcategory,  List<String>? colours,  String? brand,  ItemImageResponse? image,  String? imageKey,  String? originalImageUrl,  String? processedImageUrl,  String? processingStatus,  String? processingError,  String? failureReason,  String? errorMessage,  ItemAiResponse? ai,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemResponse() when $default != null:
return $default(_that.itemId,_that.wardrobeId,_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.image,_that.imageKey,_that.originalImageUrl,_that.processedImageUrl,_that.processingStatus,_that.processingError,_that.failureReason,_that.errorMessage,_that.ai,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String wardrobeId,  String name,  String category,  String? subcategory,  List<String>? colours,  String? brand,  ItemImageResponse? image,  String? imageKey,  String? originalImageUrl,  String? processedImageUrl,  String? processingStatus,  String? processingError,  String? failureReason,  String? errorMessage,  ItemAiResponse? ai,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ItemResponse():
return $default(_that.itemId,_that.wardrobeId,_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.image,_that.imageKey,_that.originalImageUrl,_that.processedImageUrl,_that.processingStatus,_that.processingError,_that.failureReason,_that.errorMessage,_that.ai,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String wardrobeId,  String name,  String category,  String? subcategory,  List<String>? colours,  String? brand,  ItemImageResponse? image,  String? imageKey,  String? originalImageUrl,  String? processedImageUrl,  String? processingStatus,  String? processingError,  String? failureReason,  String? errorMessage,  ItemAiResponse? ai,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ItemResponse() when $default != null:
return $default(_that.itemId,_that.wardrobeId,_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.image,_that.imageKey,_that.originalImageUrl,_that.processedImageUrl,_that.processingStatus,_that.processingError,_that.failureReason,_that.errorMessage,_that.ai,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemResponse extends ItemResponse {
  const _ItemResponse({required this.itemId, required this.wardrobeId, required this.name, required this.category, this.subcategory, this.colours, this.brand, this.image, this.imageKey, this.originalImageUrl, this.processedImageUrl, this.processingStatus, this.processingError, this.failureReason, this.errorMessage, this.ai, required this.createdAt, required this.updatedAt}): super._();
  factory _ItemResponse.fromJson(Map<String, dynamic> json) => _$ItemResponseFromJson(json);

@override final  String itemId;
@override final  String wardrobeId;
@override final  String name;
@override final  String category;
@override final  String? subcategory;
@override final  List<String>? colours;
@override final  String? brand;
@override final  ItemImageResponse? image;
@override final  String? imageKey;
@override final  String? originalImageUrl;
@override final  String? processedImageUrl;
@override final  String? processingStatus;
@override final  String? processingError;
@override final  String? failureReason;
@override final  String? errorMessage;
@override final  ItemAiResponse? ai;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemResponseCopyWith<_ItemResponse> get copyWith => __$ItemResponseCopyWithImpl<_ItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemResponse&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&const DeepCollectionEquality().equals(other.colours, colours)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey)&&(identical(other.originalImageUrl, originalImageUrl) || other.originalImageUrl == originalImageUrl)&&(identical(other.processedImageUrl, processedImageUrl) || other.processedImageUrl == processedImageUrl)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.processingError, processingError) || other.processingError == processingError)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.ai, ai) || other.ai == ai)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,wardrobeId,name,category,subcategory,const DeepCollectionEquality().hash(colours),brand,image,imageKey,originalImageUrl,processedImageUrl,processingStatus,processingError,failureReason,errorMessage,ai,createdAt,updatedAt);

@override
String toString() {
  return 'ItemResponse(itemId: $itemId, wardrobeId: $wardrobeId, name: $name, category: $category, subcategory: $subcategory, colours: $colours, brand: $brand, image: $image, imageKey: $imageKey, originalImageUrl: $originalImageUrl, processedImageUrl: $processedImageUrl, processingStatus: $processingStatus, processingError: $processingError, failureReason: $failureReason, errorMessage: $errorMessage, ai: $ai, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ItemResponseCopyWith<$Res> implements $ItemResponseCopyWith<$Res> {
  factory _$ItemResponseCopyWith(_ItemResponse value, $Res Function(_ItemResponse) _then) = __$ItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String wardrobeId, String name, String category, String? subcategory, List<String>? colours, String? brand, ItemImageResponse? image, String? imageKey, String? originalImageUrl, String? processedImageUrl, String? processingStatus, String? processingError, String? failureReason, String? errorMessage, ItemAiResponse? ai, DateTime createdAt, DateTime updatedAt
});


@override $ItemImageResponseCopyWith<$Res>? get image;@override $ItemAiResponseCopyWith<$Res>? get ai;

}
/// @nodoc
class __$ItemResponseCopyWithImpl<$Res>
    implements _$ItemResponseCopyWith<$Res> {
  __$ItemResponseCopyWithImpl(this._self, this._then);

  final _ItemResponse _self;
  final $Res Function(_ItemResponse) _then;

/// Create a copy of ItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? wardrobeId = null,Object? name = null,Object? category = null,Object? subcategory = freezed,Object? colours = freezed,Object? brand = freezed,Object? image = freezed,Object? imageKey = freezed,Object? originalImageUrl = freezed,Object? processedImageUrl = freezed,Object? processingStatus = freezed,Object? processingError = freezed,Object? failureReason = freezed,Object? errorMessage = freezed,Object? ai = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ItemResponse(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as String?,colours: freezed == colours ? _self.colours : colours // ignore: cast_nullable_to_non_nullable
as List<String>?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ItemImageResponse?,imageKey: freezed == imageKey ? _self.imageKey : imageKey // ignore: cast_nullable_to_non_nullable
as String?,originalImageUrl: freezed == originalImageUrl ? _self.originalImageUrl : originalImageUrl // ignore: cast_nullable_to_non_nullable
as String?,processedImageUrl: freezed == processedImageUrl ? _self.processedImageUrl : processedImageUrl // ignore: cast_nullable_to_non_nullable
as String?,processingStatus: freezed == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as String?,processingError: freezed == processingError ? _self.processingError : processingError // ignore: cast_nullable_to_non_nullable
as String?,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,ai: freezed == ai ? _self.ai : ai // ignore: cast_nullable_to_non_nullable
as ItemAiResponse?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemImageResponseCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $ItemImageResponseCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}/// Create a copy of ItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemAiResponseCopyWith<$Res>? get ai {
    if (_self.ai == null) {
    return null;
  }

  return $ItemAiResponseCopyWith<$Res>(_self.ai!, (value) {
    return _then(_self.copyWith(ai: value));
  });
}
}


/// @nodoc
mixin _$ItemListResponse {

 List<ItemResponse> get items;
/// Create a copy of ItemListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemListResponseCopyWith<ItemListResponse> get copyWith => _$ItemListResponseCopyWithImpl<ItemListResponse>(this as ItemListResponse, _$identity);

  /// Serializes this ItemListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemListResponse&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ItemListResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class $ItemListResponseCopyWith<$Res>  {
  factory $ItemListResponseCopyWith(ItemListResponse value, $Res Function(ItemListResponse) _then) = _$ItemListResponseCopyWithImpl;
@useResult
$Res call({
 List<ItemResponse> items
});




}
/// @nodoc
class _$ItemListResponseCopyWithImpl<$Res>
    implements $ItemListResponseCopyWith<$Res> {
  _$ItemListResponseCopyWithImpl(this._self, this._then);

  final ItemListResponse _self;
  final $Res Function(ItemListResponse) _then;

/// Create a copy of ItemListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ItemResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemListResponse].
extension ItemListResponsePatterns on ItemListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemListResponse value)  $default,){
final _that = this;
switch (_that) {
case _ItemListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ItemListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ItemResponse> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemListResponse() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ItemResponse> items)  $default,) {final _that = this;
switch (_that) {
case _ItemListResponse():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ItemResponse> items)?  $default,) {final _that = this;
switch (_that) {
case _ItemListResponse() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemListResponse extends ItemListResponse {
  const _ItemListResponse({required this.items}): super._();
  factory _ItemListResponse.fromJson(Map<String, dynamic> json) => _$ItemListResponseFromJson(json);

@override final  List<ItemResponse> items;

/// Create a copy of ItemListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemListResponseCopyWith<_ItemListResponse> get copyWith => __$ItemListResponseCopyWithImpl<_ItemListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemListResponse&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ItemListResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class _$ItemListResponseCopyWith<$Res> implements $ItemListResponseCopyWith<$Res> {
  factory _$ItemListResponseCopyWith(_ItemListResponse value, $Res Function(_ItemListResponse) _then) = __$ItemListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<ItemResponse> items
});




}
/// @nodoc
class __$ItemListResponseCopyWithImpl<$Res>
    implements _$ItemListResponseCopyWith<$Res> {
  __$ItemListResponseCopyWithImpl(this._self, this._then);

  final _ItemListResponse _self;
  final $Res Function(_ItemListResponse) _then;

/// Create a copy of ItemListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_ItemListResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ItemResponse>,
  ));
}


}


/// @nodoc
mixin _$CreateItemRequest {

 String get name; String get category;@JsonKey(includeIfNull: false) String? get subcategory;@JsonKey(includeIfNull: false) List<String>? get colours;@JsonKey(includeIfNull: false) String? get brand; String get imageKey;
/// Create a copy of CreateItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateItemRequestCopyWith<CreateItemRequest> get copyWith => _$CreateItemRequestCopyWithImpl<CreateItemRequest>(this as CreateItemRequest, _$identity);

  /// Serializes this CreateItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateItemRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&const DeepCollectionEquality().equals(other.colours, colours)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category,subcategory,const DeepCollectionEquality().hash(colours),brand,imageKey);

@override
String toString() {
  return 'CreateItemRequest(name: $name, category: $category, subcategory: $subcategory, colours: $colours, brand: $brand, imageKey: $imageKey)';
}


}

/// @nodoc
abstract mixin class $CreateItemRequestCopyWith<$Res>  {
  factory $CreateItemRequestCopyWith(CreateItemRequest value, $Res Function(CreateItemRequest) _then) = _$CreateItemRequestCopyWithImpl;
@useResult
$Res call({
 String name, String category,@JsonKey(includeIfNull: false) String? subcategory,@JsonKey(includeIfNull: false) List<String>? colours,@JsonKey(includeIfNull: false) String? brand, String imageKey
});




}
/// @nodoc
class _$CreateItemRequestCopyWithImpl<$Res>
    implements $CreateItemRequestCopyWith<$Res> {
  _$CreateItemRequestCopyWithImpl(this._self, this._then);

  final CreateItemRequest _self;
  final $Res Function(CreateItemRequest) _then;

/// Create a copy of CreateItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? category = null,Object? subcategory = freezed,Object? colours = freezed,Object? brand = freezed,Object? imageKey = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as String?,colours: freezed == colours ? _self.colours : colours // ignore: cast_nullable_to_non_nullable
as List<String>?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,imageKey: null == imageKey ? _self.imageKey : imageKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateItemRequest].
extension CreateItemRequestPatterns on CreateItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String category, @JsonKey(includeIfNull: false)  String? subcategory, @JsonKey(includeIfNull: false)  List<String>? colours, @JsonKey(includeIfNull: false)  String? brand,  String imageKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateItemRequest() when $default != null:
return $default(_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.imageKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String category, @JsonKey(includeIfNull: false)  String? subcategory, @JsonKey(includeIfNull: false)  List<String>? colours, @JsonKey(includeIfNull: false)  String? brand,  String imageKey)  $default,) {final _that = this;
switch (_that) {
case _CreateItemRequest():
return $default(_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.imageKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String category, @JsonKey(includeIfNull: false)  String? subcategory, @JsonKey(includeIfNull: false)  List<String>? colours, @JsonKey(includeIfNull: false)  String? brand,  String imageKey)?  $default,) {final _that = this;
switch (_that) {
case _CreateItemRequest() when $default != null:
return $default(_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.imageKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateItemRequest implements CreateItemRequest {
  const _CreateItemRequest({required this.name, required this.category, @JsonKey(includeIfNull: false) this.subcategory, @JsonKey(includeIfNull: false) this.colours, @JsonKey(includeIfNull: false) this.brand, required this.imageKey});
  factory _CreateItemRequest.fromJson(Map<String, dynamic> json) => _$CreateItemRequestFromJson(json);

@override final  String name;
@override final  String category;
@override@JsonKey(includeIfNull: false) final  String? subcategory;
@override@JsonKey(includeIfNull: false) final  List<String>? colours;
@override@JsonKey(includeIfNull: false) final  String? brand;
@override final  String imageKey;

/// Create a copy of CreateItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateItemRequestCopyWith<_CreateItemRequest> get copyWith => __$CreateItemRequestCopyWithImpl<_CreateItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateItemRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&const DeepCollectionEquality().equals(other.colours, colours)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category,subcategory,const DeepCollectionEquality().hash(colours),brand,imageKey);

@override
String toString() {
  return 'CreateItemRequest(name: $name, category: $category, subcategory: $subcategory, colours: $colours, brand: $brand, imageKey: $imageKey)';
}


}

/// @nodoc
abstract mixin class _$CreateItemRequestCopyWith<$Res> implements $CreateItemRequestCopyWith<$Res> {
  factory _$CreateItemRequestCopyWith(_CreateItemRequest value, $Res Function(_CreateItemRequest) _then) = __$CreateItemRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String category,@JsonKey(includeIfNull: false) String? subcategory,@JsonKey(includeIfNull: false) List<String>? colours,@JsonKey(includeIfNull: false) String? brand, String imageKey
});




}
/// @nodoc
class __$CreateItemRequestCopyWithImpl<$Res>
    implements _$CreateItemRequestCopyWith<$Res> {
  __$CreateItemRequestCopyWithImpl(this._self, this._then);

  final _CreateItemRequest _self;
  final $Res Function(_CreateItemRequest) _then;

/// Create a copy of CreateItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? category = null,Object? subcategory = freezed,Object? colours = freezed,Object? brand = freezed,Object? imageKey = null,}) {
  return _then(_CreateItemRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as String?,colours: freezed == colours ? _self.colours : colours // ignore: cast_nullable_to_non_nullable
as List<String>?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,imageKey: null == imageKey ? _self.imageKey : imageKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UpdateItemRequest {

@JsonKey(includeIfNull: false) String? get name;@JsonKey(includeIfNull: false) String? get category;@JsonKey(includeIfNull: false) String? get subcategory;@JsonKey(includeIfNull: false) List<String>? get colours;@JsonKey(includeIfNull: false) String? get brand;@JsonKey(includeIfNull: false) String? get imageKey;
/// Create a copy of UpdateItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateItemRequestCopyWith<UpdateItemRequest> get copyWith => _$UpdateItemRequestCopyWithImpl<UpdateItemRequest>(this as UpdateItemRequest, _$identity);

  /// Serializes this UpdateItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateItemRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&const DeepCollectionEquality().equals(other.colours, colours)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category,subcategory,const DeepCollectionEquality().hash(colours),brand,imageKey);

@override
String toString() {
  return 'UpdateItemRequest(name: $name, category: $category, subcategory: $subcategory, colours: $colours, brand: $brand, imageKey: $imageKey)';
}


}

/// @nodoc
abstract mixin class $UpdateItemRequestCopyWith<$Res>  {
  factory $UpdateItemRequestCopyWith(UpdateItemRequest value, $Res Function(UpdateItemRequest) _then) = _$UpdateItemRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? name,@JsonKey(includeIfNull: false) String? category,@JsonKey(includeIfNull: false) String? subcategory,@JsonKey(includeIfNull: false) List<String>? colours,@JsonKey(includeIfNull: false) String? brand,@JsonKey(includeIfNull: false) String? imageKey
});




}
/// @nodoc
class _$UpdateItemRequestCopyWithImpl<$Res>
    implements $UpdateItemRequestCopyWith<$Res> {
  _$UpdateItemRequestCopyWithImpl(this._self, this._then);

  final UpdateItemRequest _self;
  final $Res Function(UpdateItemRequest) _then;

/// Create a copy of UpdateItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? category = freezed,Object? subcategory = freezed,Object? colours = freezed,Object? brand = freezed,Object? imageKey = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as String?,colours: freezed == colours ? _self.colours : colours // ignore: cast_nullable_to_non_nullable
as List<String>?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,imageKey: freezed == imageKey ? _self.imageKey : imageKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateItemRequest].
extension UpdateItemRequestPatterns on UpdateItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? name, @JsonKey(includeIfNull: false)  String? category, @JsonKey(includeIfNull: false)  String? subcategory, @JsonKey(includeIfNull: false)  List<String>? colours, @JsonKey(includeIfNull: false)  String? brand, @JsonKey(includeIfNull: false)  String? imageKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateItemRequest() when $default != null:
return $default(_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.imageKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? name, @JsonKey(includeIfNull: false)  String? category, @JsonKey(includeIfNull: false)  String? subcategory, @JsonKey(includeIfNull: false)  List<String>? colours, @JsonKey(includeIfNull: false)  String? brand, @JsonKey(includeIfNull: false)  String? imageKey)  $default,) {final _that = this;
switch (_that) {
case _UpdateItemRequest():
return $default(_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.imageKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? name, @JsonKey(includeIfNull: false)  String? category, @JsonKey(includeIfNull: false)  String? subcategory, @JsonKey(includeIfNull: false)  List<String>? colours, @JsonKey(includeIfNull: false)  String? brand, @JsonKey(includeIfNull: false)  String? imageKey)?  $default,) {final _that = this;
switch (_that) {
case _UpdateItemRequest() when $default != null:
return $default(_that.name,_that.category,_that.subcategory,_that.colours,_that.brand,_that.imageKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateItemRequest implements UpdateItemRequest {
  const _UpdateItemRequest({@JsonKey(includeIfNull: false) this.name, @JsonKey(includeIfNull: false) this.category, @JsonKey(includeIfNull: false) this.subcategory, @JsonKey(includeIfNull: false) this.colours, @JsonKey(includeIfNull: false) this.brand, @JsonKey(includeIfNull: false) this.imageKey});
  factory _UpdateItemRequest.fromJson(Map<String, dynamic> json) => _$UpdateItemRequestFromJson(json);

@override@JsonKey(includeIfNull: false) final  String? name;
@override@JsonKey(includeIfNull: false) final  String? category;
@override@JsonKey(includeIfNull: false) final  String? subcategory;
@override@JsonKey(includeIfNull: false) final  List<String>? colours;
@override@JsonKey(includeIfNull: false) final  String? brand;
@override@JsonKey(includeIfNull: false) final  String? imageKey;

/// Create a copy of UpdateItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateItemRequestCopyWith<_UpdateItemRequest> get copyWith => __$UpdateItemRequestCopyWithImpl<_UpdateItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateItemRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&const DeepCollectionEquality().equals(other.colours, colours)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category,subcategory,const DeepCollectionEquality().hash(colours),brand,imageKey);

@override
String toString() {
  return 'UpdateItemRequest(name: $name, category: $category, subcategory: $subcategory, colours: $colours, brand: $brand, imageKey: $imageKey)';
}


}

/// @nodoc
abstract mixin class _$UpdateItemRequestCopyWith<$Res> implements $UpdateItemRequestCopyWith<$Res> {
  factory _$UpdateItemRequestCopyWith(_UpdateItemRequest value, $Res Function(_UpdateItemRequest) _then) = __$UpdateItemRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? name,@JsonKey(includeIfNull: false) String? category,@JsonKey(includeIfNull: false) String? subcategory,@JsonKey(includeIfNull: false) List<String>? colours,@JsonKey(includeIfNull: false) String? brand,@JsonKey(includeIfNull: false) String? imageKey
});




}
/// @nodoc
class __$UpdateItemRequestCopyWithImpl<$Res>
    implements _$UpdateItemRequestCopyWith<$Res> {
  __$UpdateItemRequestCopyWithImpl(this._self, this._then);

  final _UpdateItemRequest _self;
  final $Res Function(_UpdateItemRequest) _then;

/// Create a copy of UpdateItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? category = freezed,Object? subcategory = freezed,Object? colours = freezed,Object? brand = freezed,Object? imageKey = freezed,}) {
  return _then(_UpdateItemRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as String?,colours: freezed == colours ? _self.colours : colours // ignore: cast_nullable_to_non_nullable
as List<String>?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,imageKey: freezed == imageKey ? _self.imageKey : imageKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
