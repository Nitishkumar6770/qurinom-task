part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}
final class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final String role;

  LoginButtonPressed({
    required this.email,
    required this.password,
    required this.role,
  });
}
