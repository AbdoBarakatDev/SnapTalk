import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/modules/buttom_nav_modules/chats_screen/chat_details_screen/chat_details_screen.dart';
import 'package:flutter_social/modules/buttom_nav_modules/chats_screen/chats_screen.dart';
import 'package:flutter_social/modules/buttom_nav_modules/new_post/new_post.dart';
import 'package:flutter_social/modules/buttom_nav_modules/settings_screen/edit_profile/change_phone/change_phone_screen.dart';
import 'package:flutter_social/modules/buttom_nav_modules/settings_screen/edit_profile/change_phone/recieve_pincode_screen.dart';
import 'package:flutter_social/modules/buttom_nav_modules/settings_screen/edit_profile/edit_profile.dart';
import 'package:flutter_social/modules/buttom_nav_modules/users_screen/users_screen.dart';
import 'package:flutter_social/modules/home_layout/home_layout.dart';
import 'package:flutter_social/modules/login_screen/login_cubit/login_cubit.dart';
import 'package:flutter_social/modules/login_screen/login_screen.dart';
import 'package:flutter_social/modules/register/register_cubit/register_cubit.dart';
import 'package:flutter_social/modules/register/register_screen.dart';
import 'package:flutter_social/network/end_points.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:flutter_social/shared/cubit/app_cubit.dart';
import 'package:flutter_social/shared/cubit/app_states.dart';
import 'package:flutter_social/shared/network/local/darkness_helper.dart';
import 'package:flutter_social/shared/network/remote/dio_helper.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  printMSG(
      "Notification details for onBackgroundMessage :${message.notification?.title.toString()}");
  showToast(
      message:
          "onBackground Message : ${message.notification?.title.toString()}",
      color: Colors.green);
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  token = await FirebaseMessaging.instance.getToken();
  printMSG("Token is : ${token.toString()}");

  FirebaseMessaging.onMessage.listen((event) {
    printMSG(
        "Notification details for onMessage : ${event.notification?.title.toString()}");
    showToast(
        message: "onMessage : ${event.notification?.title.toString()}",
        color: Colors.green);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    printMSG(
        "Notification details for onMessageOpenedApp : ${event.notification?.title.toString()}");
    showToast(
        message: "onMessageOpenedApp : ${event.notification?.title.toString()}",
        color: Colors.green);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  AppDioHelper.init();
  await CashHelper.init();
  Widget? startUpWidget;
  String? startUpWidgetID;
  bool? isDarkFromShared = CashHelper.getBoolean(key: "isDark");
  uId = CashHelper.getData(key: "uId");
  printMSG("isDarkFromShared $isDarkFromShared");

  if (uId != null) {
    printMSG("Already Logged Before ${uId.toString()}");
    startUpWidget = const HomeLayout();
    startUpWidgetID = HomeLayout.id;
  } else {
    printMSG("Didn't Logged Yet");
    startUpWidget = LoginScreen();
    startUpWidgetID = LoginScreen.id;
  }
  runApp(MyApp(
      startUpWidgetID: startUpWidgetID,
      startUpWidget: startUpWidget,
      isDark: isDarkFromShared));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget? startUpWidget;
  final String? startUpWidgetID;

  const MyApp({
    Key? key,
    this.startUpWidget,
    this.startUpWidgetID,
    this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) =>
              AppCubit()..changeThemeMode(isDarkFromShared: isDark),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),
        BlocProvider<RegisterCubit>(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider<SocialAppCubit>(
          create: (context) => SocialAppCubit()
            ..getCurrentUser(id: uId)
            ..getAllUsersV2()
            ..getPostsV2()
            ..getPostsLikesV2()
            ..getLastMessages(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          color: Theme.of(context).primaryColor,
          theme: AppCubit.get(context).isDark
              ? ThemeData.dark()
              : ThemeData.light(),
          debugShowCheckedModeBanner: false,
          home: startUpWidget,
          initialRoute: startUpWidgetID,
          routes: {
            LoginScreen.id: (context) => LoginScreen(),
            RegisterScreen.id: (context) => RegisterScreen(),
            HomeLayout.id: (context) => const HomeLayout(),
            NewPostScreen.id: (context) => NewPostScreen(),
            EditProfileScreen.id: (context) => EditProfileScreen(),
            ChangePhoneScreen.id: (context) => ChangePhoneScreen(),
            ReceivePinCodeScreen.id: (context) => ReceivePinCodeScreen(),
            ChatsScreen.id: (context) => const ChatsScreen(),
            ChatDetailsScreen.id: (context) => ChatDetailsScreen(),
            UsersScreen.id: (context) => UsersScreen(),
          },
        ),
      ),
    );
  }
}
