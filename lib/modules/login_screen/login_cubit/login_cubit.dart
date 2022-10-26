import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/modules/login_screen/login_cubit/login_cubit_states.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:flutter_social/shared/network/local/darkness_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialStates());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  // ShopAppLoginModel modelData;
  bool isHidden = false;
  IconData icon = Icons.visibility_off_outlined;

  void changePasswordVisibility() {
    isHidden = !isHidden;
    isHidden
        ? icon = Icons.visibility_outlined
        : icon = Icons.visibility_off_outlined;
    emit(LoginChangePasswordVisibilityStates());
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  // void login(
  //     {@required BuildContext? context,
  //     @required String? email,
  //     @required String? password}) async {
  //   emit(LoginLoadingStates());
  //   await auth
  //       .signInWithEmailAndPassword(email: email!, password: password!)
  //       .then((value) {
  //     CashHelper.putData(key: "uId", value: value.user?.uid);
  //     printMSG("Sign value is ${value.user?.uid}");
  //     SocialAppCubit.get(context!).getCurrentUser(id: value.user?.uid);
  //     printMSG("Login Cubit Email is : ${value.user?.email}");
  //     printMSG("Login Cubit uId is : ${value.user?.uid}");
  //     emit(LoginSuccessStates(value.user?.uid));
  //   }).catchError((error) {
  //     printMSG("Error is: ${error.message.toString()}");
  //     emit(LoginErrorStates(error.message.toString()));
  //   });
  // }

  void login(
      {@required BuildContext? context,
      @required String? email,
      @required String? password}) async {
    emit(LoginLoadingStates());
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      CashHelper.putData(key: "uId", value: result.user?.uid);
      printMSG("Sign value is ${result.user?.uid}");
      SocialAppCubit.get(context!).getCurrentUser(id: result.user?.uid);
      printMSG("Login Cubit Email is : ${result.user?.email}");
      printMSG("Login Cubit uId is : ${result.user?.uid}");
      emit(LoginSuccessStates(result.user?.uid));
    } catch (e) {
      printMSG("Error is: ${mapAuthCodeToMessage(e.toString())}");
      emit(LoginErrorStates(mapAuthCodeToMessage(e.toString())));
    }
  }

  String mapAuthCodeToMessage(String authCode) {
    String result = "";
    print("=====> $authCode");
    if (authCode.contains("wrong-password")) {
      result = "Password provided is not corrected";
    } else if (authCode.contains("invalid-email")) {
      result = "Email provided is invalid";
    } else if (authCode.contains("user-not-found")) {
      result = "User Not Found";
    }
    return result;
  }
}
