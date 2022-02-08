//main imports
import 'dart:async';

import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
//pubsecyaml imports
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/services/FirebaseOperations.dart';
import 'package:mekancimapp/utils/PostOptions.dart';
import '../screens.dart';

class CommentScreen extends StatefulWidget {
  String postId;
  int yorumSayisi;
  List<DocumentSnapshot> snapshot;
  CommentScreen(this.postId, this.yorumSayisi, this.snapshot);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = new TextEditingController();
  var comment;
  FocusNode focusNode = new FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void saveFrom() {
      Provider.of<PostFunctions>(context, listen: false).addComment(
          context, widget.postId, _commentController.text, widget.yorumSayisi);
      // _newComment.text = '';
      focusNode.unfocus();

      _commentController.clear();
    }

    Widget comments(var userimage, var username, var comment, var userid) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          leading: Container(
            width: 40.0,
            height: 40.0,
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
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(PageTransition(
                    child: AltProfile(
                      userUid: userid,
                    ),
                    type: PageTransitionType.bottomToTop));
              },
              child: CircleAvatar(
                child: ClipOval(
                  child: Image(
                    height: 45.0,
                    width: 45.0,
                    image: NetworkImage(userimage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            comment,
            style: TextStyle(fontSize: 13),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite_border,
              size: 20,
            ),
            color: Colors.grey,
            onPressed: () => print('Like comment'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Yorumlar',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedContainer(
                //  color: Colors.amber,
                height: MediaQuery.of(context).size.height * 0.78,
                width: MediaQuery.of(context).size.width,
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.postId)
                      .collection('comments')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    List<DocumentSnapshot> documents = snapshot.data.docs;
                    // print(documents);
                    return ListView.builder(
                        //reverse: true,
                        itemCount: documents.length,
                        itemBuilder: (context, i) {
                          return comments(
                              documents[i].get('userimage'),
                              documents[i].get('username'),
                              documents[i].get('comment'),
                              documents[i].get('useruid'));
                        });
                  },
                )),
            Container(
              //   margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(
                  right: 10,
                  left: 8.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getInitUserImage),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Yorum yap...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(),
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          saveFrom();
                        }
                      },
                      child: Icon(
                        Icons.send_sharp,
                        color: Colors.blue,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
