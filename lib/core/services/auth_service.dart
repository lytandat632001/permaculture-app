import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

/// Service xác thực người dùng
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn? _googleSignIn;  // nullable để phù hợp với web

  AuthService({
    required FirebaseAuth firebaseAuth,
    GoogleSignIn? googleSignIn,  // nhận tham số tùy chọn
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  /// Đăng nhập bằng email và password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Đăng ký bằng email và password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Đăng nhập bằng Google
  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      // Trên web: dùng popup không cần GoogleSignIn package
      final googleProvider = GoogleAuthProvider();
      return _firebaseAuth.signInWithPopup(googleProvider);
    } else {
      // Trên mobile: dùng GoogleSignIn package
      if (_googleSignIn == null) {
        throw Exception('GoogleSignIn chưa được khởi tạo');
      }
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return _firebaseAuth.signInWithCredential(credential);
    }
  }

  /// Đăng xuất
  Future<void> signOut() async {
    if (!kIsWeb && _googleSignIn != null) {
      await _googleSignIn!.signOut(); // chỉ gọi trên mobile
    }
    await _firebaseAuth.signOut();
  }

  /// Lấy người dùng hiện tại
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream lắng nghe thay đổi trạng thái đăng nhập
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Gửi email reset mật khẩu
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}