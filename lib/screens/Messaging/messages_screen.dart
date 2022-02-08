//main imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//pubsecyaml imports
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

//doc imports
import '../screens.dart';
import 'package:mekancimapp/services/FirebaseOperations.dart';

class MessagesScreen extends StatelessWidget {
  final String userUid;
  final AsyncSnapshot<DocumentSnapshot> documentSnapshot;
  final TextEditingController messageController = TextEditingController();

  MessagesScreen({@required this.userUid, @required this.documentSnapshot});
  var comment;
  Widget appbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            EvaIcons.arrowIosBack,
            color: Colors.black,
          )),
      title: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        //  color: Colors.red,
        child: Row(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(snapshot.data['userImage']),
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userUid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return Container(
                          child: Text(
                            snapshot.data['username'],
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        );
                      }),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userUid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return Container(
                          width: 109,
                          //  color: Colors.red,
                          child: Text(
                            '${snapshot.data['name']} ${snapshot.data['surname']}',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        // StreamBuilder(
        //     stream: FirebaseFirestore.instance
        //         .collection('users')
        //         .doc(userUid)
        //         .snapshots(),
        //     builder: (context, snapshot) {
        //       return Container(
        //         child: Text(snapshot.data['name']),
        //       );
        //     }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm').format(now);
    return Scaffold(
      appBar: appbar(context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                // color: ConstantColors().redColor,
                height: MediaQuery.of(context).size.height * 0.775,
                width: MediaQuery.of(context).size.width,
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection('chats')
                      .doc(userUid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    try {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      } else {
                        return Provider.of<GroupMessageHelper>(context,
                                listen: false)
                            .showMessages(context, userUid);
                      }
                    } catch (err) {
                      print(err);
                    }
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 8.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        //   color: Colors.red,
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: TextField(
                          controller: messageController,
                          onChanged: (val) {
                            comment = val;
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                              hintText: 'Mesaj', border: InputBorder.none),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FloatingActionButton(
                          backgroundColor: Colors.blue,
                          onPressed: () async {
                            if (comment != null) {
                              messageController.clear();
                              await Provider.of<GroupMessageHelper>(context,
                                      listen: false)
                                  .sendMessage(context, userUid, comment);

                              comment = null;
                            }
                          },
                          child: Icon(
                            Icons.send_sharp,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
