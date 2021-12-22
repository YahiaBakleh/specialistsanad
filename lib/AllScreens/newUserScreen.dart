import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:specialistsanad/Models/userDetails.dart';
import 'package:specialistsanad/configMaps.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: NewUserScreen._kGooglePlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            // zoomControlsEnabled: true,
            // zoomGesturesEnabled: true,
            // polylines: polylineSet,
            // markers: markersSet,
            // circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newUserGoogleMapController = controller;
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
                    SizedBox(height: 5.0,),
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
}
