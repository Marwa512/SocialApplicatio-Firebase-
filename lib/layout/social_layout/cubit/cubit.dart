// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_socialapp/models/Social_chat_model.dart';
import 'package:firebase_socialapp/models/social_comment_model.dart';
import 'package:firebase_socialapp/models/socialpostmodel.dart';
import 'package:firebase_socialapp/modules/newpost/new_post.dart';
import 'package:firebase_socialapp/modules/notification/notification.dart';
import 'package:image_picker/image_picker.dart';
import '/modules/chats/chats.dart';
import '/modules/setting/setting.dart';
import '/models/socialusermodel.dart';
import '/modules/home/home.dart';
import '/modules/users/users.dart';
import '/shared/component/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitialState());
  static SocialCubit get(context) => BlocProvider.of(context);
  SocialUserModel? userData;
  SocialPostModel? postsModel;
  void GetUser() {
    emit(SocialGetUserLoadinfState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      userData = SocialUserModel.FromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error));
    });
  }

  List<SocialPostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> comments = [];

  List<bool> isLike = [];

  void GetPosts() {
    posts = [];
    likes = [];
    isLike = [];
    postsId = [];
    comments = [];
    emit(SocialGetPostsLoadinfState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      //postsModel = SocialPostModel.FromJson(value.data()!);

      value.docs.forEach(
        (element) {
          element.reference
              .collection('comments')
              .get()
              .then((value) => comments.add(value.docs.length))
              .catchError((onError) {});
          element.reference.collection('likes').get().then((value) {
            //  print("isLikes ${value.docs(userData!.uid)}");
            posts.add(SocialPostModel.FromJson(element.data()));
            postsId.add(element.id);
            getLikes(postId: element.id);
            likes.add(value.docs.length);
          }).catchError((error) {});
        },
      );

      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetPostsErrorState(error));
    });
  }

  void getLikes({required String postId}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userData!.uid)
        .get()
        .then((value) {
      print(' GET LIKES VALUE${value.data() ?? {'likes': false}}');
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialLikePostErrorState(error));
    });
  }

  List<SocialUserModel> users = [];

  void GetUsers() {
    users = [];
    emit(SocialGetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('Users').get().then((value) {
      value.docs.forEach(
        (element) {
          if (element.data()['uid'] != userData!.uid) {
            users.add(SocialUserModel.FromJson(element.data()));
          }
        },
      );
      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetAllUsersErrorState(error));
    });
  }

  int currentIndex = 0;
  List<Widget> screen = [
    const SocialHomeScreen(),
    const SocialChatsScreen(),
    NewPostScreen(),
    const SocialSettingScreen(),
  ];

  void BottomNavBar(index) {
    if (index == 1) {
      GetUsers();
    }
    if (index == 2) {
      emit(SociaNewPostState());
    } else {
      currentIndex = index;
      emit(SocialBottomNavBarState());
    }
  }

  int currentTitle = 0;
  List<String> titles = ['Home', 'Chats ', 'New Post', 'Profile '];

  File? ProfileImage;
  var picker = ImagePicker();
  Future<void> getProfileImage() async {
    final PickedFile = await picker.getImage(source: ImageSource.gallery);

    if (PickedFile != null) {
      ProfileImage = File(PickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print("No Image Selected");
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? ProfileCover;

  Future<void> getProfileCover() async {
    final PickedFile = await picker.getImage(source: ImageSource.gallery);

    if (PickedFile != null) {
      ProfileCover = File(PickedFile.path);
      emit(SocialProfileCoverPickedSuccessState());
    } else {
      print("No Image Selected");
      emit(SocialProfileCoverPickedErrorState());
    }
  }

  void uploadProfileImage({
    required String bio,
    required String name,
    required String phone,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(ProfileImage!.path).pathSegments.last}')
        .putFile(ProfileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadProfileImagePickedSuccessState());
        updateUser(
          bio: bio,
          name: name,
          phone: phone,
          image: value,
        );
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialUploadProfileImagePickedErrorState());
    });
  }

  void uploadProfileCover({
    required String bio,
    required String name,
    required String phone,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(ProfileCover!.path).pathSegments.last}')
        .putFile(ProfileCover!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadProfileCoverPickedSuccessState());
        updateUser(bio: bio, name: name, phone: phone, cover: value);
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialUploadProfileCoverPickedErrorState());
    });
  }

  void updateUser({
    required String bio,
    required String name,
    required String phone,
    String? cover,
    String? image,
  }) {
    emit(SocialUserUpdateLoadingState());
    SocialUserModel model = SocialUserModel(
      bio: bio,
      name: name,
      phone: phone,
      cover: cover ?? userData!.cover,
      email: userData!.email,
      uid: userData!.uid,
      image: image ?? userData!.image,
    );
    emit(SocialUserUpdateLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userData!.uid)
        .update(model.ToMap())
        .then((value) {
      GetUser();
    }).catchError((error) {
      print(error.toString());
      emit(SocialUserUpdateErrorState());
    });
  }

//upload post

  File? postImage;

  Future<void> getpostImage() async {
    final PickedFile = await picker.getImage(source: ImageSource.gallery);

    if (PickedFile != null) {
      postImage = File(PickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print("No Image Selected");
      emit(SocialostImagePickedErrorState());
    }
  }

  void RemovePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void UploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadPostImagePickedSuccessState());
        CreatePost(dateTime: dateTime, text: text, postImage: value);
      }).catchError((error) {
        emit(SocialUploadPostImagePickedErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialUploadPostImagePickedErrorState());
    });
  }

  void CreatePost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    SocialPostModel model = SocialPostModel(
      name: userData!.name,
      postImage: postImage ?? '',
      dateTime: dateTime,
      uid: userData!.uid,
      image: userData!.image,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.ToMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreatePostErrorState());
    });
  }

  void LikePost({required String postId}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userData!.uid)
        .set({'like': true}).then((value) {
      isLike.add(true);
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialLikePostErrorState(error));
    });
  }

  List<SocialCommentModel> commentModel = [];
  void CommentPost(
      {required String postId,
      required String comment,
      required String dateTime,
      required String commentname,
      required String commentuser}) {
    SocialCommentModel model =
        SocialCommentModel(comment, commentuser, commentname, dateTime, postId);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userData!.uid)
        .set(model.toMap())
        .then((value) {
      emit(SocialCommentsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCommentsErrorState());
    });
  }

  void getComments({
    required postId,
  }) {
    commentModel = [];
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('commments')
        .get()
        .then((value) {
      value.docs.forEach(
        (element) {
          commentModel.add(SocialCommentModel.fromJson(json: element.data()));
          print("ELEMEnt ${element.data()}");
        },
      );
      print("ELEMEnt ${value.docs[0]}");
      emit(SocialGetCommentsSuccessState());
    }).catchError((onError));
  }

  void SendMessage({
    required String receiverId,
    required String text,
    required String dateTime,
    String? img,
  }) {
    SocialChatModel model = SocialChatModel(
        dateTime: dateTime,
        text: text,
        receiverId: receiverId,
        senderId: userData!.uid,
        img: img ?? '');

    FirebaseFirestore.instance
        .collection('Users')
        .doc(userData!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.ToMap())
        .then((value) => {emit(SocialCommentsSuccessState())})
        .catchError((error) {
      print(error.toString());
      emit(SocialCommentsErrorState());
    });

    FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverId)
        .collection('chats')
        .doc(userData!.uid)
        .collection('messages')
        .add(model.ToMap())
        .then((value) => {emit(SocialSendMessageSuccessState())})
        .catchError((error) {
      print(error.toString());
      emit(SocialSendMessageErrorState());
    });
  }

  List<SocialChatModel> messages = [];
  void getMessages({required receiverId}) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userData!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(SocialChatModel.FromJson(element.data()));
        emit(SocialGetMessageSuccessState());
      });
    });
  }

// send image
  File? chatImage;

  Future<void> getchatImage() async {
    final PickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (PickedFile != null) {
      chatImage = File(PickedFile.path);
      emit(SocialChatImagePickedSuccessState());
    } else {
      print("No Image Selected");
      emit(SociaChatImagePickedErrorState());
    }
  }

  void RemoveChatImage() {
    chatImage = null;
    emit(SocialChatImageState());
  }

  void UploadChatImage({
    required String receiverId,
    required String text,
    required String dateTime,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chats/${Uri.file(chatImage!.path).pathSegments.last}')
        .putFile(chatImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadChatImagePickedSuccessState());
        SendMessage(
            receiverId: receiverId, text: text, dateTime: dateTime, img: value);
        emit(SocialUploadChatImagePickedSuccessState());
      }).catchError((error) {
        emit(SocialUploadChatImagePickedSuccessState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialUploadChatImagePickedErrorState());
    });
  }
}
