//main imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//doc imports
import 'package:mekancimapp/constants/Constantcolors.dart';
import 'package:mekancimapp/screens/screens.dart';
import 'package:mekancimapp/utils/PostOptions.dart';
//pubsecyaml imports
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PostWidget extends StatefulWidget {
  final userImageUrl,
      userName,
      userComment,
      userRating,
      userLiked,
      mapImageUrl,
      placeName,
      postImageUrl,
      postId,
      useruid;

  const PostWidget({
    Key key,
    this.userImageUrl,
    this.userName,
    this.userComment,
    this.userRating,
    this.userLiked,
    this.mapImageUrl,
    this.postImageUrl,
    this.placeName,
    this.postId,
    this.useruid,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  int likeSayisi = 0;
  int yorumSayisi = 0;
  List<String> likesId = [];
  List<DocumentSnapshot> _snapshot;
  Future _launchUrl() async {
    String url = 'https://www.google.com/maps/@41.023619,28.8678737,13.75';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  // @override
  // void initState() {
  //   print(widget.postId);
  //   getDocs();
  //   print(likesId.length);
  //   super.initState();
  // }

  // Future getDocs() async {
  //   QuerySnapshot snapshot = await FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(widget.postId)
  //       .collection('likes')
  //       .get();

  //   List<DocumentSnapshot> docs = snapshot.docs;
  //   docs.forEach((element) {
  //     setState(() {
  //       likesId.add(element.id);
  //     });
  //   });
  //   // print(docs[0].id);
  //   //  print(likesId.length);
  // }

  @override
  Widget build(BuildContext context) {
    // print(likesId.length);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: ViewPostScreen(
              uavatar: widget.userImageUrl, // widget.uavatar,
              userRating: widget.userRating, // widget.urating,
              userName: widget.userName, //.uname,
              userComment: widget.userComment,
              mapUrl: widget.mapImageUrl,
              postImageUrl: widget.postImageUrl,
              postid: widget.postId,
              useruid: widget.useruid,
              placename: widget.placeName,
              likesCount: likeSayisi,
              commentCount: yorumSayisi,
            ),
            type: PageTransitionType.rightToLeft,
          ),
        );
      },
      child: Container(
        // color: Colors.blue,
        //  padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        height: widget.postImageUrl == null
            ? MediaQuery.of(context).size.height * 0.5
            : MediaQuery.of(context).size.height * 0.6, // 450,
        child: Container(
          // padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          // print(widget.useruid);
                          if (widget.useruid !=
                              FirebaseAuth.instance.currentUser.uid) {
                            Navigator.of(context).push(PageTransition(
                                child: AltProfile(
                                  userUid: widget.useruid,
                                ),
                                type: PageTransitionType.rightToLeftWithFade));
                          }
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            widget.userImageUrl,
                            // widget.uavatar,
                          ),
                        ),
                      ),
                      title: Text(
                        widget.userName,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.placeName,
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            '${Provider.of<PostFunctions>(context, listen: false).getImageTimePosted}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                color: ConstantColors()
                                    .lightColor
                                    .withOpacity(0.8)),
                          ),
                        ],
                      ),
                      trailing: Card(
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.all(3),
                          child: RatingBarIndicator(
                            rating: widget.userRating, //widget.urating,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 18,
                            direction: Axis.horizontal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  _launchUrl();
                },
                child: Container(
                  height: widget.postImageUrl == null ? 200 : 50,
                  color: Colors.black,
                  width: double.maxFinite,
                  child: Image.network(
                    widget.mapImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                // color: Colors.black,
                height: widget.postImageUrl == null ? 0 : 250,
                width: double.maxFinite,
                child: widget.postImageUrl == null
                    ? null
                    : Image.network(
                        widget.postImageUrl, //widget.mapImageUrl,
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.userComment,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                //  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Provider.of<PostFunctions>(context, listen: false)
                              .adaptiveLikeButton(context, widget.postId,
                                  widget.useruid, likeSayisi),
                          // InkWell(
                          //   onTap: () {
                          //     Provider.of<PostFunctions>(context, listen: false)
                          //         .addLike(
                          //             context,
                          //             widget.postId,
                          //             widget.useruid,
                          //             widget.useruid,
                          //             likeSayisi);
                          //   },
                          //   child: StreamBuilder<QuerySnapshot>(
                          //     stream: FirebaseFirestore.instance
                          //         .collection('posts')
                          //         .doc(widget.postId)
                          //         .collection('likes')
                          //         .snapshots(),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.connectionState ==
                          //           ConnectionState.waiting)
                          //         return Center(
                          //           child: CircularProgressIndicator(),
                          //         );
                          //       else {
                          //         List<DocumentSnapshot> docs =
                          //             snapshot.data.docs;
                          //         for (int i = 0; i < docs.length; i++) {
                          //           //  print(docs[i].id);
                          //           if (docs[i].id ==
                          //               FirebaseAuth.instance.currentUser.uid) {
                          //             return Icon(Icons.favorite_outline);
                          //           } else {
                          //             return Icon(
                          //               Icons.favorite,
                          //               color: Colors.red,
                          //             );
                          //           }
                          //         }
                          //       }

                          //       return Icon(Icons.favorite_outline);
                          //     },
                          //   ),
                          // ),

                          SizedBox(
                            width: 6,
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(widget.postId)
                                .collection('likes')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );

                              likeSayisi = snapshot.data.size;
                              return Text(likeSayisi.toString());
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {
                              print('comments');
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: CommentScreen(widget.postId,
                                          yorumSayisi, _snapshot),
                                      type: PageTransitionType.bottomToTop));
                            },
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(widget.postId)
                                .collection('comments')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              yorumSayisi = snapshot.data.size;
                              return Text(yorumSayisi.toString());
                            },
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.near_me),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {},
                      ),
                      FirebaseAuth.instance.currentUser.uid == widget.useruid
                          ? IconButton(
                              onPressed: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showPostOptions(
                                        context, widget.postId, 'posts');
                              },
                              icon: Icon(Icons.more_vert))
                          : Container(
                              width: 60,
                            )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
