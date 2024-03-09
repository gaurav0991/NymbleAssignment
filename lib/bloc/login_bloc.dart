import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nymble_music/events/LoginEvet.dart';
import 'package:nymble_music/States/LoginState.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _firebaseAuth;

  LoginBloc(this._firebaseAuth) : super(LoginInitial()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<Submitted>(_onSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {}

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {}

  Future<void> _onSubmitted(Submitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      emit(LoginSuccess());
    } catch (signInError) {
      if (signInError is FirebaseAuthException &&
          (signInError.code == 'user-not-found' ||
              signInError.code == 'wrong-password')) {
        try {
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: event.email, password: event.password);
          emit(LoginSuccess());
        } catch (createUserError) {
          emit(LoginFailure(error: createUserError.toString()));
        }
      } else {
        emit(LoginFailure(error: signInError.toString()));
      }
    }
  }
}
