abstract class SocialState {}

class SocialInitialState extends SocialState {}

class SocialGetUserLoadinfState extends SocialState {}

class SocialGetUserSuccessState extends SocialState {}

class SocialGetUserErrorState extends SocialState {
  final error;

  SocialGetUserErrorState(this.error);
}

class SocialGetAllUsersLoadingState extends SocialState {}

class SocialGetAllUsersSuccessState extends SocialState {}

class SocialGetAllUsersErrorState extends SocialState {
  final error;

  SocialGetAllUsersErrorState(this.error);
}

class SocialBottomNavBarState extends SocialState {}

class SociaNewPostState extends SocialState {}

class SocialProfileImagePickedSuccessState extends SocialState {}

class SocialProfileImagePickedErrorState extends SocialState {}

class SocialProfileCoverPickedSuccessState extends SocialState {}

class SocialProfileCoverPickedErrorState extends SocialState {}

class SocialUploadProfileImagePickedSuccessState extends SocialState {}

class SocialUploadProfileImagePickedErrorState extends SocialState {}

class SocialUploadProfileCoverPickedSuccessState extends SocialState {}

class SocialUploadProfileCoverPickedErrorState extends SocialState {}

class SocialUserUpdateLoadingState extends SocialState {}

class SocialUserUpdateErrorState extends SocialState {}

class SocialCreatePostLoadingState extends SocialState {}

class SocialCreatePostSuccessState extends SocialState {}

class SocialCreatePostErrorState extends SocialState {}

class SocialPostImagePickedSuccessState extends SocialState {}

class SocialostImagePickedErrorState extends SocialState {}

class SocialUploadPostImagePickedSuccessState extends SocialState {}

class SocialUploadPostImagePickedErrorState extends SocialState {}

// post data
class SocialGetPostsLoadinfState extends SocialState {}

class SocialGetPostsSuccessState extends SocialState {}

class SocialGetPostsErrorState extends SocialState {
  final error;

  SocialGetPostsErrorState(this.error);
}

class SocialRemovePostImageState extends SocialState {}

class SocialLikePostSuccessState extends SocialState {}

class SocialLikePostErrorState extends SocialState {
  final error;

  SocialLikePostErrorState(this.error);
}
//chat state

class SocialSendMessageSuccessState extends SocialState {}

class SocialSendMessageErrorState extends SocialState {}

class SocialGetMessageSuccessState extends SocialState {}

class SocialGetMessageErrorState extends SocialState {}

//send image
class SocialChatImagePickedSuccessState extends SocialState {}

class SociaChatImagePickedErrorState extends SocialState {}

class SocialUploadChatImagePickedSuccessState extends SocialState {}

class SocialUploadChatImagePickedErrorState extends SocialState {}

class SocialChatImageState extends SocialState {}

// comments
class SocialCommentsLoadinfState extends SocialState {}

class SocialCommentsSuccessState extends SocialState {}

class SocialCommentsErrorState extends SocialState {}

class SocialGetCommentsSuccessState extends SocialState {}

class SocialGetCommentsErrorState extends SocialState {}
