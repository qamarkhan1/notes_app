import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthUnknown extends AuthState {}
class Authenticated extends AuthState {
  final String uid;
  const Authenticated(this.uid);
  @override
  List<Object?> get props => [uid];
}
class Unauthenticated extends AuthState {}
