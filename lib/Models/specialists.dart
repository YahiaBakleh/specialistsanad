import 'package:firebase_database/firebase_database.dart';

class Specialists{
  String? id;
  String? name;
  String? email;
  String? phone;
  String? mobile;
  String? residence;
  int? price;
  Specialists({this.id,this.name,this.email,this.price,this.phone,this.mobile});

  Specialists.fromSnapShot(DataSnapshot dataSnapshot){
    id        = dataSnapshot.key;
    name      = dataSnapshot .value['name'];
    email     = dataSnapshot .value['email'];
    phone     = dataSnapshot .value['phone'];
    mobile    = dataSnapshot .value['mobile'];
    residence = dataSnapshot .value['residence'];
    price     = dataSnapshot .value['price'];
  }
}
