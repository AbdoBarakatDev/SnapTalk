import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/app_cubit/states.dart';
import 'package:flutter_social/models/users_model.dart';
import 'package:flutter_social/modules/buttom_nav_modules/chats_screen/chat_details_screen/chat_details_screen.dart';
import 'package:flutter_social/shared/components/components.dart';

class ChatsScreen extends StatelessWidget {
  static const String id = "ChatsScreen";

  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    printMSG("users length : ${SocialAppCubit.get(context).allUsers.length}");
    printMSG(
        "last Messages length : ${SocialAppCubit.get(context).lastMessages.length}");
    printMSG("Last Messages is :${SocialAppCubit.get(context).lastMessages}");
    SocialAppCubit.get(context).getLastMessages();
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialAppCubit.get(context).allUsers.isNotEmpty &&
              SocialAppCubit.get(context).allUsersIds.isNotEmpty &&
              SocialAppCubit.get(context).lastMessages.isNotEmpty &&
              SocialAppCubit.get(context).allUsersIds.length ==
                  SocialAppCubit.get(context).lastMessages.length&&
              SocialAppCubit.get(context).allUsersIds.length ==SocialAppCubit.get(context).allUsers.length,
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          builder: (context) {
            return RefreshIndicator(
              onRefresh: () => _pullRefresh(context),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          printMSG(
                              "User ${SocialAppCubit.get(context).allUsers[index].name} Clicked / Id is :${SocialAppCubit.get(context).allUsers[index].uId} ");
                          doWidgetNavigation(
                              context,
                              ChatDetailsScreen(
                                  usersModel: SocialAppCubit.get(context)
                                      .allUsers[index]));
                        },
                        child: buildChatUser(
                            context: context,
                            model: SocialAppCubit.get(context).allUsers[index],
                            index: index),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: SocialAppCubit.get(context).allUsers.length),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildChatUser({BuildContext? context, UsersModel? model, int? index}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage("${model?.profilePicture}"),
          radius: 28,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${model?.name}",
                  style: Theme.of(context!)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.normal)
                  // ?.copyWith(fontWeight: FontWeight.w600),
                  ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${SocialAppCubit.get(context).lastMessages.isNotEmpty && SocialAppCubit.get(context).lastMessages[index!].messageText != null ? SocialAppCubit.get(context).lastMessages[index].messageText : 'there were not any messages'}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pullRefresh(BuildContext? context) async {
    SocialAppCubit.get(context!).getAllUsersV2();
    SocialAppCubit.get(context).getLastMessages();
  }
}
