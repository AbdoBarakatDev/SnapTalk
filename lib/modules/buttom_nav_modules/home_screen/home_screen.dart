import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/app_cubit/states.dart';
import 'package:flutter_social/models/new_post_model.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:flutter_social/shared/cubit/app_cubit.dart';

class HomeScreen extends StatelessWidget {
  static const String id = "HomeScreen";

  HomeScreen({Key? key}) : super(key: key);
  double? height;

  double? width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocConsumer<SocialAppCubit, SocialAppStates>(
        listener: (context, state) {
          if (state is SocialAppDeletePostLoadingState) {
            const Center(child: CircularProgressIndicator());
          }
        },
        builder: (context, state) {
          return ConditionalBuilder(
              condition: SocialAppCubit.get(context).posts.isNotEmpty &&
                  SocialAppCubit.get(context).postLikes.isNotEmpty &&
                  // SocialAppCubit.get(context).posts.length ==
                  // SocialAppCubit.get(context).likes.length &&
                  SocialAppCubit.get(context).usersModel != null,
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
              builder: (context) {
                return RefreshIndicator(
                  onRefresh: () => _pullRefresh(context),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height! * 0.25,
                          width: width,
                          child: Card(
                            margin: const EdgeInsets.all(8),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Stack(fit: StackFit.expand, children: [
                              Image.network(
                                "https://img.freepik.com/free-photo/pile-3d-popular-social-media-logos_1379-881.jpg?w=740&t=st=1653139102~exp=1653139702~hmac=3bfb526ee5ccfe048147b8c8e5e21f1c4c30b202ba8603935d9a75bf48550c82",
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Communicate with friends",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            itemBuilder: (context, index) => buildPostItem(
                                context: context,
                                postModel:
                                    SocialAppCubit.get(context).posts[index],
                                indexOfId: index),
                            itemCount: SocialAppCubit.get(context).posts.length)
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  buildPostItem({BuildContext? context, PostModel? postModel, int? indexOfId}) {
    SocialAppCubit.get(context!).chekStartingWithArabic(postModel?.postText);
    printMSG(
        "postsLike Length : ${SocialAppCubit.get(context).postLikes.length}");
    printMSG("posts Length : ${SocialAppCubit.get(context).posts.length}");
    printMSG("likes Length : ${SocialAppCubit.get(context).likes.length}");
    printMSG("postsLike : ${SocialAppCubit.get(context).postLikes.toString()}");
    // printMSG("posts : ${SocialAppCubit.get(context).posts[indexOfId!].uId.toString()}");
    printMSG("likes : ${SocialAppCubit.get(context).likes.toString()}");
    printMSG("PostsIDS : ${SocialAppCubit.get(context).postsIds.toString()}");
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppCubit.get(context).appPrimaryColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: SocialAppCubit.get(context).isStartWithArabic!
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage("${postModel?.profilePicture}"),
                radius: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text("${postModel?.name}",
                        style: Theme.of(context).textTheme.bodyText1
                        // ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 15,
                    )
                  ]),
                  Text(
                    // "${postModel?.dateTime}",
                    SocialAppCubit.get(context).convertDateToAgo(
                        DateTime.parse((postModel?.dateTime).toString())),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz_outlined),
                onSelected: (value) => handlePostPopUpClick(
                    context: context, value: value, postId: postModel?.postId),
                itemBuilder: (BuildContext context) {
                  return {"Share Post", 'Delete Post'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
              height: 0,
              color: Colors.grey.shade700,
              endIndent: 5,
              thickness: 1,
              indent: 5),
          const SizedBox(
            height: 5,
          ),
          Text(
            textAlign: SocialAppCubit.get(context).isStartWithArabic!
                ? TextAlign.end
                : TextAlign.start,
            "${postModel?.postText}",
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
            style: Theme.of(context).textTheme.button,
          ),
          const SizedBox(
            height: 5,
          ),
          // Wrap(
          //   spacing: 3,
          //   // crossAxisAlignment: WrapCrossAlignment.start,
          //   // alignment: WrapAlignment.start,
          //   children: [
          //     addHashtag(context, "Software"),
          //     addHashtag(context, "Programming"),
          //     addHashtag(context, "DataBase"),
          //     addHashtag(context, "IQ"),
          //     addHashtag(context, "Flutter"),
          //   ],
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          postModel?.postImage != ""
              ? Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  // height: height! * 0.3,
                  // width: width,
                  child: FadeInImage(
                    image: NetworkImage(
                      "${postModel?.postImage}",
                    ),
                    placeholder: AssetImage(
                      AppCubit.get(context).isDark
                          ? "assets/images/Loading_icon_dark.gif"
                          : "assets/images/loading_icon.gif",
                    ),
                    // height: 100,
                    // width: 100,
                    placeholderFit: BoxFit.fill,
                    fit: BoxFit.cover,
                  ),
                  // Image.network(
                  //   "${postModel?.postImage}",
                  //   fit: BoxFit.scaleDown,
                  // ),
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  //on show all likes
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                        "${SocialAppCubit.get(context).postLikes.length == SocialAppCubit.get(context).posts.length && SocialAppCubit.get(context).postLikes.isNotEmpty ? SocialAppCubit.get(context).postLikes[indexOfId!] : "0"}")
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  //on show all comments
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.comment_bank,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("0 comments")
                  ],
                ),
              ),
            ],
          ),
          Divider(
              height: 20,
              color: Colors.grey.shade700,
              endIndent: 5,
              thickness: 1,
              indent: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  //on comment clicked
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "${SocialAppCubit.get(context).usersModel?.profilePicture}"),
                      radius: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Write a comment...",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  //on Like clicked
                  SocialAppCubit.get(context).addPostsLikeV2(
                      SocialAppCubit.get(context).postsIds[indexOfId!]);
                },
                child: Row(
                  children: [
                    Icon(
                      SocialAppCubit.get(context).likes.isNotEmpty &&
                              (SocialAppCubit.get(context).likes.length ==
                                      SocialAppCubit.get(context)
                                          .postsIds
                                          .length &&
                                  SocialAppCubit.get(context)
                                          .likes[indexOfId!] ==
                                      true)
                          ? Icons.favorite_outlined
                          : Icons.favorite_border_outlined,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text("Like")
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pullRefresh(BuildContext? context) async {
    SocialAppCubit.get(context!).getPostsV2();
    SocialAppCubit.get(context).getPostsLikesV2();
  }
}

addHashtag(BuildContext context, String hashText) {
  return GestureDetector(
    onTap: () {
      showSnackBar(
          context: context,
          message: "$hashText Is Clicked",
          states: SnackBarStates.SUCCESS);
    },
    child: Text("#$hashText",
        style:
            Theme.of(context).textTheme.caption?.copyWith(color: Colors.blue)),
  );
}

void handlePostPopUpClick(
    {String? value, BuildContext? context, String? postId}) {
  switch (value) {
    case 'Share Post':
      SocialAppCubit.get(context!).signOut(context);
      break;
    case 'Delete Post':
      SocialAppCubit.get(context!).deletePost(postId);
      break;
  }
}
