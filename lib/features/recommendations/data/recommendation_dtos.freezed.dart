// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecommendationItemResponse {

 String get itemId; String get slot;
/// Create a copy of RecommendationItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationItemResponseCopyWith<RecommendationItemResponse> get copyWith => _$RecommendationItemResponseCopyWithImpl<RecommendationItemResponse>(this as RecommendationItemResponse, _$identity);

  /// Serializes this RecommendationItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendationItemResponse&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.slot, slot) || other.slot == slot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,slot);

@override
String toString() {
  return 'RecommendationItemResponse(itemId: $itemId, slot: $slot)';
}


}

/// @nodoc
abstract mixin class $RecommendationItemResponseCopyWith<$Res>  {
  factory $RecommendationItemResponseCopyWith(RecommendationItemResponse value, $Res Function(RecommendationItemResponse) _then) = _$RecommendationItemResponseCopyWithImpl;
@useResult
$Res call({
 String itemId, String slot
});




}
/// @nodoc
class _$RecommendationItemResponseCopyWithImpl<$Res>
    implements $RecommendationItemResponseCopyWith<$Res> {
  _$RecommendationItemResponseCopyWithImpl(this._self, this._then);

  final RecommendationItemResponse _self;
  final $Res Function(RecommendationItemResponse) _then;

/// Create a copy of RecommendationItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? slot = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RecommendationItemResponse].
extension RecommendationItemResponsePatterns on RecommendationItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendationItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendationItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendationItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _RecommendationItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendationItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendationItemResponse() when $default != null:
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
case _RecommendationItemResponse() when $default != null:
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
case _RecommendationItemResponse():
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
case _RecommendationItemResponse() when $default != null:
return $default(_that.itemId,_that.slot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecommendationItemResponse extends RecommendationItemResponse {
  const _RecommendationItemResponse({required this.itemId, required this.slot}): super._();
  factory _RecommendationItemResponse.fromJson(Map<String, dynamic> json) => _$RecommendationItemResponseFromJson(json);

@override final  String itemId;
@override final  String slot;

/// Create a copy of RecommendationItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationItemResponseCopyWith<_RecommendationItemResponse> get copyWith => __$RecommendationItemResponseCopyWithImpl<_RecommendationItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecommendationItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendationItemResponse&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.slot, slot) || other.slot == slot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,slot);

@override
String toString() {
  return 'RecommendationItemResponse(itemId: $itemId, slot: $slot)';
}


}

/// @nodoc
abstract mixin class _$RecommendationItemResponseCopyWith<$Res> implements $RecommendationItemResponseCopyWith<$Res> {
  factory _$RecommendationItemResponseCopyWith(_RecommendationItemResponse value, $Res Function(_RecommendationItemResponse) _then) = __$RecommendationItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String slot
});




}
/// @nodoc
class __$RecommendationItemResponseCopyWithImpl<$Res>
    implements _$RecommendationItemResponseCopyWith<$Res> {
  __$RecommendationItemResponseCopyWithImpl(this._self, this._then);

  final _RecommendationItemResponse _self;
  final $Res Function(_RecommendationItemResponse) _then;

/// Create a copy of RecommendationItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? slot = null,}) {
  return _then(_RecommendationItemResponse(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RecommendationResponse {

 String? get name; List<RecommendationItemResponse> get items;
/// Create a copy of RecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationResponseCopyWith<RecommendationResponse> get copyWith => _$RecommendationResponseCopyWithImpl<RecommendationResponse>(this as RecommendationResponse, _$identity);

  /// Serializes this RecommendationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendationResponse&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'RecommendationResponse(name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class $RecommendationResponseCopyWith<$Res>  {
  factory $RecommendationResponseCopyWith(RecommendationResponse value, $Res Function(RecommendationResponse) _then) = _$RecommendationResponseCopyWithImpl;
@useResult
$Res call({
 String? name, List<RecommendationItemResponse> items
});




}
/// @nodoc
class _$RecommendationResponseCopyWithImpl<$Res>
    implements $RecommendationResponseCopyWith<$Res> {
  _$RecommendationResponseCopyWithImpl(this._self, this._then);

  final RecommendationResponse _self;
  final $Res Function(RecommendationResponse) _then;

/// Create a copy of RecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<RecommendationItemResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [RecommendationResponse].
extension RecommendationResponsePatterns on RecommendationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendationResponse value)  $default,){
final _that = this;
switch (_that) {
case _RecommendationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  List<RecommendationItemResponse> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendationResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  List<RecommendationItemResponse> items)  $default,) {final _that = this;
switch (_that) {
case _RecommendationResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  List<RecommendationItemResponse> items)?  $default,) {final _that = this;
switch (_that) {
case _RecommendationResponse() when $default != null:
return $default(_that.name,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecommendationResponse extends RecommendationResponse {
  const _RecommendationResponse({this.name, this.items = const []}): super._();
  factory _RecommendationResponse.fromJson(Map<String, dynamic> json) => _$RecommendationResponseFromJson(json);

@override final  String? name;
@override@JsonKey() final  List<RecommendationItemResponse> items;

/// Create a copy of RecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationResponseCopyWith<_RecommendationResponse> get copyWith => __$RecommendationResponseCopyWithImpl<_RecommendationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecommendationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendationResponse&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'RecommendationResponse(name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class _$RecommendationResponseCopyWith<$Res> implements $RecommendationResponseCopyWith<$Res> {
  factory _$RecommendationResponseCopyWith(_RecommendationResponse value, $Res Function(_RecommendationResponse) _then) = __$RecommendationResponseCopyWithImpl;
@override @useResult
$Res call({
 String? name, List<RecommendationItemResponse> items
});




}
/// @nodoc
class __$RecommendationResponseCopyWithImpl<$Res>
    implements _$RecommendationResponseCopyWith<$Res> {
  __$RecommendationResponseCopyWithImpl(this._self, this._then);

  final _RecommendationResponse _self;
  final $Res Function(_RecommendationResponse) _then;

/// Create a copy of RecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? items = null,}) {
  return _then(_RecommendationResponse(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<RecommendationItemResponse>,
  ));
}


}


/// @nodoc
mixin _$RecommendationListResponse {

 List<RecommendationResponse> get recommendations;
/// Create a copy of RecommendationListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationListResponseCopyWith<RecommendationListResponse> get copyWith => _$RecommendationListResponseCopyWithImpl<RecommendationListResponse>(this as RecommendationListResponse, _$identity);

  /// Serializes this RecommendationListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendationListResponse&&const DeepCollectionEquality().equals(other.recommendations, recommendations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(recommendations));

@override
String toString() {
  return 'RecommendationListResponse(recommendations: $recommendations)';
}


}

/// @nodoc
abstract mixin class $RecommendationListResponseCopyWith<$Res>  {
  factory $RecommendationListResponseCopyWith(RecommendationListResponse value, $Res Function(RecommendationListResponse) _then) = _$RecommendationListResponseCopyWithImpl;
@useResult
$Res call({
 List<RecommendationResponse> recommendations
});




}
/// @nodoc
class _$RecommendationListResponseCopyWithImpl<$Res>
    implements $RecommendationListResponseCopyWith<$Res> {
  _$RecommendationListResponseCopyWithImpl(this._self, this._then);

  final RecommendationListResponse _self;
  final $Res Function(RecommendationListResponse) _then;

/// Create a copy of RecommendationListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recommendations = null,}) {
  return _then(_self.copyWith(
recommendations: null == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<RecommendationResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [RecommendationListResponse].
extension RecommendationListResponsePatterns on RecommendationListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendationListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendationListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendationListResponse value)  $default,){
final _that = this;
switch (_that) {
case _RecommendationListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendationListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendationListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RecommendationResponse> recommendations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendationListResponse() when $default != null:
return $default(_that.recommendations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RecommendationResponse> recommendations)  $default,) {final _that = this;
switch (_that) {
case _RecommendationListResponse():
return $default(_that.recommendations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RecommendationResponse> recommendations)?  $default,) {final _that = this;
switch (_that) {
case _RecommendationListResponse() when $default != null:
return $default(_that.recommendations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecommendationListResponse extends RecommendationListResponse {
  const _RecommendationListResponse({required this.recommendations}): super._();
  factory _RecommendationListResponse.fromJson(Map<String, dynamic> json) => _$RecommendationListResponseFromJson(json);

@override final  List<RecommendationResponse> recommendations;

/// Create a copy of RecommendationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationListResponseCopyWith<_RecommendationListResponse> get copyWith => __$RecommendationListResponseCopyWithImpl<_RecommendationListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecommendationListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendationListResponse&&const DeepCollectionEquality().equals(other.recommendations, recommendations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(recommendations));

@override
String toString() {
  return 'RecommendationListResponse(recommendations: $recommendations)';
}


}

/// @nodoc
abstract mixin class _$RecommendationListResponseCopyWith<$Res> implements $RecommendationListResponseCopyWith<$Res> {
  factory _$RecommendationListResponseCopyWith(_RecommendationListResponse value, $Res Function(_RecommendationListResponse) _then) = __$RecommendationListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<RecommendationResponse> recommendations
});




}
/// @nodoc
class __$RecommendationListResponseCopyWithImpl<$Res>
    implements _$RecommendationListResponseCopyWith<$Res> {
  __$RecommendationListResponseCopyWithImpl(this._self, this._then);

  final _RecommendationListResponse _self;
  final $Res Function(_RecommendationListResponse) _then;

/// Create a copy of RecommendationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recommendations = null,}) {
  return _then(_RecommendationListResponse(
recommendations: null == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<RecommendationResponse>,
  ));
}


}

// dart format on
