//main imports
import 'dart:ui';
import 'package:flutter/material.dart';

//pubsecyaml imports
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/constants/Constantcolors.dart';
import 'package:mekancimapp/data/auth_service.dart';
import 'package:mekancimapp/models/httpexception.dart';
import '../screens.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final ConstantColors constantColors = ConstantColors();

  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<AuthService>(context, listen: false)
            .signIn(email: _authData['email'], password: _authData['password']);
      } else {
        // Sign user up
        await Provider.of<AuthService>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
          context,
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  var _isLoading = false;

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) *
              1.10,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  constantColors.darkColor,
                  constantColors.blueGreyColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.5,
                  0.9,
                ]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'share',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Loc',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: constantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/splashicon.png'),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    // height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    //  color: Colors.red,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(color: Colors.white),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: constantColors.blueGreyColor),
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(12),
                                        left: Radius.circular(12),
                                      ),
                                      color: constantColors.blueGreyColor),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'E-Mail',
                                      hintStyle: TextStyle(color: Colors.white),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                constantColors.blueGreyColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                constantColors.blueGreyColor),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Invalid email!';
                                      }
                                    },
                                    onSaved: (value) {
                                      _authData['email'] = value;
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Password',
                            style: TextStyle(color: Colors.white),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: constantColors.blueGreyColor),
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(12),
                                        left: Radius.circular(12),
                                      ),
                                      color: constantColors.blueGreyColor),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    style: TextStyle(color: Colors.white),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'Şifre',
                                      hintStyle: TextStyle(color: Colors.white),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                constantColors.blueGreyColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                constantColors.blueGreyColor),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 5) {
                                        return 'Password is too short!';
                                      }
                                    },
                                    onSaved: (value) {
                                      _authData['password'] = value;
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                  onPressed: _submit, child: Text('giriş Yap')),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                RegisterScreen()));
                                  },
                                  child: Text('üye ol'))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
