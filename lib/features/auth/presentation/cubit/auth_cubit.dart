import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lowgos_app/features/auth/domain/usecases/login_with_email.dart';
import 'package:lowgos_app/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:lowgos_app/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:lowgos_app/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required LoginWithEmail loginWithEmail,
    required SignUpWithEmail signUpWithEmail,
    required SignInWithGoogle signInWithGoogle,
  }) : _loginWithEmail = loginWithEmail,
       _signUpWithEmail = signUpWithEmail,
       _signInWithGoogle = signInWithGoogle,
        super(const AuthState.initial());

  final LoginWithEmail _loginWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignInWithGoogle _signInWithGoogle;

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const AuthState.loading());
    final result = await _loginWithEmail(
      LoginWithEmailParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (user) => emit(AuthState.success(user)),
    );
  }

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthState.loading());
    final result = await _signUpWithEmail(
      SignUpWithEmailParams(name: name, email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (user) => emit(AuthState.success(user)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthState.loading());
    final result = await _signInWithGoogle();
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (user) => emit(AuthState.success(user)),
    );
  }
}
