//main imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
//pubsecyaml imports
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
//doc imports
import 'package:mekancimapp/utils/PostOptions.dart';
import 'package:mekancimapp/services/FirebaseOperations.dart';
import '../screens.dart';

class ViewPostScreen extends StatefulWidget {
  final uavatar,
      userName,
      userRating,
      userComment,
      mapUrl,
      postImageUrl,
      useruid,
      postid,
      placename,
      likesCount,
      commentCount;

  const ViewPostScreen(
      {Key key,
      this.uavatar,
      this.userName,
      this.userRating,
      this.userComment,
      this.mapUrl,
      this.postImageUrl,
      this.useruid,
      this.postid,
      this.likesCount,
      this.commentCount,
      this.placename})
      : super(key: key);

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  TextEditingController commentController = new TextEditingController();
  FocusNode focusNode = new FocusNode();
  String likes;
  int comments;

  @override
  void initState() {
    print(widget.likesCount);
    super.initState();
  }

  void saveFrom() {
    Provider.of<PostFunctions>(context, listen: false).addComment(
        context, widget.postid, commentController.text, widget.commentCount);
    // _newComment.text = '';
    // focusNode.unfocus();
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Widget comments(var userimage, var username, var comment, var userid) {
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: ListTile(
          leading: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0, 2),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(PageTransition(
                    child: AltProfile(
                      userUid: userid,
                    ),
                    type: PageTransitionType.bottomToTop));
              },
              child: CircleAvatar(
                child: ClipOval(
                  child: Image(
                    height: 50.0,
                    width: 50.0,
                    image: NetworkImage(userimage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            comment,
            style: TextStyle(fontSize: 18),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite_border,
            ),
            color: Colors.grey,
            onPressed: () => print('Like comment'),
          ),
        ),
      );
    }

    print('yenilendi');
    return Scaffold(
      backgroundColor: Color(0xFFEDF0F6),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(children: <Widget>[
            Container(
              width: double.infinity,
              height: widget.userComment.length > 100 ? 600 : 450.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.chevron_left_outlined,
                            ),
                            iconSize: 35.0,
                            color: Colors.black,
                            onPressed: () => Navigator.pop(context),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ListTile(
                              leading: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black45,
                                      offset: Offset(0, 2),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  child: ClipOval(
                                    child: Image(
                                      height: 50.0,
                                      width: 50.0,
                                      image: NetworkImage(widget.uavatar),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                widget.userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                widget.placename,
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.more_horiz),
                                color: Colors.black,
                                onPressed: () => print('More'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onDoubleTap: () => print('Like post'),
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: widget.mapUrl != null
                              ? Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(widget.userComment),
                                      // Text('as'),
                                      Card(
                                        color: Colors.blue,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          padding: EdgeInsets.all(3),
                                          child: RatingBarIndicator(
                                            rating: widget
                                                .userRating, //widget.urating,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 18,
                                            direction: Axis.horizontal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Image.network(
                                  widget.mapUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      InkWell(
                        onDoubleTap: () => print('Like post'),
                        child: Container(
                          //  margin: EdgeInsets.all(10.0),
                          width: double.infinity,
                          height: 250.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: widget.postImageUrl == null
                              ? Image.network(
                                  widget.mapUrl,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.postImageUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  iconSize: 30.0,
                                  onPressed: () => print('Like post'),
                                ),
                                Text(
                                  widget.likesCount.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.chat),
                                  iconSize: 30.0,
                                  onPressed: () {
                                    print('Chat');
                                  },
                                ),
                                //
                                Text(
                                  widget.commentCount.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
                width: double.infinity,
                height: 300.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.postid)
                      .collection('comments')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    List<DocumentSnapshot> documents = snapshot.data.docs;
                    // print(documents);
                    return ListView.builder(
                        //reverse: true,
                        itemCount: documents.length,
                        itemBuilder: (context, i) {
                          return comments(
                              documents[i].get('userimage'),
                              documents[i].get('username'),
                              documents[i].get('comment'),
                              documents[i].get('useruid'));
                        });
                  },
                ))
          ]),
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -2),
                blurRadius: 6.0,
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              focusNode: focusNode,
              controller: commentController,
              onChanged: (value) {},
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.all(20.0),
                hintText: 'Add a comment',
                prefixIcon: Container(
                  margin: EdgeInsets.all(4.0),
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image(
                        height: 48.0,
                        width: 48.0,
                        image: NetworkImage(Provider.of<FirebaseOperations>(
                                context,
                                listen: false)
                            .getInitUserImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                suffixIcon: Container(
                  margin: EdgeInsets.only(right: 4.0),
                  width: 70.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed:
                        commentController.text.trim().isEmpty ? null : saveFrom,
                    child: Icon(
                      Icons.send,
                      size: 25.0,
                      color: commentController.text.trim().isEmpty
                          ? Colors.grey
                          : Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
