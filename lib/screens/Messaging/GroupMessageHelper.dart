//main imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//pubsecyaml imports
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/services/FirebaseOperations.dart';

class GroupMessageHelper with ChangeNotifier {
  showMessages(BuildContext context, String useruid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('chats')
          .doc(useruid)
          .collection('messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: Text('...'),
          );
        else {
          List<DocumentSnapshot> docs = snapshot.data.docs;
          return ListView.builder(
              reverse: true,
              itemCount: snapshot.data.size,
              itemBuilder: (context, i) {
                return Stack(
                  children: [
                    Row(
                      mainAxisAlignment:
                          FirebaseAuth.instance.currentUser.uid ==
                                  docs[i].get('useruid')
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: FirebaseAuth.instance.currentUser.uid ==
                                    docs[i].get('useruid')
                                ? Colors.blue
                                : Colors.grey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft:
                                  FirebaseAuth.instance.currentUser.uid !=
                                          docs[i].get('useruid')
                                      ? Radius.circular(0)
                                      : Radius.circular(12),
                              bottomRight:
                                  FirebaseAuth.instance.currentUser.uid ==
                                          docs[i].get('useruid')
                                      ? Radius.circular(0)
                                      : Radius.circular(12),
                            ),
                          ),
                          width: 140,
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 8,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                FirebaseAuth.instance.currentUser.uid ==
                                        docs[i].get('useruid')
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                docs[i].get('message'),
                                style: TextStyle(color: Colors.white),
                                textAlign:
                                    FirebaseAuth.instance.currentUser.uid ==
                                            docs[i].get('useruid')
                                        ? TextAlign.end
                                        : TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      left: FirebaseAuth.instance.currentUser.uid ==
                              docs[i].get('useruid')
                          ? null
                          : 120,
                      right: FirebaseAuth.instance.currentUser.uid ==
                              docs[i].get('useruid')
                          ? 120
                          : null,
                      child: FirebaseAuth.instance.currentUser.uid ==
                              docs[i].get('useruid')
                          ? Container()
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                docs[i].get('userimage'),
                              ),
                            ),
                    ),
                  ],
                  overflow: Overflow.visible,
                );
              });
        }
      },
    );
  }

  sendMessage(BuildContext context, String useruid, var messageController) {
    DateTime now = DateTime.now();

    String formattedTime = '${now.hour.toString()} : ${now.minute.toString()}';
    print(formattedTime);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('chats')
        .doc(useruid)
        .collection('messages')
        .add({
      'message': messageController,
      'time': Timestamp.now(),
      'useruid': FirebaseAuth.instance.currentUser.uid,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
    }).whenComplete(() {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(useruid)
          .collection('chats')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('messages')
          .add({
        'message': messageController,
        'time': Timestamp.now(),
        'useruid': FirebaseAuth.instance.currentUser.uid,
        'username': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserName,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserImage,
      });
    });
  }
}
