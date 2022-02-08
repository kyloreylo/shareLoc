//main imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//pubsecyaml imports
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/constants/Constantcolors.dart';
import 'package:mekancimapp/services/FirebaseOperations.dart';

class ChatroomHelper with ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  String chatroomID;
  String get getChatRoomID => chatroomID;

  showCreateChatRoomSheet(context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
                color: Colors.grey,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 4,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.465,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection('following')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          List<DocumentSnapshot> docs = snapshot.data.docs;
                          return ListView.builder(
                              itemCount: docs.length,
                              itemBuilder: (ctx, i) {
                                return ListTile(
                                  onTap: () {
                                    // Navigator.of(context).push(PageTransition(
                                    //     child: AltProfile(
                                    //       userUid: data[i].get('useruid'),
                                    //     ),
                                    //     type: PageTransitionType.bottomToTop));
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: ConstantColors().darkColor,
                                    backgroundImage:
                                        NetworkImage(docs[i].get('userimage')),
                                  ),
                                  title: Text(
                                    docs[i].get('username'),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    '${docs[i].get('name')} ${docs[i].get('surname')} ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: MaterialButton(
                                    onPressed: () {
                                      Provider.of<FirebaseOperations>(context,
                                              listen: false)
                                          .createChat(
                                        FirebaseAuth.instance.currentUser.uid,
                                        docs[i].get('useruid'),
                                        {'message': 'sa'},
                                        'sa',
                                      );
                                    },
                                    child: Text(
                                      'Mesaj Gönder',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    color: Colors.blue,
                                  ),
                                );
                              });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showChatRooms(context) {
    return StreamBuilder<QuerySnapshot>(
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
          List<DocumentSnapshot> docs = snapshot.data.docs;
          for (int i = 0; i < docs.length; i++) {
            print(docs[i].id);
          }
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, i) {
                return Text(docs[i].id);
              });
        }
      },
    );
  }

  showChatroomDetails(context, DocumentSnapshot snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.27,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: ConstantColors().blueGreyColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: Colors.white,
                    thickness: 4,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Üyeler',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Admin',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage(snapshot.get('userimage')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          snapshot.get('username'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
