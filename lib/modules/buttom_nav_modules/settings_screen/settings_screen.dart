import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/app_cubit/states.dart';
import 'package:flutter_social/modules/buttom_nav_modules/settings_screen/edit_profile/edit_profile.dart';
import 'package:flutter_social/shared/components/components.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = "SettingsScreen";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    printMSG(
        "Setting Screen model is : ${SocialAppCubit.get(context).usersModel?.toMap().toString()}");
    printMSG(
        "Setting Screen name is : ${SocialAppCubit.get(context).usersModel?.name}");
    printMSG(
        "Setting Screen uId is : ${SocialAppCubit.get(context).usersModel?.uId}");
    printMSG(
        "Setting Screen bio is : ${SocialAppCubit.get(context).usersModel?.bio}");
    printMSG(
        "Setting Screen phone is : ${SocialAppCubit.get(context).usersModel?.phone}");
    printMSG(
        "Setting Screen email is : ${SocialAppCubit.get(context).usersModel?.email}");


    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    // UsersModel? model=SocialAppCubit.get(context).usersModel;
    return Scaffold(
      body: ConditionalBuilder(
        condition: SocialAppCubit.get(context).usersModel != null,
        fallback: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        builder: (context) => BlocConsumer<SocialAppCubit, SocialAppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.33,
                      child: Align(
                        child: Stack(
                          alignment: Alignment.topCenter,
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
                              child: Image.network(
                                SocialAppCubit.get(context)
                                    .usersModel!
                                    .backgroundPicture
                                    .toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CircleAvatar(
                                radius: 62,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    SocialAppCubit.get(context)
                                        .usersModel!
                                        .profilePicture
                                        .toString(),
                                  ),
                                  radius: 60,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      SocialAppCubit.get(context).usersModel!.name.toString(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                        width: width * 0.50,
                        child: Text(
                            // 'If you want to be happy you must صلي علي النبي',
                            SocialAppCubit.get(context)
                                .usersModel!
                                .bio
                                .toString(),
                            maxLines: 2,
                            style: Theme.of(context).textTheme.button,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center)),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "100",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Posts",
                              style:
                                  Theme.of(context).textTheme.button?.copyWith(
                                        color: Colors.grey,
                                      ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "267",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Photos",
                              style:
                                  Theme.of(context).textTheme.button?.copyWith(
                                        color: Colors.grey,
                                      ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "100k",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Followers",
                              style:
                                  Theme.of(context).textTheme.button?.copyWith(
                                        color: Colors.grey,
                                      ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "90",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Following",
                              style:
                                  Theme.of(context).textTheme.button?.copyWith(
                                        color: Colors.grey,
                                      ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text("Add Photos"),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              doWidgetNavigation(context, EditProfileScreen());
                            },
                            child: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
