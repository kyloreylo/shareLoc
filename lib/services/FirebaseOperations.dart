//main imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
//pubsecyaml imports
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/utils/landingUtils.dart';

class FirebaseOperations with ChangeNotifier {
  UploadTask imageUploadTask;
  String initUserEmail, initUserName, initUserImage, initName, initSurName;
  String get getInitUserEmail => initUserEmail;
  String get getInitUserName => initUserName;
  String get getInitUserImage => initUserImage;
  String get getInitName => initName;
  String get getInitSurname => initSurName;
  List<String> myFollowingList;
  List<String> get getMyFollowingList => myFollowingList;

  Future uploadUserImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileImage/${Provider.of<LandingUtils>(context, listen: false).getUserImage.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserImage);

    await imageUploadTask.whenComplete(() {
      print('Fotoğraf yüklendi');
    });
    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userImageUrl =
          url.toString();
      print(
          'the user profile image url => ${Provider.of<LandingUtils>(context, listen: false).userImageUrl}');
      notifyListeners();
    });
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) {
      print('fecthing user data');
      initUserName = doc.data()['username'];
      initUserEmail = doc.data()['useremail'];
      initUserImage = doc.data()['userImage'];
      initName = doc.data()['name'];
      initSurName = doc.data()['surname'];
      print(initUserName);
      print(initUserEmail);
      print(initUserImage);
      notifyListeners();
    });
  }

  Future getUserFollowing() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('following')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        myFollowingList.add(element.id);
      });
      return value.docs;
      // print(list.length);
    });
  }

  Future uploadPostData(
      BuildContext context, String postId, dynamic data) async {
    try {
      return FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(data);
    } catch (err) {
      print(err);
    }
  }

  Future uploadPostDataToUser(String userId, dynamic data) async {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('posts')
          .add(data);
    } catch (err) {
      print(err);
    }
  }

  Future deleteUserPostData(String userId, dynamic collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .delete();
  }

  Future updateCaption(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future followUser(
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }

  Future unfollowUser(String followingUid, String followerUid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followerUid)
        .delete()
        .whenComplete(() {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followingUid)
          .delete();
    });
  }

  Future submitChatroomData(String chatroomName, dynamic chatroomData) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomName)
        .set(chatroomData);
  }

  Future createChat(
      String adminId, String userid, dynamic data, String message) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(adminId)
        .collection('chats')
        .doc(userid)
        .collection('messages')
        .doc(message)
        .set(data)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .collection('chats')
          .doc(adminId)
          .collection('messages')
          .doc(message)
          .set(data);
    });
  }
}
