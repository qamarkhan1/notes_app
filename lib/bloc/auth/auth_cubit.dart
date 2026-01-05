import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;
  StreamSubscription<User?>? _sub;

  AuthCubit(this._repo) : super(AuthUnknown()) {
    _sub = _repo.authStateChanges().listen((user) {
      if (user == null) emit(Unauthenticated());
      else emit(Authenticated(user.uid));
    });
  }

  Future<void> login(String email, String password) => _repo.login(email, password);
  Future<void> register(String email, String password) => _repo.register(email, password);
  Future<void> logout() => _repo.logout();

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
