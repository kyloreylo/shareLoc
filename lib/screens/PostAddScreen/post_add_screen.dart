//main imports
import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//pubsecyaml imports
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:location/location.dart';
//doc imports
import 'package:mekancimapp/services/FirebaseOperations.dart';
import 'package:mekancimapp/models/post_model.dart';
import 'package:mekancimapp/providers/address_data_provider.dart';
import 'package:mekancimapp/helpers/location.helper.dart';
import 'package:mekancimapp/screens/screens.dart';

class PostAddScreen extends StatefulWidget {
  const PostAddScreen({Key key}) : super(key: key);
  @override
  _PostAddScreenState createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  TextEditingController mycontroller = new TextEditingController();
  TextEditingController yorum = new TextEditingController();
  // String placeId;
  double rating;
  LatLng _pickedLocation;
  String _previewImageUrl;
  String placeName;
  File uploadPostImage;
  File get getuploadPostImage => uploadPostImage;
  String uploadPostImageUrl;
  String get getuploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();
  UploadTask imagePostUploadTask;

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(
      source: source,
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 50,
    );
    uploadPostImageVal == null
        ? print('Fotoğraf ekleyiniz')
        : setState(() {
            uploadPostImage = File(uploadPostImageVal.path);
          });
    // print(uploadPostImageVal.path);

    uploadPostImageVal != null
        ? uploadPostImageToFirebase()
        : print('image upload error');
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {
      print('Gönderi resmi yüklendi');
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
    });
  }

  Future selectImageOpitonsSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      pickUploadPostImage(context, ImageSource.gallery)
                          .whenComplete(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      'From Gallery',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      pickUploadPostImage(context, ImageSource.camera)
                          .whenComplete(
                        () {
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: Text(
                      'From Camera',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  var _newPost = Post(
    userimageUrl: '',
    name: '',
    rate: 1,
    mapUrl: '',
    comment: '',
    placeName: '',
    postImageUrl: '',
  );

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      print(locData.latitude);
      print(locData.longitude);
      final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: locData.latitude,
        longitude: locData.longitude,
      );
      setState(() {
        _previewImageUrl = staticMapImageUrl;
        _newPost.mapUrl = _previewImageUrl;
      });
      _selectPlace(locData.latitude, locData.longitude);
      print(_previewImageUrl);
    } catch (error) {
      return;
    }
  }

  Future<void> searchPlace() async {
    final String placeId = await Navigator.of(context)
        .push<String>(MaterialPageRoute(builder: (ctx) => SearchScreen()));

    final addressData = Provider.of<AddressProvider>(context, listen: false);
    // print(selectedPlace.latitude);
    // print(selectedPlace.longitude);
    // _pickedLocation = LatLng(selectedPlace.latitude, selectedPlace.longitude);
    print('post add screen $placeId');
    try {
      final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: addressData.address[0].latitude,
        longitude: addressData.address[0].longitude,
      );
      setState(() {
        _previewImageUrl = staticMapImageUrl;
        _newPost.mapUrl = _previewImageUrl;
        _newPost.placeName = addressData.address[0].placeName;
        placeName = addressData.address[0].placeName;
      });

      print('search place ${addressData.address[0].placeName}');
      print(_previewImageUrl);
    } catch (err) {
      print(err);
    }
  }

  Future<void> _selectOnMap() async {
    final currentLocation = await LocationHelper.getCurrentLocation();
    print(currentLocation);
    final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(
          initialLocation: currentLocation,
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    print(selectedLocation);
    _pickedLocation =
        LatLng(selectedLocation.latitude, selectedLocation.longitude);

    final address = await LocationHelper.getPlaceAddress(
        _pickedLocation.latitude, _pickedLocation.longitude);
    print(address);
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: _pickedLocation.latitude,
      longitude: _pickedLocation.longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
      _newPost.mapUrl = _previewImageUrl;
    });
    print(_previewImageUrl);
    print(_pickedLocation.latitude);
    print(_pickedLocation.longitude);
    final placeName = await LocationHelper.getPlaceName(
        _pickedLocation.latitude, _pickedLocation.longitude, 'Bim');
    print(placeName);
    setState(() {
      _newPost.placeName = placeName;
    });
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = LatLng(lat, lng);
  }

  // void _savePlace() {
  //   Provider.of<GreatPlaces>(context, listen: false)
  //       .addPlace('sa', _pickedLocation);
  //   // Navigator.of(context).pop();
  //   print(_pickedLocation.address);
  // }

  void saveFrom() async {
    if (_previewImageUrl != null) {
      setState(() {
        _newPost.userimageUrl =
            Provider.of<FirebaseOperations>(context, listen: false)
                .getInitUserImage;
        _newPost.name = Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserName;

        _newPost.postImageUrl = uploadPostImageUrl;
      });
      Provider.of<FirebaseOperations>(context, listen: false)
          .uploadPostData(context, _newPost.comment, {
        'likes': 0,
        'comments': 0,
        'caption': _newPost.comment,
        'username': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserName,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserImage,
        'useruid': FirebaseAuth.instance.currentUser.uid,
        'time': Timestamp.now(),
        'useremail': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserEmail,
        'mapimage': _previewImageUrl,
        'rating': _newPost.rate,
        'postImage': _newPost.postImageUrl,
        'placename': _newPost.placeName,
      });
      // print(Provider.of<Auth>(context, listen: false).getUserUid);
      Provider.of<FirebaseOperations>(context, listen: false)
          .uploadPostDataToUser(FirebaseAuth.instance.currentUser.uid, {
        'likes': 0,
        'comments': 0,
        'caption': _newPost.comment,
        'username': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserName,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserImage,
        'useruid': FirebaseAuth.instance.currentUser.uid,
        'time': Timestamp.now(),
        'useremail': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserEmail,
        'mapimage': _previewImageUrl,
        'rating': _newPost.rate,
        'postImage': _newPost.postImageUrl,
        'placename': _newPost.placeName,
      });
      //  Provider.of<Data>(context, listen: false).addPost(_newPost);
      Provider.of<AddressProvider>(context, listen: false).deleteAddress();
      Navigator.of(context).pushReplacementNamed('/anasayfa');
    } else {
      print('konum seçin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarTheme.of(context).backgroundColor,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "Gönderi Paylaş",
          style: TextStyle(fontFamily: 'Cocon', color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.black,
            ),
            onPressed: saveFrom,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            Provider.of<FirebaseOperations>(context)
                                .getInitUserImage),
                      ),
                      title: Text(Provider.of<FirebaseOperations>(context)
                          .getInitUserName),
                      subtitle: GestureDetector(
                        child: Text("Konum Seç"),
                        onTap: () {
                          searchPlace();
                        },
                        onLongPress: _selectOnMap,
                      ),
                      trailing: Card(
                        child: RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemSize: 25,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (value) {
                            setState(() {
                              _newPost.rate = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      selectImageOpitonsSheet(context)
                          .whenComplete(() => print('Gönderi resmi yüklendi'));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      // color: Colors.grey,
                      margin: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.97,
                      child: Center(
                        child: Icon(EvaIcons.plusSquareOutline),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      // controller: mycontroller,
                      //  maxLength: 300,

                      // ignore: deprecated_member_use
                      maxLengthEnforced: true,

                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) return "Lütfen yazı giriniz.";
                      },
                      decoration:
                          InputDecoration(labelText: "Günün Nasıl Geçti ?"),
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          _newPost.comment = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        /* Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                highlightColor: Colors.white,
                onTap: searchPlace,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        //  borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2, color: Colors.black),
                      ),
                      child: _previewImageUrl == null
                          ? Row(
                              children: [
                                Icon(Icons.search),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Konumunu Ara',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : Image.network(
                              _previewImageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton.icon(
                          icon: Icon(
                            Icons.location_on,
                          ),
                          label: Text('Geçerli Konum'),
                          textColor: Colors.black,
                          onPressed: _getCurrentUserLocation,
                        ),
                        FlatButton.icon(
                          icon: Icon(
                            Icons.map,
                          ),
                          label: Text('Haritadan Seç'),
                          textColor: Colors.black,
                          onPressed: _selectOnMap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(10),
                            right: Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (value) {
                            setState(() {
                              _newPost.rate = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'Deneyimini Oyla!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Cocon'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      selectImageOpitonsSheet(context)
                          .whenComplete(() => print('Gönderi resmi yüklendi'));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2, color: Colors.black),
                      ),
                      child: uploadPostImage == null
                          ? Center(child: Icon(Icons.add_a_photo_outlined))
                          : Image.file(
                              uploadPostImage,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      // controller: mycontroller,
                      maxLength: 300,

                      // ignore: deprecated_member_use
                      maxLengthEnforced: true,

                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) return "Lütfen yazı giriniz.";
                      },
                      decoration: InputDecoration(
                        labelText: "Günün Nasıl Geçti ?",
                      ),
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          _newPost.comment = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),*/
      ),
    );
  }
}
