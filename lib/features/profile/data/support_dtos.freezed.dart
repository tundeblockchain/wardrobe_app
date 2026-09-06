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

 String get subject; String get body;@JsonKey(includeIfNull: false) String? get replyTo;@JsonKey(includeIfNull: false) Map<String, String>? get meta;
/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportRequestCopyWith<SupportRequest> get copyWith => _$SupportRequestCopyWithImpl<SupportRequest>(this as SupportRequest, _$identity);

  /// Serializes this SupportRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportRequest&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.body, body) || other.body == body)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&const DeepCollectionEquality().equals(other.meta, meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,body,replyTo,const DeepCollectionEquality().hash(meta));

@override
String toString() {
  return 'SupportRequest(subject: $subject, body: $body, replyTo: $replyTo, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $SupportRequestCopyWith<$Res>  {
  factory $SupportRequestCopyWith(SupportRequest value, $Res Function(SupportRequest) _then) = _$SupportRequestCopyWithImpl;
@useResult
$Res call({
 String subject, String body,@JsonKey(includeIfNull: false) String? replyTo,@JsonKey(includeIfNull: false) Map<String, String>? meta
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
@pragma('vm:prefer-inline') @override $Res call({Object? subject = null,Object? body = null,Object? replyTo = freezed,Object? meta = freezed,}) {
  return _then(_self.copyWith(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as String?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subject,  String body, @JsonKey(includeIfNull: false)  String? replyTo, @JsonKey(includeIfNull: false)  Map<String, String>? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
return $default(_that.subject,_that.body,_that.replyTo,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subject,  String body, @JsonKey(includeIfNull: false)  String? replyTo, @JsonKey(includeIfNull: false)  Map<String, String>? meta)  $default,) {final _that = this;
switch (_that) {
case _SupportRequest():
return $default(_that.subject,_that.body,_that.replyTo,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subject,  String body, @JsonKey(includeIfNull: false)  String? replyTo, @JsonKey(includeIfNull: false)  Map<String, String>? meta)?  $default,) {final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
return $default(_that.subject,_that.body,_that.replyTo,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupportRequest implements SupportRequest {
  const _SupportRequest({required this.subject, required this.body, @JsonKey(includeIfNull: false) this.replyTo, @JsonKey(includeIfNull: false) this.meta});
  factory _SupportRequest.fromJson(Map<String, dynamic> json) => _$SupportRequestFromJson(json);

@override final  String subject;
@override final  String body;
@override@JsonKey(includeIfNull: false) final  String? replyTo;
@override@JsonKey(includeIfNull: false) final  Map<String, String>? meta;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportRequest&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.body, body) || other.body == body)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&const DeepCollectionEquality().equals(other.meta, meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,body,replyTo,const DeepCollectionEquality().hash(meta));

@override
String toString() {
  return 'SupportRequest(subject: $subject, body: $body, replyTo: $replyTo, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$SupportRequestCopyWith<$Res> implements $SupportRequestCopyWith<$Res> {
  factory _$SupportRequestCopyWith(_SupportRequest value, $Res Function(_SupportRequest) _then) = __$SupportRequestCopyWithImpl;
@override @useResult
$Res call({
 String subject, String body,@JsonKey(includeIfNull: false) String? replyTo,@JsonKey(includeIfNull: false) Map<String, String>? meta
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
@override @pragma('vm:prefer-inline') $Res call({Object? subject = null,Object? body = null,Object? replyTo = freezed,Object? meta = freezed,}) {
  return _then(_SupportRequest(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as String?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}

// dart format on
