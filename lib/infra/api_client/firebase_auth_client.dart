import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthClient {
  factory FirebaseAuthClient() => _instance;
  FirebaseAuthClient._internal();
  static final FirebaseAuthClient _instance = FirebaseAuthClient._internal();
  final _firebaseAuth = FirebaseAuth.instance;

  Stream<String?> getLoginUserStream() {
    return _firebaseAuth.authStateChanges().map((user) => user?.uid);
  }

  bool? getLoginUserEmailVerified() {
    final user = _firebaseAuth.currentUser?.emailVerified;
  }
}
