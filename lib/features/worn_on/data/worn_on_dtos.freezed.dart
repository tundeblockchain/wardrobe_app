// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worn_on_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SetWornOnRequest {

 String get wornOn;
/// Create a copy of SetWornOnRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetWornOnRequestCopyWith<SetWornOnRequest> get copyWith => _$SetWornOnRequestCopyWithImpl<SetWornOnRequest>(this as SetWornOnRequest, _$identity);

  /// Serializes this SetWornOnRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetWornOnRequest&&(identical(other.wornOn, wornOn) || other.wornOn == wornOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wornOn);

@override
String toString() {
  return 'SetWornOnRequest(wornOn: $wornOn)';
}


}

/// @nodoc
abstract mixin class $SetWornOnRequestCopyWith<$Res>  {
  factory $SetWornOnRequestCopyWith(SetWornOnRequest value, $Res Function(SetWornOnRequest) _then) = _$SetWornOnRequestCopyWithImpl;
@useResult
$Res call({
 String wornOn
});




}
/// @nodoc
class _$SetWornOnRequestCopyWithImpl<$Res>
    implements $SetWornOnRequestCopyWith<$Res> {
  _$SetWornOnRequestCopyWithImpl(this._self, this._then);

  final SetWornOnRequest _self;
  final $Res Function(SetWornOnRequest) _then;

/// Create a copy of SetWornOnRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wornOn = null,}) {
  return _then(_self.copyWith(
wornOn: null == wornOn ? _self.wornOn : wornOn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SetWornOnRequest].
extension SetWornOnRequestPatterns on SetWornOnRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetWornOnRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetWornOnRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetWornOnRequest value)  $default,){
final _that = this;
switch (_that) {
case _SetWornOnRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetWornOnRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SetWornOnRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String wornOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetWornOnRequest() when $default != null:
return $default(_that.wornOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String wornOn)  $default,) {final _that = this;
switch (_that) {
case _SetWornOnRequest():
return $default(_that.wornOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String wornOn)?  $default,) {final _that = this;
switch (_that) {
case _SetWornOnRequest() when $default != null:
return $default(_that.wornOn);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SetWornOnRequest implements SetWornOnRequest {
  const _SetWornOnRequest({required this.wornOn});
  factory _SetWornOnRequest.fromJson(Map<String, dynamic> json) => _$SetWornOnRequestFromJson(json);

@override final  String wornOn;

/// Create a copy of SetWornOnRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetWornOnRequestCopyWith<_SetWornOnRequest> get copyWith => __$SetWornOnRequestCopyWithImpl<_SetWornOnRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetWornOnRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetWornOnRequest&&(identical(other.wornOn, wornOn) || other.wornOn == wornOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wornOn);

@override
String toString() {
  return 'SetWornOnRequest(wornOn: $wornOn)';
}


}

/// @nodoc
abstract mixin class _$SetWornOnRequestCopyWith<$Res> implements $SetWornOnRequestCopyWith<$Res> {
  factory _$SetWornOnRequestCopyWith(_SetWornOnRequest value, $Res Function(_SetWornOnRequest) _then) = __$SetWornOnRequestCopyWithImpl;
@override @useResult
$Res call({
 String wornOn
});




}
/// @nodoc
class __$SetWornOnRequestCopyWithImpl<$Res>
    implements _$SetWornOnRequestCopyWith<$Res> {
  __$SetWornOnRequestCopyWithImpl(this._self, this._then);

  final _SetWornOnRequest _self;
  final $Res Function(_SetWornOnRequest) _then;

/// Create a copy of SetWornOnRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wornOn = null,}) {
  return _then(_SetWornOnRequest(
wornOn: null == wornOn ? _self.wornOn : wornOn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WornOnEntryResponse {

 String get outfitId; String get wardrobeId; String get wornOn; DateTime get createdAt;
/// Create a copy of WornOnEntryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WornOnEntryResponseCopyWith<WornOnEntryResponse> get copyWith => _$WornOnEntryResponseCopyWithImpl<WornOnEntryResponse>(this as WornOnEntryResponse, _$identity);

  /// Serializes this WornOnEntryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WornOnEntryResponse&&(identical(other.outfitId, outfitId) || other.outfitId == outfitId)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.wornOn, wornOn) || other.wornOn == wornOn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,outfitId,wardrobeId,wornOn,createdAt);

@override
String toString() {
  return 'WornOnEntryResponse(outfitId: $outfitId, wardrobeId: $wardrobeId, wornOn: $wornOn, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WornOnEntryResponseCopyWith<$Res>  {
  factory $WornOnEntryResponseCopyWith(WornOnEntryResponse value, $Res Function(WornOnEntryResponse) _then) = _$WornOnEntryResponseCopyWithImpl;
@useResult
$Res call({
 String outfitId, String wardrobeId, String wornOn, DateTime createdAt
});




}
/// @nodoc
class _$WornOnEntryResponseCopyWithImpl<$Res>
    implements $WornOnEntryResponseCopyWith<$Res> {
  _$WornOnEntryResponseCopyWithImpl(this._self, this._then);

  final WornOnEntryResponse _self;
  final $Res Function(WornOnEntryResponse) _then;

/// Create a copy of WornOnEntryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outfitId = null,Object? wardrobeId = null,Object? wornOn = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
outfitId: null == outfitId ? _self.outfitId : outfitId // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,wornOn: null == wornOn ? _self.wornOn : wornOn // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WornOnEntryResponse].
extension WornOnEntryResponsePatterns on WornOnEntryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WornOnEntryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WornOnEntryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WornOnEntryResponse value)  $default,){
final _that = this;
switch (_that) {
case _WornOnEntryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WornOnEntryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WornOnEntryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String outfitId,  String wardrobeId,  String wornOn,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WornOnEntryResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String outfitId,  String wardrobeId,  String wornOn,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WornOnEntryResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String outfitId,  String wardrobeId,  String wornOn,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WornOnEntryResponse() when $default != null:
return $default(_that.outfitId,_that.wardrobeId,_that.wornOn,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WornOnEntryResponse extends WornOnEntryResponse {
  const _WornOnEntryResponse({required this.outfitId, required this.wardrobeId, required this.wornOn, required this.createdAt}): super._();
  factory _WornOnEntryResponse.fromJson(Map<String, dynamic> json) => _$WornOnEntryResponseFromJson(json);

@override final  String outfitId;
@override final  String wardrobeId;
@override final  String wornOn;
@override final  DateTime createdAt;

/// Create a copy of WornOnEntryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WornOnEntryResponseCopyWith<_WornOnEntryResponse> get copyWith => __$WornOnEntryResponseCopyWithImpl<_WornOnEntryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WornOnEntryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WornOnEntryResponse&&(identical(other.outfitId, outfitId) || other.outfitId == outfitId)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.wornOn, wornOn) || other.wornOn == wornOn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,outfitId,wardrobeId,wornOn,createdAt);

@override
String toString() {
  return 'WornOnEntryResponse(outfitId: $outfitId, wardrobeId: $wardrobeId, wornOn: $wornOn, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WornOnEntryResponseCopyWith<$Res> implements $WornOnEntryResponseCopyWith<$Res> {
  factory _$WornOnEntryResponseCopyWith(_WornOnEntryResponse value, $Res Function(_WornOnEntryResponse) _then) = __$WornOnEntryResponseCopyWithImpl;
@override @useResult
$Res call({
 String outfitId, String wardrobeId, String wornOn, DateTime createdAt
});




}
/// @nodoc
class __$WornOnEntryResponseCopyWithImpl<$Res>
    implements _$WornOnEntryResponseCopyWith<$Res> {
  __$WornOnEntryResponseCopyWithImpl(this._self, this._then);

  final _WornOnEntryResponse _self;
  final $Res Function(_WornOnEntryResponse) _then;

/// Create a copy of WornOnEntryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outfitId = null,Object? wardrobeId = null,Object? wornOn = null,Object? createdAt = null,}) {
  return _then(_WornOnEntryResponse(
outfitId: null == outfitId ? _self.outfitId : outfitId // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,wornOn: null == wornOn ? _self.wornOn : wornOn // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WornOnListResponse {

 List<WornOnEntryResponse> get entries;
/// Create a copy of WornOnListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WornOnListResponseCopyWith<WornOnListResponse> get copyWith => _$WornOnListResponseCopyWithImpl<WornOnListResponse>(this as WornOnListResponse, _$identity);

  /// Serializes this WornOnListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WornOnListResponse&&const DeepCollectionEquality().equals(other.entries, entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(entries));

@override
String toString() {
  return 'WornOnListResponse(entries: $entries)';
}


}

/// @nodoc
abstract mixin class $WornOnListResponseCopyWith<$Res>  {
  factory $WornOnListResponseCopyWith(WornOnListResponse value, $Res Function(WornOnListResponse) _then) = _$WornOnListResponseCopyWithImpl;
@useResult
$Res call({
 List<WornOnEntryResponse> entries
});




}
/// @nodoc
class _$WornOnListResponseCopyWithImpl<$Res>
    implements $WornOnListResponseCopyWith<$Res> {
  _$WornOnListResponseCopyWithImpl(this._self, this._then);

  final WornOnListResponse _self;
  final $Res Function(WornOnListResponse) _then;

/// Create a copy of WornOnListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,}) {
  return _then(_self.copyWith(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<WornOnEntryResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [WornOnListResponse].
extension WornOnListResponsePatterns on WornOnListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WornOnListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WornOnListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WornOnListResponse value)  $default,){
final _that = this;
switch (_that) {
case _WornOnListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WornOnListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WornOnListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WornOnEntryResponse> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WornOnListResponse() when $default != null:
return $default(_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WornOnEntryResponse> entries)  $default,) {final _that = this;
switch (_that) {
case _WornOnListResponse():
return $default(_that.entries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WornOnEntryResponse> entries)?  $default,) {final _that = this;
switch (_that) {
case _WornOnListResponse() when $default != null:
return $default(_that.entries);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WornOnListResponse extends WornOnListResponse {
  const _WornOnListResponse({required this.entries}): super._();
  factory _WornOnListResponse.fromJson(Map<String, dynamic> json) => _$WornOnListResponseFromJson(json);

@override final  List<WornOnEntryResponse> entries;

/// Create a copy of WornOnListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WornOnListResponseCopyWith<_WornOnListResponse> get copyWith => __$WornOnListResponseCopyWithImpl<_WornOnListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WornOnListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WornOnListResponse&&const DeepCollectionEquality().equals(other.entries, entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(entries));

@override
String toString() {
  return 'WornOnListResponse(entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$WornOnListResponseCopyWith<$Res> implements $WornOnListResponseCopyWith<$Res> {
  factory _$WornOnListResponseCopyWith(_WornOnListResponse value, $Res Function(_WornOnListResponse) _then) = __$WornOnListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<WornOnEntryResponse> entries
});




}
/// @nodoc
class __$WornOnListResponseCopyWithImpl<$Res>
    implements _$WornOnListResponseCopyWith<$Res> {
  __$WornOnListResponseCopyWithImpl(this._self, this._then);

  final _WornOnListResponse _self;
  final $Res Function(_WornOnListResponse) _then;

/// Create a copy of WornOnListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,}) {
  return _then(_WornOnListResponse(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<WornOnEntryResponse>,
  ));
}


}

// dart format on
