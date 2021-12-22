import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'Models/allUsers.dart';

String mapKey = "AIzaSyAXhk1498g3ORPHcP6Wytkouh0Mn28obVo";

String  BrandBold='Brand Bold' ;
String  BrandRegular='Brand-Regular' ;
String  Signatra='Signatra';
final assetsAudioPlayers = AssetsAudioPlayer();
User? firebaseUser;

Users? userCurrentInfo;

User? currentFirebaseUser;
String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

StreamSubscription<Position>? homeTabPagesStreamSubscription;
int? driverRequestTimeOut = 40;
String? statusRide = "";
String? rideStatus = "Driver is Coming";
String? carDetailsDriver = "";
String? driverName = "";
String? driverphone = "";

double? starCounter=0.0;
String? title="";
String? carRideType="";

String? serverToken = "key=AAAAgyudES0:APA91bGZjOc3Dje2kxGTfvUicXFA8XaeOGB3WTpcp0DxBEOwondnXAVt-_koh_l_iJGeO6Czt2mEq8x65EvDuJIZ_LCqgY0hkWQ3bqU5mBjspjCMAdz_pQ8QBNyru3AFLuWIgq9op3cs";