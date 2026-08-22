// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collections.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImmutableColl implements DiagnosticableTreeMixin {

 List<int> get list;
/// Create a copy of ImmutableColl
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImmutableCollCopyWith<ImmutableColl> get copyWith => _$ImmutableCollCopyWithImpl<ImmutableColl>(this as ImmutableColl, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ImmutableColl'))
    ..add(DiagnosticsProperty('list', list));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImmutableColl&&const DeepCollectionEquality().equals(other.list, list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ImmutableColl(list: $list)';
}


}

/// @nodoc
abstract mixin class $ImmutableCollCopyWith<$Res>  {
  factory $ImmutableCollCopyWith(ImmutableColl value, $Res Function(ImmutableColl) _then) = _$ImmutableCollCopyWithImpl;
@useResult
$Res call({
 List<int> list
});




}
/// @nodoc
class _$ImmutableCollCopyWithImpl<$Res>
    implements $ImmutableCollCopyWith<$Res> {
  _$ImmutableCollCopyWithImpl(this._self, this._then);

  final ImmutableColl _self;
  final $Res Function(ImmutableColl) _then;

/// Create a copy of ImmutableColl
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,}) {
  return _then(ImmutableColl(
null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ImmutableColl].
extension ImmutableCollPatterns on ImmutableColl {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImmutableColl value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImmutableColl() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImmutableColl value)  $default,){
final _that = this;
switch (_that) {
case _ImmutableColl():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImmutableColl value)?  $default,){
final _that = this;
switch (_that) {
case _ImmutableColl() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> list)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImmutableColl() when $default != null:
return $default(_that.list);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> list)  $default,) {final _that = this;
switch (_that) {
case _ImmutableColl():
return $default(_that.list);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> list)?  $default,) {final _that = this;
switch (_that) {
case _ImmutableColl() when $default != null:
return $default(_that.list);case _:
  return null;

}
}

}

/// @nodoc


class _ImmutableColl with DiagnosticableTreeMixin implements ImmutableColl {
   _ImmutableColl( List<int> list): _list = list;
  

 final  List<int> _list;
@override List<int> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}


/// Create a copy of ImmutableColl
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImmutableCollCopyWith<_ImmutableColl> get copyWith => __$ImmutableCollCopyWithImpl<_ImmutableColl>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ImmutableColl'))
    ..add(DiagnosticsProperty('list', list));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImmutableColl&&const DeepCollectionEquality().equals(other._list, _list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ImmutableColl(list: $list)';
}


}

/// @nodoc
abstract mixin class _$ImmutableCollCopyWith<$Res> implements $ImmutableCollCopyWith<$Res> {
  factory _$ImmutableCollCopyWith(_ImmutableColl value, $Res Function(_ImmutableColl) _then) = __$ImmutableCollCopyWithImpl;
@override @useResult
$Res call({
 List<int> list
});




}
/// @nodoc
class __$ImmutableCollCopyWithImpl<$Res>
    implements _$ImmutableCollCopyWith<$Res> {
  __$ImmutableCollCopyWithImpl(this._self, this._then);

  final _ImmutableColl _self;
  final $Res Function(_ImmutableColl) _then;

/// Create a copy of ImmutableColl
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,}) {
  return _then(_ImmutableColl(
null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc
mixin _$MutableColl implements DiagnosticableTreeMixin {

 List<int> get list;
/// Create a copy of MutableColl
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MutableCollCopyWith<MutableColl> get copyWith => _$MutableCollCopyWithImpl<MutableColl>(this as MutableColl, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MutableColl'))
    ..add(DiagnosticsProperty('list', list));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MutableColl&&const DeepCollectionEquality().equals(other.list, list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MutableColl(list: $list)';
}


}

/// @nodoc
abstract mixin class $MutableCollCopyWith<$Res>  {
  factory $MutableCollCopyWith(MutableColl value, $Res Function(MutableColl) _then) = _$MutableCollCopyWithImpl;
@useResult
$Res call({
 List<int> list
});




}
/// @nodoc
class _$MutableCollCopyWithImpl<$Res>
    implements $MutableCollCopyWith<$Res> {
  _$MutableCollCopyWithImpl(this._self, this._then);

  final MutableColl _self;
  final $Res Function(MutableColl) _then;

/// Create a copy of MutableColl
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,}) {
  return _then(MutableColl(
null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [MutableColl].
extension MutableCollPatterns on MutableColl {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MutableColl value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MutableColl() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MutableColl value)  $default,){
final _that = this;
switch (_that) {
case _MutableColl():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MutableColl value)?  $default,){
final _that = this;
switch (_that) {
case _MutableColl() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> list)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MutableColl() when $default != null:
return $default(_that.list);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> list)  $default,) {final _that = this;
switch (_that) {
case _MutableColl():
return $default(_that.list);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> list)?  $default,) {final _that = this;
switch (_that) {
case _MutableColl() when $default != null:
return $default(_that.list);case _:
  return null;

}
}

}

/// @nodoc


class _MutableColl with DiagnosticableTreeMixin implements MutableColl {
   _MutableColl(this.list);
  

@override final  List<int> list;

/// Create a copy of MutableColl
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MutableCollCopyWith<_MutableColl> get copyWith => __$MutableCollCopyWithImpl<_MutableColl>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MutableColl'))
    ..add(DiagnosticsProperty('list', list));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MutableColl&&const DeepCollectionEquality().equals(other.list, list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MutableColl(list: $list)';
}


}

/// @nodoc
abstract mixin class _$MutableCollCopyWith<$Res> implements $MutableCollCopyWith<$Res> {
  factory _$MutableCollCopyWith(_MutableColl value, $Res Function(_MutableColl) _then) = __$MutableCollCopyWithImpl;
@override @useResult
$Res call({
 List<int> list
});




}
/// @nodoc
class __$MutableCollCopyWithImpl<$Res>
    implements _$MutableCollCopyWith<$Res> {
  __$MutableCollCopyWithImpl(this._self, this._then);

  final _MutableColl _self;
  final $Res Function(_MutableColl) _then;

/// Create a copy of MutableColl
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,}) {
  return _then(_MutableColl(
null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
