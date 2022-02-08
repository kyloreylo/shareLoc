import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:mekancimapp/data/auth_service.dart';
import 'package:mekancimapp/screens/Chatroom/ChatroomHelper.dart';
import 'package:mekancimapp/screens/Messaging/GroupMessageHelper.dart';
import 'package:provider/provider.dart';

import 'package:mekancimapp/constants/Constantcolors.dart';
import 'package:mekancimapp/data/auth.dart';
import 'package:mekancimapp/models/post.dart';
import 'package:mekancimapp/providers/address_data_provider.dart';

import 'package:mekancimapp/services/FirebaseOperations.dart';
import 'package:mekancimapp/utils/PostOptions.dart';
import 'package:mekancimapp/utils/landingUtils.dart';

import 'screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null),
        ChangeNotifierProvider(create: (ctx) => GroupMessageHelper()),
        ChangeNotifierProvider(create: (ctx) => ChatroomHelper()),
        ChangeNotifierProvider(create: (ctx) => AltProfileHelper()),
        ChangeNotifierProvider(create: (ctx) => AddressProvider()),
        ChangeNotifierProvider(create: (ctx) => FirebaseOperations()),
        ChangeNotifierProvider(create: (ctx) => LandingUtils()),
        ChangeNotifierProvider(create: (ctx) => Post()),
        ChangeNotifierProvider(create: (ctx) => PostFunctions()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mekancim',
        theme: ThemeData(
          fontFamily: 'Poppins',
          canvasColor: Colors.transparent,
          appBarTheme: AppBarTheme(color: Color.fromRGBO(247, 247, 247, 1)),
          scaffoldBackgroundColor: Color.fromRGBO(247, 247, 247, 1),
          bottomAppBarColor: Colors.blue,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: constantColors.blueColor),
        ),
        home: AuthWrapper(),
        routes: {
          "/anasayfa": (BuildContext context) => HomeScreen(),
          "/profilescreen": (BuildContext context) => ProfileScreen(),
          '/postscreen': (ctx) => PostHomeScreen(),
          '/postoverviewscreen': (ctx) => ViewPostScreen(),
          "/register": (BuildContext context) => RegisterScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return HomeScreen();
    }
    return AuthScreen();
  }
}
