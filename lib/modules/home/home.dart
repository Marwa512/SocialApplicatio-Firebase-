// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_socialapp/layout/social_layout/cubit/cubit.dart';
import 'package:firebase_socialapp/layout/social_layout/cubit/states.dart';
import 'package:firebase_socialapp/shared/component/reusablecomponent.dart';
import 'package:firebase_socialapp/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/socialpostmodel.dart';
import '../users/users.dart';

class SocialHomeScreen extends StatelessWidget {
  const SocialHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! SocialGetPostsLoadinfState,
          builder: (context) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.all(8),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          const Image(
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                              image: NetworkImage(
                                  "https://img.freepik.com/free-photo/isolated-shot-woman-uses-smartphone-application-enjoys-browsing-social-media-creats-news-content-makes-online-order-wears-spectacles-casual-jumper-poses-beige-studio-wall_273609-44111.jpg?w=996&t=st=1674231697~exp=1674232297~hmac=72f36f6ccfbde8cf9d9e8e685daee40cdbb70510216d031908249c4c5facee4f")),
                          Text(
                            "Communicate with friends",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.white),
                          ),
                        ]),
                  ),
                  ListView.separated(
                    itemBuilder: (context, index) => buildPostItem(
                        context, SocialCubit.get(context).posts[index], index),
                    itemCount: SocialCubit.get(context).posts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            );
          },
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPostItem(context, SocialPostModel model, index) => Card(
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage("${model.image}"),
                      radius: 25,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${model.name}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(height: 1.1, fontSize: 18),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                const Icon(
                                  Icons.verified_rounded,
                                  color: Colors.blue,
                                  size: 18,
                                )
                              ],
                            ),
                            Text(
                              '${model.dateTime}',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(height: 1.2, fontSize: 12),
                            ),
                          ]),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(IconBroken.More_Circle))
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${model.text}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(height: 1.3, fontSize: 18),
              ),
              /*  Container(
                width: double.infinity,
                child: Wrap(
                  children: [
                    Container(
                      height: 20,
                      child: MaterialButton(
                        minWidth: 1,
                        padding: const EdgeInsets.only(right: 5),
                        onPressed: () {},
                        child: const Text(
                          "#Software_development",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      child: MaterialButton(
                        minWidth: 1,
                        padding: const EdgeInsets.only(right: 5),
                        onPressed: () {},
                        child: const Text(
                          "#Flutter",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              */
              if (model.postImage != '')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage("${model.postImage}"),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                            size: 22,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${SocialCubit.get(context).likes[index]}",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    )),
                    const Spacer(),
                    Expanded(
                        child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(
                            IconBroken.Chat,
                            color: Colors.amber,
                            size: 22,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${SocialCubit.get(context).comments[index]} comments",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              InkWell(
                onTap: () {
                  navigateTo(
                      context,
                      SocialCommentsScreen(
                          SocialCubit.get(context).postsId[index]));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            "${SocialCubit.get(context).userData!.image}"),
                        radius: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Write a comment ...",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ],
                        ),
                      )),
                      InkWell(
                        onTap: () {
                          SocialCubit.get(context).LikePost(
                              postId: SocialCubit.get(context).postsId[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              const Icon(
                                IconBroken.Heart,
                                color: Colors.red,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Like",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
