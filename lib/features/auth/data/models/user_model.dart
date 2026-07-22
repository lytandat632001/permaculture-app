import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/entities/user.dart';

/// Model chuyển đổi dữ liệu từ Firebase thành Entity
class UserModel {
  /// Chuyển từ Firebase User sang Entity
  static User fromFirebaseUser(firebase.User? user) {
    if (user == null) {
      throw Exception('User is null');
    }
    return User(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified,
    );
  }

  /// Chuyển từ JSON sang Entity (nếu cần lưu trữ cục bộ)
  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    );
  }

  /// Chuyển Entity thành JSON
  static Map<String, dynamic> toJson(User user) {
    return {
      'id': user.id,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'isEmailVerified': user.isEmailVerified,
    };
  }
}