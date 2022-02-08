//main imports
import 'dart:ui';
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//pubsecyaml imports
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/constants/Constantcolors.dart';
import 'package:mekancimapp/screens/screens.dart';
import 'package:mekancimapp/services/FirebaseOperations.dart';
import 'package:mekancimapp/widgets/post_widget.dart';

class AltProfileHelper with ChangeNotifier {
  Widget appBar(BuildContext context, String useruid) {
    return AppBar(
        elevation: 0.5,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: ConstantColors().darkColor,
            )),
        backgroundColor: ConstantColors().whiteColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                EvaIcons.moreVertical,
                color: ConstantColors().darkColor,
              )),
        ],
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(useruid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return Text(
              snapshot.data['username'],
              style: TextStyle(color: Colors.black, fontSize: 20),
            );
          },
        ));
  }

  Widget headerProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> asnapshot, String userUid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.49,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('sa');
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 60,
                        backgroundImage:
                            NetworkImage(asnapshot.data['userImage']),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${asnapshot.data['name']} ${asnapshot.data['surname']}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.blue,
                          size: 16,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          asnapshot.data.get('useremail'),
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.49,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              checkFollowersSheet(context, userUid, asnapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 70,
                              width: 80,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(asnapshot.data['userUid'])
                                        .collection('followers')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      return Text(
                                        snapshot.data.size.toString(),
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    'Takipçi',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              checkFollowingSheet(context, userUid, asnapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 70,
                              width: 80,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(asnapshot.data['userUid'])
                                        .collection('following')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      return Text(
                                        snapshot.data.size.toString(),
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    'Takip Edilen',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 70,
                        width: 80,
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(asnapshot.data['userUid'])
                                  .collection('posts')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                return Text(
                                  snapshot.data.size.toString(),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                            Text(
                              'Gönderi',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(asnapshot.data['userUid'])
                          .collection('followers')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        List<DocumentSnapshot> data = snapshot.data.docs;
                        //  print(data.id);
                        for (int i = 0; i < data.length; i++) {
                          if (data[i].id ==
                              FirebaseAuth.instance.currentUser.uid) {
                            print('eşleşme bulundu');
                            return MaterialButton(
                              // color: Colors.blue,
                              onPressed: () {
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .unfollowUser(userUid,
                                        FirebaseAuth.instance.currentUser.uid);
                              },
                              child: Text(
                                'Takibi bırak',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }
                        }
                        print('eşleşme yok ');
                        return MaterialButton(
                          // color: Colors.blue,
                          onPressed: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .followUser(
                                    userUid,
                                    FirebaseAuth.instance.currentUser.uid,
                                    {
                                      'username':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitUserName,
                                      'name': Provider.of<FirebaseOperations>(
                                              context,
                                              listen: false)
                                          .getInitName,
                                      'surname':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitSurname,
                                      'userimage':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitUserImage,
                                      'useruid':
                                          FirebaseAuth.instance.currentUser.uid,
                                      'useremail':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitUserEmail,
                                      'time': Timestamp.now(),
                                    },
                                    FirebaseAuth.instance.currentUser.uid,
                                    userUid,
                                    {
                                      'username': asnapshot.data['username'],
                                      'userimage': asnapshot.data['userImage'],
                                      'useremail': asnapshot.data['useremail'],
                                      'useruid': asnapshot.data['userUid'],
                                      'time': Timestamp.now(),
                                      'name': asnapshot.data['name'],
                                      'surname': asnapshot.data['surname'],
                                    })
                                .whenComplete(() {
                              return followedNotification(
                                  context, asnapshot.data['username']);
                            });
                          },
                          child: Text(
                            'Takip Et',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                    Text('|'),
                    MaterialButton(
                      onPressed: () {
                        DateTime now = DateTime.now();

                        String formattedTime =
                            '${now.hour.toString()} : ${now.minute.toString()}';

                        return FirebaseFirestore.instance
                            .collection('users')
                            .doc(asnapshot.data['userUid'])
                            .collection('chats')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .set({
                          'useruid1': asnapshot.data['userUid'],
                          'useruid2': FirebaseAuth.instance.currentUser.uid,
                          'createdTime': Timestamp.now(),
                          'lastMessageTime': formattedTime.toString()
                        }).whenComplete(() {
                          return FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .collection('chats')
                              .doc(asnapshot.data['userUid'])
                              .set({
                            'useruid1': FirebaseAuth.instance.currentUser.uid,
                            'useruid2': asnapshot.data['userUid'],
                            'createdTime': Timestamp.now(),
                            'lastMessageTime': formattedTime.toString(),
                          });
                        }).whenComplete(() {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: MessagesScreen(
                                      userUid: asnapshot.data['userUid'],
                                      documentSnapshot: asnapshot),
                                  type: PageTransitionType.rightToLeft));
                        });
                      },
                      child: Text(
                        'Mesaj',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      // color: Colors.blue,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25,
        width: 350,
        child: Divider(
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            //  color: ConstantColors().darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5)),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data['userUid'])
              .collection('posts')
              .snapshots(),
          builder: (context, documentSnapshot) {
            if (documentSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (documentSnapshot.data.size == 0) {
              return Image.asset('assets/images/empty.png');
            } else {
              List<DocumentSnapshot> docs = documentSnapshot.data.docs;

              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    return PostWidget(
                      userImageUrl: docs[i].get('userimage'),
                      userRating: docs[i].get('rating'),
                      userComment: docs[i].get('caption'),
                      userName: docs[i].get('username'),
                      mapImageUrl: docs[i].get('mapimage'),
                      placeName: docs[i].get('placename'),
                      postImageUrl: docs[i].get('postImage'),
                      postId: docs[i].get('caption'),
                      useruid: docs[i].get('useruid'),
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: ConstantColors().darkColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$name Takip ediliyor.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  checkFollowingSheet(BuildContext context, String useruid,
      AsyncSnapshot<DocumentSnapshot> asnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
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
                  padding: EdgeInsets.all(12),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(useruid)
                        .collection('following')
                        .snapshots(),
                    builder: (context, documentsnapshot) {
                      if (documentsnapshot.connectionState ==
                          ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                      List<DocumentSnapshot> data = documentsnapshot.data.docs;
                      if (data.isEmpty) {
                        return Center(
                          child: Text('Takip Edilen Kişi Yok',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        );
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                  onTap: () {
                                    //Kullanıcı kendi profiline sadece ana ekrandan girebilir.
                                    if (data[i].get('useruid') !=
                                        FirebaseAuth.instance.currentUser.uid) {
                                      Navigator.of(context).push(PageTransition(
                                          child: AltProfile(
                                            userUid: data[i].get('useruid'),
                                          ),
                                          type:
                                              PageTransitionType.leftToRight));
                                    }
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: ConstantColors().darkColor,
                                    backgroundImage:
                                        NetworkImage(data[i].get('userimage')),
                                  ),
                                  title: Text(
                                    data[i].get('username'),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    '${data[i].get('name')} ${data[i].get('surname')}',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  trailing: Container(
                                    height: 50,
                                    width: 90,
                                    // child: StreamBuilder<QuerySnapshot>(
                                    //   stream: FirebaseFirestore.instance
                                    //       .collection('users')
                                    //       .doc(Provider.of<Auth>(context,
                                    //               listen: false)
                                    //           .getUserUid)
                                    //       .collection('following')
                                    //       .snapshots(),
                                    //   builder: (context, snapshot) {
                                    //     if (snapshot.connectionState ==
                                    //         ConnectionState.waiting) {
                                    //       return Center(
                                    //         child: CircularProgressIndicator(),
                                    //       );
                                    //     } else {
                                    //       List<DocumentSnapshot> docs =
                                    //           snapshot.data.docs;
                                    //       for (int k = 0;
                                    //           k < docs.length;
                                    //           k++) {
                                    //         if (data[i].get('useruid') ==
                                    //             docs[k].id) {
                                    //           print(
                                    //               '${data[i].get('useruid')} ile ${docs[k].id} arasında eşleşme bulundu');
                                    //           if (data[i].get('useruid') !=
                                    //               Provider.of<Auth>(context,
                                    //                       listen: false)
                                    //                   .getUserUid)
                                    //             return MaterialButton(
                                    //               color: Colors.blue,
                                    //               onPressed: () {
                                    //                 Provider.of<FirebaseOperations>(
                                    //                         context,
                                    //                         listen: false)
                                    //                     .unfollowUser(
                                    //                         data[i]
                                    //                             .get('useruid'),
                                    //                         Provider.of<Auth>(
                                    //                                 context,
                                    //                                 listen:
                                    //                                     false)
                                    //                             .getUserUid);
                                    //               },
                                    //               child: Text(
                                    //                 'Takibi bırak',
                                    //                 style: TextStyle(
                                    //                     color: Colors.white,
                                    //                     fontWeight:
                                    //                         FontWeight.bold),
                                    //               ),
                                    //             );
                                    //         } else {
                                    //           print(
                                    //               '${data[i].get('useruid')} ile ${docs[k].id} arasında eşleşme bulunamadı');
                                    //           if (data[i].get('useruid') !=
                                    //               Provider.of<Auth>(context,
                                    //                       listen: false)
                                    //                   .getUserUid)
                                    //             return MaterialButton(
                                    //               color: Colors.blue,
                                    //               onPressed: () {
                                    //                 Provider.of<FirebaseOperations>(
                                    //                         context,
                                    //                         listen: false)
                                    //                     .followUser(
                                    //                         data[i]
                                    //                             .get('useruid'),
                                    //                         Provider.of<Auth>(
                                    //                                 context,
                                    //                                 listen:
                                    //                                     false)
                                    //                             .getUserUid,
                                    //                         {
                                    //                           'username': Provider.of<
                                    //                                       FirebaseOperations>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getInitUserName,
                                    //                           'name': Provider.of<
                                    //                                       FirebaseOperations>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getInitName,
                                    //                           'surname': Provider.of<
                                    //                                       FirebaseOperations>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getInitSurname,
                                    //                           'userimage': Provider.of<
                                    //                                       FirebaseOperations>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getInitUserImage,
                                    //                           'useruid': Provider.of<
                                    //                                       Auth>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getUserUid,
                                    //                           'useremail': Provider.of<
                                    //                                       FirebaseOperations>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getInitUserEmail,
                                    //                           'time': Timestamp
                                    //                               .now(),
                                    //                         },
                                    //                         Provider.of<Auth>(
                                    //                                 context,
                                    //                                 listen:
                                    //                                     false)
                                    //                             .getUserUid,
                                    //                         data[i]
                                    //                             .get('useruid'),
                                    //                         {
                                    //                           'username':
                                    //                               asnapshot
                                    //                                       .data[
                                    //                                   'username'],
                                    //                           'userimage':
                                    //                               asnapshot
                                    //                                       .data[
                                    //                                   'userImage'],
                                    //                           'useremail':
                                    //                               asnapshot
                                    //                                       .data[
                                    //                                   'useremail'],
                                    //                           'useruid':
                                    //                               asnapshot
                                    //                                       .data[
                                    //                                   'userUid'],
                                    //                           'time': Timestamp
                                    //                               .now(),
                                    //                           'name': asnapshot
                                    //                               .data['name'],
                                    //                           'surname':
                                    //                               asnapshot
                                    //                                       .data[
                                    //                                   'surname'],
                                    //                         })
                                    //                     .whenComplete(() {
                                    //                   return followedNotification(
                                    //                       context,
                                    //                       data[i]
                                    //                           .get('username'));
                                    //                 });
                                    //               },
                                    //               child: Text(
                                    //                 'Takip et',
                                    //                 style: TextStyle(
                                    //                     color: Colors.white,
                                    //                     fontWeight:
                                    //                         FontWeight.bold),
                                    //               ),
                                    //             );
                                    //         }
                                    //         print(docs[k].id);
                                    //       }
                                    //       return Container(
                                    //         width: 0,
                                    //         height: 0,
                                    //       );
                                    //     }
                                    //   },
                                    // ),
                                  ));
                            }),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  checkFollowersSheet(BuildContext context, String useruid,
      AsyncSnapshot<DocumentSnapshot> asnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
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
                  padding: EdgeInsets.all(12),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(useruid)
                        .collection('followers')
                        .snapshots(),
                    builder: (context, documentsnapshot) {
                      if (documentsnapshot.connectionState ==
                          ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      List<DocumentSnapshot> data = documentsnapshot.data.docs;
                      if (data.isEmpty) {
                        return Center(
                          child: Text('Takip Edilen Kişi Yok',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        );
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                  onTap: () {
                                    //Kullanıcı kendi profiline sadece ana ekrandan girebilir.
                                    if (data[i].get('useruid') !=
                                        FirebaseAuth.instance.currentUser.uid) {
                                      Navigator.of(context).push(PageTransition(
                                          child: AltProfile(
                                            userUid: data[i].get('useruid'),
                                          ),
                                          type:
                                              PageTransitionType.leftToRight));
                                    }
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: ConstantColors().darkColor,
                                    backgroundImage:
                                        NetworkImage(data[i].get('userimage')),
                                  ),
                                  title: Text(
                                    data[i].get('username'),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    '${data[i].get('name')} ${data[i].get('surname')}',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  trailing: Container(
                                    height: 50,
                                    width: 90,
                                    // child: StreamBuilder<QuerySnapshot>(
                                    //   stream: FirebaseFirestore.instance
                                    //       .collection('users')
                                    //       .doc(Provider.of<Auth>(context,
                                    //               listen: false)
                                    //           .getUserUid)
                                    //       .collection('following')
                                    //       .snapshots(),
                                    //   builder: (context, snapshot) {
                                    //     if (snapshot.connectionState ==
                                    //         ConnectionState.waiting) {
                                    //       return Center(
                                    //         child: CircularProgressIndicator(),
                                    //       );
                                    //     } else {
                                    //       List<DocumentSnapshot> docs =
                                    //           snapshot.data.docs;
                                    //       for (int k = 0;
                                    //           k < docs.length;
                                    //           k++) {
                                    //         if (data[i].get('useruid') ==
                                    //             docs[k].id) {
                                    //           print(
                                    //               '${data[i].get('useruid')} ile ${docs[k].id} arasında eşleşme bulundu');
                                    //           if (data[i].get('useruid') !=
                                    //               Provider.of<Auth>(context,
                                    //                       listen: false)
                                    //                   .getUserUid)
                                    //             return MaterialButton(
                                    //               color: Colors.blue,
                                    //               onPressed: () {
                                    //                 Provider.of<FirebaseOperations>(
                                    //                         context,
                                    //                         listen: false)
                                    //                     .unfollowUser(
                                    //                         data[i]
                                    //                             .get('useruid'),
                                    //                         Provider.of<Auth>(
                                    //                                 context,
                                    //                                 listen:
                                    //                                     false)
                                    //                             .getUserUid);
                                    //               },
                                    //               child: Text(
                                    //                 'Takibi bırak',
                                    //                 style: TextStyle(
                                    //                     color: Colors.white,
                                    //                     fontWeight:
                                    //                         FontWeight.bold),
                                    //               ),
                                    //             );
                                    //         } else {
                                    //           print(
                                    //               '${data[i].get('useruid')} ile ${docs[k].id} arasında eşleşme bulunamadı');
                                    //           if (data[i].get('useruid') !=
                                    //               Provider.of<Auth>(context,
                                    //                       listen: false)
                                    //                   .getUserUid)
                                    //             return MaterialButton(
                                    //               color: Colors.blue,
                                    //               onPressed: () {
                                    //                 Provider.of<FirebaseOperations>(
                                    //                         context,
                                    //                         listen: false)
                                    //                     .followUser(
                                    //                         data[i]
                                    //                             .get('useruid'),
                                    //                         Provider.of<Auth>(
                                    //                                 context,
                                    //                                 listen:
                                    //                                     false)
                                    //                             .getUserUid,
                                    //                         {
                                    //                           'username': Provider.of<
                                    //                                       FirebaseOperations>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getInitUserName,
                                    //                           'name': Provider.of<
                                    //                                       FirebaseOperations>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getInitName,
                                    //                           'surname': Provider.of<
                                    //                                       FirebaseOperations>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getInitSurname,
                                    //                           'userimage': Provider.of<
                                    //                                       FirebaseOperations>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getInitUserImage,
                                    //                           'useruid': Provider.of<
                                    //                                       Auth>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getUserUid,
                                    //                           'useremail': Provider.of<
                                    //                                       FirebaseOperations>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .getInitUserEmail,
                                    //                           'time': Timestamp
                                    //                               .now(),
                                    //                         },
                                    //                         Provider.of<Auth>(
                                    //                                 context,
                                    //                                 listen:
                                    //                                     false)
                                    //                             .getUserUid,
                                    //                         data[i]
                                    //                             .get('useruid'),
                                    //                         {
                                    //                           'username':
                                    //                               asnapshot
                                    //                                       .data[
                                    //                                   'username'],
                                    //                           'userimage':
                                    //                               asnapshot
                                    //                                       .data[
                                    //                                   'userImage'],
                                    //                           'useremail':
                                    //                               asnapshot
                                    //                                       .data[
                                    //                                   'useremail'],
                                    //                           'useruid':
                                    //                               asnapshot
                                    //                                       .data[
                                    //                                   'userUid'],
                                    //                           'time': Timestamp
                                    //                               .now(),
                                    //                           'name': asnapshot
                                    //                               .data['name'],
                                    //                           'surname':
                                    //                               asnapshot
                                    //                                       .data[
                                    //                                   'surname'],
                                    //                         })
                                    //                     .whenComplete(() {
                                    //                   return followedNotification(
                                    //                       context,
                                    //                       data[i]
                                    //                           .get('username'));
                                    //                 });
                                    //               },
                                    //               child: Text(
                                    //                 'Takip et',
                                    //                 style: TextStyle(
                                    //                     color: Colors.white,
                                    //                     fontWeight:
                                    //                         FontWeight.bold),
                                    //               ),
                                    //             );
                                    //         }
                                    //         print(docs[k].id);
                                    //       }
                                    //       return Container(
                                    //         width: 0,
                                    //         height: 0,
                                    //       );
                                    //     }
                                    //   },
                                    // ),
                                  ));
                            }),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
