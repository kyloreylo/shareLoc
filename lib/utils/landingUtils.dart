//main imports
import 'dart:io';
import 'package:flutter/material.dart';
//pubsecyaml imports
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/services/FirebaseOperations.dart';

class LandingUtils with ChangeNotifier {
  final picker = ImagePicker();
  File userImage;
  File get getUserImage => userImage;

  String userImageUrl;

  String get getUserImageUrl => userImageUrl;

  Future picUserImage(BuildContext context, ImageSource source) async {
    final pickedUserImage = await picker.pickImage(source: source);
    pickedUserImage == null
        ? print('Fotoğraf ekleyiniz')
        : userImage = File(pickedUserImage.path);
    print(userImage.path);

    userImage != null
        ? Provider.of<FirebaseOperations>(context, listen: false)
            .uploadUserImage(context)
        : print('image upload error');

    notifyListeners();
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
                      picUserImage(context, ImageSource.gallery)
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
                      picUserImage(context, ImageSource.camera).whenComplete(
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
}
