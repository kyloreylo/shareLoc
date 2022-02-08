//main imports
import 'package:flutter/material.dart';

//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
//doc imports
import 'package:mekancimapp/constants/Constantcolors.dart';
import 'package:mekancimapp/screens/screens.dart';
//pubsecyaml imports
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AltProfile extends StatelessWidget {
  final String userUid;
  AltProfile({@required this.userUid});
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<AltProfileHelper>(context, listen: false)
          .appBar(context, userUid),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                //  print(snapshot.data.get('username'));
                // print(snapshot.data.get('userImage'));
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .headerProfile(context, snapshot, userUid),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .divider(),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .footerProfile(context, snapshot)
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
