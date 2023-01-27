import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_socialapp/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());
  static SocialLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({required String email, required String password}) {
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      //print(value.user!.email);
      emit(SocialLoginSucessState());
    }).catchError((error) {
      emit(SocialLoginErrorState(error.toString()));
    });
  }

  void userLogOut() {
    FirebaseAuth.instance.signOut().then((value) {
      cachHelper.DeleteItem(key: 'uid');
      emit(SocialLogoutSucessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialLogoutErrorState());
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShown = true;

  void changePasswordVisibility() {
    if (isPasswordShown == true) {
      suffix = Icons.visibility_off_outlined;
      isPasswordShown = false;
    } else {
      suffix = Icons.visibility_outlined;
      isPasswordShown = true;
    }

    emit(SocialLoginchangePasswordVisibilityState());
  }
}
