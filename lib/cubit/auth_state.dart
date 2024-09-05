part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

// Signup State
final class SignupState extends AuthState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupFailed extends SignupState {}

// Login State
final class LoginState extends AuthState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginFailed extends LoginState {
  final String error;

  LoginFailed(this.error);
}

// Logout State
final class LogoutState extends AuthState {}

final class LogoutLoading extends LogoutState {}

final class LogoutSuccess extends LogoutState {}

final class LogoutFailed extends LogoutState {
  final String error;

  LogoutFailed(this.error);
}

// General Auth States
final class Authenticated extends AuthState {} // المستخدم مصدق عليه

final class Unauthenticated extends AuthState {} // المستخدم لم يعد مصدق عليه

final class AuthError extends AuthState {
  final String message;

  AuthError(this.message); // عند حدوث خطأ عام
}
