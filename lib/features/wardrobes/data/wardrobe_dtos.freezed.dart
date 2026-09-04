// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wardrobe_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WardrobeResponse {

 String get wardrobeId; String get name; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of WardrobeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WardrobeResponseCopyWith<WardrobeResponse> get copyWith => _$WardrobeResponseCopyWithImpl<WardrobeResponse>(this as WardrobeResponse, _$identity);

  /// Serializes this WardrobeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WardrobeResponse&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wardrobeId,name,createdAt,updatedAt);

@override
String toString() {
  return 'WardrobeResponse(wardrobeId: $wardrobeId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WardrobeResponseCopyWith<$Res>  {
  factory $WardrobeResponseCopyWith(WardrobeResponse value, $Res Function(WardrobeResponse) _then) = _$WardrobeResponseCopyWithImpl;
@useResult
$Res call({
 String wardrobeId, String name, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$WardrobeResponseCopyWithImpl<$Res>
    implements $WardrobeResponseCopyWith<$Res> {
  _$WardrobeResponseCopyWithImpl(this._self, this._then);

  final WardrobeResponse _self;
  final $Res Function(WardrobeResponse) _then;

/// Create a copy of WardrobeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wardrobeId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WardrobeResponse].
extension WardrobeResponsePatterns on WardrobeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WardrobeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WardrobeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WardrobeResponse value)  $default,){
final _that = this;
switch (_that) {
case _WardrobeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WardrobeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WardrobeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String wardrobeId,  String name,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WardrobeResponse() when $default != null:
return $default(_that.wardrobeId,_that.name,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String wardrobeId,  String name,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WardrobeResponse():
return $default(_that.wardrobeId,_that.name,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String wardrobeId,  String name,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WardrobeResponse() when $default != null:
return $default(_that.wardrobeId,_that.name,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WardrobeResponse extends WardrobeResponse {
  const _WardrobeResponse({required this.wardrobeId, required this.name, required this.createdAt, required this.updatedAt}): super._();
  factory _WardrobeResponse.fromJson(Map<String, dynamic> json) => _$WardrobeResponseFromJson(json);

@override final  String wardrobeId;
@override final  String name;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of WardrobeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WardrobeResponseCopyWith<_WardrobeResponse> get copyWith => __$WardrobeResponseCopyWithImpl<_WardrobeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WardrobeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WardrobeResponse&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wardrobeId,name,createdAt,updatedAt);

@override
String toString() {
  return 'WardrobeResponse(wardrobeId: $wardrobeId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WardrobeResponseCopyWith<$Res> implements $WardrobeResponseCopyWith<$Res> {
  factory _$WardrobeResponseCopyWith(_WardrobeResponse value, $Res Function(_WardrobeResponse) _then) = __$WardrobeResponseCopyWithImpl;
@override @useResult
$Res call({
 String wardrobeId, String name, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$WardrobeResponseCopyWithImpl<$Res>
    implements _$WardrobeResponseCopyWith<$Res> {
  __$WardrobeResponseCopyWithImpl(this._self, this._then);

  final _WardrobeResponse _self;
  final $Res Function(_WardrobeResponse) _then;

/// Create a copy of WardrobeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wardrobeId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_WardrobeResponse(
wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WardrobeListResponse {

 List<WardrobeResponse> get wardrobes;
/// Create a copy of WardrobeListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WardrobeListResponseCopyWith<WardrobeListResponse> get copyWith => _$WardrobeListResponseCopyWithImpl<WardrobeListResponse>(this as WardrobeListResponse, _$identity);

  /// Serializes this WardrobeListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WardrobeListResponse&&const DeepCollectionEquality().equals(other.wardrobes, wardrobes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(wardrobes));

@override
String toString() {
  return 'WardrobeListResponse(wardrobes: $wardrobes)';
}


}

/// @nodoc
abstract mixin class $WardrobeListResponseCopyWith<$Res>  {
  factory $WardrobeListResponseCopyWith(WardrobeListResponse value, $Res Function(WardrobeListResponse) _then) = _$WardrobeListResponseCopyWithImpl;
@useResult
$Res call({
 List<WardrobeResponse> wardrobes
});




}
/// @nodoc
class _$WardrobeListResponseCopyWithImpl<$Res>
    implements $WardrobeListResponseCopyWith<$Res> {
  _$WardrobeListResponseCopyWithImpl(this._self, this._then);

  final WardrobeListResponse _self;
  final $Res Function(WardrobeListResponse) _then;

/// Create a copy of WardrobeListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wardrobes = null,}) {
  return _then(_self.copyWith(
wardrobes: null == wardrobes ? _self.wardrobes : wardrobes // ignore: cast_nullable_to_non_nullable
as List<WardrobeResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [WardrobeListResponse].
extension WardrobeListResponsePatterns on WardrobeListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WardrobeListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WardrobeListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WardrobeListResponse value)  $default,){
final _that = this;
switch (_that) {
case _WardrobeListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WardrobeListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WardrobeListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WardrobeResponse> wardrobes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WardrobeListResponse() when $default != null:
return $default(_that.wardrobes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WardrobeResponse> wardrobes)  $default,) {final _that = this;
switch (_that) {
case _WardrobeListResponse():
return $default(_that.wardrobes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WardrobeResponse> wardrobes)?  $default,) {final _that = this;
switch (_that) {
case _WardrobeListResponse() when $default != null:
return $default(_that.wardrobes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WardrobeListResponse extends WardrobeListResponse {
  const _WardrobeListResponse({required this.wardrobes}): super._();
  factory _WardrobeListResponse.fromJson(Map<String, dynamic> json) => _$WardrobeListResponseFromJson(json);

@override final  List<WardrobeResponse> wardrobes;

/// Create a copy of WardrobeListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WardrobeListResponseCopyWith<_WardrobeListResponse> get copyWith => __$WardrobeListResponseCopyWithImpl<_WardrobeListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WardrobeListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WardrobeListResponse&&const DeepCollectionEquality().equals(other.wardrobes, wardrobes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(wardrobes));

@override
String toString() {
  return 'WardrobeListResponse(wardrobes: $wardrobes)';
}


}

/// @nodoc
abstract mixin class _$WardrobeListResponseCopyWith<$Res> implements $WardrobeListResponseCopyWith<$Res> {
  factory _$WardrobeListResponseCopyWith(_WardrobeListResponse value, $Res Function(_WardrobeListResponse) _then) = __$WardrobeListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<WardrobeResponse> wardrobes
});




}
/// @nodoc
class __$WardrobeListResponseCopyWithImpl<$Res>
    implements _$WardrobeListResponseCopyWith<$Res> {
  __$WardrobeListResponseCopyWithImpl(this._self, this._then);

  final _WardrobeListResponse _self;
  final $Res Function(_WardrobeListResponse) _then;

/// Create a copy of WardrobeListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wardrobes = null,}) {
  return _then(_WardrobeListResponse(
wardrobes: null == wardrobes ? _self.wardrobes : wardrobes // ignore: cast_nullable_to_non_nullable
as List<WardrobeResponse>,
  ));
}


}


/// @nodoc
mixin _$CreateWardrobeRequest {

 String get name;
/// Create a copy of CreateWardrobeRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWardrobeRequestCopyWith<CreateWardrobeRequest> get copyWith => _$CreateWardrobeRequestCopyWithImpl<CreateWardrobeRequest>(this as CreateWardrobeRequest, _$identity);

  /// Serializes this CreateWardrobeRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWardrobeRequest&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CreateWardrobeRequest(name: $name)';
}


}

/// @nodoc
abstract mixin class $CreateWardrobeRequestCopyWith<$Res>  {
  factory $CreateWardrobeRequestCopyWith(CreateWardrobeRequest value, $Res Function(CreateWardrobeRequest) _then) = _$CreateWardrobeRequestCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$CreateWardrobeRequestCopyWithImpl<$Res>
    implements $CreateWardrobeRequestCopyWith<$Res> {
  _$CreateWardrobeRequestCopyWithImpl(this._self, this._then);

  final CreateWardrobeRequest _self;
  final $Res Function(CreateWardrobeRequest) _then;

/// Create a copy of CreateWardrobeRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateWardrobeRequest].
extension CreateWardrobeRequestPatterns on CreateWardrobeRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWardrobeRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWardrobeRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWardrobeRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateWardrobeRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWardrobeRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWardrobeRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWardrobeRequest() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name)  $default,) {final _that = this;
switch (_that) {
case _CreateWardrobeRequest():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name)?  $default,) {final _that = this;
switch (_that) {
case _CreateWardrobeRequest() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWardrobeRequest implements CreateWardrobeRequest {
  const _CreateWardrobeRequest({required this.name});
  factory _CreateWardrobeRequest.fromJson(Map<String, dynamic> json) => _$CreateWardrobeRequestFromJson(json);

@override final  String name;

/// Create a copy of CreateWardrobeRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWardrobeRequestCopyWith<_CreateWardrobeRequest> get copyWith => __$CreateWardrobeRequestCopyWithImpl<_CreateWardrobeRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWardrobeRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWardrobeRequest&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CreateWardrobeRequest(name: $name)';
}


}

/// @nodoc
abstract mixin class _$CreateWardrobeRequestCopyWith<$Res> implements $CreateWardrobeRequestCopyWith<$Res> {
  factory _$CreateWardrobeRequestCopyWith(_CreateWardrobeRequest value, $Res Function(_CreateWardrobeRequest) _then) = __$CreateWardrobeRequestCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$CreateWardrobeRequestCopyWithImpl<$Res>
    implements _$CreateWardrobeRequestCopyWith<$Res> {
  __$CreateWardrobeRequestCopyWithImpl(this._self, this._then);

  final _CreateWardrobeRequest _self;
  final $Res Function(_CreateWardrobeRequest) _then;

/// Create a copy of CreateWardrobeRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_CreateWardrobeRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UpdateWardrobeRequest {

 String get name;
/// Create a copy of UpdateWardrobeRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWardrobeRequestCopyWith<UpdateWardrobeRequest> get copyWith => _$UpdateWardrobeRequestCopyWithImpl<UpdateWardrobeRequest>(this as UpdateWardrobeRequest, _$identity);

  /// Serializes this UpdateWardrobeRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWardrobeRequest&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'UpdateWardrobeRequest(name: $name)';
}


}

/// @nodoc
abstract mixin class $UpdateWardrobeRequestCopyWith<$Res>  {
  factory $UpdateWardrobeRequestCopyWith(UpdateWardrobeRequest value, $Res Function(UpdateWardrobeRequest) _then) = _$UpdateWardrobeRequestCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$UpdateWardrobeRequestCopyWithImpl<$Res>
    implements $UpdateWardrobeRequestCopyWith<$Res> {
  _$UpdateWardrobeRequestCopyWithImpl(this._self, this._then);

  final UpdateWardrobeRequest _self;
  final $Res Function(UpdateWardrobeRequest) _then;

/// Create a copy of UpdateWardrobeRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWardrobeRequest].
extension UpdateWardrobeRequestPatterns on UpdateWardrobeRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWardrobeRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWardrobeRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWardrobeRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWardrobeRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWardrobeRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWardrobeRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWardrobeRequest() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name)  $default,) {final _that = this;
switch (_that) {
case _UpdateWardrobeRequest():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWardrobeRequest() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWardrobeRequest implements UpdateWardrobeRequest {
  const _UpdateWardrobeRequest({required this.name});
  factory _UpdateWardrobeRequest.fromJson(Map<String, dynamic> json) => _$UpdateWardrobeRequestFromJson(json);

@override final  String name;

/// Create a copy of UpdateWardrobeRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWardrobeRequestCopyWith<_UpdateWardrobeRequest> get copyWith => __$UpdateWardrobeRequestCopyWithImpl<_UpdateWardrobeRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWardrobeRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWardrobeRequest&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'UpdateWardrobeRequest(name: $name)';
}


}

/// @nodoc
abstract mixin class _$UpdateWardrobeRequestCopyWith<$Res> implements $UpdateWardrobeRequestCopyWith<$Res> {
  factory _$UpdateWardrobeRequestCopyWith(_UpdateWardrobeRequest value, $Res Function(_UpdateWardrobeRequest) _then) = __$UpdateWardrobeRequestCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$UpdateWardrobeRequestCopyWithImpl<$Res>
    implements _$UpdateWardrobeRequestCopyWith<$Res> {
  __$UpdateWardrobeRequestCopyWithImpl(this._self, this._then);

  final _UpdateWardrobeRequest _self;
  final $Res Function(_UpdateWardrobeRequest) _then;

/// Create a copy of UpdateWardrobeRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_UpdateWardrobeRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
