//main imports
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//pubsecyaml imports
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/constants/Constantcolors.dart';
import 'package:mekancimapp/data/auth_service.dart';
import 'package:mekancimapp/main.dart';
import 'package:mekancimapp/widgets/post_widget.dart';
import '../screens.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  settingsSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.transparent,
            height: 250,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Colors.grey,
                    height: 70,
                    width: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Profili Düzenle",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    height: 70,
                    width: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Ayarlar",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<AuthService>(context, listen: false)
                          .logout(context)
                          .whenComplete(() {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (a) => MyApp()));
                      });
                    },
                    child: Container(
                      color: Colors.grey,
                      height: 70,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "Çıkış Yap",
                          style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                settingsSheet();
              },
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ))
        ],
        elevation: 0.5,
        backgroundColor: AppBarTheme.of(context).backgroundColor,
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('yükleniyor...');
            } else {
              return Text(
                snapshot.data['username'],
                style: TextStyle(color: Colors.black, fontSize: 20),
              );
            }
          },
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_outlined,
            color: Colors.black,
            size: 35,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SafeArea(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Container(
                                  //  color: Colors.red,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 60,
                                          backgroundImage: snapshot
                                                      .data['userImage'] ==
                                                  null
                                              ? AssetImage(
                                                  'assets/images/splashicon.png')
                                              : NetworkImage(
                                                  snapshot.data['userImage']),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${snapshot.data['name']} ${snapshot.data['surname']}',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.email,
                                            color: Colors.blue,
                                            size: 16,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              snapshot.data['useremail'],
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                checkFollowersSheet(
                                                    context, snapshot);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blueGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                height: 70,
                                                width: 80,
                                                child: Column(
                                                  children: [
                                                    StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(snapshot
                                                              .data['userUid'])
                                                          .collection(
                                                              'followers')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting)
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        return Text(
                                                          snapshot.data.size
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 28,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Text(
                                                      'Takipçi',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                checkFollowingSheet(
                                                    context, snapshot);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blueGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                height: 70,
                                                width: 80,
                                                child: Column(
                                                  children: [
                                                    StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(snapshot
                                                              .data['userUid'])
                                                          .collection(
                                                              'following')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting)
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        return Text(
                                                          snapshot.data.size
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 28,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Text(
                                                      'Takip Edilen',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          height: 70,
                                          width: 80,
                                          child: Column(
                                            children: [
                                              StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(snapshot
                                                        .data['userUid'])
                                                    .collection('posts')
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting)
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  return Text(
                                                    snapshot.data.size
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                          ),
                          Center(
                            child: SizedBox(
                              height: 25,
                              width: 350,
                              child: Divider(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          footerProfile(context, snapshot.data['userImage'])
                        ],
                      ),
                    )),
        ),
      ),
    );
  }
}

Widget footerProfile(BuildContext context, dynamic snapshot) {
  return Padding(
    padding: const EdgeInsets.all(0),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
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
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
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

checkFollowingSheet(
    BuildContext context, AsyncSnapshot<DocumentSnapshot> asnapshot) {
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
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection('following')
                      .snapshots(),
                  builder: (context, documentsnapshot) {
                    if (documentsnapshot.connectionState ==
                        ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    List<DocumentSnapshot> data = documentsnapshot.data.docs;

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
                                        type: PageTransitionType.leftToRight));
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
                                  //       for (int k = 0; k < docs.length; k++) {
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
                                  //                                 listen: false)
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
                                  //                                 listen: false)
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
                                  //                           'surname': Provider
                                  //                                   .of<FirebaseOperations>(
                                  //                                       context,
                                  //                                       listen:
                                  //                                           false)
                                  //                               .getInitSurname,
                                  //                           'userimage': Provider.of<
                                  //                                       FirebaseOperations>(
                                  //                                   context,
                                  //                                   listen:
                                  //                                       false)
                                  //                               .getInitUserImage,
                                  //                           'useruid': Provider
                                  //                                   .of<Auth>(
                                  //                                       context,
                                  //                                       listen:
                                  //                                           false)
                                  //                               .getUserUid,
                                  //                           'useremail': Provider.of<
                                  //                                       FirebaseOperations>(
                                  //                                   context,
                                  //                                   listen:
                                  //                                       false)
                                  //                               .getInitUserEmail,
                                  //                           'time':
                                  //                               Timestamp.now(),
                                  //                         },
                                  //                         Provider.of<Auth>(
                                  //                                 context,
                                  //                                 listen: false)
                                  //                             .getUserUid,
                                  //                         data[i]
                                  //                             .get('useruid'),
                                  //                         {
                                  //                           'username':
                                  //                               asnapshot.data[
                                  //                                   'username'],
                                  //                           'userimage':
                                  //                               asnapshot.data[
                                  //                                   'userImage'],
                                  //                           'useremail':
                                  //                               asnapshot.data[
                                  //                                   'useremail'],
                                  //                           'useruid':
                                  //                               asnapshot.data[
                                  //                                   'userUid'],
                                  //                           'time':
                                  //                               Timestamp.now(),
                                  //                           'name': asnapshot
                                  //                               .data['name'],
                                  //                           'surname':
                                  //                               asnapshot.data[
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

checkFollowersSheet(
    BuildContext context, AsyncSnapshot<DocumentSnapshot> asnapshot) {
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
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection('followers')
                      .snapshots(),
                  builder: (context, documentsnapshot) {
                    if (documentsnapshot.connectionState ==
                        ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    List<DocumentSnapshot> data = documentsnapshot.data.docs;

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
                                        type: PageTransitionType.leftToRight));
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
                                  //           k + 1) {
                                  //         if (data[i].get('useruid') ==
                                  //             docs[k].id) {
                                  //           print(
                                  //               '${data[i].get('useruid')} ile ${docs[k].id} arasında eşleşme bulundu');
                                  //           print(k.toString());
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
                                  //                                 listen: false)
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
                                  //                                 listen: false)
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
                                  //                           'surname': Provider
                                  //                                   .of<FirebaseOperations>(
                                  //                                       context,
                                  //                                       listen:
                                  //                                           false)
                                  //                               .getInitSurname,
                                  //                           'userimage': Provider.of<
                                  //                                       FirebaseOperations>(
                                  //                                   context,
                                  //                                   listen:
                                  //                                       false)
                                  //                               .getInitUserImage,
                                  //                           'useruid': Provider
                                  //                                   .of<Auth>(
                                  //                                       context,
                                  //                                       listen:
                                  //                                           false)
                                  //                               .getUserUid,
                                  //                           'useremail': Provider.of<
                                  //                                       FirebaseOperations>(
                                  //                                   context,
                                  //                                   listen:
                                  //                                       false)
                                  //                               .getInitUserEmail,
                                  //                           'time':
                                  //                               Timestamp.now(),
                                  //                         },
                                  //                         Provider.of<Auth>(
                                  //                                 context,
                                  //                                 listen: false)
                                  //                             .getUserUid,
                                  //                         data[i]
                                  //                             .get('useruid'),
                                  //                         {
                                  //                           'name': data[i]
                                  //                               .get('name'),
                                  //                           'surname': data[i]
                                  //                               .get('surname'),
                                  //                           'userimage': data[i]
                                  //                               .get(
                                  //                                   'userimage'),
                                  //                           'useruid': data[i]
                                  //                               .get('useruid'),
                                  //                           'useremail': data[i]
                                  //                               .get(
                                  //                                   'useremail'),
                                  //                           'time':
                                  //                               Timestamp.now(),
                                  //                           'username': data[i]
                                  //                               .get('username')
                                  //                         })
                                  //                     .whenComplete(() {
                                  //                   return followedNotification(
                                  //                       context,
                                  //                       data[i]
                                  //                           .get('username'));
                                  //                 });
                                  //               },
                                  //               child: Text(
                                  //                 'Takibi bırak',
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
