import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:specialistsanad/AllWidgets/progressDialog.dart';
import 'package:specialistsanad/Assistants/assistantMethod.dart';
import 'package:specialistsanad/Assistants/mapKitAssistant.dart';
import 'package:specialistsanad/Models/userDetails.dart';
import 'package:specialistsanad/configMaps.dart';
import 'package:specialistsanad/main.dart';

//to show user Details in dialog for specialist
class NewUserScreen extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(target: LatLng(33.50279062, 36.28587224), zoom: 14.4746);
  // const NewUserScreen({Key? key}) : super(key: key);
  UserDetails userDetails;
  NewUserScreen(this.userDetails);
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newUserGoogleMapController;
  Set<Marker> markersSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polylineSet= Set<Polyline>();
  List<LatLng> polylineCorOrdinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPaddingBottom = 0;
  Geolocator geolocator= Geolocator();
  LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  late BitmapDescriptor animatingMarkerIcon;
  late Position myPosition;
  String status = "accepted";
  String minDurationToArrive='until judge Day';
  bool isRequestDirection = false;

  void createIconMarker(){
    if(animatingMarkerIcon==null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context,size:Size(2,2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'images/specialist.png').then((value) => animatingMarkerIcon=value);
    }
  }

  void getUserLiveLocationUpdates(){
    LatLng oldPosition = LatLng(0.0, 0.0);
    userStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      myPosition = position;
      LatLng markerPosition = LatLng(position.longitude, position.longitude); // in tutorial called mPosition
      var rot = MapKitAssistant.getMarkerRotation(oldPosition.latitude, oldPosition.longitude, myPosition.latitude, myPosition.longitude);
      //TODO:rotation: rot // if any problem rot is double data type try num data type just so let .getMarkerRotation return num and remove .toDouble in return clause
      Marker animatingMarker = Marker(
          markerId: MarkerId('animating'),
          rotation: rot,
          position: markerPosition,
          icon:animatingMarkerIcon,
          infoWindow: InfoWindow(title: "Current Location"));

      setState(() {
        CameraPosition cameraPosition = new CameraPosition(target: markerPosition, zoom: 17);
        newUserGoogleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        markersSet.removeWhere((marker) => marker.markerId.value=="animating");
        markersSet.add(animatingMarker);
      });
      oldPosition = markerPosition;
      updateUserDetails();
      // to update spe location in firebse
      String? userRequestId = widget.userDetails.user_request_id;
      Map locMap =
      {
        "latitude": currentPosition?.latitude.toString(),
        "longitude": currentPosition?.longitude.toString(),
      };
      newRequsetsRef.child(userRequestId.toString()).child("specialist_location").set(locMap);
    });
  }

  @override
  void initState(){
    super.initState();
    acceptUserRequest();
  }

  @override
  Widget build(BuildContext context) {
    createIconMarker();
    return Scaffold(
      body:  Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingBottom),
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            initialCameraPosition: NewUserScreen._kGooglePlex,
            myLocationEnabled: true,
            // zoomControlsEnabled: true,
            // zoomGesturesEnabled: true,
            markers: markersSet,
            circles: circleSet,
            polylines: polylineSet,
            onMapCreated: (GoogleMapController controller) async {
              _controllerGoogleMap.complete(controller);
              newUserGoogleMapController = controller;
              setState(() {
                mapPaddingBottom = 270;
              });
              var currentLatlng = LatLng(currentPosition!.latitude.toDouble(), currentPosition!.longitude.toDouble());
              var sessionLatling = widget.userDetails.session_location;
              await getPlaceDirection(currentLatlng, sessionLatling!);
              getUserLiveLocationUpdates();
            },
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight:Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color:Colors.black38,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  )
                ],
              ),
              height: 270,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0,vertical:18.0 ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                            "Minimums Arrived at " + minDurationToArrive ,
                            style:TextStyle(fontSize: 14.0,fontFamily: BrandBold,color: Colors.deepPurpleAccent),
                          ),
                        ),
                      ),
                    SizedBox(height: 6.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('User Name',style:TextStyle(fontFamily: BrandBold,fontSize: 24.0)),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.phone_android),
                        ),
                      ],
                    ),
                    SizedBox(height: 26.0,),
                    Row(
                      children: [
                        Image.asset('images/desticon.png',height: 16.0,width: 16.0,),
                        SizedBox(width: 18.0,),
                        Expanded(
                            child: Container(
                              child: Text('Streer#44, Paris, France.',style:TextStyle(fontSize: 18.0,),overflow: TextOverflow.ellipsis,),
                            ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26.0,),
                    Row(
                      children: [
                        Icon(Icons.phone_iphone,size:18.0,color:Colors.redAccent),
                        SizedBox(width: 18.0,),
                        Expanded(
                          child: Container(
                            child: Text('User mobile',style:TextStyle(fontSize: 18.0,),overflow: TextOverflow.ellipsis,),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26.0,),
                    // Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: (){

                        },
                        color: Colors.blueAccent,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Arrived',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.white)),
                              Icon(Icons.directions_car_sharp)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }

  Future<void> getPlaceDirection( LatLng initialLatLng , LatLng sessionLatLng) async {
    //HINT: initialPos is where spacialist or doctor will come or accept the request
    // get pickUpLocation as initialPos and sessionLocation as sessionPos
    // var initialPos =
    //     Provider.of<AppData>(context, listen: false).pickUpLocation;
    // var sessionPos =
    //     Provider.of<AppData>(context, listen: false).sessionLocation;
    // // convert initialPos and sessionPos to LatLng point
    // var initialLatLng = LatLng(
    //     initialPos!.latitude!.toDouble(), initialPos.longitude!.toDouble());
    // var sessionLatLng = LatLng(
    //     sessionPos!.latitude!.toDouble(), sessionPos.longitude!.toDouble());

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: "Please wait...",
        ));

    var details = await AssistantMethod.obtainPlaceDirectionDetails(
        initialLatLng /*pickUpLatLng*/, sessionLatLng /*dropOffLatLng*/);

    Navigator.pop(context);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
    polylinePoints.decodePolyline(details!.encodedPoints.toString());

    polylineCorOrdinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polylineCorOrdinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylineCorOrdinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (initialLatLng.latitude > sessionLatLng.latitude &&
        initialLatLng.longitude > sessionLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: initialLatLng, northeast: sessionLatLng);
    } else if (initialLatLng.longitude > sessionLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(initialLatLng.latitude, sessionLatLng.longitude),
          northeast: LatLng(sessionLatLng.latitude, initialLatLng.longitude));
    } else if (initialLatLng.latitude > sessionLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(sessionLatLng.latitude, initialLatLng.longitude),
          northeast: LatLng(initialLatLng.latitude, sessionLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: initialLatLng, northeast: sessionLatLng);
    }

    newUserGoogleMapController?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker initialLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      position: initialLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker sessionLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: sessionLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(initialLocMarker);
      markersSet.add(sessionLocMarker);
    });

    Circle initialLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: initialLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle sessionLocCircle = Circle(
      fillColor: Colors.deepPurple,
      center: sessionLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circleSet.add(initialLocCircle);
      circleSet.add(sessionLocCircle);
    });
  }

  void acceptUserRequest() {
    String? userRequestId = widget.userDetails.user_request_id;
    newRequsetsRef.child(userRequestId.toString()).child("status").set("accepted");
    newRequsetsRef.child(userRequestId.toString()).child("specialist_name").set(specialistsInfo?.name);
    newRequsetsRef.child(userRequestId.toString()).child("specialist_phone").set(specialistsInfo?.phone);
    newRequsetsRef.child(userRequestId.toString()).child("specialist_mobile").set(specialistsInfo?.mobile);
    newRequsetsRef.child(userRequestId.toString()).child("specialist_id").set(specialistsInfo?.id);
    newRequsetsRef.child(userRequestId.toString()).child("specialist_price").set(specialistsInfo?.price);
    Map locMap =
    {
      "latitude": currentPosition?.latitude.toString(),
      "longitude": currentPosition?.longitude.toString(),
    };
    newRequsetsRef.child(userRequestId.toString()).child("specialist_location").set(locMap);
    specialistRef.child(currentFirebaseUser!.uid).child("history").child(userRequestId!).set(true);
  }
  void updateUserDetails(){
    if(isRequestDirection=false){
      setState(() {
        isRequestDirection = true;
      });
      if(myPosition ==null){
        return;
      }
      LatLng posLatlng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng? destinationLatlng ;
      if(status=="accepted"){
        destinationLatlng= widget.userDetails?.session_location;
      }
      var directionDetails = AssistantMethod.obtainPlaceDirectionDetails(posLatlng, destinationLatlng!);
      if(directionDetails!=null){
        directionDetails.then((value){
          setState(() {
            minDurationToArrive= value!.durationText.toString();
          });
        });
      }
      setState(() {
        isRequestDirection = false;
      });
    }
  }
}
