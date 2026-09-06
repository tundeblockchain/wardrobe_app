// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportRequest {

 String get subject; String get message;@JsonKey(includeIfNull: false) String? get device;@JsonKey(includeIfNull: false) String? get appVersion;
/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportRequestCopyWith<SupportRequest> get copyWith => _$SupportRequestCopyWithImpl<SupportRequest>(this as SupportRequest, _$identity);

  /// Serializes this SupportRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportRequest&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.message, message) || other.message == message)&&(identical(other.device, device) || other.device == device)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,message,device,appVersion);

@override
String toString() {
  return 'SupportRequest(subject: $subject, message: $message, device: $device, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class $SupportRequestCopyWith<$Res>  {
  factory $SupportRequestCopyWith(SupportRequest value, $Res Function(SupportRequest) _then) = _$SupportRequestCopyWithImpl;
@useResult
$Res call({
 String subject, String message,@JsonKey(includeIfNull: false) String? device,@JsonKey(includeIfNull: false) String? appVersion
});




}
/// @nodoc
class _$SupportRequestCopyWithImpl<$Res>
    implements $SupportRequestCopyWith<$Res> {
  _$SupportRequestCopyWithImpl(this._self, this._then);

  final SupportRequest _self;
  final $Res Function(SupportRequest) _then;

/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subject = null,Object? message = null,Object? device = freezed,Object? appVersion = freezed,}) {
  return _then(_self.copyWith(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportRequest].
extension SupportRequestPatterns on SupportRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportRequest value)  $default,){
final _that = this;
switch (_that) {
case _SupportRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subject,  String message, @JsonKey(includeIfNull: false)  String? device, @JsonKey(includeIfNull: false)  String? appVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
return $default(_that.subject,_that.message,_that.device,_that.appVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subject,  String message, @JsonKey(includeIfNull: false)  String? device, @JsonKey(includeIfNull: false)  String? appVersion)  $default,) {final _that = this;
switch (_that) {
case _SupportRequest():
return $default(_that.subject,_that.message,_that.device,_that.appVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subject,  String message, @JsonKey(includeIfNull: false)  String? device, @JsonKey(includeIfNull: false)  String? appVersion)?  $default,) {final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
return $default(_that.subject,_that.message,_that.device,_that.appVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupportRequest implements SupportRequest {
  const _SupportRequest({required this.subject, required this.message, @JsonKey(includeIfNull: false) this.device, @JsonKey(includeIfNull: false) this.appVersion});
  factory _SupportRequest.fromJson(Map<String, dynamic> json) => _$SupportRequestFromJson(json);

@override final  String subject;
@override final  String message;
@override@JsonKey(includeIfNull: false) final  String? device;
@override@JsonKey(includeIfNull: false) final  String? appVersion;

/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportRequestCopyWith<_SupportRequest> get copyWith => __$SupportRequestCopyWithImpl<_SupportRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportRequest&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.message, message) || other.message == message)&&(identical(other.device, device) || other.device == device)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,message,device,appVersion);

@override
String toString() {
  return 'SupportRequest(subject: $subject, message: $message, device: $device, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class _$SupportRequestCopyWith<$Res> implements $SupportRequestCopyWith<$Res> {
  factory _$SupportRequestCopyWith(_SupportRequest value, $Res Function(_SupportRequest) _then) = __$SupportRequestCopyWithImpl;
@override @useResult
$Res call({
 String subject, String message,@JsonKey(includeIfNull: false) String? device,@JsonKey(includeIfNull: false) String? appVersion
});




}
/// @nodoc
class __$SupportRequestCopyWithImpl<$Res>
    implements _$SupportRequestCopyWith<$Res> {
  __$SupportRequestCopyWithImpl(this._self, this._then);

  final _SupportRequest _self;
  final $Res Function(_SupportRequest) _then;

/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subject = null,Object? message = null,Object? device = freezed,Object? appVersion = freezed,}) {
  return _then(_SupportRequest(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
