import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:specialistsanad/AllScreens/loginScreen.dart';
import 'package:specialistsanad/AllScreens/mainScreen.dart';
import 'package:specialistsanad/AllScreens/registerationScreen.dart';
import 'package:specialistsanad/DataHandler/appData.dart';
import 'package:specialistsanad/configMaps.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentFirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child('users');
//TODO: if face any errro just uncomment where u find 'specialits' word
// DatabaseReference specialistRef = FirebaseDatabase.instance.reference().child('specialits');
DatabaseReference specialistRef = FirebaseDatabase.instance.reference().child('specialists');
// newRequsettRef for user request node
DatabaseReference newRequsetsRef = FirebaseDatabase.instance.reference().child('User Requests');
// requestRef is used for specialist to be on or off and save his location using geofire
// DatabaseReference requestRef = FirebaseDatabase.instance.reference().child('specialits').child(currentFirebaseUser!.uid).child('newRequest');
DatabaseReference requestRef = FirebaseDatabase.instance.reference().child('specialists').child(currentFirebaseUser!.uid).child('newRequest');

class MyApp extends StatelessWidget {
  static const idScreen = 'mainScreen';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Sanad Care - Every thing Start Small',
        theme: ThemeData(
          // primarySwatch: Colors.indigo,
          primarySwatch: Colors.indigo,
          fontFamily: 'Brand Bold',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => FirebaseAuth.instance.currentUser == null ? LoginScreen() : MainScreen(), //LoginScreen(),
          // '/': (context) => MainScreen(), //LoginScreen(),
          // '/': (context) => const RegisterationScreen(), //LoginScreen(),
          RegisterationScreen.idScreen: (context) => RegisterationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
