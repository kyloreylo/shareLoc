//main imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
//pubsecyaml imports
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/utils/PostOptions.dart';
import 'package:mekancimapp/widgets/post_widget.dart';

// ignore: must_be_immutable
class TrendItem extends StatelessWidget {
  const TrendItem({Key key}) : super(key: key);
  //ConstantColors constantColors = new ConstantColors();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 500,
              width: 400,
              child: Lottie.asset('assets/animations/loading.json'),
            ),
          );
        } else {
          List<DocumentSnapshot> documents = snapshot.data.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, i) {
              
              if (documents[i].get('likes') >= 0) {
                Provider.of<PostFunctions>(context, listen: false)
                    .showTimeAgo(documents[i].get('time'));
                return Column(
                  children: [
                    PostWidget(
                      userImageUrl: documents[i].get('userimage'),
                      userRating: documents[i].get('rating'),
                      userComment: documents[i].get('caption'),
                      userName: documents[i].get('username'),
                      mapImageUrl: documents[i].get('mapimage'),
                      placeName: documents[i].get('placename'),
                      postImageUrl: documents[i].get('postImage'),
                      postId: documents[i].get('caption'),
                      useruid: documents[i].get('useruid'),
                    ),
                    Center(
                      child: SizedBox(
                        height: 1,
                        width: 300,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Text('Trend Boş');
              }
            },
          );
        }
      },
    );
  }
}
