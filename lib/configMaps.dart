import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:specialistsanad/Models/specialists.dart';
import 'Models/allUsers.dart';

String mapKey = "AIzaSyAXhk1498g3ORPHcP6Wytkouh0Mn28obVo";

String  BrandBold='Brand Bold' ;
String  BrandRegular='Brand-Regular' ;
String  Signatra='Signatra';
final assetsAudioPlayers = AssetsAudioPlayer();
Position? currentPosition;
User? firebaseUser;

Users? userCurrentInfo;
Specialists? specialistsInfo;
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
String? seriveceType="";

String? serverToken = "key=AAAAgyudES0:APA91bGZjOc3Dje2kxGTfvUicXFA8XaeOGB3WTpcp0DxBEOwondnXAVt-_koh_l_iJGeO6Czt2mEq8x65EvDuJIZ_LCqgY0hkWQ3bqU5mBjspjCMAdz_pQ8QBNyru3AFLuWIgq9op3cs";
String? messagingServiceToken = "AAAAB-NSOzo:APA91bF9niY__G_2VK_j_GqSBqPO1hYiD71oFPVz4PA21rnxEK5I9HH5Xs4ZlDfdEgN-rha7sS5p5GXvsVIT0-Ga8v3yHhX09w0LD21V4hIPS347d67LOdDt0SOyclSA2UnOsbLv7v5C";