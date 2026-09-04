// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outfit_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OutfitItemResponse {

 String get itemId; String get slot;
/// Create a copy of OutfitItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutfitItemResponseCopyWith<OutfitItemResponse> get copyWith => _$OutfitItemResponseCopyWithImpl<OutfitItemResponse>(this as OutfitItemResponse, _$identity);

  /// Serializes this OutfitItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutfitItemResponse&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.slot, slot) || other.slot == slot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,slot);

@override
String toString() {
  return 'OutfitItemResponse(itemId: $itemId, slot: $slot)';
}


}

/// @nodoc
abstract mixin class $OutfitItemResponseCopyWith<$Res>  {
  factory $OutfitItemResponseCopyWith(OutfitItemResponse value, $Res Function(OutfitItemResponse) _then) = _$OutfitItemResponseCopyWithImpl;
@useResult
$Res call({
 String itemId, String slot
});




}
/// @nodoc
class _$OutfitItemResponseCopyWithImpl<$Res>
    implements $OutfitItemResponseCopyWith<$Res> {
  _$OutfitItemResponseCopyWithImpl(this._self, this._then);

  final OutfitItemResponse _self;
  final $Res Function(OutfitItemResponse) _then;

/// Create a copy of OutfitItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? slot = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OutfitItemResponse].
extension OutfitItemResponsePatterns on OutfitItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutfitItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutfitItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutfitItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _OutfitItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutfitItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OutfitItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String slot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutfitItemResponse() when $default != null:
return $default(_that.itemId,_that.slot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String slot)  $default,) {final _that = this;
switch (_that) {
case _OutfitItemResponse():
return $default(_that.itemId,_that.slot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String slot)?  $default,) {final _that = this;
switch (_that) {
case _OutfitItemResponse() when $default != null:
return $default(_that.itemId,_that.slot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OutfitItemResponse extends OutfitItemResponse {
  const _OutfitItemResponse({required this.itemId, required this.slot}): super._();
  factory _OutfitItemResponse.fromJson(Map<String, dynamic> json) => _$OutfitItemResponseFromJson(json);

@override final  String itemId;
@override final  String slot;

/// Create a copy of OutfitItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutfitItemResponseCopyWith<_OutfitItemResponse> get copyWith => __$OutfitItemResponseCopyWithImpl<_OutfitItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OutfitItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutfitItemResponse&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.slot, slot) || other.slot == slot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,slot);

@override
String toString() {
  return 'OutfitItemResponse(itemId: $itemId, slot: $slot)';
}


}

/// @nodoc
abstract mixin class _$OutfitItemResponseCopyWith<$Res> implements $OutfitItemResponseCopyWith<$Res> {
  factory _$OutfitItemResponseCopyWith(_OutfitItemResponse value, $Res Function(_OutfitItemResponse) _then) = __$OutfitItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String slot
});




}
/// @nodoc
class __$OutfitItemResponseCopyWithImpl<$Res>
    implements _$OutfitItemResponseCopyWith<$Res> {
  __$OutfitItemResponseCopyWithImpl(this._self, this._then);

  final _OutfitItemResponse _self;
  final $Res Function(_OutfitItemResponse) _then;

/// Create a copy of OutfitItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? slot = null,}) {
  return _then(_OutfitItemResponse(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OutfitItemRequest {

 String get itemId; String get slot;
/// Create a copy of OutfitItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutfitItemRequestCopyWith<OutfitItemRequest> get copyWith => _$OutfitItemRequestCopyWithImpl<OutfitItemRequest>(this as OutfitItemRequest, _$identity);

  /// Serializes this OutfitItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutfitItemRequest&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.slot, slot) || other.slot == slot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,slot);

@override
String toString() {
  return 'OutfitItemRequest(itemId: $itemId, slot: $slot)';
}


}

/// @nodoc
abstract mixin class $OutfitItemRequestCopyWith<$Res>  {
  factory $OutfitItemRequestCopyWith(OutfitItemRequest value, $Res Function(OutfitItemRequest) _then) = _$OutfitItemRequestCopyWithImpl;
@useResult
$Res call({
 String itemId, String slot
});




}
/// @nodoc
class _$OutfitItemRequestCopyWithImpl<$Res>
    implements $OutfitItemRequestCopyWith<$Res> {
  _$OutfitItemRequestCopyWithImpl(this._self, this._then);

  final OutfitItemRequest _self;
  final $Res Function(OutfitItemRequest) _then;

/// Create a copy of OutfitItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? slot = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OutfitItemRequest].
extension OutfitItemRequestPatterns on OutfitItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutfitItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutfitItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutfitItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _OutfitItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutfitItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _OutfitItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String slot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutfitItemRequest() when $default != null:
return $default(_that.itemId,_that.slot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String slot)  $default,) {final _that = this;
switch (_that) {
case _OutfitItemRequest():
return $default(_that.itemId,_that.slot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String slot)?  $default,) {final _that = this;
switch (_that) {
case _OutfitItemRequest() when $default != null:
return $default(_that.itemId,_that.slot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OutfitItemRequest implements OutfitItemRequest {
  const _OutfitItemRequest({required this.itemId, required this.slot});
  factory _OutfitItemRequest.fromJson(Map<String, dynamic> json) => _$OutfitItemRequestFromJson(json);

@override final  String itemId;
@override final  String slot;

/// Create a copy of OutfitItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutfitItemRequestCopyWith<_OutfitItemRequest> get copyWith => __$OutfitItemRequestCopyWithImpl<_OutfitItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OutfitItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutfitItemRequest&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.slot, slot) || other.slot == slot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,slot);

@override
String toString() {
  return 'OutfitItemRequest(itemId: $itemId, slot: $slot)';
}


}

/// @nodoc
abstract mixin class _$OutfitItemRequestCopyWith<$Res> implements $OutfitItemRequestCopyWith<$Res> {
  factory _$OutfitItemRequestCopyWith(_OutfitItemRequest value, $Res Function(_OutfitItemRequest) _then) = __$OutfitItemRequestCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String slot
});




}
/// @nodoc
class __$OutfitItemRequestCopyWithImpl<$Res>
    implements _$OutfitItemRequestCopyWith<$Res> {
  __$OutfitItemRequestCopyWithImpl(this._self, this._then);

  final _OutfitItemRequest _self;
  final $Res Function(_OutfitItemRequest) _then;

/// Create a copy of OutfitItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? slot = null,}) {
  return _then(_OutfitItemRequest(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OutfitResponse {

 String get outfitId; String get wardrobeId; String get name; List<OutfitItemResponse> get items; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of OutfitResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutfitResponseCopyWith<OutfitResponse> get copyWith => _$OutfitResponseCopyWithImpl<OutfitResponse>(this as OutfitResponse, _$identity);

  /// Serializes this OutfitResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutfitResponse&&(identical(other.outfitId, outfitId) || other.outfitId == outfitId)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,outfitId,wardrobeId,name,const DeepCollectionEquality().hash(items),createdAt,updatedAt);

@override
String toString() {
  return 'OutfitResponse(outfitId: $outfitId, wardrobeId: $wardrobeId, name: $name, items: $items, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OutfitResponseCopyWith<$Res>  {
  factory $OutfitResponseCopyWith(OutfitResponse value, $Res Function(OutfitResponse) _then) = _$OutfitResponseCopyWithImpl;
@useResult
$Res call({
 String outfitId, String wardrobeId, String name, List<OutfitItemResponse> items, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$OutfitResponseCopyWithImpl<$Res>
    implements $OutfitResponseCopyWith<$Res> {
  _$OutfitResponseCopyWithImpl(this._self, this._then);

  final OutfitResponse _self;
  final $Res Function(OutfitResponse) _then;

/// Create a copy of OutfitResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outfitId = null,Object? wardrobeId = null,Object? name = null,Object? items = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
outfitId: null == outfitId ? _self.outfitId : outfitId // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OutfitItemResponse>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [OutfitResponse].
extension OutfitResponsePatterns on OutfitResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutfitResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutfitResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutfitResponse value)  $default,){
final _that = this;
switch (_that) {
case _OutfitResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutfitResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OutfitResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String outfitId,  String wardrobeId,  String name,  List<OutfitItemResponse> items,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutfitResponse() when $default != null:
return $default(_that.outfitId,_that.wardrobeId,_that.name,_that.items,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String outfitId,  String wardrobeId,  String name,  List<OutfitItemResponse> items,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _OutfitResponse():
return $default(_that.outfitId,_that.wardrobeId,_that.name,_that.items,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String outfitId,  String wardrobeId,  String name,  List<OutfitItemResponse> items,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _OutfitResponse() when $default != null:
return $default(_that.outfitId,_that.wardrobeId,_that.name,_that.items,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OutfitResponse extends OutfitResponse {
  const _OutfitResponse({required this.outfitId, required this.wardrobeId, required this.name, this.items = const [], required this.createdAt, required this.updatedAt}): super._();
  factory _OutfitResponse.fromJson(Map<String, dynamic> json) => _$OutfitResponseFromJson(json);

@override final  String outfitId;
@override final  String wardrobeId;
@override final  String name;
@override@JsonKey() final  List<OutfitItemResponse> items;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of OutfitResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutfitResponseCopyWith<_OutfitResponse> get copyWith => __$OutfitResponseCopyWithImpl<_OutfitResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OutfitResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutfitResponse&&(identical(other.outfitId, outfitId) || other.outfitId == outfitId)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,outfitId,wardrobeId,name,const DeepCollectionEquality().hash(items),createdAt,updatedAt);

@override
String toString() {
  return 'OutfitResponse(outfitId: $outfitId, wardrobeId: $wardrobeId, name: $name, items: $items, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OutfitResponseCopyWith<$Res> implements $OutfitResponseCopyWith<$Res> {
  factory _$OutfitResponseCopyWith(_OutfitResponse value, $Res Function(_OutfitResponse) _then) = __$OutfitResponseCopyWithImpl;
@override @useResult
$Res call({
 String outfitId, String wardrobeId, String name, List<OutfitItemResponse> items, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$OutfitResponseCopyWithImpl<$Res>
    implements _$OutfitResponseCopyWith<$Res> {
  __$OutfitResponseCopyWithImpl(this._self, this._then);

  final _OutfitResponse _self;
  final $Res Function(_OutfitResponse) _then;

/// Create a copy of OutfitResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outfitId = null,Object? wardrobeId = null,Object? name = null,Object? items = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_OutfitResponse(
outfitId: null == outfitId ? _self.outfitId : outfitId // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OutfitItemResponse>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$OutfitListResponse {

 List<OutfitResponse> get outfits;
/// Create a copy of OutfitListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutfitListResponseCopyWith<OutfitListResponse> get copyWith => _$OutfitListResponseCopyWithImpl<OutfitListResponse>(this as OutfitListResponse, _$identity);

  /// Serializes this OutfitListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutfitListResponse&&const DeepCollectionEquality().equals(other.outfits, outfits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(outfits));

@override
String toString() {
  return 'OutfitListResponse(outfits: $outfits)';
}


}

/// @nodoc
abstract mixin class $OutfitListResponseCopyWith<$Res>  {
  factory $OutfitListResponseCopyWith(OutfitListResponse value, $Res Function(OutfitListResponse) _then) = _$OutfitListResponseCopyWithImpl;
@useResult
$Res call({
 List<OutfitResponse> outfits
});




}
/// @nodoc
class _$OutfitListResponseCopyWithImpl<$Res>
    implements $OutfitListResponseCopyWith<$Res> {
  _$OutfitListResponseCopyWithImpl(this._self, this._then);

  final OutfitListResponse _self;
  final $Res Function(OutfitListResponse) _then;

/// Create a copy of OutfitListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outfits = null,}) {
  return _then(_self.copyWith(
outfits: null == outfits ? _self.outfits : outfits // ignore: cast_nullable_to_non_nullable
as List<OutfitResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [OutfitListResponse].
extension OutfitListResponsePatterns on OutfitListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutfitListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutfitListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutfitListResponse value)  $default,){
final _that = this;
switch (_that) {
case _OutfitListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutfitListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OutfitListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OutfitResponse> outfits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutfitListResponse() when $default != null:
return $default(_that.outfits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OutfitResponse> outfits)  $default,) {final _that = this;
switch (_that) {
case _OutfitListResponse():
return $default(_that.outfits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OutfitResponse> outfits)?  $default,) {final _that = this;
switch (_that) {
case _OutfitListResponse() when $default != null:
return $default(_that.outfits);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OutfitListResponse extends OutfitListResponse {
  const _OutfitListResponse({required this.outfits}): super._();
  factory _OutfitListResponse.fromJson(Map<String, dynamic> json) => _$OutfitListResponseFromJson(json);

@override final  List<OutfitResponse> outfits;

/// Create a copy of OutfitListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutfitListResponseCopyWith<_OutfitListResponse> get copyWith => __$OutfitListResponseCopyWithImpl<_OutfitListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OutfitListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutfitListResponse&&const DeepCollectionEquality().equals(other.outfits, outfits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(outfits));

@override
String toString() {
  return 'OutfitListResponse(outfits: $outfits)';
}


}

/// @nodoc
abstract mixin class _$OutfitListResponseCopyWith<$Res> implements $OutfitListResponseCopyWith<$Res> {
  factory _$OutfitListResponseCopyWith(_OutfitListResponse value, $Res Function(_OutfitListResponse) _then) = __$OutfitListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<OutfitResponse> outfits
});




}
/// @nodoc
class __$OutfitListResponseCopyWithImpl<$Res>
    implements _$OutfitListResponseCopyWith<$Res> {
  __$OutfitListResponseCopyWithImpl(this._self, this._then);

  final _OutfitListResponse _self;
  final $Res Function(_OutfitListResponse) _then;

/// Create a copy of OutfitListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outfits = null,}) {
  return _then(_OutfitListResponse(
outfits: null == outfits ? _self.outfits : outfits // ignore: cast_nullable_to_non_nullable
as List<OutfitResponse>,
  ));
}


}


/// @nodoc
mixin _$CreateOutfitRequest {

 String get name; List<OutfitItemRequest> get items;
/// Create a copy of CreateOutfitRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateOutfitRequestCopyWith<CreateOutfitRequest> get copyWith => _$CreateOutfitRequestCopyWithImpl<CreateOutfitRequest>(this as CreateOutfitRequest, _$identity);

  /// Serializes this CreateOutfitRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateOutfitRequest&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'CreateOutfitRequest(name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class $CreateOutfitRequestCopyWith<$Res>  {
  factory $CreateOutfitRequestCopyWith(CreateOutfitRequest value, $Res Function(CreateOutfitRequest) _then) = _$CreateOutfitRequestCopyWithImpl;
@useResult
$Res call({
 String name, List<OutfitItemRequest> items
});




}
/// @nodoc
class _$CreateOutfitRequestCopyWithImpl<$Res>
    implements $CreateOutfitRequestCopyWith<$Res> {
  _$CreateOutfitRequestCopyWithImpl(this._self, this._then);

  final CreateOutfitRequest _self;
  final $Res Function(CreateOutfitRequest) _then;

/// Create a copy of CreateOutfitRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? items = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OutfitItemRequest>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateOutfitRequest].
extension CreateOutfitRequestPatterns on CreateOutfitRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateOutfitRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateOutfitRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateOutfitRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateOutfitRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateOutfitRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateOutfitRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<OutfitItemRequest> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateOutfitRequest() when $default != null:
return $default(_that.name,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<OutfitItemRequest> items)  $default,) {final _that = this;
switch (_that) {
case _CreateOutfitRequest():
return $default(_that.name,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<OutfitItemRequest> items)?  $default,) {final _that = this;
switch (_that) {
case _CreateOutfitRequest() when $default != null:
return $default(_that.name,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateOutfitRequest implements CreateOutfitRequest {
  const _CreateOutfitRequest({required this.name, required this.items});
  factory _CreateOutfitRequest.fromJson(Map<String, dynamic> json) => _$CreateOutfitRequestFromJson(json);

@override final  String name;
@override final  List<OutfitItemRequest> items;

/// Create a copy of CreateOutfitRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateOutfitRequestCopyWith<_CreateOutfitRequest> get copyWith => __$CreateOutfitRequestCopyWithImpl<_CreateOutfitRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateOutfitRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateOutfitRequest&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'CreateOutfitRequest(name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class _$CreateOutfitRequestCopyWith<$Res> implements $CreateOutfitRequestCopyWith<$Res> {
  factory _$CreateOutfitRequestCopyWith(_CreateOutfitRequest value, $Res Function(_CreateOutfitRequest) _then) = __$CreateOutfitRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, List<OutfitItemRequest> items
});




}
/// @nodoc
class __$CreateOutfitRequestCopyWithImpl<$Res>
    implements _$CreateOutfitRequestCopyWith<$Res> {
  __$CreateOutfitRequestCopyWithImpl(this._self, this._then);

  final _CreateOutfitRequest _self;
  final $Res Function(_CreateOutfitRequest) _then;

/// Create a copy of CreateOutfitRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? items = null,}) {
  return _then(_CreateOutfitRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OutfitItemRequest>,
  ));
}


}


/// @nodoc
mixin _$UpdateOutfitRequest {

@JsonKey(includeIfNull: false) String? get name;@JsonKey(includeIfNull: false) List<OutfitItemRequest>? get items;
/// Create a copy of UpdateOutfitRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateOutfitRequestCopyWith<UpdateOutfitRequest> get copyWith => _$UpdateOutfitRequestCopyWithImpl<UpdateOutfitRequest>(this as UpdateOutfitRequest, _$identity);

  /// Serializes this UpdateOutfitRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateOutfitRequest&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'UpdateOutfitRequest(name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class $UpdateOutfitRequestCopyWith<$Res>  {
  factory $UpdateOutfitRequestCopyWith(UpdateOutfitRequest value, $Res Function(UpdateOutfitRequest) _then) = _$UpdateOutfitRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? name,@JsonKey(includeIfNull: false) List<OutfitItemRequest>? items
});




}
/// @nodoc
class _$UpdateOutfitRequestCopyWithImpl<$Res>
    implements $UpdateOutfitRequestCopyWith<$Res> {
  _$UpdateOutfitRequestCopyWithImpl(this._self, this._then);

  final UpdateOutfitRequest _self;
  final $Res Function(UpdateOutfitRequest) _then;

/// Create a copy of UpdateOutfitRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? items = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OutfitItemRequest>?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateOutfitRequest].
extension UpdateOutfitRequestPatterns on UpdateOutfitRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateOutfitRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateOutfitRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateOutfitRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateOutfitRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateOutfitRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateOutfitRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? name, @JsonKey(includeIfNull: false)  List<OutfitItemRequest>? items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateOutfitRequest() when $default != null:
return $default(_that.name,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? name, @JsonKey(includeIfNull: false)  List<OutfitItemRequest>? items)  $default,) {final _that = this;
switch (_that) {
case _UpdateOutfitRequest():
return $default(_that.name,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? name, @JsonKey(includeIfNull: false)  List<OutfitItemRequest>? items)?  $default,) {final _that = this;
switch (_that) {
case _UpdateOutfitRequest() when $default != null:
return $default(_that.name,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateOutfitRequest implements UpdateOutfitRequest {
  const _UpdateOutfitRequest({@JsonKey(includeIfNull: false) this.name, @JsonKey(includeIfNull: false) this.items});
  factory _UpdateOutfitRequest.fromJson(Map<String, dynamic> json) => _$UpdateOutfitRequestFromJson(json);

@override@JsonKey(includeIfNull: false) final  String? name;
@override@JsonKey(includeIfNull: false) final  List<OutfitItemRequest>? items;

/// Create a copy of UpdateOutfitRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateOutfitRequestCopyWith<_UpdateOutfitRequest> get copyWith => __$UpdateOutfitRequestCopyWithImpl<_UpdateOutfitRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateOutfitRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateOutfitRequest&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'UpdateOutfitRequest(name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class _$UpdateOutfitRequestCopyWith<$Res> implements $UpdateOutfitRequestCopyWith<$Res> {
  factory _$UpdateOutfitRequestCopyWith(_UpdateOutfitRequest value, $Res Function(_UpdateOutfitRequest) _then) = __$UpdateOutfitRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? name,@JsonKey(includeIfNull: false) List<OutfitItemRequest>? items
});




}
/// @nodoc
class __$UpdateOutfitRequestCopyWithImpl<$Res>
    implements _$UpdateOutfitRequestCopyWith<$Res> {
  __$UpdateOutfitRequestCopyWithImpl(this._self, this._then);

  final _UpdateOutfitRequest _self;
  final $Res Function(_UpdateOutfitRequest) _then;

/// Create a copy of UpdateOutfitRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? items = freezed,}) {
  return _then(_UpdateOutfitRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OutfitItemRequest>?,
  ));
}


}

// dart format on
