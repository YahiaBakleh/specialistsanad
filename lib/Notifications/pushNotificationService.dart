import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:specialistsanad/Models/userDetails.dart';
import 'package:specialistsanad/Notifications/notificationDialog.dart';
import 'package:specialistsanad/configMaps.dart';
import 'package:specialistsanad/main.dart';
import 'dart:io' show Platform;

class PushNotificationService {
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  initialize(context) {
    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     retrieveUserRequestInfo(getUserRequestId(message));
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     retrieveUserRequestInfo(getUserRequestId(message));
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     retrieveUserRequestInfo(getUserRequestId(message));
    //   },
    // );
    // await Firebase.initializeApp();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      retrieveUserRequestInfo(getUserRequestId(message), context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      retrieveUserRequestInfo(getUserRequestId(message), context);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      retrieveUserRequestInfo(getUserRequestId(message), context);
    });
  }

  Future<String?> getToken() async {
    String? token = await firebaseMessaging.getToken();
    print('1');
    print('2');
    print('3');
    print('4');
    print('5');
    print('6');
    print('7');
    print('Token is:');
    print(token);
    specialistRef.child(currentFirebaseUser!.uid).child("token").set(token);
    firebaseMessaging.subscribeToTopic("allspecialists"); // subscriber will psuh from here to cloud message side so we can find them
    firebaseMessaging.subscribeToTopic("allusers");
    return token;
  }

  String getUserRequestId(/*Map<String, dynamic>*/ RemoteMessage message) {
    String userRequestId = message.data['user_request_id'].toString(); // error here : The operator '[]' isn't defined for the type 'RemoteMessage'.
    if (Platform.isAndroid) {
      userRequestId = message.data['data']['user_request_id'].toString(); // and here on ['data'] :The operator '[]' isn't defined for the type 'RemoteMessage'.
    }
    return userRequestId;
  }

  void retrieveUserRequestInfo(String userRequestId, BuildContext context) {
    newRequsetsRef.child(userRequestId).once().then((DataSnapshot dataSnapShot) {
      if (dataSnapShot != null) {
        double sessionLocationLat = double.parse(dataSnapShot.value['session_location']['latitude'].toString());
        double sessionLocationLng = double.parse(dataSnapShot.value['session_location']['longitude'].toString());
        String sessionAddress = dataSnapShot.value['session_address'].toString();
        String paymentMethod = dataSnapShot.value['payment_method'].toString();

        UserDetails userDetails = UserDetails();
        userDetails.user_request_id = userRequestId;
        userDetails.payment_method = paymentMethod;
        userDetails.session_address = sessionAddress;
        userDetails.session_location = LatLng(sessionLocationLat, sessionLocationLng);
        assetsAudioPlayers.open(Audio("sounds/alerts.mp3"));
        assetsAudioPlayers.play();
        showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => NotificationDialog(userDetails));
      }
    });
  }
}
