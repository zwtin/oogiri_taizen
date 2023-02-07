import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/infra/dao/user_dao.dart';

class FirestoreClient {
  factory FirestoreClient() => _instance;
  FirestoreClient._internal();
  static final FirestoreClient _instance = FirestoreClient._internal();
  final _firestore = FirebaseFirestore.instance;

  // 通信を共通化したいが、上手く実装できなかったので一旦メソッドごとにしてここに置いておく
  Future<Result<UserDAO>> requestUser({required String id}) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      final data = doc.data();
      if (data == null) {
        throw OTException(title: 'エラー', text: 'ユーザーの取得に失敗しました');
      }
      final user = UserDAO.fromMap(data);
      return Result.success(user);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }
}
