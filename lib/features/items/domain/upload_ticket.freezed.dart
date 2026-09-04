// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_ticket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UploadTicket {

 String get uploadUrl; String get objectKey; int get expiresIn;
/// Create a copy of UploadTicket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadTicketCopyWith<UploadTicket> get copyWith => _$UploadTicketCopyWithImpl<UploadTicket>(this as UploadTicket, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadTicket&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}


@override
int get hashCode => Object.hash(runtimeType,uploadUrl,objectKey,expiresIn);

@override
String toString() {
  return 'UploadTicket(uploadUrl: $uploadUrl, objectKey: $objectKey, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class $UploadTicketCopyWith<$Res>  {
  factory $UploadTicketCopyWith(UploadTicket value, $Res Function(UploadTicket) _then) = _$UploadTicketCopyWithImpl;
@useResult
$Res call({
 String uploadUrl, String objectKey, int expiresIn
});




}
/// @nodoc
class _$UploadTicketCopyWithImpl<$Res>
    implements $UploadTicketCopyWith<$Res> {
  _$UploadTicketCopyWithImpl(this._self, this._then);

  final UploadTicket _self;
  final $Res Function(UploadTicket) _then;

/// Create a copy of UploadTicket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uploadUrl = null,Object? objectKey = null,Object? expiresIn = null,}) {
  return _then(_self.copyWith(
uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,objectKey: null == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadTicket].
extension UploadTicketPatterns on UploadTicket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadTicket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadTicket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadTicket value)  $default,){
final _that = this;
switch (_that) {
case _UploadTicket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadTicket value)?  $default,){
final _that = this;
switch (_that) {
case _UploadTicket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uploadUrl,  String objectKey,  int expiresIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadTicket() when $default != null:
return $default(_that.uploadUrl,_that.objectKey,_that.expiresIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uploadUrl,  String objectKey,  int expiresIn)  $default,) {final _that = this;
switch (_that) {
case _UploadTicket():
return $default(_that.uploadUrl,_that.objectKey,_that.expiresIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uploadUrl,  String objectKey,  int expiresIn)?  $default,) {final _that = this;
switch (_that) {
case _UploadTicket() when $default != null:
return $default(_that.uploadUrl,_that.objectKey,_that.expiresIn);case _:
  return null;

}
}

}

/// @nodoc


class _UploadTicket implements UploadTicket {
  const _UploadTicket({required this.uploadUrl, required this.objectKey, required this.expiresIn});
  

@override final  String uploadUrl;
@override final  String objectKey;
@override final  int expiresIn;

/// Create a copy of UploadTicket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadTicketCopyWith<_UploadTicket> get copyWith => __$UploadTicketCopyWithImpl<_UploadTicket>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadTicket&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}


@override
int get hashCode => Object.hash(runtimeType,uploadUrl,objectKey,expiresIn);

@override
String toString() {
  return 'UploadTicket(uploadUrl: $uploadUrl, objectKey: $objectKey, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class _$UploadTicketCopyWith<$Res> implements $UploadTicketCopyWith<$Res> {
  factory _$UploadTicketCopyWith(_UploadTicket value, $Res Function(_UploadTicket) _then) = __$UploadTicketCopyWithImpl;
@override @useResult
$Res call({
 String uploadUrl, String objectKey, int expiresIn
});




}
/// @nodoc
class __$UploadTicketCopyWithImpl<$Res>
    implements _$UploadTicketCopyWith<$Res> {
  __$UploadTicketCopyWithImpl(this._self, this._then);

  final _UploadTicket _self;
  final $Res Function(_UploadTicket) _then;

/// Create a copy of UploadTicket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uploadUrl = null,Object? objectKey = null,Object? expiresIn = null,}) {
  return _then(_UploadTicket(
uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,objectKey: null == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
