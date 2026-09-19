// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worn_on_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WornOnEntry {

 String get outfitId; String get wardrobeId; DateTime get wornOn; DateTime get createdAt;
/// Create a copy of WornOnEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WornOnEntryCopyWith<WornOnEntry> get copyWith => _$WornOnEntryCopyWithImpl<WornOnEntry>(this as WornOnEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WornOnEntry&&(identical(other.outfitId, outfitId) || other.outfitId == outfitId)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.wornOn, wornOn) || other.wornOn == wornOn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,outfitId,wardrobeId,wornOn,createdAt);

@override
String toString() {
  return 'WornOnEntry(outfitId: $outfitId, wardrobeId: $wardrobeId, wornOn: $wornOn, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WornOnEntryCopyWith<$Res>  {
  factory $WornOnEntryCopyWith(WornOnEntry value, $Res Function(WornOnEntry) _then) = _$WornOnEntryCopyWithImpl;
@useResult
$Res call({
 String outfitId, String wardrobeId, DateTime wornOn, DateTime createdAt
});




}
/// @nodoc
class _$WornOnEntryCopyWithImpl<$Res>
    implements $WornOnEntryCopyWith<$Res> {
  _$WornOnEntryCopyWithImpl(this._self, this._then);

  final WornOnEntry _self;
  final $Res Function(WornOnEntry) _then;

/// Create a copy of WornOnEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outfitId = null,Object? wardrobeId = null,Object? wornOn = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
outfitId: null == outfitId ? _self.outfitId : outfitId // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,wornOn: null == wornOn ? _self.wornOn : wornOn // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WornOnEntry].
extension WornOnEntryPatterns on WornOnEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WornOnEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WornOnEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WornOnEntry value)  $default,){
final _that = this;
switch (_that) {
case _WornOnEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WornOnEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WornOnEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String outfitId,  String wardrobeId,  DateTime wornOn,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WornOnEntry() when $default != null:
return $default(_that.outfitId,_that.wardrobeId,_that.wornOn,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String outfitId,  String wardrobeId,  DateTime wornOn,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WornOnEntry():
return $default(_that.outfitId,_that.wardrobeId,_that.wornOn,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String outfitId,  String wardrobeId,  DateTime wornOn,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WornOnEntry() when $default != null:
return $default(_that.outfitId,_that.wardrobeId,_that.wornOn,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _WornOnEntry implements WornOnEntry {
  const _WornOnEntry({required this.outfitId, required this.wardrobeId, required this.wornOn, required this.createdAt});
  

@override final  String outfitId;
@override final  String wardrobeId;
@override final  DateTime wornOn;
@override final  DateTime createdAt;

/// Create a copy of WornOnEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WornOnEntryCopyWith<_WornOnEntry> get copyWith => __$WornOnEntryCopyWithImpl<_WornOnEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WornOnEntry&&(identical(other.outfitId, outfitId) || other.outfitId == outfitId)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.wornOn, wornOn) || other.wornOn == wornOn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,outfitId,wardrobeId,wornOn,createdAt);

@override
String toString() {
  return 'WornOnEntry(outfitId: $outfitId, wardrobeId: $wardrobeId, wornOn: $wornOn, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WornOnEntryCopyWith<$Res> implements $WornOnEntryCopyWith<$Res> {
  factory _$WornOnEntryCopyWith(_WornOnEntry value, $Res Function(_WornOnEntry) _then) = __$WornOnEntryCopyWithImpl;
@override @useResult
$Res call({
 String outfitId, String wardrobeId, DateTime wornOn, DateTime createdAt
});




}
/// @nodoc
class __$WornOnEntryCopyWithImpl<$Res>
    implements _$WornOnEntryCopyWith<$Res> {
  __$WornOnEntryCopyWithImpl(this._self, this._then);

  final _WornOnEntry _self;
  final $Res Function(_WornOnEntry) _then;

/// Create a copy of WornOnEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outfitId = null,Object? wardrobeId = null,Object? wornOn = null,Object? createdAt = null,}) {
  return _then(_WornOnEntry(
outfitId: null == outfitId ? _self.outfitId : outfitId // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,wornOn: null == wornOn ? _self.wornOn : wornOn // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
