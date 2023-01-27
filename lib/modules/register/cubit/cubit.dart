// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_socialapp/models/socialusermodel.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());
  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister(
      {required String email,
      required String password,
      required String name,
      required String phone}) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.email);
      CreateUser(email: email, name: name, phone: phone, uid: value.user!.uid);
      emit(SocialRegisterSucessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void CreateUser(
      {required String email,
      required String name,
      required String phone,
      required String uid}) {
    emit(SocialCreateUserLoadingState());
    SocialUserModel model = SocialUserModel(
        email: email,
        name: name,
        phone: phone,
        uid: uid,
        bio: "Write your bio..",
        image:
            "https://img.freepik.com/free-photo/cute-business-woman-idea-thinking-present-pink-background-3d-rendering_56104-1460.jpg?w=900&t=st=1674248784~exp=1674249384~hmac=aebfba89320d348d32a47fa5e0d1c98245910282ae082a30b9a677b6dfa34823",
        cover:
            "https://img.freepik.com/free-photo/cute-girl-chef-uniform-holding-plate-restaurant-cook-mascot-pink-background-3d-rendering_56104-1422.jpg?w=1060&t=st=1674334699~exp=1674335299~hmac=4ffb87d837861c39afab877e4d51d2207195afef796bf7ff219b8fce1669a442");
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .set(model.ToMap())
        .then((value) {
      emit(SocialCreateUserSucessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreateUserErrorState(error));
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

    emit(SocialRegisterchangePasswordVisibilityState());
  }
}
