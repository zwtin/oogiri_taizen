// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'answer_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AnswerViewDataTearOff {
  const _$AnswerViewDataTearOff();

  _AnswerViewData call(
      {required String id,
      required String text,
      required int viewedTime,
      required int likedTime,
      required bool isLike,
      required int favoredTime,
      required bool isFavor,
      required int point,
      required DateTime createdAt,
      required TopicViewData topic,
      required UserViewData createdUser,
      required bool isOwn}) {
    return _AnswerViewData(
      id: id,
      text: text,
      viewedTime: viewedTime,
      likedTime: likedTime,
      isLike: isLike,
      favoredTime: favoredTime,
      isFavor: isFavor,
      point: point,
      createdAt: createdAt,
      topic: topic,
      createdUser: createdUser,
      isOwn: isOwn,
    );
  }
}

/// @nodoc
const $AnswerViewData = _$AnswerViewDataTearOff();

/// @nodoc
mixin _$AnswerViewData {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  int get viewedTime => throw _privateConstructorUsedError;
  int get likedTime => throw _privateConstructorUsedError;
  bool get isLike => throw _privateConstructorUsedError;
  int get favoredTime => throw _privateConstructorUsedError;
  bool get isFavor => throw _privateConstructorUsedError;
  int get point => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  TopicViewData get topic => throw _privateConstructorUsedError;
  UserViewData get createdUser => throw _privateConstructorUsedError;
  bool get isOwn => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnswerViewDataCopyWith<AnswerViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerViewDataCopyWith<$Res> {
  factory $AnswerViewDataCopyWith(
          AnswerViewData value, $Res Function(AnswerViewData) then) =
      _$AnswerViewDataCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String text,
      int viewedTime,
      int likedTime,
      bool isLike,
      int favoredTime,
      bool isFavor,
      int point,
      DateTime createdAt,
      TopicViewData topic,
      UserViewData createdUser,
      bool isOwn});

  $TopicViewDataCopyWith<$Res> get topic;
  $UserViewDataCopyWith<$Res> get createdUser;
}

/// @nodoc
class _$AnswerViewDataCopyWithImpl<$Res>
    implements $AnswerViewDataCopyWith<$Res> {
  _$AnswerViewDataCopyWithImpl(this._value, this._then);

  final AnswerViewData _value;
  // ignore: unused_field
  final $Res Function(AnswerViewData) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
    Object? viewedTime = freezed,
    Object? likedTime = freezed,
    Object? isLike = freezed,
    Object? favoredTime = freezed,
    Object? isFavor = freezed,
    Object? point = freezed,
    Object? createdAt = freezed,
    Object? topic = freezed,
    Object? createdUser = freezed,
    Object? isOwn = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      viewedTime: viewedTime == freezed
          ? _value.viewedTime
          : viewedTime // ignore: cast_nullable_to_non_nullable
              as int,
      likedTime: likedTime == freezed
          ? _value.likedTime
          : likedTime // ignore: cast_nullable_to_non_nullable
              as int,
      isLike: isLike == freezed
          ? _value.isLike
          : isLike // ignore: cast_nullable_to_non_nullable
              as bool,
      favoredTime: favoredTime == freezed
          ? _value.favoredTime
          : favoredTime // ignore: cast_nullable_to_non_nullable
              as int,
      isFavor: isFavor == freezed
          ? _value.isFavor
          : isFavor // ignore: cast_nullable_to_non_nullable
              as bool,
      point: point == freezed
          ? _value.point
          : point // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      topic: topic == freezed
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as TopicViewData,
      createdUser: createdUser == freezed
          ? _value.createdUser
          : createdUser // ignore: cast_nullable_to_non_nullable
              as UserViewData,
      isOwn: isOwn == freezed
          ? _value.isOwn
          : isOwn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $TopicViewDataCopyWith<$Res> get topic {
    return $TopicViewDataCopyWith<$Res>(_value.topic, (value) {
      return _then(_value.copyWith(topic: value));
    });
  }

  @override
  $UserViewDataCopyWith<$Res> get createdUser {
    return $UserViewDataCopyWith<$Res>(_value.createdUser, (value) {
      return _then(_value.copyWith(createdUser: value));
    });
  }
}

/// @nodoc
abstract class _$AnswerViewDataCopyWith<$Res>
    implements $AnswerViewDataCopyWith<$Res> {
  factory _$AnswerViewDataCopyWith(
          _AnswerViewData value, $Res Function(_AnswerViewData) then) =
      __$AnswerViewDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String text,
      int viewedTime,
      int likedTime,
      bool isLike,
      int favoredTime,
      bool isFavor,
      int point,
      DateTime createdAt,
      TopicViewData topic,
      UserViewData createdUser,
      bool isOwn});

  @override
  $TopicViewDataCopyWith<$Res> get topic;
  @override
  $UserViewDataCopyWith<$Res> get createdUser;
}

/// @nodoc
class __$AnswerViewDataCopyWithImpl<$Res>
    extends _$AnswerViewDataCopyWithImpl<$Res>
    implements _$AnswerViewDataCopyWith<$Res> {
  __$AnswerViewDataCopyWithImpl(
      _AnswerViewData _value, $Res Function(_AnswerViewData) _then)
      : super(_value, (v) => _then(v as _AnswerViewData));

  @override
  _AnswerViewData get _value => super._value as _AnswerViewData;

  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
    Object? viewedTime = freezed,
    Object? likedTime = freezed,
    Object? isLike = freezed,
    Object? favoredTime = freezed,
    Object? isFavor = freezed,
    Object? point = freezed,
    Object? createdAt = freezed,
    Object? topic = freezed,
    Object? createdUser = freezed,
    Object? isOwn = freezed,
  }) {
    return _then(_AnswerViewData(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      viewedTime: viewedTime == freezed
          ? _value.viewedTime
          : viewedTime // ignore: cast_nullable_to_non_nullable
              as int,
      likedTime: likedTime == freezed
          ? _value.likedTime
          : likedTime // ignore: cast_nullable_to_non_nullable
              as int,
      isLike: isLike == freezed
          ? _value.isLike
          : isLike // ignore: cast_nullable_to_non_nullable
              as bool,
      favoredTime: favoredTime == freezed
          ? _value.favoredTime
          : favoredTime // ignore: cast_nullable_to_non_nullable
              as int,
      isFavor: isFavor == freezed
          ? _value.isFavor
          : isFavor // ignore: cast_nullable_to_non_nullable
              as bool,
      point: point == freezed
          ? _value.point
          : point // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      topic: topic == freezed
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as TopicViewData,
      createdUser: createdUser == freezed
          ? _value.createdUser
          : createdUser // ignore: cast_nullable_to_non_nullable
              as UserViewData,
      isOwn: isOwn == freezed
          ? _value.isOwn
          : isOwn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_AnswerViewData implements _AnswerViewData {
  const _$_AnswerViewData(
      {required this.id,
      required this.text,
      required this.viewedTime,
      required this.likedTime,
      required this.isLike,
      required this.favoredTime,
      required this.isFavor,
      required this.point,
      required this.createdAt,
      required this.topic,
      required this.createdUser,
      required this.isOwn});

  @override
  final String id;
  @override
  final String text;
  @override
  final int viewedTime;
  @override
  final int likedTime;
  @override
  final bool isLike;
  @override
  final int favoredTime;
  @override
  final bool isFavor;
  @override
  final int point;
  @override
  final DateTime createdAt;
  @override
  final TopicViewData topic;
  @override
  final UserViewData createdUser;
  @override
  final bool isOwn;

  @override
  String toString() {
    return 'AnswerViewData(id: $id, text: $text, viewedTime: $viewedTime, likedTime: $likedTime, isLike: $isLike, favoredTime: $favoredTime, isFavor: $isFavor, point: $point, createdAt: $createdAt, topic: $topic, createdUser: $createdUser, isOwn: $isOwn)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AnswerViewData &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)) &&
            (identical(other.viewedTime, viewedTime) ||
                const DeepCollectionEquality()
                    .equals(other.viewedTime, viewedTime)) &&
            (identical(other.likedTime, likedTime) ||
                const DeepCollectionEquality()
                    .equals(other.likedTime, likedTime)) &&
            (identical(other.isLike, isLike) ||
                const DeepCollectionEquality().equals(other.isLike, isLike)) &&
            (identical(other.favoredTime, favoredTime) ||
                const DeepCollectionEquality()
                    .equals(other.favoredTime, favoredTime)) &&
            (identical(other.isFavor, isFavor) ||
                const DeepCollectionEquality()
                    .equals(other.isFavor, isFavor)) &&
            (identical(other.point, point) ||
                const DeepCollectionEquality().equals(other.point, point)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.topic, topic) ||
                const DeepCollectionEquality().equals(other.topic, topic)) &&
            (identical(other.createdUser, createdUser) ||
                const DeepCollectionEquality()
                    .equals(other.createdUser, createdUser)) &&
            (identical(other.isOwn, isOwn) ||
                const DeepCollectionEquality().equals(other.isOwn, isOwn)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(text) ^
      const DeepCollectionEquality().hash(viewedTime) ^
      const DeepCollectionEquality().hash(likedTime) ^
      const DeepCollectionEquality().hash(isLike) ^
      const DeepCollectionEquality().hash(favoredTime) ^
      const DeepCollectionEquality().hash(isFavor) ^
      const DeepCollectionEquality().hash(point) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(topic) ^
      const DeepCollectionEquality().hash(createdUser) ^
      const DeepCollectionEquality().hash(isOwn);

  @JsonKey(ignore: true)
  @override
  _$AnswerViewDataCopyWith<_AnswerViewData> get copyWith =>
      __$AnswerViewDataCopyWithImpl<_AnswerViewData>(this, _$identity);
}

abstract class _AnswerViewData implements AnswerViewData {
  const factory _AnswerViewData(
      {required String id,
      required String text,
      required int viewedTime,
      required int likedTime,
      required bool isLike,
      required int favoredTime,
      required bool isFavor,
      required int point,
      required DateTime createdAt,
      required TopicViewData topic,
      required UserViewData createdUser,
      required bool isOwn}) = _$_AnswerViewData;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get text => throw _privateConstructorUsedError;
  @override
  int get viewedTime => throw _privateConstructorUsedError;
  @override
  int get likedTime => throw _privateConstructorUsedError;
  @override
  bool get isLike => throw _privateConstructorUsedError;
  @override
  int get favoredTime => throw _privateConstructorUsedError;
  @override
  bool get isFavor => throw _privateConstructorUsedError;
  @override
  int get point => throw _privateConstructorUsedError;
  @override
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  TopicViewData get topic => throw _privateConstructorUsedError;
  @override
  UserViewData get createdUser => throw _privateConstructorUsedError;
  @override
  bool get isOwn => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AnswerViewDataCopyWith<_AnswerViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
