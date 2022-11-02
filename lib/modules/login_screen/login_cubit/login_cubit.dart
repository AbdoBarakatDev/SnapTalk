import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/app_cubit/states.dart';
import 'package:flutter_social/modules/login_screen/login_cubit/login_cubit_states.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:flutter_social/shared/network/local/darkness_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

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
    } on FirebaseAuthException catch (e) {
      printMSG("Error is: ${e.message.toString()}");
      emit(LoginErrorStates(e.message.toString()));
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? photoUrl;
  Future<void> signInWithGoogle(BuildContext context) async {
    emit(LoginLoadingStates());
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      GoogleSignInAuthentication authentication =
          await googleSignInAccount!.authentication;

      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);

      await auth.signInWithCredential(authCredential);

      await auth.signInWithCredential(authCredential).then((value) async {
        final userRef =
            FirebaseFirestore.instance.collection("users").doc(value.user!.uid);
        if ((await userRef.get()).exists) {
          CashHelper.putData(key: "uId", value: value.user?.uid);
          SocialAppCubit.get(context).getCurrentUser(id: value.user?.uid);
          emit(LoginSuccessStates(value.user!.uid));
        } else {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(value.user!.uid)
              .set({
            "backgroundPicture":
                "https://media.istockphoto.com/photos/user-based-blockchain-futuristic-technology-backgrounds-picture-id1344724504?b=1&k=20&m=1344724504&s=170667a&w=0&h=Nk0gXz9WkXGHifkv498rDoJl1uOC7iw-RsgFESKm0Ms=",
            "bio": "Type your bio",
            "email": value.user!.email,
            "isEmailVerified": false,
            "name": value.user!.displayName,
            "phone": "",
            "profilePicture":
                "https://img.freepik.com/free-photo/profile-shot-brutal-man-with-thick-foxy-beard-wears-round-glasses-looks-thoughtfully-aside_273609-17433.jpg?t=st=1656947988~exp=1656948588~hmac=76af713dbfd35d1228f9c22864011a15aabd7df67514168d51aa0f05f9fc5fc4&w=740",
            "uId": value.user!.uid,
          }, SetOptions(merge: true));
          log("====User Email====><><>${value.user!.email}");
          log("====User uId====><><>${value.user!.uid}");

          log("====User uId====><><>${value.user!.uid}");
          log("Sign value is ${value.user?.uid}");
          CashHelper.putData(key: "uId", value: value.user?.uid);
          SocialAppCubit.get(context).getCurrentUser(id: value.user?.uid);
          log("====User uId====><><>${value.user!.uid}");
          ("Login Cubit Email is : ${value.user?.email}");
          log("====User uId====><><>${value.user!.uid}");
          ("Login Cubit uId is : ${value.user?.uid}");
          emit(LoginSuccessStates(value.user!.uid));
        }
      });
    } on FirebaseAuthException catch (e) {
      printMSG("Error is: ${e.message.toString()}");
      emit(LoginErrorStates(e.message.toString()));
    }
  }

  Future<void> signOut(BuildContext context) async {
    emit(SignOutLoadingState());
    try {
      await _googleSignIn.signOut();
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      emit(SignOutFailState());
    }
  }
}
