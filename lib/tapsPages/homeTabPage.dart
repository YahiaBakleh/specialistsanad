import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:specialistsanad/Notifications/pushNotificationService.dart';
import 'package:specialistsanad/configMaps.dart';
import 'package:specialistsanad/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(target: LatLng(33.50279062, 36.28587224), zoom: 14.4746);
  const HomeTabPage({Key? key}) : super(key: key);
  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController? newGoogleMapController;

  Position? currentPosition;

  var geoLocator = Geolocator();

  Color onlineOfflineColorState = Colors.black;

  // MaterialColor green = Colors.green;
  String buttonLabelState = 'Offline - Go Online ';
  // the text show on the button
  bool isAvailable = false;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // String address = await AssistantMethod.searchCoordinateAddress(position, context);
    // String? address = await AssistantMethod.getAddressByCoordinate(position, context);
  }

  void getSpecialistInfo() async {
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.initialize(context);
    pushNotificationService.getToken();
  }

  @override
  void initState() {
    super.initState();
    getSpecialistInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          // zoomControlsEnabled: true,
          // zoomGesturesEnabled: true,
          // polylines: polylineSet,
          // markers: markersSet,
          // circles: circlesSet,

          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),
        //online offline container
        /**this Positioned area to mimic myLocationButton on google map**/
        //TODO: rebuild / the button on Positioned and re Position it
        // Positioned(
        //   top: 175.0,
        //   right: 30.0,
        //   child: Padding(
        //     padding: EdgeInsets.all(15.0),
        //     child: FloatingActionButton.extended(
        //       onPressed: () {
        //         locatePosition();
        //       },
        //       label: Text('My Location'),
        //       icon: Icon(Icons.location_on),
        //     ),
        //   ),
        // ),
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black45,
        ),
        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    /*specialist offline make him online */
                    if (isAvailable != true) {
                      makeMeOnline();
                      getLocationLiveUpdates();
                      setState(() {
                        isAvailable = true; // make him available/online
                        onlineOfflineColorState = Colors.green; // color was red change to green
                        buttonLabelState = "Online - Go Offline ";
                        Fluttertoast.showToast(msg: "You are online Now :) ");
                      });
                    }
                    /*specialist online make him offline*/
                    else {
                      makeMeOffline();
                      setState(() {
                        isAvailable = false; // make him unavailable/offline
                        onlineOfflineColorState = Colors.black; // color was green change to red
                        buttonLabelState = "Offline - Go Online ";
                        Fluttertoast.showToast(msg: "You are offline Now :l ");
                      });
                    }
                  },
                  color: onlineOfflineColorState,
                  child: Padding(
                    padding: EdgeInsets.all(17.00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          buttonLabelState,
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Icon(
                          (!isAvailable ? Icons.phone_android : Icons.signal_wifi_off_outlined),
                          color: Colors.white,
                          size: 26.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void makeMeOnline() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    Geofire.initialize('availableSpecialist');
    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition!.latitude, currentPosition!.longitude);
    requestRef.set('serching');
    requestRef.onValue.listen((event) {});
  }

  void makeMeOffline() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    requestRef.onDisconnect();
    requestRef.remove();
    // requestRef = null;
  }

  void getLocationLiveUpdates() {
    homeTabPagesStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isAvailable == true) {
        Geofire.setLocation(currentFirebaseUser!.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
