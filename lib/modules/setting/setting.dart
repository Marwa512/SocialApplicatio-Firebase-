import 'package:firebase_socialapp/layout/social_layout/cubit/cubit.dart';
import 'package:firebase_socialapp/layout/social_layout/cubit/states.dart';
import 'package:firebase_socialapp/models/socialusermodel.dart';
import 'package:firebase_socialapp/shared/component/reusablecomponent.dart';
import 'package:firebase_socialapp/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../edit_profile/edit_profile.dart';

class SocialSettingScreen extends StatelessWidget {
  const SocialSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialUserModel? model = SocialCubit.get(context).userData;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 225,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          image: DecorationImage(
                              image: NetworkImage("${model!.cover}"),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 72,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage('${model.image}'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${model.name}",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                "${model.bio}",
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            "100",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            "Posts",
                            style: Theme.of(context).textTheme.subtitle2,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            "777",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            "Photos",
                            style: Theme.of(context).textTheme.subtitle2,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            "300",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            "Followings",
                            style: Theme.of(context).textTheme.subtitle2,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            "150k",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            "Followers",
                            style: Theme.of(context).textTheme.subtitle2,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text("Add Photo"),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        navigateTo(context, EditProfileScreen());
                      },
                      child: const Icon(
                        IconBroken.Edit,
                        size: 16,
                      ))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
