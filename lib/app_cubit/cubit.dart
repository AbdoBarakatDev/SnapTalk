import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/states.dart';
import 'package:flutter_social/models/chats_model.dart';
import 'package:flutter_social/models/new_post_model.dart';
import 'package:flutter_social/models/users_model.dart';
import 'package:flutter_social/modules/buttom_nav_modules/chats_screen/chats_screen.dart';
import 'package:flutter_social/modules/buttom_nav_modules/home_screen/home_screen.dart';
import 'package:flutter_social/modules/buttom_nav_modules/new_post/new_post.dart';
import 'package:flutter_social/modules/buttom_nav_modules/settings_screen/settings_screen.dart';
import 'package:flutter_social/modules/buttom_nav_modules/users_screen/users_screen.dart';
import 'package:flutter_social/modules/login_screen/login_screen.dart';
import 'package:flutter_social/network/end_points.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:flutter_social/shared/network/local/darkness_helper.dart';
import 'package:flutter_social/shared/network/remote/dio_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SocialAppCubit extends Cubit<SocialAppStates> {
  SocialAppCubit() : super(SocialAppInitialState());

  static SocialAppCubit get(BuildContext context) => BlocProvider.of(context);

  UsersModel? usersModel;

  // BuildContext? context;

  getCurrentUser({String? id}) {
    emit(SocialAppGetUsersLoadingState());
    if (id != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .get()
          .then((value) {
        usersModel = UsersModel.fromJson(value.data()!);
        // printMsg("Cubit User Model : ${usersModel?.toMap().toString()}");
        // printMsg("Cubit Data is : ${value.data().toString()}");
        emit(SocialAppGetUsersSuccessState());
      }).catchError((error) {
        emit(SocialAppGetUsersErrorState(error.toString()));
      });
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(uId)
          .get()
          .then((value) {
        usersModel = UsersModel.fromJson(value.data()!);
        // printMsg("Cubit User Model : ${usersModel?.toMap().toString()}");
        // printMsg("Cubit Data is : ${value.data().toString()}");
        emit(SocialAppGetUsersSuccessState());
      }).catchError((error) {
        emit(SocialAppGetUsersErrorState(error.toString()));
      });
    }
  }

  signOut(BuildContext context) {
    emit(SocialAppSignOutLoadingState());
    FirebaseAuth.instance.signOut().then((value) {
      CashHelper.clearData(key: "uId").then((value) {
        // printMsg("From Sign Out Value is :$value");
        emit(SocialAppSignOutSuccessState());
        // printMsg("Signing Out....  UID value :$uId");
        doReplacementWidgetNavigation(context, LoginScreen());
      });
    }).catchError((error) {
      emit(SocialAppSignOutFailState());
    });
  }

  List<Widget> bottomNavScreens = [
    HomeScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    const SettingsScreen(),
  ];
  List<String> bottomNavScreenTitles = [
    "Home",
    "Chats",
    "New Post",
    "Users",
    "Settings",
  ];

  int index = 0;

  changeBottomNav(int value) {
    // printMsg("Value of index : $index");
    if (value == 0) {
      // getPostsV2();
      // getPostsLikesV2();
    }
    if (value == 1) {
      getAllUsersV2();
      // getLastMessages();
    }
    if (value == 2) {
      emit(SocialAppNewPostScreenState());
    } else {
      index = value;
      emit(SocialAppChangeBottomNavState());
    }
  }

  final ImagePicker picker = ImagePicker();

  File? profileImage;

  Future<void> pickProfileImage() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      emit(SocialAppPickProfileImageSuccessState());
    } else {
      // printMsg("No Selected Image!");
      emit(SocialAppPickProfileImageErrorState());
    }
  }

  File? backgroundImage;

  Future<void> pickBackgroundImage() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      backgroundImage = File(pickedImage.path);
      emit(SocialAppPickProfileImageSuccessState());
    } else {
      // printMsg("No Selected Image!");
      emit(SocialAppPickProfileImageErrorState());
    }
  }

  uploadProfileImage({
    BuildContext? context,
    @required String? name,
    @required String? phone,
    @required String? bio,
  }) async {
    await FirebaseStorage.instance
        .ref()
        .child(
            "$userProfileImagesRef/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((value) {
      emit(SocialAppUpdateUserDataLoadingState());
      value.ref.getDownloadURL().then((value) {
        emit(SocialAppUploadProfileImageLoadingState());
        uploadUserData(
            name: name, phone: phone, bio: bio, profilePicture: value);
        // printMsg("profileImageUrl is : $value");
        showToast(context: context, message: "Profile updated Successfully");
      }).catchError((error) {
        emit(state);
      });
    }).catchError((error) {
      emit(SocialAppUploadProfileImageErrorState());
    });
  }

  uploadBackgroundImage({
    BuildContext? context,
    @required String? name,
    @required String? phone,
    @required String? bio,
  }) async {
    emit(SocialAppUpdateUserDataLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child(
            "$userBackgroundImagesRef/${Uri.file(backgroundImage!.path).pathSegments.last}")
        .putFile(backgroundImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        uploadUserData(name: name, phone: phone, bio: bio, profileCover: value);
        // printMsg("backgroundImageUrl is : $value");
        showToast(context: context, message: "Cover updated Successfully");
        emit(SocialAppGetBackgroundDownloadURLImageSuccessState());
      }).catchError((error) {
        emit(SocialAppGetBackgroundDownloadURLImageErrorState());
      });
    }).catchError((error) {
      emit(SocialAppUploadBackgroundImageErrorState());
    });
  }

  uploadUserData({
    BuildContext? context,
    @required String? name,
    @required String? phone,
    @required String? bio,
    String? profilePicture,
    String? profileCover,
  }) async {
    UsersModel model = UsersModel(
      name: name,
      phone: phone,
      isEmailVerified: false,
      bio: bio,
      email: usersModel?.email,
      uId: usersModel?.uId,
      profilePicture: profilePicture ?? usersModel?.profilePicture,
      backgroundPicture: profileCover ?? usersModel?.backgroundPicture,
    );

    var doc =
        await FirebaseFirestore.instance.collection("users").doc(uId).get();
    if (doc.exists) {
      // final DocumentReference documentReference =
      FirebaseFirestore.instance.collection("users").doc(uId);
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(uId)
          .update(model.toMap()!)
          .then((value) {
        getCurrentUser();
        emit(SocialAppUpdateUserDataSuccessState());
        showToast(context: context, message: "Updated Successfully");
      }).catchError((error) {
        emit(SocialAppUpdateUserDataErrorState(error.toString()));
        // printMsg(error.toString());
      });
    }
  }

  bool verifyPhoneButtonIsEnabled = false;

  changeVerifyPhoneButtonEnabled(bool value) {
    verifyPhoneButtonIsEnabled = value;
    emit(SocialAPPChangeVerifyPhoneButtonState());
  }

  bool? postIsEmpty = true;

  checkNewPostIsEmpty({String? value}) {
    // printMSG("Post Image is : $postImage");
    printMSG("value is: $value");
    // printMSG("value is: ${value.toString()}");
    if (value != null || postImage != null) {
      postIsEmpty = false;
    } else {
      postIsEmpty = true;
    }
    printMSG("postTextIsEmpty is: $postIsEmpty");

    emit(SocialAPPCheckPostTextIsEmptyState());
  }

  File? postImage;

  Future<void> pickPostImage() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      postImage = File(pickedImage.path);
      emit(SocialAppPickPostImageSuccessState());
    } else {
      // printMsg("No Selected Image!");
      emit(SocialAppPickPostImageErrorState());
    }
    checkNewPostIsEmpty();
  }

  String? postText;

  removePostTextFormTextAfterPostCreation() {
    postText = null;
    emit(SocialAppRemovePostTextState());
  }

  createPost({
    BuildContext? context,
    @required String? postText,
    String? postImage,
    @required String? dateTime,
  }) async {
    PostModel model = PostModel(
      name: usersModel?.name,
      uId: usersModel?.uId,
      profilePicture: usersModel?.profilePicture,
      dateTime: dateTime,
      postImage: postImage ?? "",
      postText: postText,
    );
    await FirebaseFirestore.instance
        .collection("posts")
        .add(model.toMap()!)
        .then((value) {
      FirebaseFirestore.instance.collection("posts").doc(value.id).set({
        "name": usersModel?.name,
        "uId": usersModel?.uId,
        "profilePicture": usersModel?.profilePicture,
        "dateTime": dateTime,
        "postImage": postImage ?? "",
        "postText": postText,
        "postId": value.id,
      });
      // getPostsV2();
      // getPostsLikesV2();
      Navigator.pop(context!);
      printMSG("Post Creation Id : ${value.id}");
      emit(SocialAppCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialAppCreatePostErrorState());
      // printMsg(error.toString());
    });
  }

  createPostWithImage({
    @required String? dateTime,
    @required String? postText,
  }) async {
    emit(SocialAppCreatePostLoadingState());

    await FirebaseStorage.instance
        .ref()
        .child(
            "$userPostsImagesRef/${Uri.file(postImage!.path).pathSegments.last}")
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(postText: postText, dateTime: dateTime, postImage: value);
        // printMsg("backgroundImageUrl is : $value");
        posts = [];
        postsIds = [];
        likes = [];
        emit(SocialAppCreatePostSuccessState());
      }).catchError((error) {
        emit(SocialAppCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialAppCreatePostErrorState());
    });
  }

  removePostImage() {
    postImage = null;
    emit(SocialAppRemovePostImageState());
    checkNewPostIsEmpty();
  }

  List<PostModel> posts = [];
  List<String> postsIds = [];

  getPostsV2() {
    emit(SocialAppGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection(postsFirestoreCollectionName)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      postsIds = [];
      posts = [];
      for (var element in event.docs) {
        postsIds.add(element.id);
        posts.add(PostModel.fromJson(element.data()));
        element.reference
            .collection(postLikesFirestoreCollectionName)
            .snapshots()
            .listen((event) {
          // printMsg("Post Likes : ${event.docs.length}");
          // postLikes.add(event.docs.length);
          emit(SocialAppLoadLikesSuccessState());
        });
      }
      emit(SocialAppGetPostsSuccessState());
    });
  }

  List<int> postLikes = [];
  List<bool> likes = [];

  getPostsLikesV2() {
    // emit(SocialAppGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection(postsFirestoreCollectionName)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      postLikes = [];
      for (var element in event.docs) {
        element.reference
            .collection(postLikesFirestoreCollectionName)
            .snapshots()
            .listen((event) {
          // if (event.size > 0 &&
          //     event.docs != null &&
          //     event.docs.single != null &&
          //     event.docs.single.get("like") != null &&
          //     (event.docs.single.get("like")) as bool == true) {
          //   postLikes.add(event.docs.length);
          // } else {
          postLikes.add(0);
          // }
          emit(SocialAppLoadLikesSuccessState());
        });
      }
      printMSG("Likes ::::  ${postLikes.toString()}");
      drawFillLikeV2();
      emit(SocialAppGetPostsSuccessState());
    });
  }

  drawFillLikeV2() {
    likes = [];
    for (var item in postsIds) {
      FirebaseFirestore.instance
          .collection(postsFirestoreCollectionName)
          .doc(item)
          .collection(postLikesFirestoreCollectionName)
          .doc(usersModel?.uId)
          .snapshots()
          .listen((event) {
        printMSG("value draw ${event.exists}");
        if (event.exists) {
          likes.add(true);
        } else {
          likes.add(false);
        }
        emit(SocialDrawFillLikeSuccessState());
      });
    }
  }

  void addPostsLikeV2(String postId) {
    FirebaseFirestore.instance
        .collection(postsFirestoreCollectionName)
        .doc(postId)
        .collection(postLikesFirestoreCollectionName)
        .doc(usersModel?.uId)
        .get()
        .then((value) {
      if (value.exists) {
        FirebaseFirestore.instance
            .collection(postsFirestoreCollectionName)
            .doc(postId)
            .collection(postLikesFirestoreCollectionName)
            .doc(usersModel?.uId)
            .delete()
            .then((value) {
          getPostsLikesV2();
          emit(SocialAppRemoveLikeSuccessState());
        }).catchError((error) {
          emit(SocialAppRemoveLikeErrorState());
        });
      } else {
        FirebaseFirestore.instance
            .collection(postsFirestoreCollectionName)
            .doc(postId)
            .collection(postLikesFirestoreCollectionName)
            .doc(usersModel?.uId)
            .set({
          "like": true,
        }).then((value) {
          getPostsLikesV2();
          emit(SocialAppAddLikeSuccessState());
        }).catchError((error) {
          emit(SocialAppAddLikeErrorState());
        });
      }
    });
  }

  void deletePost(String? postId) async {
    printMSG("Post Id : $postId");
    emit(SocialAppDeletePostLoadingState());
    await FirebaseFirestore.instance
        .collection(postsFirestoreCollectionName)
        .doc(postId)
        .delete()
        .then((value) {
      getPostsV2();
      getPostsLikesV2();
      printMSG("Post Deleted Successfully");
      emit(SocialAppDeletePostSuccessState());
    }).catchError((error) {
      printMSG("Can not Delete The Post ");
      emit(SocialAppDeletePostErrorState());
    });
  }

  List<String> allUsersIds = [];
  List<UsersModel> allUsers = [];

  getAllUsers() async {
    if (allUsers.isEmpty) {
      emit(SocialAppGetPostsLoadingState());

      await FirebaseFirestore.instance
          .collection(usersFirestoreCollectionName)
          .get()
          .then((value) {
        for (var element in value.docs) {
          if (element.id != uId) {
            allUsersIds.add(element.data()["uId"].toString());
          }
        }

        for (var element in value.docs) {
          if (element.id != uId) {
            allUsers.add(UsersModel.fromJson(element.data()));
          }
        }
        emit(SocialAppGetPostsSuccessState());
      }).catchError((error) {
        emit(SocialAppGetPostsErrorState(error.toString()));
      });
    }
  }

  getAllUsersV2() {
    if (allUsers.isEmpty) {
      emit(SocialAppGetPostsLoadingState());

      FirebaseFirestore.instance
          .collection(usersFirestoreCollectionName)
          .snapshots()
          .listen((event) {
        for (var element in event.docs) {
          if (element.id != uId) {
            allUsersIds.add(element.data()["uId"].toString());
          }
        }

        for (var element in event.docs) {
          if (element.id != uId) {
            allUsers.add(UsersModel.fromJson(element.data()));
          }
        }
        emit(SocialAppGetPostsSuccessState());
      });
    }
  }

  sendMessage({
    @required String? reciverId,
    @required String? dateTime,
    @required String? messageText,
  }) async {
    MessagesModel messageModel = MessagesModel(
        dateTime: dateTime,
        messageText: messageText,
        receiverId: reciverId,
        senderId: usersModel?.uId);

    await FirebaseFirestore.instance
        .collection(usersFirestoreCollectionName)
        .doc(usersModel?.uId)
        .collection(chatsFirestoreCollectionName)
        .doc(reciverId)
        .collection(messagesFirestoreCollectionName)
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialAppSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialAppSendMessageErrorState());
    });
  }

  List<MessagesModel> messages = [];

  getMessages({@required String? receiverId}) {
    FirebaseFirestore.instance
        .collection(usersFirestoreCollectionName)
        .doc(usersModel?.uId)
        .collection(chatsFirestoreCollectionName)
        .doc(receiverId)
        .collection(messagesFirestoreCollectionName)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .listen((event) {
      printMSG(
          "Last is : ${event.docs.isNotEmpty ? event.docs.last.data().toString() : null}");
      messages = [];
      for (var element in event.docs) {
        messages.add(MessagesModel.fromJson(element.data()));
        //   if (event.docs[event.docs.length - 1].exists) {
        //     getMessageNotification(
        //         messageTitle: "You Got a message ",
        //         messageDetails: element.data()["messageText"]);
        //   }
      }
      emit(SocialAppGetMessagesSuccessState());
    });
  }

  bool emojiShowing = false;

  hideShowEmoji() {
    emojiShowing = !emojiShowing;
    emit(SocialChangeEmojiState());
  }

  List<MessagesModel> lastMessages = [];

  getLastMessages() async {
    emit(SocialAppGetLastMessagesLoadingState());
    // printMsg("START HERE!");
    // printMsg("All Ids got : ${allUsersIds.toString()}");
    lastMessages = [];
    for (var id in allUsersIds) {
      await FirebaseFirestore.instance
          .collection(usersFirestoreCollectionName)
          .doc(usersModel?.uId)
          .collection(chatsFirestoreCollectionName)
          .doc(id)
          .collection(messagesFirestoreCollectionName)
          .orderBy('dateTime', descending: false)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          printMSG("=>>>>>  ${value.docs.last.data().toString()}");
          lastMessages.add(MessagesModel.fromJson(value.docs.last.data()));
        } else {
          lastMessages.add(MessagesModel.fromJson({}));
        }
      });
    }
    printMSG("Last Edit : ${lastMessages.toString()}");
    emit(SocialAppGetLastMessagesSuccessState());
  }

  bool isTextMessageEmpty = true;

  void checkTextMessageIsEmpty(String value) {
    isTextMessageEmpty = value.isEmpty ? true : false;
    emit(SocialCheckTextMessageEmptyState());
  }

  String convertDateToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} day(s) ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour(s) ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute(s) ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second(s) ago';
    } else {
      return 'just now';
    }
  }

  void getMessageNotification(
      {@required String? messageDetails,
      @required String? messageTitle,
      BuildContext? context}) {
    AppDioHelper.post(
      url: sendNotificationUrl,
      data: {
        "to": "$token",
        "notification": {
          "body": "$messageDetails",
          "title": "$messageTitle",
          "sound": "default"
        },
        "data": {
          "type": "order",
          "id": 87,
          "click_action": "FLUTTER_NOTFICATION_CLICK"
        },
        "android": {
          "priority": "HIGH",
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "default",
            "default_sound": true,
            "default_vibrate_timings": true,
            "default_light_settings": true
          }
        }
      },
      token: token!,
    ).then((value) {
      // printMsg("Status Message is : ${value.statusMessage}");
      // printMsg("Message data is : ${value.data}");
      emit(SocialAppGetNotificationSuccessState());
    });
  }

  bool? isStartWithArabic = false;

  chekStartingWithArabic(String? text) {
    RegExp regex = RegExp(
        "[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]");
    isStartWithArabic = regex.hasMatch(text!.substring(0, 1));
    // printMsg("Test Arabic Or Not for $text as start with ${text.substring(0,1)} : $isStartWithArabic");
  }

  // for maps
  var myMarkers = HashSet<Marker>();

  addToMarkers(Marker marker) {
    myMarkers.add(marker);
    emit(SocialAppAddMarkersSuccessState());
  }

  // LatLng? currentPostion;

  // void getUserLocation() async {
  //   var position = await GeolocatorPlatform.instance.getCurrentPosition(
  //     locationSettings: const LocationSettings(
  //       accuracy: LocationAccuracy.high,
  //     ),
  //   );

  //   currentPostion = LatLng(position.latitude, position.longitude);
  //   emit(SocialAppGetCurrentLocationSuccessState());
  // }
}

enum PermissionGroup { locationAlways, locationWhenInUse }
