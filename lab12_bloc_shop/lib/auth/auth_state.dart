import 'package:equatable/equatable.dart';

/// Immutable auth states. Equatable compares them by value (props),
/// so emitting an equal state twice does not rebuild the UI.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  const AuthSuccess({required this.username, required this.email});

  final String username;
  final String email;

  @override
  List<Object?> get props => [username, email];
}

class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
