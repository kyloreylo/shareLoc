//main imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mekancimapp/screens/HomePage/FollowerPostScreen.dart';
import 'package:mekancimapp/screens/HomePage/TrendScreen.dart';
import 'package:mekancimapp/screens/Profile/profile_screen.dart';
import 'package:mekancimapp/services/FirebaseOperations.dart';
//doc imports
import 'package:mekancimapp/widgets/post_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PostHomeScreen extends StatefulWidget {
  // final routename = '/postscreen';

  @override
  _PostHomeScreenState createState() => _PostHomeScreenState();
}

class _PostHomeScreenState extends State<PostHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          //centerTitle: true,

          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                child: Text(
                  'Takip',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
              Tab(
                child: Text(
                  'Trend',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
              Tab(
                child: Text(
                  'Sana Özel',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
              Tab(
                child: Text(
                  'Hepsi',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
            ],
          ),
          backgroundColor: AppBarTheme.of(context).backgroundColor,
          elevation: 0.5,
          title: Text(
            "shareLoc",
            style: TextStyle(color: Colors.black, fontFamily: 'Cocon'),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_outline,
                  size: 25,
                  color: Colors.black,
                )),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ProfileScreen(),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      Provider.of<FirebaseOperations>(context, listen: false)
                                  .getInitUserImage ==
                              null
                          ? null
                          : NetworkImage(Provider.of<FirebaseOperations>(
                                  context,
                                  listen: false)
                              .getInitUserImage),
                ),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            FollowerPostScreen(),
            TrendScreeen(),
            Icon(Icons.directions_transit),
            PostItem(
              key: PageStorageKey("postitem"),
            ),
          ],
        ),
      ),
    );
  }
}
