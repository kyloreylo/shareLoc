//main imports

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
//pubsecyaml imports

//doc imports

import 'package:mekancimapp/widgets/post_widget.dart';

// ignore: must_be_immutable
class FollowerPostItem extends StatefulWidget {
  List<String> myFollowers;
  FollowerPostItem(this.myFollowers);

  @override
  State<FollowerPostItem> createState() => _FollowerPostItemState();
}

class _FollowerPostItemState extends State<FollowerPostItem> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<DocumentSnapshot> allPostData = snapshot.data.docs;
            return ListView.builder(
                itemCount: allPostData.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      widget.myFollowers.contains(allPostData[i].get('useruid'))
                          ? PostWidget(
                              userImageUrl: allPostData[i].get('userimage'),
                              userRating: allPostData[i].get('rating'),
                              userComment: allPostData[i].get('caption'),
                              userName: allPostData[i].get('username'),
                              mapImageUrl: allPostData[i].get('mapimage'),
                              placeName: allPostData[i].get('placename'),
                              postImageUrl: allPostData[i].get('postImage'),
                              postId: allPostData[i].id,
                              useruid: allPostData[i].get('useruid'),
                            )
                          : Center(
                              child: Text('Henüz Kimseyi Takip Etmiyorsun'),
                            ),
                      Center(
                        child: SizedBox(
                          height: 1,
                          width: 300,
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                });
          }
        });
  }
}
