// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outfit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OutfitItem {

 String get itemId; ItemCategory get slot;
/// Create a copy of OutfitItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutfitItemCopyWith<OutfitItem> get copyWith => _$OutfitItemCopyWithImpl<OutfitItem>(this as OutfitItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutfitItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.slot, slot) || other.slot == slot));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,slot);

@override
String toString() {
  return 'OutfitItem(itemId: $itemId, slot: $slot)';
}


}

/// @nodoc
abstract mixin class $OutfitItemCopyWith<$Res>  {
  factory $OutfitItemCopyWith(OutfitItem value, $Res Function(OutfitItem) _then) = _$OutfitItemCopyWithImpl;
@useResult
$Res call({
 String itemId, ItemCategory slot
});




}
/// @nodoc
class _$OutfitItemCopyWithImpl<$Res>
    implements $OutfitItemCopyWith<$Res> {
  _$OutfitItemCopyWithImpl(this._self, this._then);

  final OutfitItem _self;
  final $Res Function(OutfitItem) _then;

/// Create a copy of OutfitItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? slot = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as ItemCategory,
  ));
}

}


/// Adds pattern-matching-related methods to [OutfitItem].
extension OutfitItemPatterns on OutfitItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutfitItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutfitItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutfitItem value)  $default,){
final _that = this;
switch (_that) {
case _OutfitItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutfitItem value)?  $default,){
final _that = this;
switch (_that) {
case _OutfitItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  ItemCategory slot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutfitItem() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  ItemCategory slot)  $default,) {final _that = this;
switch (_that) {
case _OutfitItem():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  ItemCategory slot)?  $default,) {final _that = this;
switch (_that) {
case _OutfitItem() when $default != null:
return $default(_that.itemId,_that.slot);case _:
  return null;

}
}

}

/// @nodoc


class _OutfitItem implements OutfitItem {
  const _OutfitItem({required this.itemId, required this.slot});
  

@override final  String itemId;
@override final  ItemCategory slot;

/// Create a copy of OutfitItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutfitItemCopyWith<_OutfitItem> get copyWith => __$OutfitItemCopyWithImpl<_OutfitItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutfitItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.slot, slot) || other.slot == slot));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,slot);

@override
String toString() {
  return 'OutfitItem(itemId: $itemId, slot: $slot)';
}


}

/// @nodoc
abstract mixin class _$OutfitItemCopyWith<$Res> implements $OutfitItemCopyWith<$Res> {
  factory _$OutfitItemCopyWith(_OutfitItem value, $Res Function(_OutfitItem) _then) = __$OutfitItemCopyWithImpl;
@override @useResult
$Res call({
 String itemId, ItemCategory slot
});




}
/// @nodoc
class __$OutfitItemCopyWithImpl<$Res>
    implements _$OutfitItemCopyWith<$Res> {
  __$OutfitItemCopyWithImpl(this._self, this._then);

  final _OutfitItem _self;
  final $Res Function(_OutfitItem) _then;

/// Create a copy of OutfitItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? slot = null,}) {
  return _then(_OutfitItem(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as ItemCategory,
  ));
}


}

/// @nodoc
mixin _$Outfit {

 String get id; String get wardrobeId; String get name; List<OutfitItem> get items; OutfitRender? get render; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Outfit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutfitCopyWith<Outfit> get copyWith => _$OutfitCopyWithImpl<Outfit>(this as Outfit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Outfit&&(identical(other.id, id) || other.id == id)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.render, render) || other.render == render)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,wardrobeId,name,const DeepCollectionEquality().hash(items),render,createdAt,updatedAt);

@override
String toString() {
  return 'Outfit(id: $id, wardrobeId: $wardrobeId, name: $name, items: $items, render: $render, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OutfitCopyWith<$Res>  {
  factory $OutfitCopyWith(Outfit value, $Res Function(Outfit) _then) = _$OutfitCopyWithImpl;
@useResult
$Res call({
 String id, String wardrobeId, String name, List<OutfitItem> items, OutfitRender? render, DateTime createdAt, DateTime updatedAt
});


$OutfitRenderCopyWith<$Res>? get render;

}
/// @nodoc
class _$OutfitCopyWithImpl<$Res>
    implements $OutfitCopyWith<$Res> {
  _$OutfitCopyWithImpl(this._self, this._then);

  final Outfit _self;
  final $Res Function(Outfit) _then;

/// Create a copy of Outfit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? wardrobeId = null,Object? name = null,Object? items = null,Object? render = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OutfitItem>,render: freezed == render ? _self.render : render // ignore: cast_nullable_to_non_nullable
as OutfitRender?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Outfit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OutfitRenderCopyWith<$Res>? get render {
    if (_self.render == null) {
    return null;
  }

  return $OutfitRenderCopyWith<$Res>(_self.render!, (value) {
    return _then(_self.copyWith(render: value));
  });
}
}


/// Adds pattern-matching-related methods to [Outfit].
extension OutfitPatterns on Outfit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Outfit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Outfit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Outfit value)  $default,){
final _that = this;
switch (_that) {
case _Outfit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Outfit value)?  $default,){
final _that = this;
switch (_that) {
case _Outfit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String wardrobeId,  String name,  List<OutfitItem> items,  OutfitRender? render,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Outfit() when $default != null:
return $default(_that.id,_that.wardrobeId,_that.name,_that.items,_that.render,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String wardrobeId,  String name,  List<OutfitItem> items,  OutfitRender? render,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Outfit():
return $default(_that.id,_that.wardrobeId,_that.name,_that.items,_that.render,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String wardrobeId,  String name,  List<OutfitItem> items,  OutfitRender? render,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Outfit() when $default != null:
return $default(_that.id,_that.wardrobeId,_that.name,_that.items,_that.render,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Outfit implements Outfit {
  const _Outfit({required this.id, required this.wardrobeId, required this.name, this.items = const [], this.render, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String wardrobeId;
@override final  String name;
@override@JsonKey() final  List<OutfitItem> items;
@override final  OutfitRender? render;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Outfit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutfitCopyWith<_Outfit> get copyWith => __$OutfitCopyWithImpl<_Outfit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Outfit&&(identical(other.id, id) || other.id == id)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.render, render) || other.render == render)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,wardrobeId,name,const DeepCollectionEquality().hash(items),render,createdAt,updatedAt);

@override
String toString() {
  return 'Outfit(id: $id, wardrobeId: $wardrobeId, name: $name, items: $items, render: $render, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OutfitCopyWith<$Res> implements $OutfitCopyWith<$Res> {
  factory _$OutfitCopyWith(_Outfit value, $Res Function(_Outfit) _then) = __$OutfitCopyWithImpl;
@override @useResult
$Res call({
 String id, String wardrobeId, String name, List<OutfitItem> items, OutfitRender? render, DateTime createdAt, DateTime updatedAt
});


@override $OutfitRenderCopyWith<$Res>? get render;

}
/// @nodoc
class __$OutfitCopyWithImpl<$Res>
    implements _$OutfitCopyWith<$Res> {
  __$OutfitCopyWithImpl(this._self, this._then);

  final _Outfit _self;
  final $Res Function(_Outfit) _then;

/// Create a copy of Outfit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? wardrobeId = null,Object? name = null,Object? items = null,Object? render = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Outfit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OutfitItem>,render: freezed == render ? _self.render : render // ignore: cast_nullable_to_non_nullable
as OutfitRender?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Outfit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OutfitRenderCopyWith<$Res>? get render {
    if (_self.render == null) {
    return null;
  }

  return $OutfitRenderCopyWith<$Res>(_self.render!, (value) {
    return _then(_self.copyWith(render: value));
  });
}
}

// dart format on
