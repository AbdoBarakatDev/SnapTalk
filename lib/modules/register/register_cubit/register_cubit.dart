import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/models/users_model.dart';
import 'package:flutter_social/modules/login_screen/login_screen.dart';
import 'package:flutter_social/modules/register/register_cubit/register_cubit_states.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:intl_phone_field/phone_number.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialStates());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  FirebaseAuth auth = FirebaseAuth.instance;

  // void register(
  //     {@required BuildContext? context,
  //     @required String? email,
  //     @required String? password,
  //     @required String? name,
  //     @required String? phone}) async {
  //   emit(RegisterLoadingStates());
  //   auth
  //       .createUserWithEmailAndPassword(email: email!, password: password!)
  //       .then((userCredential) {
  //     userCreate(
  //       context: context,
  //       email: email,
  //       name: name,
  //       phone: phone,
  //       uId: userCredential.user?.uid,
  //       bio: "Type your bio...",
  //       backgroundPicture:
  //           "https://media.istockphoto.com/photos/user-based-blockchain-futuristic-technology-backgrounds-picture-id1344724504?b=1&k=20&m=1344724504&s=170667a&w=0&h=Nk0gXz9WkXGHifkv498rDoJl1uOC7iw-RsgFESKm0Ms=",
  //       profilePicture:
  //           "https://img.freepik.com/free-photo/profile-shot-brutal-man-with-thick-foxy-beard-wears-round-glasses-looks-thoughtfully-aside_273609-17433.jpg?t=st=1656947988~exp=1656948588~hmac=76af713dbfd35d1228f9c22864011a15aabd7df67514168d51aa0f05f9fc5fc4&w=740",
  //     );
  //     showSnackBar(
  //         context: context,
  //         message: "registered successfully",
  //         states: SnackBarStates.SUCCESS);
  //     doReplacementWidgetNavigation(
  //         context!,
  //         LoginScreen(
  //           email: email,
  //           password: password,
  //         ));
  //     printMSG(userCredential.user?.email);
  //     printMSG(userCredential.user?.uid);
  //     printMSG(userCredential.user?.email);
  //     printMSG(userCredential.user?.uid);
  //     emit(RegisterSuccessStates());
  //   }).catchError((error) {
  //     showSnackBar(
  //         context: context,
  //         message: error.message.toString(),
  //         states: SnackBarStates.ERROR);

  //     printMSG(error.toString());
  //     emit(RegisterErrorStates(error.toString()));
  //   });
  // }

  void register(
      {@required BuildContext? context,
      @required String? email,
      @required String? password,
      @required String? name,
      @required String? phone}) async {
    emit(RegisterLoadingStates());
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);

      userCreate(
        context: context,
        email: email,
        name: name,
        phone: phone,
        uId: userCredential.user?.uid,
        bio: "Type your bio...",
        backgroundPicture:
            "https://media.istockphoto.com/photos/user-based-blockchain-futuristic-technology-backgrounds-picture-id1344724504?b=1&k=20&m=1344724504&s=170667a&w=0&h=Nk0gXz9WkXGHifkv498rDoJl1uOC7iw-RsgFESKm0Ms=",
        profilePicture:
            "https://img.freepik.com/free-photo/profile-shot-brutal-man-with-thick-foxy-beard-wears-round-glasses-looks-thoughtfully-aside_273609-17433.jpg?t=st=1656947988~exp=1656948588~hmac=76af713dbfd35d1228f9c22864011a15aabd7df67514168d51aa0f05f9fc5fc4&w=740",
      );

      showSnackBar(
          context: context,
          message: "registered successfully",
          states: SnackBarStates.SUCCESS);
      doReplacementWidgetNavigation(
          context!,
          LoginScreen(
            email: email,
            password: password,
          ));
      printMSG(userCredential.user?.email);
      printMSG(userCredential.user?.uid);
      printMSG(userCredential.user?.email);
      printMSG(userCredential.user?.uid);
      emit(RegisterSuccessStates());
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context,
          message: e.message.toString(),
          states: SnackBarStates.ERROR);

      printMSG(e.message.toString());
      emit(RegisterErrorStates(e.message.toString()));
    }
  }

  // String mapAuthCodeToMessage(String authCode) {
  //   String result = "";
  //   print("=====> $authCode");
  //   if (authCode.contains("wrong-password")) {
  //     result = "Password provided is not corrected";
  //   } else if (authCode.contains("invalid-email")) {
  //     result = "Email provided is invalid";
  //   } else if (authCode.contains("user-not-found")) {
  //     result = "User Not Found";
  //   } else if (authCode.contains("email-already-in-use")) {
  //     result = "The email address is already in use by another account.";
  //   }

  // return result;
  // }

  void userCreate({
    @required BuildContext? context,
    @required String? email,
    @required String? name,
    @required String? phone,
    @required String? uId,
    @required String? profilePicture,
    @required String? backgroundPicture,
    @required String? bio,
  }) {
    UsersModel usersModel = UsersModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      isEmailVerified: false,
      profilePicture: profilePicture,
      backgroundPicture: backgroundPicture,
      bio: bio,
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(usersModel.toMap()!)
        .then((userCredential) {
      emit(UserCreationSuccessStates());
    }).catchError((error) {
      emit(UserCreationErrorStates(error.toString()));

      printMSG(error.toString());
    });
  }

  bool isHidden = false;
  IconData icon = Icons.visibility_off_outlined;

  void changePasswordVisibility() {
    isHidden = !isHidden;
    isHidden
        ? icon = Icons.visibility_outlined
        : icon = Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityStates());
  }

  int maxLength = 11;

  maxLinesDetected({String? countryCode = "EG"}) {
    if (countryCode == "EG") {
      maxLength = 11;
    } else {
      maxLength = 13;
    }
    emit(ChangePhoneLengthStates());
  }
}
