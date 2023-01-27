import 'dart:ffi';
import 'dart:io';

import 'package:firebase_socialapp/layout/social_layout/cubit/cubit.dart';
import 'package:firebase_socialapp/layout/social_layout/cubit/states.dart';
import 'package:firebase_socialapp/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/reusablecomponent.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({super.key});
  var postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var userMode = SocialCubit.get(context).userData;
        return Scaffold(
          appBar:
              defaultAppBar(context: context, title: "Create Post", action: [
            TextButton(
                onPressed: () {
                  if (SocialCubit.get(context).postImage == null) {
                    SocialCubit.get(context).CreatePost(
                        dateTime: DateTime.now().toString(),
                        text: postController.text);
                  } else {
                    SocialCubit.get(context).UploadPostImage(
                        dateTime: DateTime.now().toString(),
                        text: postController.text);
                  }
                },
                child: const Text('POST')),
            const SizedBox(
              width: 10,
            )
          ]),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(children: [
              if (state is SocialCreatePostLoadingState)
                const LinearProgressIndicator(),
              if (state is SocialCreatePostLoadingState)
                const SizedBox(
                  height: 5,
                ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('${userMode!.image}'),
                    radius: 25,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${SocialCubit.get(context).userData!.name}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(height: 1.1, fontSize: 18),
                            ),
                            Text(
                              "public",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(height: 1.2, fontSize: 12),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: TextFormField(
                  controller: postController,
                  keyboardType: TextInputType.text,
                  /* validator: ((String? value) {
                  if (value!.isEmpty) {
                    return ("Name cant be empty");
                  }
                  return null;
                }), */
                  decoration: const InputDecoration(
                    hintText: "what is on your mind ..?",
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (SocialCubit.get(context).postImage != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: FileImage(
                                SocialCubit.get(context).postImage as File),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20,
                        child: IconButton(
                            onPressed: () {
                              SocialCubit.get(context).RemovePostImage();
                            },
                            icon: const Icon(
                              IconBroken.Close_Square,
                              size: 18,
                            )),
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        SocialCubit.get(context).getpostImage();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(IconBroken.Image),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Add photo")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                        onPressed: () {}, child: const Text("# tags")),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}
