// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_socialapp/modules/login/cubit/cubit.dart';
import 'package:firebase_socialapp/modules/login/login_screen.dart';
import 'package:firebase_socialapp/modules/newpost/new_post.dart';
import '/layout/social_layout/cubit/cubit.dart';
import '/layout/social_layout/cubit/states.dart';
import '/modules/notification/notification.dart';
import '/modules/search/search.dart';
import '/shared/component/reusablecomponent.dart';
import '/shared/style/colors.dart';
import '/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SociaNewPostState) navigateTo(context, NewPostScreen());
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(context, SocialNotifcationScreen());
                  },
                  icon: Icon(IconBroken.Notification)),
              IconButton(
                  onPressed: () {
                    SocialLoginCubit.get(context).userLogOut();
                    navigateAndFinish(context, SocialLoginScreen());
                  },
                  icon: Icon(IconBroken.Logout))
            ],
          ),
          body: cubit.screen[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.BottomNavBar(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Chat), label: 'Chats'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Paper_Plus), label: 'Post'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Profile), label: 'Profile'),
              ]),
        );
      },
    );
  }
}
/*  ConditionalBuilder(
                condition: SocialCubit.get(context).userData != null,
                builder: (context) {
                  if (FirebaseAuth.instance.currentUser!.emailVerified) {
                    return Container(
                      color: Colors.amber.withOpacity(.7),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Row(children: [
                          Icon(Icons.info),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Text(
                            'Please Verify Your Email',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          SizedBox(
                            width: 15,
                          ),
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                            },
                            child: const Text(
                              "Send",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ]),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                fallback: ((context) => Center(
                      child: CircularProgressIndicator(),
                    ))) */