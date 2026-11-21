import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

export 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({this.delay = const Duration(seconds: 2)})
    : super(const AuthInitial());

  static const validEmail = 'student@narxoz.kz';
  static const validPassword = '123456';

  /// Simulated network latency.
  final Duration delay;

  Future<void> login(String email, String password) async {
    if (state is AuthLoading) return; // ignore double taps
    final cleanEmail = email.trim().toLowerCase();

    emit(const AuthLoading());
    await Future<void>.delayed(delay);
    if (isClosed) return;

    if (cleanEmail.isEmpty || password.isEmpty) {
      emit(const AuthError('Please enter email and password'));
    } else if (!cleanEmail.contains('@')) {
      emit(const AuthError('Invalid email format'));
    } else if (cleanEmail != validEmail || password != validPassword) {
      emit(const AuthError('Invalid email or password'));
    } else {
      emit(
        AuthSuccess(username: cleanEmail.split('@').first, email: cleanEmail),
      );
    }
  }

  void logout() => emit(const AuthInitial());
}
