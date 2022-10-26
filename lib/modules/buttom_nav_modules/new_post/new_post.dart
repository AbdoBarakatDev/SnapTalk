import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/app_cubit/states.dart';
import 'package:flutter_social/shared/components/components.dart';

class NewPostScreen extends StatelessWidget {
  static const String id = "NewPostScreen";

  NewPostScreen({Key? key}) : super(key: key);

  TextEditingController? newPostController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    SocialAppCubit.get(context).checkNewPostIsEmpty();
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {
        if (state is SocialAppCreatePostSuccessState) {
          showToast(
            context: context,
            message: "Post Uploaded",
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: defaultAppBar(
                context: context,
                title: "Create Post",
                leading: GestureDetector(
                  onTap: (() => Navigator.pop(context)),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.grey,
                  ),
                ),
                actions: [
                  defaultTextButton(
                      textStyle: SocialAppCubit.get(context).postIsEmpty!
                          ? const TextStyle(color: Colors.grey)
                          : const TextStyle(color: Colors.white),
                      text: "Post",
                      enabled: SocialAppCubit.get(context).postIsEmpty!
                          ? false
                          : true,
                      function: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          var now = DateTime.now();
                          if (SocialAppCubit.get(context).postImage == null) {
                            SocialAppCubit.get(context).createPost(
                                context: context,
                                postText: newPostController?.text,
                                dateTime: now.toString());
                            newPostController?.text = "";
                          } else {
                            SocialAppCubit.get(context).createPostWithImage(
                                postText: newPostController?.text,
                                dateTime: now.toString());
                            newPostController?.text = "";
                            SocialAppCubit.get(context).removePostImage();
                          }
                        }
                      }),
                ]),
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  if (state is SocialAppCreatePostLoadingState)
                    const LinearProgressIndicator(),
                  if (state is SocialAppCreatePostLoadingState)
                    const SizedBox(
                      height: 5,
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "${SocialAppCubit.get(context).usersModel?.profilePicture}"),
                          radius: 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(
                                  "${SocialAppCubit.get(context).usersModel?.name}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(fontWeight: FontWeight.bold)
                                  // ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: newPostController,
                        textInputAction: TextInputAction.done,
                        maxLines: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            SocialAppCubit.get(context)
                                .checkNewPostIsEmpty(value: value);
                            return "you should type any thing...";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value.isEmpty) {
                            SocialAppCubit.get(context)
                                .checkNewPostIsEmpty(value: null);
                          } else {
                            SocialAppCubit.get(context)
                                .checkNewPostIsEmpty(value: value);
                          }
                        },
                        onTap: () {
                          if (newPostController!.text.isEmpty) {
                            SocialAppCubit.get(context)
                                .checkNewPostIsEmpty(value: null);
                          } else {
                            SocialAppCubit.get(context).checkNewPostIsEmpty(
                                value: newPostController!.text);
                          }
                        },
                        // onFieldSubmitted: (value) {
                        //   if (value.isEmpty) {
                        //     SocialAppCubit.get(context)
                        //         .checkNewPostIsEmpty(value: null);
                        //   } else {
                        //     SocialAppCubit.get(context)
                        //         .checkNewPostIsEmpty(value: value);
                        //   }
                        // },
                        textAlign: newPostController!.text.isEmpty
                            ? TextAlign.start
                            : TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        decoration: const InputDecoration(
                          hintText: "whats on your mind...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  if (SocialAppCubit.get(context).postImage != null)
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          height: height * 0.25,
                          width: width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                          ),
                          margin: const EdgeInsets.all(8),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            color: Colors.grey,
                            child: Image.file(
                              SocialAppCubit.get(context).postImage!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, right: 15),
                          child: GestureDetector(
                              onTap: () {
                                SocialAppCubit.get(context).removePostImage();
                              },
                              child: const Icon(
                                Icons.close,
                                size: 25,
                              )),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.image),
                              Text("add photo"),
                            ],
                          ),
                          onPressed: () {
                            SocialAppCubit.get(context).pickPostImage();
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("# tags"),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }
}
