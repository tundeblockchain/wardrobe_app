// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_event_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobEventResponse {

 String get eventId; String get jobType; String get status; String get wardrobeId;@JsonKey(includeIfNull: false) String? get itemId;@JsonKey(includeIfNull: false) String? get outfitId;@JsonKey(includeIfNull: false) String? get renderId;@JsonKey(includeIfNull: false) String? get aiProfileId;@JsonKey(includeIfNull: false) String? get error; DateTime get createdAt;@JsonKey(includeIfNull: false) DateTime? get acknowledgedAt;
/// Create a copy of JobEventResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobEventResponseCopyWith<JobEventResponse> get copyWith => _$JobEventResponseCopyWithImpl<JobEventResponse>(this as JobEventResponse, _$identity);

  /// Serializes this JobEventResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobEventResponse&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.jobType, jobType) || other.jobType == jobType)&&(identical(other.status, status) || other.status == status)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.outfitId, outfitId) || other.outfitId == outfitId)&&(identical(other.renderId, renderId) || other.renderId == renderId)&&(identical(other.aiProfileId, aiProfileId) || other.aiProfileId == aiProfileId)&&(identical(other.error, error) || other.error == error)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,jobType,status,wardrobeId,itemId,outfitId,renderId,aiProfileId,error,createdAt,acknowledgedAt);

@override
String toString() {
  return 'JobEventResponse(eventId: $eventId, jobType: $jobType, status: $status, wardrobeId: $wardrobeId, itemId: $itemId, outfitId: $outfitId, renderId: $renderId, aiProfileId: $aiProfileId, error: $error, createdAt: $createdAt, acknowledgedAt: $acknowledgedAt)';
}


}

/// @nodoc
abstract mixin class $JobEventResponseCopyWith<$Res>  {
  factory $JobEventResponseCopyWith(JobEventResponse value, $Res Function(JobEventResponse) _then) = _$JobEventResponseCopyWithImpl;
@useResult
$Res call({
 String eventId, String jobType, String status, String wardrobeId,@JsonKey(includeIfNull: false) String? itemId,@JsonKey(includeIfNull: false) String? outfitId,@JsonKey(includeIfNull: false) String? renderId,@JsonKey(includeIfNull: false) String? aiProfileId,@JsonKey(includeIfNull: false) String? error, DateTime createdAt,@JsonKey(includeIfNull: false) DateTime? acknowledgedAt
});




}
/// @nodoc
class _$JobEventResponseCopyWithImpl<$Res>
    implements $JobEventResponseCopyWith<$Res> {
  _$JobEventResponseCopyWithImpl(this._self, this._then);

  final JobEventResponse _self;
  final $Res Function(JobEventResponse) _then;

/// Create a copy of JobEventResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? jobType = null,Object? status = null,Object? wardrobeId = null,Object? itemId = freezed,Object? outfitId = freezed,Object? renderId = freezed,Object? aiProfileId = freezed,Object? error = freezed,Object? createdAt = null,Object? acknowledgedAt = freezed,}) {
  return _then(_self.copyWith(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,jobType: null == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,outfitId: freezed == outfitId ? _self.outfitId : outfitId // ignore: cast_nullable_to_non_nullable
as String?,renderId: freezed == renderId ? _self.renderId : renderId // ignore: cast_nullable_to_non_nullable
as String?,aiProfileId: freezed == aiProfileId ? _self.aiProfileId : aiProfileId // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobEventResponse].
extension JobEventResponsePatterns on JobEventResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobEventResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobEventResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobEventResponse value)  $default,){
final _that = this;
switch (_that) {
case _JobEventResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobEventResponse value)?  $default,){
final _that = this;
switch (_that) {
case _JobEventResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  String jobType,  String status,  String wardrobeId, @JsonKey(includeIfNull: false)  String? itemId, @JsonKey(includeIfNull: false)  String? outfitId, @JsonKey(includeIfNull: false)  String? renderId, @JsonKey(includeIfNull: false)  String? aiProfileId, @JsonKey(includeIfNull: false)  String? error,  DateTime createdAt, @JsonKey(includeIfNull: false)  DateTime? acknowledgedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobEventResponse() when $default != null:
return $default(_that.eventId,_that.jobType,_that.status,_that.wardrobeId,_that.itemId,_that.outfitId,_that.renderId,_that.aiProfileId,_that.error,_that.createdAt,_that.acknowledgedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  String jobType,  String status,  String wardrobeId, @JsonKey(includeIfNull: false)  String? itemId, @JsonKey(includeIfNull: false)  String? outfitId, @JsonKey(includeIfNull: false)  String? renderId, @JsonKey(includeIfNull: false)  String? aiProfileId, @JsonKey(includeIfNull: false)  String? error,  DateTime createdAt, @JsonKey(includeIfNull: false)  DateTime? acknowledgedAt)  $default,) {final _that = this;
switch (_that) {
case _JobEventResponse():
return $default(_that.eventId,_that.jobType,_that.status,_that.wardrobeId,_that.itemId,_that.outfitId,_that.renderId,_that.aiProfileId,_that.error,_that.createdAt,_that.acknowledgedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  String jobType,  String status,  String wardrobeId, @JsonKey(includeIfNull: false)  String? itemId, @JsonKey(includeIfNull: false)  String? outfitId, @JsonKey(includeIfNull: false)  String? renderId, @JsonKey(includeIfNull: false)  String? aiProfileId, @JsonKey(includeIfNull: false)  String? error,  DateTime createdAt, @JsonKey(includeIfNull: false)  DateTime? acknowledgedAt)?  $default,) {final _that = this;
switch (_that) {
case _JobEventResponse() when $default != null:
return $default(_that.eventId,_that.jobType,_that.status,_that.wardrobeId,_that.itemId,_that.outfitId,_that.renderId,_that.aiProfileId,_that.error,_that.createdAt,_that.acknowledgedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobEventResponse extends JobEventResponse {
  const _JobEventResponse({required this.eventId, required this.jobType, required this.status, required this.wardrobeId, @JsonKey(includeIfNull: false) this.itemId, @JsonKey(includeIfNull: false) this.outfitId, @JsonKey(includeIfNull: false) this.renderId, @JsonKey(includeIfNull: false) this.aiProfileId, @JsonKey(includeIfNull: false) this.error, required this.createdAt, @JsonKey(includeIfNull: false) this.acknowledgedAt}): super._();
  factory _JobEventResponse.fromJson(Map<String, dynamic> json) => _$JobEventResponseFromJson(json);

@override final  String eventId;
@override final  String jobType;
@override final  String status;
@override final  String wardrobeId;
@override@JsonKey(includeIfNull: false) final  String? itemId;
@override@JsonKey(includeIfNull: false) final  String? outfitId;
@override@JsonKey(includeIfNull: false) final  String? renderId;
@override@JsonKey(includeIfNull: false) final  String? aiProfileId;
@override@JsonKey(includeIfNull: false) final  String? error;
@override final  DateTime createdAt;
@override@JsonKey(includeIfNull: false) final  DateTime? acknowledgedAt;

/// Create a copy of JobEventResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobEventResponseCopyWith<_JobEventResponse> get copyWith => __$JobEventResponseCopyWithImpl<_JobEventResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobEventResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobEventResponse&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.jobType, jobType) || other.jobType == jobType)&&(identical(other.status, status) || other.status == status)&&(identical(other.wardrobeId, wardrobeId) || other.wardrobeId == wardrobeId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.outfitId, outfitId) || other.outfitId == outfitId)&&(identical(other.renderId, renderId) || other.renderId == renderId)&&(identical(other.aiProfileId, aiProfileId) || other.aiProfileId == aiProfileId)&&(identical(other.error, error) || other.error == error)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,jobType,status,wardrobeId,itemId,outfitId,renderId,aiProfileId,error,createdAt,acknowledgedAt);

@override
String toString() {
  return 'JobEventResponse(eventId: $eventId, jobType: $jobType, status: $status, wardrobeId: $wardrobeId, itemId: $itemId, outfitId: $outfitId, renderId: $renderId, aiProfileId: $aiProfileId, error: $error, createdAt: $createdAt, acknowledgedAt: $acknowledgedAt)';
}


}

/// @nodoc
abstract mixin class _$JobEventResponseCopyWith<$Res> implements $JobEventResponseCopyWith<$Res> {
  factory _$JobEventResponseCopyWith(_JobEventResponse value, $Res Function(_JobEventResponse) _then) = __$JobEventResponseCopyWithImpl;
@override @useResult
$Res call({
 String eventId, String jobType, String status, String wardrobeId,@JsonKey(includeIfNull: false) String? itemId,@JsonKey(includeIfNull: false) String? outfitId,@JsonKey(includeIfNull: false) String? renderId,@JsonKey(includeIfNull: false) String? aiProfileId,@JsonKey(includeIfNull: false) String? error, DateTime createdAt,@JsonKey(includeIfNull: false) DateTime? acknowledgedAt
});




}
/// @nodoc
class __$JobEventResponseCopyWithImpl<$Res>
    implements _$JobEventResponseCopyWith<$Res> {
  __$JobEventResponseCopyWithImpl(this._self, this._then);

  final _JobEventResponse _self;
  final $Res Function(_JobEventResponse) _then;

/// Create a copy of JobEventResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? jobType = null,Object? status = null,Object? wardrobeId = null,Object? itemId = freezed,Object? outfitId = freezed,Object? renderId = freezed,Object? aiProfileId = freezed,Object? error = freezed,Object? createdAt = null,Object? acknowledgedAt = freezed,}) {
  return _then(_JobEventResponse(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,jobType: null == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,wardrobeId: null == wardrobeId ? _self.wardrobeId : wardrobeId // ignore: cast_nullable_to_non_nullable
as String,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,outfitId: freezed == outfitId ? _self.outfitId : outfitId // ignore: cast_nullable_to_non_nullable
as String?,renderId: freezed == renderId ? _self.renderId : renderId // ignore: cast_nullable_to_non_nullable
as String?,aiProfileId: freezed == aiProfileId ? _self.aiProfileId : aiProfileId // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$JobEventListResponse {

 List<JobEventResponse> get events; int get unreadCount;
/// Create a copy of JobEventListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobEventListResponseCopyWith<JobEventListResponse> get copyWith => _$JobEventListResponseCopyWithImpl<JobEventListResponse>(this as JobEventListResponse, _$identity);

  /// Serializes this JobEventListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobEventListResponse&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(events),unreadCount);

@override
String toString() {
  return 'JobEventListResponse(events: $events, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class $JobEventListResponseCopyWith<$Res>  {
  factory $JobEventListResponseCopyWith(JobEventListResponse value, $Res Function(JobEventListResponse) _then) = _$JobEventListResponseCopyWithImpl;
@useResult
$Res call({
 List<JobEventResponse> events, int unreadCount
});




}
/// @nodoc
class _$JobEventListResponseCopyWithImpl<$Res>
    implements $JobEventListResponseCopyWith<$Res> {
  _$JobEventListResponseCopyWithImpl(this._self, this._then);

  final JobEventListResponse _self;
  final $Res Function(JobEventListResponse) _then;

/// Create a copy of JobEventListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? events = null,Object? unreadCount = null,}) {
  return _then(_self.copyWith(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<JobEventResponse>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JobEventListResponse].
extension JobEventListResponsePatterns on JobEventListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobEventListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobEventListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobEventListResponse value)  $default,){
final _that = this;
switch (_that) {
case _JobEventListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobEventListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _JobEventListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<JobEventResponse> events,  int unreadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobEventListResponse() when $default != null:
return $default(_that.events,_that.unreadCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<JobEventResponse> events,  int unreadCount)  $default,) {final _that = this;
switch (_that) {
case _JobEventListResponse():
return $default(_that.events,_that.unreadCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<JobEventResponse> events,  int unreadCount)?  $default,) {final _that = this;
switch (_that) {
case _JobEventListResponse() when $default != null:
return $default(_that.events,_that.unreadCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobEventListResponse extends JobEventListResponse {
  const _JobEventListResponse({required this.events, required this.unreadCount}): super._();
  factory _JobEventListResponse.fromJson(Map<String, dynamic> json) => _$JobEventListResponseFromJson(json);

@override final  List<JobEventResponse> events;
@override final  int unreadCount;

/// Create a copy of JobEventListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobEventListResponseCopyWith<_JobEventListResponse> get copyWith => __$JobEventListResponseCopyWithImpl<_JobEventListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobEventListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobEventListResponse&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(events),unreadCount);

@override
String toString() {
  return 'JobEventListResponse(events: $events, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$JobEventListResponseCopyWith<$Res> implements $JobEventListResponseCopyWith<$Res> {
  factory _$JobEventListResponseCopyWith(_JobEventListResponse value, $Res Function(_JobEventListResponse) _then) = __$JobEventListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<JobEventResponse> events, int unreadCount
});




}
/// @nodoc
class __$JobEventListResponseCopyWithImpl<$Res>
    implements _$JobEventListResponseCopyWith<$Res> {
  __$JobEventListResponseCopyWithImpl(this._self, this._then);

  final _JobEventListResponse _self;
  final $Res Function(_JobEventListResponse) _then;

/// Create a copy of JobEventListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? events = null,Object? unreadCount = null,}) {
  return _then(_JobEventListResponse(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<JobEventResponse>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AckEventsRequest {

 List<String> get eventIds;
/// Create a copy of AckEventsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AckEventsRequestCopyWith<AckEventsRequest> get copyWith => _$AckEventsRequestCopyWithImpl<AckEventsRequest>(this as AckEventsRequest, _$identity);

  /// Serializes this AckEventsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AckEventsRequest&&const DeepCollectionEquality().equals(other.eventIds, eventIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(eventIds));

@override
String toString() {
  return 'AckEventsRequest(eventIds: $eventIds)';
}


}

/// @nodoc
abstract mixin class $AckEventsRequestCopyWith<$Res>  {
  factory $AckEventsRequestCopyWith(AckEventsRequest value, $Res Function(AckEventsRequest) _then) = _$AckEventsRequestCopyWithImpl;
@useResult
$Res call({
 List<String> eventIds
});




}
/// @nodoc
class _$AckEventsRequestCopyWithImpl<$Res>
    implements $AckEventsRequestCopyWith<$Res> {
  _$AckEventsRequestCopyWithImpl(this._self, this._then);

  final AckEventsRequest _self;
  final $Res Function(AckEventsRequest) _then;

/// Create a copy of AckEventsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventIds = null,}) {
  return _then(_self.copyWith(
eventIds: null == eventIds ? _self.eventIds : eventIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AckEventsRequest].
extension AckEventsRequestPatterns on AckEventsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AckEventsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AckEventsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AckEventsRequest value)  $default,){
final _that = this;
switch (_that) {
case _AckEventsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AckEventsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AckEventsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> eventIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AckEventsRequest() when $default != null:
return $default(_that.eventIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> eventIds)  $default,) {final _that = this;
switch (_that) {
case _AckEventsRequest():
return $default(_that.eventIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> eventIds)?  $default,) {final _that = this;
switch (_that) {
case _AckEventsRequest() when $default != null:
return $default(_that.eventIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AckEventsRequest implements AckEventsRequest {
  const _AckEventsRequest({required this.eventIds});
  factory _AckEventsRequest.fromJson(Map<String, dynamic> json) => _$AckEventsRequestFromJson(json);

@override final  List<String> eventIds;

/// Create a copy of AckEventsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AckEventsRequestCopyWith<_AckEventsRequest> get copyWith => __$AckEventsRequestCopyWithImpl<_AckEventsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AckEventsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AckEventsRequest&&const DeepCollectionEquality().equals(other.eventIds, eventIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(eventIds));

@override
String toString() {
  return 'AckEventsRequest(eventIds: $eventIds)';
}


}

/// @nodoc
abstract mixin class _$AckEventsRequestCopyWith<$Res> implements $AckEventsRequestCopyWith<$Res> {
  factory _$AckEventsRequestCopyWith(_AckEventsRequest value, $Res Function(_AckEventsRequest) _then) = __$AckEventsRequestCopyWithImpl;
@override @useResult
$Res call({
 List<String> eventIds
});




}
/// @nodoc
class __$AckEventsRequestCopyWithImpl<$Res>
    implements _$AckEventsRequestCopyWith<$Res> {
  __$AckEventsRequestCopyWithImpl(this._self, this._then);

  final _AckEventsRequest _self;
  final $Res Function(_AckEventsRequest) _then;

/// Create a copy of AckEventsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventIds = null,}) {
  return _then(_AckEventsRequest(
eventIds: null == eventIds ? _self.eventIds : eventIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$AckEventsResponse {

 List<JobEventResponse> get events;
/// Create a copy of AckEventsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AckEventsResponseCopyWith<AckEventsResponse> get copyWith => _$AckEventsResponseCopyWithImpl<AckEventsResponse>(this as AckEventsResponse, _$identity);

  /// Serializes this AckEventsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AckEventsResponse&&const DeepCollectionEquality().equals(other.events, events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(events));

@override
String toString() {
  return 'AckEventsResponse(events: $events)';
}


}

/// @nodoc
abstract mixin class $AckEventsResponseCopyWith<$Res>  {
  factory $AckEventsResponseCopyWith(AckEventsResponse value, $Res Function(AckEventsResponse) _then) = _$AckEventsResponseCopyWithImpl;
@useResult
$Res call({
 List<JobEventResponse> events
});




}
/// @nodoc
class _$AckEventsResponseCopyWithImpl<$Res>
    implements $AckEventsResponseCopyWith<$Res> {
  _$AckEventsResponseCopyWithImpl(this._self, this._then);

  final AckEventsResponse _self;
  final $Res Function(AckEventsResponse) _then;

/// Create a copy of AckEventsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? events = null,}) {
  return _then(_self.copyWith(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<JobEventResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [AckEventsResponse].
extension AckEventsResponsePatterns on AckEventsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AckEventsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AckEventsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AckEventsResponse value)  $default,){
final _that = this;
switch (_that) {
case _AckEventsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AckEventsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AckEventsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<JobEventResponse> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AckEventsResponse() when $default != null:
return $default(_that.events);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<JobEventResponse> events)  $default,) {final _that = this;
switch (_that) {
case _AckEventsResponse():
return $default(_that.events);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<JobEventResponse> events)?  $default,) {final _that = this;
switch (_that) {
case _AckEventsResponse() when $default != null:
return $default(_that.events);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AckEventsResponse extends AckEventsResponse {
  const _AckEventsResponse({required this.events}): super._();
  factory _AckEventsResponse.fromJson(Map<String, dynamic> json) => _$AckEventsResponseFromJson(json);

@override final  List<JobEventResponse> events;

/// Create a copy of AckEventsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AckEventsResponseCopyWith<_AckEventsResponse> get copyWith => __$AckEventsResponseCopyWithImpl<_AckEventsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AckEventsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AckEventsResponse&&const DeepCollectionEquality().equals(other.events, events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(events));

@override
String toString() {
  return 'AckEventsResponse(events: $events)';
}


}

/// @nodoc
abstract mixin class _$AckEventsResponseCopyWith<$Res> implements $AckEventsResponseCopyWith<$Res> {
  factory _$AckEventsResponseCopyWith(_AckEventsResponse value, $Res Function(_AckEventsResponse) _then) = __$AckEventsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<JobEventResponse> events
});




}
/// @nodoc
class __$AckEventsResponseCopyWithImpl<$Res>
    implements _$AckEventsResponseCopyWith<$Res> {
  __$AckEventsResponseCopyWithImpl(this._self, this._then);

  final _AckEventsResponse _self;
  final $Res Function(_AckEventsResponse) _then;

/// Create a copy of AckEventsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? events = null,}) {
  return _then(_AckEventsResponse(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<JobEventResponse>,
  ));
}


}

// dart format on
