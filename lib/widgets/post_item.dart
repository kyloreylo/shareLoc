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
class PostItem extends StatelessWidget {
  const PostItem({Key key}) : super(key: key);
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
                });
          }
        });
  }

  // Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //   return ListView(
  //     children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
  //       return InkWell(
  //         onTap: () {
  //           Navigator.of(context).push(MaterialPageRoute(
  //               builder: (ctx) => ViewPostScreen(
  //                     uavatar: documentSnapshot.get('userimage'),
  //                     urating: documentSnapshot.get('rating'),
  //                     uname: documentSnapshot.get('username'),
  //                     uyorum: documentSnapshot.get('caption'),
  //                     mapUrl: documentSnapshot.get('mapimage'),
  //                     postImageUrl: documentSnapshot.get('postImage'),
  //                   )));
  //         },
  //         child: Container(
  //           margin: EdgeInsets.all(10),
  //           width: double.infinity,
  //           height: documentSnapshot.get('postImage') == null
  //               ? MediaQuery.of(context).size.height * 0.5
  //               : MediaQuery.of(context).size.height * 0.7, // 450,
  //           child: Card(
  //             elevation: 5,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(30.0),
  //             ),
  //             child: Container(
  //               padding: EdgeInsets.all(15),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: ListTile(
  //                           leading: CircleAvatar(
  //                             backgroundImage: NetworkImage(
  //                               documentSnapshot.get('userimage'),
  //                               // widget.uavatar,
  //                             ),
  //                           ),
  //                           title: Text(
  //                             documentSnapshot.get('username'),
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.w700, fontSize: 15),
  //                           ),
  //                           subtitle: Text(
  //                             documentSnapshot.get('placename'),
  //                             maxLines: 1,
  //                             style: TextStyle(fontSize: 15),
  //                           ),
  //                           trailing: Card(
  //                             color: Colors.blue,
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(50),
  //                               ),
  //                               padding: EdgeInsets.all(3),
  //                               child: RatingBarIndicator(
  //                                 rating: documentSnapshot
  //                                     .get('rating'), //widget.urating,
  //                                 itemBuilder: (context, index) => Icon(
  //                                   Icons.star,
  //                                   color: Colors.amber,
  //                                 ),
  //                                 itemCount: 5,
  //                                 itemSize: 18,
  //                                 direction: Axis.horizontal,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Container(
  //                     height:
  //                         documentSnapshot.get('postImage') == null ? 200 : 50,
  //                     color: Colors.black,
  //                     width: double.maxFinite,
  //                     child: Image.network(
  //                       documentSnapshot.get('mapimage'),
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                   Container(
  //                     // color: Colors.black,
  //                     height:
  //                         documentSnapshot.get('postImage') == null ? 0 : 250,
  //                     width: double.maxFinite,
  //                     child: documentSnapshot.get('postImage') == null
  //                         ? null
  //                         : Image.network(
  //                             documentSnapshot
  //                                 .get('postImage'), //widget.mapImageUrl,
  //                             fit: BoxFit.cover,
  //                           ),
  //                   ),
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(horizontal: 5),
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                           child: Text(
  //                             documentSnapshot.get('capiton'),
  //                             style: TextStyle(fontSize: 15),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.stretch,
  //                     children: [
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           IconButton(
  //                             icon: true //widget.uliked
  //                                 ? Icon(
  //                                     Icons.favorite,
  //                                     color: Colors.red,
  //                                   )
  //                                 : Icon(Icons.favorite_outline),
  //                             onPressed: () {},
  //                           ),
  //                           IconButton(
  //                             icon: Icon(Icons.comment),
  //                             onPressed: () {
  //                               Navigator.of(context).push(MaterialPageRoute(
  //                                   builder: (ctx) => ViewPostScreen(
  //                                         uavatar:
  //                                             documentSnapshot.get('userimage'),
  //                                         urating:
  //                                             documentSnapshot.get('rating'),
  //                                         uname:
  //                                             documentSnapshot.get('username'),
  //                                         uyorum:
  //                                             documentSnapshot.get('caption'),
  //                                         mapUrl:
  //                                             documentSnapshot.get('mapimage'),
  //                                         postImageUrl:
  //                                             documentSnapshot.get('postImage'),
  //                                         // widget.uyorum,
  //                                       )));
  //                             },
  //                           ),
  //                           IconButton(
  //                             icon: Icon(Icons.near_me),
  //                             onPressed: () {},
  //                           ),
  //                           IconButton(
  //                             icon: Icon(Icons.share),
  //                             onPressed: () {},
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
}
