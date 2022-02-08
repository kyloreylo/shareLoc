//main imports
import 'dart:io';
import 'package:flutter/material.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
//pubsecyaml imports
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/screens/screens.dart';
import 'package:mekancimapp/data/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailTextEditingController =
      new TextEditingController();

  TextEditingController _passwordTextEditingController =
      new TextEditingController();

  TextEditingController _nameTextEditingController =
      new TextEditingController();

  TextEditingController _surNameTextEditingController =
      new TextEditingController();

  TextEditingController _userNameTextEditingController =
      new TextEditingController();

  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[50],
              Colors.blue[200],
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.08, horizontal: size.width * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Kayıt Ol',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        backgroundImage: userImage != null
                            ? FileImage(userImage)
                            : NetworkImage(
                                'https://i0.wp.com/www.camberpg.com/wp-content/uploads/2018/03/personicon.png'),

                        //  child: Text('Resim Ekle'),
                      ),
                      Positioned(
                        left: 70,
                        top: 70,
                        child: InkWell(
                          onTap: () {
                            selectImageOpitonsSheet(context);
                            // Provider.of<LandingUtils>(context, listen: false)
                            //     .selectImageOpitonsSheet(context);
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.blue[900],
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        Text(
                          'Ad',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.38,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        Text(
                          'Soyad',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ad',
                        ),
                        controller: _nameTextEditingController,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Soyad',
                        ),
                        controller: _surNameTextEditingController,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.white),
                    Text(
                      'Kullanıcı Adı',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Kullanıcı Adı',
                          ),
                          controller: _userNameTextEditingController,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    Text(
                      'E-Mail',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'E-Mail',
                          ),
                          controller: _emailTextEditingController,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    Text(
                      'Şifre',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Şifre',
                          ),
                          controller: _passwordTextEditingController,
                        )),
                  ),
                  IconButton(
                    icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black45),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 140,
                height: 50,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue,
                    child: Text(
                      'Kayıt Ol',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    highlightElevation: 0.0,
                    onPressed: () {
                      if (_emailTextEditingController.text.isNotEmpty) {
                        Provider.of<AuthService>(context, listen: false)
                            .signup(
                          _emailTextEditingController.text,
                          _passwordTextEditingController.text,
                          context,
                        )
                            .whenComplete(() {
                          print('Kullanıcı oluşturuluyor');
                          createColleciton({
                            'userUid': FirebaseAuth.instance.currentUser.uid,
                            'useremail': _emailTextEditingController.text,
                            'username': _userNameTextEditingController.text,
                            'userImage': userImageUrl,
                            'name': _nameTextEditingController.text,
                            'surname': _surNameTextEditingController.text,
                          });
                        }).whenComplete(() {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: HomeScreen(),
                                  type: PageTransitionType.rightToLeft));
                        });
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();
  File userImage;
  File get getUserImage => userImage;

  String userImageUrl;

  String get getUserImageUrl => userImageUrl;

  Future picUserImage(BuildContext context, ImageSource source) async {
    final pickedUserImage = await picker.pickImage(source: source);
    pickedUserImage == null
        ? print('Fotoğraf ekleyiniz')
        : setState(() {
            userImage = File(pickedUserImage.path);
          });
    print(userImage.path);

    userImage != null ? uploadUserImage(context) : print('image upload error');

    // notifyListeners();
  }

  Future selectImageOpitonsSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[50],
                Colors.blue[200],
              ],
            ),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue,
                    onPressed: () {
                      picUserImage(context, ImageSource.gallery)
                          .whenComplete(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      'Galeriden Seç',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue,
                    onPressed: () {
                      picUserImage(context, ImageSource.camera).whenComplete(
                        () {
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: Text(
                      'Fotoğraf Çek',
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

  UploadTask imageUploadTask;

  Future uploadUserImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('userProfileImage/${getUserImage.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(getUserImage);

    await imageUploadTask.whenComplete(() {
      print('Fotoğraf yüklendi');
    });
    imageReference.getDownloadURL().then((url) {
      userImageUrl = url.toString();
      print('the user profile image url => $userImageUrl');
      //  notifyListeners();
    });
  }

  Future createColleciton(dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(data);
  }
}
