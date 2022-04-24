import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:musicapp/userAuthRepository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserAuthRepository _authRepo = UserAuthRepository();

  LoginBloc() : super(LoginInitialState()) {
    on<LoginEvent>(_authVerification);
    on<GoogleLoginEvent>(_authGoogle);
    on<SignOutLoginEvent>(_signOut);
  }

  FutureOr<void> _authVerification(LoginEvent event, Emitter<LoginState> emit) {
    if (_authRepo.isAlreadyAuthenticated()) {
      emit(LoginSuccessState());
    } else {
      emit(LoginUnAuthState());
    }
  }

  FutureOr<void> _authGoogle(event, emit) async {
    emit(LoginWaitState());
    print("Attempting to login...");
    try {
      await _authRepo.signInWithGoogle();
      // await check_if_user_exists();
      print("Test sign in with google");
      emit(LoginSuccessState());
    } catch (e) {
      print("Error al autenticar: $e");
      emit(LoginErrState());
    }
  }

  FutureOr<void> _signOut(
      SignOutLoginEvent event, Emitter<LoginState> emit) async {
    await _authRepo.signOutGoogleUser();
    await _authRepo.signOutFirebaseUser();
    emit(LogOutSucessState());
  }

  Future<bool> check_if_user_exists() async {
    print("Checking if user exists...");
    try {
      var collectionRef =
          await FirebaseFirestore.instance.collection("userList");
      print(true);
      if (true != null) {
        print("entry exists");
        return true;
      } else {
        print("entry does not exist");
        return false;
      }
    } catch (e) {
      print("Got error at user exist check: $e");
      return false;
    }
  }
}
