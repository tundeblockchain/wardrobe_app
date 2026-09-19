// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterDeviceRequest {

 String get token; String get platform;@JsonKey(includeIfNull: false) String? get deviceId;
/// Create a copy of RegisterDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterDeviceRequestCopyWith<RegisterDeviceRequest> get copyWith => _$RegisterDeviceRequestCopyWithImpl<RegisterDeviceRequest>(this as RegisterDeviceRequest, _$identity);

  /// Serializes this RegisterDeviceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterDeviceRequest&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,platform,deviceId);

@override
String toString() {
  return 'RegisterDeviceRequest(token: $token, platform: $platform, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $RegisterDeviceRequestCopyWith<$Res>  {
  factory $RegisterDeviceRequestCopyWith(RegisterDeviceRequest value, $Res Function(RegisterDeviceRequest) _then) = _$RegisterDeviceRequestCopyWithImpl;
@useResult
$Res call({
 String token, String platform,@JsonKey(includeIfNull: false) String? deviceId
});




}
/// @nodoc
class _$RegisterDeviceRequestCopyWithImpl<$Res>
    implements $RegisterDeviceRequestCopyWith<$Res> {
  _$RegisterDeviceRequestCopyWithImpl(this._self, this._then);

  final RegisterDeviceRequest _self;
  final $Res Function(RegisterDeviceRequest) _then;

/// Create a copy of RegisterDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? platform = null,Object? deviceId = freezed,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterDeviceRequest].
extension RegisterDeviceRequestPatterns on RegisterDeviceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterDeviceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterDeviceRequest value)  $default,){
final _that = this;
switch (_that) {
case _RegisterDeviceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterDeviceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String platform, @JsonKey(includeIfNull: false)  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterDeviceRequest() when $default != null:
return $default(_that.token,_that.platform,_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String platform, @JsonKey(includeIfNull: false)  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _RegisterDeviceRequest():
return $default(_that.token,_that.platform,_that.deviceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String platform, @JsonKey(includeIfNull: false)  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _RegisterDeviceRequest() when $default != null:
return $default(_that.token,_that.platform,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterDeviceRequest implements RegisterDeviceRequest {
  const _RegisterDeviceRequest({required this.token, required this.platform, @JsonKey(includeIfNull: false) this.deviceId});
  factory _RegisterDeviceRequest.fromJson(Map<String, dynamic> json) => _$RegisterDeviceRequestFromJson(json);

@override final  String token;
@override final  String platform;
@override@JsonKey(includeIfNull: false) final  String? deviceId;

/// Create a copy of RegisterDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterDeviceRequestCopyWith<_RegisterDeviceRequest> get copyWith => __$RegisterDeviceRequestCopyWithImpl<_RegisterDeviceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterDeviceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterDeviceRequest&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,platform,deviceId);

@override
String toString() {
  return 'RegisterDeviceRequest(token: $token, platform: $platform, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$RegisterDeviceRequestCopyWith<$Res> implements $RegisterDeviceRequestCopyWith<$Res> {
  factory _$RegisterDeviceRequestCopyWith(_RegisterDeviceRequest value, $Res Function(_RegisterDeviceRequest) _then) = __$RegisterDeviceRequestCopyWithImpl;
@override @useResult
$Res call({
 String token, String platform,@JsonKey(includeIfNull: false) String? deviceId
});




}
/// @nodoc
class __$RegisterDeviceRequestCopyWithImpl<$Res>
    implements _$RegisterDeviceRequestCopyWith<$Res> {
  __$RegisterDeviceRequestCopyWithImpl(this._self, this._then);

  final _RegisterDeviceRequest _self;
  final $Res Function(_RegisterDeviceRequest) _then;

/// Create a copy of RegisterDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? platform = null,Object? deviceId = freezed,}) {
  return _then(_RegisterDeviceRequest(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DeviceRegistrationResponse {

 String get deviceId; String get platform; DateTime get updatedAt;
/// Create a copy of DeviceRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceRegistrationResponseCopyWith<DeviceRegistrationResponse> get copyWith => _$DeviceRegistrationResponseCopyWithImpl<DeviceRegistrationResponse>(this as DeviceRegistrationResponse, _$identity);

  /// Serializes this DeviceRegistrationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceRegistrationResponse&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,platform,updatedAt);

@override
String toString() {
  return 'DeviceRegistrationResponse(deviceId: $deviceId, platform: $platform, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DeviceRegistrationResponseCopyWith<$Res>  {
  factory $DeviceRegistrationResponseCopyWith(DeviceRegistrationResponse value, $Res Function(DeviceRegistrationResponse) _then) = _$DeviceRegistrationResponseCopyWithImpl;
@useResult
$Res call({
 String deviceId, String platform, DateTime updatedAt
});




}
/// @nodoc
class _$DeviceRegistrationResponseCopyWithImpl<$Res>
    implements $DeviceRegistrationResponseCopyWith<$Res> {
  _$DeviceRegistrationResponseCopyWithImpl(this._self, this._then);

  final DeviceRegistrationResponse _self;
  final $Res Function(DeviceRegistrationResponse) _then;

/// Create a copy of DeviceRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? platform = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceRegistrationResponse].
extension DeviceRegistrationResponsePatterns on DeviceRegistrationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceRegistrationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceRegistrationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceRegistrationResponse value)  $default,){
final _that = this;
switch (_that) {
case _DeviceRegistrationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceRegistrationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceRegistrationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String platform,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceRegistrationResponse() when $default != null:
return $default(_that.deviceId,_that.platform,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String platform,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DeviceRegistrationResponse():
return $default(_that.deviceId,_that.platform,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String platform,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DeviceRegistrationResponse() when $default != null:
return $default(_that.deviceId,_that.platform,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceRegistrationResponse extends DeviceRegistrationResponse {
  const _DeviceRegistrationResponse({required this.deviceId, required this.platform, required this.updatedAt}): super._();
  factory _DeviceRegistrationResponse.fromJson(Map<String, dynamic> json) => _$DeviceRegistrationResponseFromJson(json);

@override final  String deviceId;
@override final  String platform;
@override final  DateTime updatedAt;

/// Create a copy of DeviceRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceRegistrationResponseCopyWith<_DeviceRegistrationResponse> get copyWith => __$DeviceRegistrationResponseCopyWithImpl<_DeviceRegistrationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceRegistrationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceRegistrationResponse&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,platform,updatedAt);

@override
String toString() {
  return 'DeviceRegistrationResponse(deviceId: $deviceId, platform: $platform, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DeviceRegistrationResponseCopyWith<$Res> implements $DeviceRegistrationResponseCopyWith<$Res> {
  factory _$DeviceRegistrationResponseCopyWith(_DeviceRegistrationResponse value, $Res Function(_DeviceRegistrationResponse) _then) = __$DeviceRegistrationResponseCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String platform, DateTime updatedAt
});




}
/// @nodoc
class __$DeviceRegistrationResponseCopyWithImpl<$Res>
    implements _$DeviceRegistrationResponseCopyWith<$Res> {
  __$DeviceRegistrationResponseCopyWithImpl(this._self, this._then);

  final _DeviceRegistrationResponse _self;
  final $Res Function(_DeviceRegistrationResponse) _then;

/// Create a copy of DeviceRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? platform = null,Object? updatedAt = null,}) {
  return _then(_DeviceRegistrationResponse(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
