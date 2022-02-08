//main imports
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//pubsecyaml imports
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

//doc imports
import 'package:mekancimapp/constants/Constantcolors.dart';
import 'package:mekancimapp/screens/screens.dart';

class Chatroom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Mesajlarım",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ChatroomHelper>(context, listen: false)
                    .showCreateChatRoomSheet(context);
              },
              icon: Icon(
                Icons.add_box_rounded,
                size: 25,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection('chats')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset('assets/animations/loading.json'),
              ));
            } else {
              print(snapshot.data.size);
              List<DocumentSnapshot> docs = snapshot.data.docs;
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(docs[i].id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: 0,
                            height: 0,
                          );
                        } else {
                          //  print(docs[i].id);
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.10,
                            width: MediaQuery.of(context).size.width,
                            //  color: Colors.red,
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: MessagesScreen(
                                          userUid: docs[i].id,
                                          documentSnapshot: snapshot,
                                        ),
                                        type: PageTransitionType
                                            .rightToLeftWithFade));
                              },
                              leading: CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(snapshot.data['userImage']),
                                backgroundColor: Colors.grey,
                              ),
                              title: Text(
                                snapshot.data['username'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .collection('chats')
                                    .doc(docs[i].id)
                                    .collection('messages')
                                    .orderBy('time', descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: 0,
                                      height: 0,
                                    );
                                  } else {
                                    List<DocumentSnapshot> docs =
                                        snapshot.data.docs;
                                    if (docs.isNotEmpty) {
                                      // print('data boş değil');
                                      return Text(
                                          '${docs[0].get('username')} : ${docs[0].get('message')}');
                                    } else {
                                      // print('data boş');
                                      return Text(' ');
                                    }
                                  }
                                },
                              ),
                              trailing: Container(
                                height: 20,
                                width: 50,
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .collection('chats')
                                      .doc(docs[i].id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: Text('...'),
                                      );
                                    } else {
                                      return Text(
                                          snapshot.data['lastMessageTime']);
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
