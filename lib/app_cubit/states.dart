abstract class SocialAppStates {}

class SocialAppInitialState extends SocialAppStates {}

class SocialAppSignOutLoadingState extends SocialAppStates {}

class SocialAppSignOutSuccessState extends SocialAppStates {}

class SocialAppSignOutFailState extends SocialAppStates {}

class SocialAppGetUsersLoadingState extends SocialAppStates {}

class SocialAppGetUsersSuccessState extends SocialAppStates {}

class SocialAppGetNotificationSuccessState extends SocialAppStates {}

class SocialAppGetNotificationErrorState extends SocialAppStates {}

class SocialAppGetUsersErrorState extends SocialAppStates {
  final String error;

  SocialAppGetUsersErrorState(this.error);
}

class SocialAppGetPostsLoadingState extends SocialAppStates {}

class SocialAppLoadLikesSuccessState extends SocialAppStates {}

class SocialAppGetPostsSuccessState extends SocialAppStates {}

class SocialAppGetPostsErrorState extends SocialAppStates {
  final String error;

  SocialAppGetPostsErrorState(this.error);
}

class SocialAppChangeBottomNavState extends SocialAppStates {}

class SocialAppNewPostScreenState extends SocialAppStates {}

class SocialAppPickProfileImageSuccessState extends SocialAppStates {}

class SocialAppPickProfileImageErrorState extends SocialAppStates {}

class SocialAppUploadBackgroundImageLoadingState extends SocialAppStates {}

class SocialAppPickBackgroundImageSuccessState extends SocialAppStates {}

class SocialAppPickBackgroundImageErrorState extends SocialAppStates {}

class SocialAppUploadProfileImageLoadingState extends SocialAppStates {}

class SocialAppUploadProfileImageSuccessState extends SocialAppStates {}

class SocialAppUploadProfileImageErrorState extends SocialAppStates {}

class SocialAppUploadBackgroundImageSuccessState extends SocialAppStates {}

class SocialAppUploadBackgroundImageErrorState extends SocialAppStates {}

class SocialAppGetProfileDownloadURLImageSuccessState extends SocialAppStates {}

class SocialAppGetProfileDownloadURLImageErrorState extends SocialAppStates {}

class SocialAppGetBackgroundDownloadURLImageSuccessState
    extends SocialAppStates {}

class SocialAppGetBackgroundDownloadURLImageErrorState extends SocialAppStates {
}

class SocialAppUpdateUserDataLoadingState extends SocialAppStates {}

class SocialAppUpdateUserDataWithoutImageLoadingState extends SocialAppStates {}

class SocialAppUpdateUserDataSuccessState extends SocialAppStates {}

class SocialAPPChangeVerifyPhoneButtonState extends SocialAppStates {}

class SocialAPPCheckPostTextIsEmptyState extends SocialAppStates {}

class SocialAppUpdateUserDataErrorState extends SocialAppStates {
  String error;

  SocialAppUpdateUserDataErrorState(this.error);
}

// for new posts
class SocialAppCreatePostLoadingState extends SocialAppStates {}

class SocialAppCreatePostSuccessState extends SocialAppStates {}

class SocialAppCreatePostErrorState extends SocialAppStates {}

class SocialAppRemovePostImageState extends SocialAppStates {}

class SocialAppRemovePostTextState extends SocialAppStates {}

class SocialAppPickPostImageSuccessState extends SocialAppStates {}

class SocialAppPickPostImageErrorState extends SocialAppStates {}

class SocialAppAddLikeSuccessState extends SocialAppStates {}

class SocialAppAddLikeErrorState extends SocialAppStates {}

class SocialAppRemoveLikeSuccessState extends SocialAppStates {}

class SocialAppRemoveLikeErrorState extends SocialAppStates {}

class SocialAppDeletePostLoadingState extends SocialAppStates {}

class SocialAppDeletePostSuccessState extends SocialAppStates {}

class SocialAppDeletePostErrorState extends SocialAppStates {}

// for messages
class SocialAppSendMessageSuccessState extends SocialAppStates {}

class SocialAppSendMessageErrorState extends SocialAppStates {}

class SocialAppGetMessagesSuccessState extends SocialAppStates {}

class SocialAppGetLastMessagesLoadingState extends SocialAppStates {}

class SocialAppGetLastMessagesSuccessState extends SocialAppStates {}

class SocialAppGetLastMessageModelSuccessState extends SocialAppStates {}

class SocialChangeEmojiState extends SocialAppStates {}

class SocialCheckTextMessageEmptyState extends SocialAppStates {}

class SocialDrawFillLikeSuccessState extends SocialAppStates {}

class SocialDrawFillLikeErrorState extends SocialAppStates {}

class SocialCheckStartingLanguageStates extends SocialAppStates {}

class SocialAppAddMarkersSuccessState extends SocialAppStates {}

class SocialAppGetCurrentLocationSuccessState extends SocialAppStates {}
