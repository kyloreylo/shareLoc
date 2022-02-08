//main imports
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
//firebase imports
import 'package:firebase_auth/firebase_auth.dart';
//pubsecyaml imports
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/services/FirebaseOperations.dart';
import '../screens.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> _screens = [
    PostHomeScreen(),
    FeaturesScreen(),

    PostAddScreen(key: PageStorageKey("postaddscreen")),
    Chatroom(),
    // ProfileScreen(),
  ];
  @override
  void initState() {
    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context);
    //  Provider.of<FirebaseOperations>(context, listen: false)
    //       .getUserFollowing();

    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottombar(),
      body: _screens[_selectedIndex],
    );
  }

  Widget bottombar() {
    return BubbleBottomBar(
      backgroundColor: Colors.white,
      opacity: 0,
      inkColor: Colors.white,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      elevation: 0,
      items: <BubbleBottomBarItem>[
        BubbleBottomBarItem(
          backgroundColor: Colors.black,
          icon: Icon(
            Icons.home,
            color: Colors.black,
          ),
          title: Text("Ana Ekran"),
        ),
        BubbleBottomBarItem(
          backgroundColor: Colors.black,
          icon: Icon(
            Icons.location_searching,
            color: Colors.black,
          ),
          title: Text("Keşfet"),
        ),
        BubbleBottomBarItem(
          backgroundColor: Colors.black,
          icon: Icon(
            Icons.add_box_rounded,
            color: Colors.black,
          ),
          title: Text("Paylaş"),
        ),
        BubbleBottomBarItem(
          backgroundColor: Colors.black,
          icon: Icon(
            Icons.message,
            color: Colors.black,
          ),
          title: Text("Mesajlar"),
        ),
      ],
    );
  }

/*
  Widget buildBottomBar() {
    return ConvexAppBar(
      backgroundColor: Colors.blue,
      color: Colors.white,
      activeColor: Colors.amber,
      height: 50, elevation: 5,
      items: [
        TabItem(
          icon: Icon(Icons.home, size: 30, color: Colors.white),
        ),
        TabItem(
          icon: Icon(Icons.map_outlined, size: 30, color: Colors.white),
        ),
        TabItem(
          icon:
              Icon(FontAwesomeIcons.plusSquare, size: 30, color: Colors.white),
        ),
        TabItem(
          icon: Icon(Icons.message, size: 30, color: Colors.white),
        ),
      ],
      initialActiveIndex: _selectedIndex, //optional, default as 0
      onTap: _onItemTapped,
    );
  }
*/

}
