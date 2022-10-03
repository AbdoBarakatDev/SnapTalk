import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/app_cubit/states.dart';
import 'package:flutter_social/models/users_model.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatDetailsScreen extends StatelessWidget {
  static const String id = "ChatDetailsScreen";

 final UsersModel? usersModel;

  ChatDetailsScreen({Key? key, this.usersModel}) : super(key: key);
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      printMSG("${usersModel!.name}/ ${usersModel!.uId} chats are : ");
      SocialAppCubit.get(context).getMessages(receiverId: usersModel?.uId);
      return BlocConsumer<SocialAppCubit, SocialAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
            condition: SocialAppCubit.get(context).allUsers.isNotEmpty,
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        SocialAppCubit.get(context).getLastMessages();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage("${usersModel?.profilePicture}"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        "${usersModel?.name}",
                        overflow: TextOverflow.ellipsis,
                      )),
                      const Icon(Icons.more_vert),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ConditionalBuilder(
                          condition:
                              SocialAppCubit.get(context).messages.isNotEmpty,
                          fallback: (context) => Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Center(
                                  child: GestureDetector(
                                      onTap: () {
                                        SocialAppCubit.get(context).sendMessage(
                                            reciverId: usersModel?.uId,
                                            dateTime: DateTime.now().toString(),
                                            messageText: "Hi 👋");
                                      },
                                      child: Text(
                                          "say hi 👋 to ${usersModel?.name}")),
                                ),
                              ),
                          builder: (context) {
                            return Expanded(
                              child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  reverse: false,
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior
                                          .onDrag,
                                  itemBuilder: (context, index) {
                                    var message = SocialAppCubit.get(context)
                                        .messages[index];
                                    // SocialAppCubit.get(context).setLastMessageModel(message);
                                    printMSG(
                                        "Sender Id: ${message.senderId} Message:${message.messageText} Compare with Id: ${message.senderId}");
                                    if (message.receiverId ==
                                        usersModel?.uId) {
                                      return buildSenderMessage(
                                          message: message.messageText);
                                    }


                                    return buildReceiverMessage(
                                      context: context,
                                        message: message.messageText,
                                        model: usersModel);
                                  },
                                  separatorBuilder: (context, index) {


                                    return const SizedBox(
                                      height: 5,
                                    );
                                  },
                                  addAutomaticKeepAlives: true,
                                  itemCount: SocialAppCubit.get(context)
                                      .messages
                                      .length),
                            );
                          }),
                      SocialAppCubit.get(context).messages.isEmpty
                          ? const Spacer()
                          : Container(),
                      buildEmojis(context),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              border: Border.all()),
                          child: Row(
                            children: [
                              MaterialButton(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                padding: EdgeInsets.zero,
                                minWidth: 1,
                                onPressed: () {
                                  SocialAppCubit.get(context).hideShowEmoji();
                                },
                                child:
                                    const Icon(Icons.emoji_emotions_outlined),
                              ),
                              Expanded(
                                child: TextFormField(
                                  onChanged: (value) {
                                    printMSG("message controller text : $value");
                                    SocialAppCubit.get(context)
                                        .checkTextMessageIsEmpty(value);
                                    printMSG(value);
                                  },
                                  onTap: () {

                                  },
                                  controller: messageController,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type your message here..."),
                                ),
                              ),
                              MaterialButton(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                padding: EdgeInsets.zero,
                                minWidth: 1,
                                onPressed: SocialAppCubit.get(context)
                                        .isTextMessageEmpty
                                    ? null
                                    : () {
                                        _onSendMessagePressed(context);
                                      },
                                child: Icon(
                                  Icons.send,
                                  color: SocialAppCubit.get(context)
                                          .isTextMessageEmpty||messageController.value.text.isEmpty
                                      ? Colors.grey.shade100
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }

  buildReceiverMessage(
      {@required BuildContext? context,
      @required String? message,
      UsersModel? model}) {
    // SocialAppCubit.get(context!).getMessageNotification(
    //     messageDetails: message,
    //     messageTitle: "You got a message from ${model!.name}",
    //     context: context);
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              (model?.profilePicture).toString(),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(10),
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                ),
              ),
              child: Text(
                message!,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  buildSenderMessage({@required String? message}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.blue.shade300,
          borderRadius: const BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
          ),
        ),
        child: Text(message!),
      ),
    );
  }

  _onEmojiSelected(Emoji emoji,{BuildContext? context}) {
    messageController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
    printMSG("when emoj: ${messageController.value.text}");
    SocialAppCubit.get(context!)
        .checkTextMessageIsEmpty(messageController.value.text);
  }

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  buildEmojis(BuildContext context) {
    return Expanded(
      child: Offstage(
          offstage: !SocialAppCubit.get(context).emojiShowing,
          child: SizedBox(
            height: 250,
            child: EmojiPicker(
                onEmojiSelected: (Category category, Emoji emoji) {
                  _onEmojiSelected(emoji,context: context);
                },
                onBackspacePressed: _onBackspacePressed,
                config: Config(
                    columns: 7,
                    // Issue: https://github.com/flutter/flutter/issues/28894
                    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: const Color(0xFFF2F2F2),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    progressIndicatorColor: Colors.blue,
                    backspaceColor: Colors.blue,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    showRecentsTab: true,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: const Text(
                      'No Recent',
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL)),
          )),
    );
  }

  void _onSendMessagePressed(BuildContext context) {
    SocialAppCubit.get(context).sendMessage(
        reciverId: usersModel?.uId,
        dateTime: DateTime.now().toString(),
        messageText: messageController.text);
    messageController.text = "";
    SocialAppCubit.get(context).checkTextMessageIsEmpty("");
    if (SocialAppCubit.get(context).emojiShowing) {
      SocialAppCubit.get(context).hideShowEmoji();
    }

  }

// _scrolldownBottomOfMessages(BuildContext context) {
//   scrollController.animateTo(
//     scrollController.position.maxScrollExtent,
//     curve: Curves.easeOut,
//     duration: const Duration(milliseconds: 300),
//   );
// }

}
