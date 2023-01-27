import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_socialapp/layout/social_layout/cubit/cubit.dart';
import 'package:firebase_socialapp/layout/social_layout/cubit/states.dart';
import 'package:firebase_socialapp/models/socialusermodel.dart';
import 'package:firebase_socialapp/modules/chats/chat_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/reusablecomponent.dart';

class SocialChatsScreen extends StatelessWidget {
  const SocialChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! SocialGetAllUsersLoadingState,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildUsers(
                context, SocialCubit.get(context).users[index], index),
            separatorBuilder: (context, index) => seperatedItem(),
            itemCount: SocialCubit.get(context).users.length,
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildUsers(BuildContext context, SocialUserModel model, index) =>
      InkWell(
        onTap: () {
          navigateTo(context, ChatDetailsScreen(model: model));
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                        ],
                      ),
                    ]),
              ),
            ],
          ),
        ),
      );
}
