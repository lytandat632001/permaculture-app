import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../services/auth_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart'; // đã đổi tên
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart'; // không hide

final List<SingleChildWidget> globalProviders = [];

Future<void> initializeDependencies() async {
  final firebaseAuth = FirebaseAuth.instance;

  // Chỉ tạo GoogleSignIn khi chạy trên mobile (Android/iOS), web thì để null
  GoogleSignIn? googleSignIn;
  if (!kIsWeb) {
    googleSignIn = GoogleSignIn(scopes: ['email']);
  }

  final authService = AuthService(
    firebaseAuth: firebaseAuth,
    googleSignIn: googleSignIn,
  );

  final authRemoteDatasource = AuthRemoteDatasource(authService);
  final AuthRepository authRepository = AuthRepositoryImpl(
    authRemoteDatasource,
  );

  final signIn = SignIn(authRepository);
  final signUp = SignUp(authRepository);
  final googleSignInUc = SignInWithGoogle(authRepository);
  final signOut = SignOut(authRepository);
  final getCurrentUser = GetCurrentUser(authRepository);

  final authProvider = AuthProvider(
    signIn: signIn,
    signUp: signUp,
    googleSignIn: googleSignInUc,
    signOut: signOut,
    getCurrentUser: getCurrentUser,
  );

  globalProviders.add(
    ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
  );
}
