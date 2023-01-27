// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_socialapp/layout/social_layout/social_layout_screen.dart';
import 'package:firebase_socialapp/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../shared/component/reusablecomponent.dart';
import '../../shared/style/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../register/social_register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SocialLoginScreen extends StatelessWidget {
  SocialLoginScreen({super.key});
  var formkey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialLoginCubit, SocialLoginStates>(
      listener: (context, state) {
        if (state is SocialLoginErrorState) {
          Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        if (state is SocialLoginSucessState) {
          cachHelper.SaveData(
              key: 'uid', value: FirebaseAuth.instance.currentUser!.uid);
          navigateAndFinish(context, const SocialLayout());
        }
      },
      builder: (context, state) {
        var loginCubit = SocialLoginCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "LOGIN",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        "Login now to communicate with friends ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: ((String? value) {
                          if (value!.isEmpty) {
                            return ("Email cant be empty");
                          }
                        }),
                        decoration: const InputDecoration(
                          labelText: "Email Address",
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: loginCubit.isPasswordShown,
                        validator: ((String? value) {
                          if (value!.isEmpty) {
                            return ("password is too short");
                          }
                        }),
                        onFieldSubmitted: (value) {
                          if (formkey.currentState!.validate()) {
                            loginCubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                loginCubit.changePasswordVisibility();
                              },
                              icon: Icon(
                                loginCubit.suffix,
                              ),
                            )),
                      ),
                      const SizedBox(height: 40),
                      ConditionalBuilder(
                        condition: state is! SocialLoginLoadingState,
                        builder: (context) => Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: defaultColor,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              print("Login pressed");
                              if (formkey.currentState!.validate()) {
                                loginCubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                                cachHelper.SaveData(
                                    key: 'uid',
                                    value:
                                        FirebaseAuth.instance.currentUser!.uid);
                                print(cachHelper.GetData(key: 'uid'));
                              }
                            },
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        fallback: (Context) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don\'t have account?",
                          ),
                          TextButton(
                            onPressed: () {
                              navigateTo(context, SocialRegisterScreen());
                            },
                            child: const Text("REGISTER"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
