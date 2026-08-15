import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { checking, unauthenticated, authenticated }

class CoachUser {
  const CoachUser({
    required this.name,
    required this.email,
    required this.focus,
  });

  final String name;
  final String email;
  final String focus;
}

class AuthState {
  const AuthState({required this.status, this.user, this.errorMessage});

  const AuthState.checking() : this(status: AuthStatus.checking);

  const AuthState.unauthenticated({String? errorMessage})
    : this(status: AuthStatus.unauthenticated, errorMessage: errorMessage);

  const AuthState.authenticated(CoachUser user)
    : this(status: AuthStatus.authenticated, user: user);

  final AuthStatus status;
  final CoachUser? user;
  final String? errorMessage;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState.checking()) {
    unawaited(_restoreSession());
  }

  Future<void> _restoreSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    emit(const AuthState.unauthenticated());
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty || password.length < 4) {
      emit(
        const AuthState.unauthenticated(
          errorMessage: 'Nhập email và mật khẩu tối thiểu 4 ký tự.',
        ),
      );
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 250));
    emit(
      AuthState.authenticated(
        CoachUser(
          name: 'Coach E Learner',
          email: normalizedEmail,
          focus: 'English communication',
        ),
      ),
    );
  }

  Future<void> signInAsDemoCoach() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    emit(
      const AuthState.authenticated(
        CoachUser(
          name: 'Hai Nguyen',
          email: 'hai@coach-e.local',
          focus: 'Speaking confidence',
        ),
      ),
    );
  }

  void signOut() {
    emit(const AuthState.unauthenticated());
  }
}
