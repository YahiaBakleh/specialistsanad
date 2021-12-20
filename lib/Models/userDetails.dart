import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserDetails{
  String? user_request_id;
  String? payment_method;
  LatLng? session_location;
  String? session_address;
  String? user_name;
  String? user_mobile;
  String? user_phone;

  UserDetails({this.user_request_id,this.payment_method,this.session_location,this.session_address,this.user_name,this.user_mobile,this.user_phone});
}