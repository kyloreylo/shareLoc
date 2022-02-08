import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mekancimapp/widgets/FollowerPostItem.dart';

class FollowerPostScreen extends StatefulWidget {
  @override
  State<FollowerPostScreen> createState() => _FollowerPostScreenState();
}

class _FollowerPostScreenState extends State<FollowerPostScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('following')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<DocumentSnapshot> myFollowingData = snapshot.data.docs;
          List<String> followings = [];

          myFollowingData.forEach((element) {
            followings.add(element.id);
          });

          return FollowerPostItem(followings);
        }
      },
    );
  }
}
