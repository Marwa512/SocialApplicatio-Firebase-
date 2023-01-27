// ignore_for_file: must_be_immutable

import 'package:firebase_socialapp/layout/social_layout/cubit/cubit.dart';
import 'package:firebase_socialapp/layout/social_layout/cubit/states.dart';
import 'package:firebase_socialapp/models/social_comment_model.dart';
import 'package:firebase_socialapp/shared/style/colors.dart';
import 'package:firebase_socialapp/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialCommentsScreen extends StatelessWidget {
  final TextEditingController commentController = TextEditingController();

  SocialCommentsScreen(this.postsId);
  String postsId;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getComments(postId: postsId);
      return BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: const Center(child: Text("")),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return buildCommentSection(context,
                                SocialCubit.get(context).commentModel[index]);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 5,
                              ),
                          itemCount:
                              SocialCubit.get(context).commentModel.length),
                    ),
                    const Spacer(),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: commentController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'write a comment..'),
                            ),
                          ),
                        ),
                        Container(
                          height: 55,
                          // color: defaultColor,
                          child: MaterialButton(
                            onPressed: () {
                              SocialCubit.get(context).CommentPost(
                                  postId: postsId,
                                  comment: commentController.text,
                                  dateTime: DateTime.now().toString(),
                                  commentname: SocialCubit.get(context)
                                      .userData!
                                      .name
                                      .toString(),
                                  commentuser: SocialCubit.get(context)
                                      .userData!
                                      .image
                                      .toString());
                              commentController.clear();
                              SocialCubit.get(context)
                                  .getComments(postId: postsId);
                            },
                            minWidth: 1,
                            child: Icon(
                              IconBroken.Send,
                              size: 30,
                              color: defaultColor,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ));
        },
      );
    });
  }

  Widget buildCommentSection(context, SocialCommentModel model) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  "${model.commentuser}",
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
                height: 50,
                width: 200,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(15),
                      topEnd: Radius.circular(15),
                      topStart: Radius.circular(15),
                    ),
                    color: Colors.grey[200]),
                child: Text(
                  "${model.comment}",
                  style: Theme.of(context).textTheme.subtitle1,
                )),
          ],
        ),
      );
}
