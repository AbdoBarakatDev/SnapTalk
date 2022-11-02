import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/modules/buttom_nav_modules/new_post/new_post.dart';
import 'package:flutter_social/modules/login_screen/login_cubit/login_cubit.dart';

import 'package:flutter_social/shared/components/components.dart';
import 'package:flutter_social/shared/components/app_constants.dart';
import 'package:flutter_social/shared/cubit/app_cubit.dart';
import '../../app_cubit/states.dart';

class HomeLayout extends StatelessWidget {
  static const String id = "HomeLayout";

  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {
        if (state is SocialAppNewPostScreenState) {
          printMSG("New Post");
          doWidgetNavigation(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        // UsersModel model = SocialAppCubit.get(context).model!;
        // printMSG("model  is $model ");
        return Scaffold(
          backgroundColor: AppCubit.get(context).isDark
              ? darkThemeSecondColor
              : lightThemePrimaryColor,
          bottomNavigationBar: BottomNavyBar(
              onItemSelected: (int value) {
                SocialAppCubit.get(context).changeBottomNav(value);
              },
              showElevation: true,
              selectedIndex: SocialAppCubit.get(context).index,
              items: [
                BottomNavyBarItem(
                  icon: const Icon(Icons.home),
                  title: const Text("Home"),
                  activeColor: Colors.red,
                ),
                BottomNavyBarItem(
                  icon: const Icon(Icons.chat),
                  title: const Text("Chats"),
                  activeColor: Colors.purpleAccent,
                ),
                BottomNavyBarItem(
                  icon: const Icon(Icons.post_add),
                  title: const Text("NewPost"),
                  activeColor: Colors.grey,
                ),
                BottomNavyBarItem(
                  icon: const Icon(Icons.supervised_user_circle_outlined),
                  title: const Text("Users"),
                  activeColor: Colors.pink,
                ),
                BottomNavyBarItem(
                  // icon: const Icon(Icons.settings_applications),
                  icon: const Icon(Icons.settings_applications),
                  title: const Text("Settings"),
                  activeColor: Colors.blue,
                ),
              ]),
          appBar: defaultAppBar(
            context: context,
            title: SocialAppCubit.get(context)
                .bottomNavScreenTitles[SocialAppCubit.get(context).index],
            actions: [
              if (SocialAppCubit.get(context).index == 0 ||
                  SocialAppCubit.get(context).index == 1)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
              if (SocialAppCubit.get(context).index == 0)
                IconButton(
                  onPressed: () {
                    LoginCubit.get(context).signOut(context);
                  },
                  icon: const Icon(Icons.notifications_none),
                ),
              PopupMenuButton<String>(
                onSelected: (value) =>
                    handleClick(context: context, value: value),
                itemBuilder: (BuildContext context) {
                  return {
                    'Logout',
                    AppCubit.get(context).isDark ? "Light Mode" : "Dark Mode"
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: SocialAppCubit.get(context)
              .bottomNavScreens[SocialAppCubit.get(context).index],
        );
      },
    );
  }

  void doEmailVerfication(BuildContext context) {
    FirebaseAuth.instance.currentUser?.sendEmailVerification().then((value) {
      showSnackBar(
          context: context,
          message: "Check your email",
          states: SnackBarStates.SUCCESS);
    }).onError((error, stackTrace) {
      printMSG(error.toString());
    });
  }

  void handleClick({String? value, BuildContext? context}) async {
    switch (value) {
      case 'Logout':
        await SocialAppCubit.get(context!).signOut(context);
        break;
      case 'Dark Mode':
        AppCubit.get(context!).changeThemeMode();
        break;
      case 'Light Mode':
        AppCubit.get(context!).changeThemeMode();
        break;
    }
  }
}
