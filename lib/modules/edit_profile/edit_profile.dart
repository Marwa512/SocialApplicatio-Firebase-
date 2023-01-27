import 'package:firebase_socialapp/layout/social_layout/cubit/cubit.dart';
import 'package:firebase_socialapp/layout/social_layout/cubit/states.dart';
import 'package:firebase_socialapp/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/reusablecomponent.dart';
import '../../shared/style/colors.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = SocialCubit.get(context).userData;
        var profileImage = SocialCubit.get(context).ProfileImage;
        var profileCover = SocialCubit.get(context).ProfileCover;
        bioController.text = model!.bio!;
        nameController.text = model.name!;
        phoneController.text = model.phone!;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit profile',
            action: [
              TextButton(
                  onPressed: () {
                    SocialCubit.get(context).updateUser(
                      bio: bioController.text,
                      name: nameController.text,
                      phone: phoneController.text,
                    );
                  },
                  child: const Text('UPDATE')),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 225,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 160,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                  image: DecorationImage(
                                      image: profileCover == null
                                          ? NetworkImage("${model.cover}")
                                          : FileImage(profileCover)
                                              as ImageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 20,
                                  child: IconButton(
                                      onPressed: () {
                                        SocialCubit.get(context)
                                            .getProfileCover();
                                      },
                                      icon: const Icon(
                                        IconBroken.Camera,
                                        size: 18,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 72,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: profileImage == null
                                    ? NetworkImage('${model.image}')
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 18,
                                child: IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .getProfileImage();
                                    },
                                    icon: const Icon(
                                      IconBroken.Camera,
                                      size: 18,
                                    )),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (SocialCubit.get(context).ProfileImage != null ||
                      SocialCubit.get(context).ProfileCover != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).ProfileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: defaultColor,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .uploadProfileImage(
                                              bio: bioController.text,
                                              name: nameController.text,
                                              phone: phoneController.text);
                                    },
                                    child: const Text(
                                      "Upload Image",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (state is SocialUserUpdateLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (SocialCubit.get(context).ProfileCover != null)
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: defaultColor,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .uploadProfileCover(
                                              bio: bioController.text,
                                              name: nameController.text,
                                              phone: phoneController.text);
                                    },
                                    child: const Text(
                                      "Upload Cover",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (state is SocialUserUpdateLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          )
                      ],
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    validator: ((String? value) {
                      if (value!.isEmpty) {
                        return ("Name cant be empty");
                      }
                      return null;
                    }),
                    decoration: const InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(IconBroken.User),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: bioController,
                    keyboardType: TextInputType.name,
                    validator: ((String? value) {
                      if (value!.isEmpty) {
                        return ("bio cant be empty");
                      }
                      return null;
                    }),
                    decoration: const InputDecoration(
                      labelText: "Bio",
                      prefixIcon: Icon(IconBroken.Info_Circle),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.name,
                    validator: ((String? value) {
                      if (value!.isEmpty) {
                        return ("phone cant be empty");
                      }
                      return null;
                    }),
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(IconBroken.Call),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
