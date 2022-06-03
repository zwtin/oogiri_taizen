// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'block_answer_list_card_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$BlockAnswerListCardViewDataTearOff {
  const _$BlockAnswerListCardViewDataTearOff();

  _BlockAnswerListCardViewData call(
      {required String id,
      String? userImageUrl,
      required DateTime createdTime,
      required String userName,
      required String text}) {
    return _BlockAnswerListCardViewData(
      id: id,
      userImageUrl: userImageUrl,
      createdTime: createdTime,
      userName: userName,
      text: text,
    );
  }
}

/// @nodoc
const $BlockAnswerListCardViewData = _$BlockAnswerListCardViewDataTearOff();

/// @nodoc
mixin _$BlockAnswerListCardViewData {
  String get id => throw _privateConstructorUsedError;
  String? get userImageUrl => throw _privateConstructorUsedError;
  DateTime get createdTime => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BlockAnswerListCardViewDataCopyWith<BlockAnswerListCardViewData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockAnswerListCardViewDataCopyWith<$Res> {
  factory $BlockAnswerListCardViewDataCopyWith(
          BlockAnswerListCardViewData value,
          $Res Function(BlockAnswerListCardViewData) then) =
      _$BlockAnswerListCardViewDataCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String? userImageUrl,
      DateTime createdTime,
      String userName,
      String text});
}

/// @nodoc
class _$BlockAnswerListCardViewDataCopyWithImpl<$Res>
    implements $BlockAnswerListCardViewDataCopyWith<$Res> {
  _$BlockAnswerListCardViewDataCopyWithImpl(this._value, this._then);

  final BlockAnswerListCardViewData _value;
  // ignore: unused_field
  final $Res Function(BlockAnswerListCardViewData) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? userImageUrl = freezed,
    Object? createdTime = freezed,
    Object? userName = freezed,
    Object? text = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userImageUrl: userImageUrl == freezed
          ? _value.userImageUrl
          : userImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: createdTime == freezed
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$BlockAnswerListCardViewDataCopyWith<$Res>
    implements $BlockAnswerListCardViewDataCopyWith<$Res> {
  factory _$BlockAnswerListCardViewDataCopyWith(
          _BlockAnswerListCardViewData value,
          $Res Function(_BlockAnswerListCardViewData) then) =
      __$BlockAnswerListCardViewDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String? userImageUrl,
      DateTime createdTime,
      String userName,
      String text});
}

/// @nodoc
class __$BlockAnswerListCardViewDataCopyWithImpl<$Res>
    extends _$BlockAnswerListCardViewDataCopyWithImpl<$Res>
    implements _$BlockAnswerListCardViewDataCopyWith<$Res> {
  __$BlockAnswerListCardViewDataCopyWithImpl(
      _BlockAnswerListCardViewData _value,
      $Res Function(_BlockAnswerListCardViewData) _then)
      : super(_value, (v) => _then(v as _BlockAnswerListCardViewData));

  @override
  _BlockAnswerListCardViewData get _value =>
      super._value as _BlockAnswerListCardViewData;

  @override
  $Res call({
    Object? id = freezed,
    Object? userImageUrl = freezed,
    Object? createdTime = freezed,
    Object? userName = freezed,
    Object? text = freezed,
  }) {
    return _then(_BlockAnswerListCardViewData(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userImageUrl: userImageUrl == freezed
          ? _value.userImageUrl
          : userImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: createdTime == freezed
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_BlockAnswerListCardViewData implements _BlockAnswerListCardViewData {
  const _$_BlockAnswerListCardViewData(
      {required this.id,
      this.userImageUrl,
      required this.createdTime,
      required this.userName,
      required this.text});

  @override
  final String id;
  @override
  final String? userImageUrl;
  @override
  final DateTime createdTime;
  @override
  final String userName;
  @override
  final String text;

  @override
  String toString() {
    return 'BlockAnswerListCardViewData(id: $id, userImageUrl: $userImageUrl, createdTime: $createdTime, userName: $userName, text: $text)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _BlockAnswerListCardViewData &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.userImageUrl, userImageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.userImageUrl, userImageUrl)) &&
            (identical(other.createdTime, createdTime) ||
                const DeepCollectionEquality()
                    .equals(other.createdTime, createdTime)) &&
            (identical(other.userName, userName) ||
                const DeepCollectionEquality()
                    .equals(other.userName, userName)) &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(userImageUrl) ^
      const DeepCollectionEquality().hash(createdTime) ^
      const DeepCollectionEquality().hash(userName) ^
      const DeepCollectionEquality().hash(text);

  @JsonKey(ignore: true)
  @override
  _$BlockAnswerListCardViewDataCopyWith<_BlockAnswerListCardViewData>
      get copyWith => __$BlockAnswerListCardViewDataCopyWithImpl<
          _BlockAnswerListCardViewData>(this, _$identity);
}

abstract class _BlockAnswerListCardViewData
    implements BlockAnswerListCardViewData {
  const factory _BlockAnswerListCardViewData(
      {required String id,
      String? userImageUrl,
      required DateTime createdTime,
      required String userName,
      required String text}) = _$_BlockAnswerListCardViewData;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String? get userImageUrl => throw _privateConstructorUsedError;
  @override
  DateTime get createdTime => throw _privateConstructorUsedError;
  @override
  String get userName => throw _privateConstructorUsedError;
  @override
  String get text => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$BlockAnswerListCardViewDataCopyWith<_BlockAnswerListCardViewData>
      get copyWith => throw _privateConstructorUsedError;
}
