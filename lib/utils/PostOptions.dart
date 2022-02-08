//main imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//pubsecyaml imports
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
//doc imports
import 'package:mekancimapp/constants/Constantcolors.dart';
import 'package:mekancimapp/screens/screens.dart';

import 'package:mekancimapp/services/FirebaseOperations.dart';

class PostFunctions with ChangeNotifier {
  TextEditingController updatedCaptionController = TextEditingController();
  String imageTimePosted;

  String get getImageTimePosted => imageTimePosted;

  showTimeAgo(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    //   print(imageTimePosted);
    // notifyListeners();
  }

  showPostOptions(BuildContext context, String postId, String collection) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: ConstantColors().blueGreyColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: ConstantColors().blueColor,
                        child: Text(
                          'Düzenle',
                          style: TextStyle(
                            color: ConstantColors().whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              //  isScrollControlled: true,
                              context: context,
                              builder: (ctx) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Container(
                                    //  color: Colors.white,
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 300,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Açıklama',
                                                hintStyle: TextStyle(
                                                  color: ConstantColors()
                                                      .whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              style: TextStyle(
                                                color:
                                                    ConstantColors().whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              controller:
                                                  updatedCaptionController,
                                            ),
                                          ),
                                          FloatingActionButton(
                                            backgroundColor:
                                                ConstantColors().redColor,
                                            onPressed: () {
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .updateCaption(postId, {
                                                'caption':
                                                    updatedCaptionController
                                                        .text
                                              }).whenComplete(() {
                                                updatedCaptionController
                                                    .clear();
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Icon(
                                              FontAwesomeIcons.fileUpload,
                                              color:
                                                  ConstantColors().whiteColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                      MaterialButton(
                        color: ConstantColors().redColor,
                        child: Text(
                          'Gönderiiyi Sil',
                          style: TextStyle(
                            color: ConstantColors().whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Gönderiyi silmek istediğinize emin misiniz ?',
                                    style: TextStyle(
                                      color: ConstantColors().darkColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  actions: [
                                    MaterialButton(
                                      color: Colors.grey[200],
                                      child: Text(
                                        'Hayır',
                                        style: TextStyle(
                                          color: ConstantColors().blueColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    MaterialButton(
                                      // color: ConstantColors().redColor,
                                      child: Text(
                                        'Evet',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              ConstantColors().redColor,
                                          color: ConstantColors().redColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        Provider.of<FirebaseOperations>(context,
                                                listen: false)
                                            .deleteUserPostData(
                                                postId, collection)
                                            .whenComplete(() =>
                                                Navigator.of(context).pop());
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future addLike(BuildContext context, String postID, String subDocID,
      String userUid, int likesayisi) async {
    return await FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'likes': true,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': FirebaseAuth.instance.currentUser.uid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    }).whenComplete(() {
      return FirebaseFirestore.instance
          .collection('posts')
          .doc(postID)
          .update({'likes': likesayisi + 1});
    }).whenComplete(() {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('likes')
          .add({'likedPostUid': postID});
    });
  }

  Future addComment(BuildContext context, String postID, String comment,
      int yorumSayisi) async {
    DateTime now = DateTime.now();
    return await FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('comments')
        .doc(
            '${FirebaseAuth.instance.currentUser.uid} ${now.hour} : ${now.minute} ${now.second}')
        .set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': FirebaseAuth.instance.currentUser.uid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    }).whenComplete(() {
      return FirebaseFirestore.instance
          .collection('posts')
          .doc(postID)
          .update({'comments': 'yorumSayisi'});
    });
  }

  showComments(
      BuildContext context, List<DocumentSnapshot> snapshot, String docId) {
    return Container(
      width: double.infinity,
      // height: 600.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(docId)
            .collection('comments')
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              children:
                  snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: ListTile(
                leading: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image(
                        height: 50.0,
                        width: 50.0,
                        image: NetworkImage(documentSnapshot.get('userimage')),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  documentSnapshot.get('username'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  documentSnapshot.get('comment'),
                  style: TextStyle(fontSize: 18),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                  ),
                  color: Colors.grey,
                  onPressed: () => print('Like comment'),
                ),
              ),
            );
          }).toList());
        },
      ),

      // child: Column(
      //   children: <Widget>[
      //     for (int i = 0; i < commentsData.comments.length; i++)
      //       _buildComment(i),
      //   ],
      // ),
    );
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      List<DocumentSnapshot> data = snapshot.data.docs;
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: ListView.builder(
                            itemCount: snapshot.data.size,
                            itemBuilder: (context, i) {
                              return ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(PageTransition(
                                        child: AltProfile(
                                          userUid: data[i].get('useruid'),
                                        ),
                                        type: PageTransitionType.bottomToTop));
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      data[i].get('userimage'),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  data[i].get('username'),
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing:
                                    FirebaseAuth.instance.currentUser.uid ==
                                            data[i].get('useruid')
                                        ? null
                                        : MaterialButton(
                                            color: Colors.blue,
                                            onPressed: () {},
                                            child: Text(
                                              'Takip Et',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                              );
                            }),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  adaptiveLikeButton(
      BuildContext context, String postId, var useruid, var likeSayisi) {
    return InkWell(
      onTap: () {
        Provider.of<PostFunctions>(context, listen: false)
            .addLike(context, postId, useruid, useruid, likeSayisi);
      },
      child: Container(
        height: 50,
        width: 50,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .collection('likes')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<DocumentSnapshot> docs = snapshot.data.docs;
              List<String> likerid = [];
              docs.forEach((element) {
                likerid.add(element.id);
              });
              return InkWell(
                child: likerid.contains(FirebaseAuth.instance.currentUser.uid)
                    ? InkWell(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection('posts')
                              .doc(postId)
                              .collection('likes')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .delete();
                        },
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      )
                    : Icon(Icons.favorite_border),
              );
            }
          },
        ),
      ),
    );
  }
}
