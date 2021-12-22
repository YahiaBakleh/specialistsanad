import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:specialistsanad/Assistants/requestAssistant.dart';
import 'package:specialistsanad/DataHandler/appData.dart';
import 'package:specialistsanad/Models/address.dart' as userAddress;
import 'package:specialistsanad/Models/allUsers.dart';
import 'package:specialistsanad/Models/directionDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:specialistsanad/configMaps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:specialistsanad/main.dart';

class AssistantMethod {
//TODO:  enable Billing on the Google Cloud Project at https://console.cloud.google.com/ Learn more at https://developers.google.com/maps/gmp-get-started"
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    /**TODO: Add API_KEY**/
    // String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + position.altitude.toString() + "," + position.longitude.toString() + "&key=" + mapKey.toString();
    // Uri url =Uri.parse(("https://maps.googleapis.com/maps/api/geocode/json?latlng=" + position.altitude.toString() + "," + position.longitude.toString() + "&key=" + mapKey.toString()).trim());
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.altitude},${position.longitude}&key=$mapKey";
    print(url);
    var response = await RequestAssistant.getRequest(url);
    if (response != 'failed') {
      // placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][3]["long_name"]
          .toString();
      st2 = response["results"][0]["address_components"][4]["long_name"]
          .toString();
      st3 = response["results"][0]["address_components"][5]["long_name"]
          .toString();
      st4 = response["results"][0]["address_components"][6]["long_name"]
          .toString();
      placeAddress = (st1 + " " + st2 + " " + st3 + " " + st4).toString();
      userAddress.Address userPickUpAddress =
          new userAddress.Address(placeName: placeAddress);
      print(placeAddress);
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  // static Future<String?> getAddressByCoordinate(
  //     Position position, context) async {
  //   List<Placemark> address =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   userAddress.Address userPickUpAddress = new userAddress.Address();
  //   // String addressLocation = address.first.locality.toString() + '1 , ' + address.first.street.toString() + '2 , ' + address.first.name.toString() + '3 , ';
  //   String addressLocation = address.first.street.toString() + ' , ';
  //   userPickUpAddress.latitude = position.latitude;
  //   userPickUpAddress.longitude = position.longitude;
  //   userPickUpAddress.placeName = addressLocation;
  //   Provider.of<AppData>(context, listen: false)
  //       .updatePickUpLocationAddress(userPickUpAddress);
  //   return address.first.name;
  // }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPostion, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPostion.latitude},${initialPostion.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails(encodedPoints: '');

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    return 10;
  }

  static void getCurrentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser!.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child('userId');
    reference.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        userCurrentInfo = Users.fromSnapshot(dataSnapshot);
      }
    });
  }

  static void appProtection(BuildContext context){
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    specialistRef.child(currentUserId.toString()).once().then((DataSnapshot snap) {
      if (snap.value != null) {
        if(snap.value['activated']){
          currentFirebaseUser = firebaseUser;
        }else{
          Geofire.removeLocation(currentFirebaseUser!.uid);
          requestRef.onDisconnect();
          requestRef.remove();
          Navigator.pop(context);
          _firebaseAuth.signOut();
          Fluttertoast.showToast(msg: "Account has been disctivate, contact us to reactivate ");
        }
      } else {
        Navigator.pop(context);
        _firebaseAuth.signOut();
        Fluttertoast.showToast(msg: "No Such User. Please create new account");
      }
    });
  }

}
