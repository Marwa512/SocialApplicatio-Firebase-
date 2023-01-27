// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_socialapp/layout/social_layout/cubit/cubit.dart';
import 'package:firebase_socialapp/layout/social_layout/cubit/states.dart';
import 'package:firebase_socialapp/models/Social_chat_model.dart';
import 'package:firebase_socialapp/models/socialusermodel.dart';
import 'package:firebase_socialapp/shared/style/colors.dart';
import 'package:firebase_socialapp/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel model;
  ChatDetailsScreen({super.key, required this.model});
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receiverId: model.uid);
        return BlocConsumer<SocialCubit, SocialState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 1,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('${model.image}'),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text("${model.name}"),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              var message = SocialCubit.get(context).messages;
                              if (SocialCubit.get(context).userData!.uid ==
                                  message[index].senderId) {
                                return myMessageBuilder(
                                  message[index],
                                );
                              }
                              return messageBuilder(
                                message[index],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 20,
                                ),
                            itemCount:
                                SocialCubit.get(context).messages.length),
                      ),
                      if (SocialCubit.get(context).chatImage != null)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    image: FileImage(SocialCubit.get(context)
                                        .chatImage as File),
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
                                          .RemoveChatImage();
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                controller: messageController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type your message here..'),
                              ),
                            ),
                          ),
                          Container(
                            // color: defaultColor.withOpacity(.2),
                            height: 55,
                            child: IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getchatImage();
                                },
                                icon: Icon(
                                  IconBroken.Camera,
                                  color: defaultcolor,
                                )),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Container(
                            height: 55,
                            color: defaultColor,
                            child: MaterialButton(
                              onPressed: () {
                                if (SocialCubit.get(context).chatImage !=
                                    null) {
                                  SocialCubit.get(context).UploadChatImage(
                                    receiverId: model.uid as String,
                                    text: messageController.text,
                                    dateTime: DateTime.now().toString(),
                                  );
                                } else {
                                  SocialCubit.get(context).SendMessage(
                                      receiverId: model.uid as String,
                                      text: messageController.text,
                                      dateTime: DateTime.now().toString());
                                }
                                messageController.clear();
                                SocialCubit.get(context).RemoveChatImage();
                              },
                              minWidth: 1,
                              child: const Icon(
                                IconBroken.Send,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ]),
                      ),
                    ]),
                  );
                },
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget messageBuilder(
    SocialChatModel model,
  ) =>
      Align(
        alignment: AlignmentDirectional.topStart,
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: const BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(15),
                topEnd: Radius.circular(15),
                topStart: Radius.circular(15),
              ),
              color: Colors.grey),
          child: model.img != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: NetworkImage("${model.img}"),
                      fit: BoxFit.cover,
                      height: 200,
                      width: 300,
                    ),
                    model.text != null ? Text("${model.text}") : const Text(""),
                  ],
                )
              : Text("${model.text}"),
        ),
      );
  Widget myMessageBuilder(
    SocialChatModel model,
  ) =>
      Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: const BorderRadiusDirectional.only(
                bottomStart: Radius.circular(15),
                topEnd: Radius.circular(15),
                topStart: Radius.circular(15),
              ),
              color: defaultColor.withOpacity(.2)),
          child: model.img != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: NetworkImage("${model.img}"),
                      fit: BoxFit.cover,
                      height: 200,
                      width: 300,
                    ),
                    model.text != null ? Text("${model.text}") : const Text(""),
                  ],
                )
              : Text("${model.text}"),
        ),
      );
}
