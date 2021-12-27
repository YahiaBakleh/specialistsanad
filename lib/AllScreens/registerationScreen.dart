// import 'package:specialistsanad/AllScreens/mainScreen.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:specialistsanad/AllScreens/profileInfoScreen.dart';
import 'package:specialistsanad/AllWidgets/progressDialog.dart';
import 'package:specialistsanad/Models/allUsers.dart';
import 'package:specialistsanad/configMaps.dart';
import 'package:specialistsanad/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:specialistsanad/AllScreens/loginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterationScreen extends StatefulWidget {
  static const idScreen = 'register';

  const RegisterationScreen({Key? key}) : super(key: key);
  @override
  _RegisterationScreenState createState() => _RegisterationScreenState();
}

//TODO: Email and name cellPhone  Should be unique
//ToDO : Password Should
//TODO: Connect to database
//TODO: Residence Should Open Model box with map
class _RegisterationScreenState extends State<RegisterationScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController residence = TextEditingController();
  TextEditingController price = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 35.0,
                ),
                // Image(
                //     image: AssetImage('images/Hand-Logo.png'),
                //     height: 150.0,
                //     width: 390.0,
                //     alignment: Alignment.center
                // ),
                // SizedBox(height: 30.0,),
                Text('Register', style: TextStyle(fontSize: 26, fontFamily: "Brand Bold"), textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 1.0,
                      ),
                      TextFormField(
                        controller: email,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Email';
                          }
                          if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)) {
                            return 'Please enter valid Email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 50,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontFamily: 'Brand Bold', fontSize: 16, color: Colors.redAccent),
                            contentPadding: EdgeInsets.all(2.0), //  <- you can it to 0.0 for no space
                            isDense: true,
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 22)),
                        style: TextStyle(fontSize: 22.0, fontFamily: 'Brand Bold'),
                      ), //Email
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: password,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          return value.length <= 6 ? 'Password is equal or greater than 7 characters' : null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontFamily: 'Brand Bold', fontSize: 16, color: Colors.redAccent),
                            contentPadding: EdgeInsets.all(2.0), //  <- you can it to 0.0 for no space
                            isDense: true,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 22)),
                        style: TextStyle(fontSize: 22.0, fontFamily: 'Brand Bold'),
                      ), //Password
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Name';
                          }
                          return value.length <= 2 ? 'Name is equal or greater than 3 characters' : null;
                        },
                        keyboardType: TextInputType.name,
                        maxLength: 50,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontFamily: 'Brand Bold', fontSize: 16, color: Colors.redAccent),
                            contentPadding: EdgeInsets.all(2.0), //  <- you can it to 0.0 for no space
                            isDense: true,
                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 22)),
                        style: TextStyle(fontSize: 22.0, fontFamily: 'Brand Bold'),
                      ), //Name
                      SizedBox(
                        height: 30.0,
                      ),

                      TextFormField(
                        controller: price,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your wages';
                          }
                          if (!RegExp(r"^[0-9]*$").hasMatch(value)) {
                            return 'Numeric Value only';
                          }
                          return int.parse(value) <= 0 ? 'Price is greater than 0' : null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        maxLength: 4,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontFamily: 'Brand Bold', fontSize: 16, color: Colors.redAccent),
                            contentPadding: EdgeInsets.all(2.0), //  <- you can it to 0.0 for no space
                            isDense: true,
                            hintText: "Price Per Hour",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 22)),
                        style: TextStyle(fontSize: 22.0, fontFamily: 'Brand Bold'),
                      ), //Price per hour
                      SizedBox(
                        height: 30.0,
                      ),

                      TextFormField(
                        controller: phone,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Phone';
                          }
                          return value.length <= 6 ? 'Phone is equal or greater than 7 characters' : null;
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 20,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontFamily: 'Brand Bold', fontSize: 16, color: Colors.redAccent),
                            contentPadding: EdgeInsets.all(2.0), //  <- you can it to 0.0 for no space
                            isDense: true,
                            hintText: "Phone",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 22)),
                        style: TextStyle(fontSize: 22.0, fontFamily: 'Brand Bold'),
                      ), //Phone
                      SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: mobile,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Mobile';
                          }
                          return value.length <= 9 ? 'Mobile is equal or greater than 9 characters' : null;
                        },
                        maxLength: 20,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontFamily: 'Brand Bold', fontSize: 16, color: Colors.redAccent),
                            contentPadding: EdgeInsets.all(2.0), //  <- you can it to 0.0 for no space
                            isDense: true,
                            hintText: "Mobile",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 22)),
                        style: TextStyle(fontSize: 22.0, fontFamily: 'Brand Bold'),
                      ), //Mobile
                      SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: residence,
                        keyboardType: TextInputType.streetAddress,
                        maxLength: 100,
                        maxLines: 4,
                        minLines: 2,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontFamily: 'Brand Bold', fontSize: 16, color: Colors.redAccent),
                            contentPadding: EdgeInsets.all(2.0), //  <- you can it to 0.0 for no space
                            isDense: true,
                            hintText: "Residence",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 22)),
                        style: TextStyle(fontSize: 22.0, fontFamily: 'Brand Bold'),
                      ), //Residence
                      SizedBox(
                        height: 30.0,
                      ),
                      RaisedButton(
                        color: Colors.indigo,
                        textColor: Colors.white,
                        onPressed: () {
                          registerNewUser(context);
                        },
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              'Creat Account',
                              style: TextStyle(fontSize: 22.0, fontFamily: 'Brand Bold'),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                    },
                    child: Text(
                      'Do Have an Account? Login Here.',
                      style: TextStyle(fontSize: 16.0, fontFamily: 'Brand Bold', color: Colors.black),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Creating Account , Please Wait...");
        });

    final result = (await _firebaseAuth.createUserWithEmailAndPassword(email: email.text, password: password.text).catchError((error) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error: ' + error.toString());
    }))
        .user;
    if (result != null) /*user created*/ {
      Map specialistDataMap = {
        'email': email.text.trim(),
        'password': password.text.trim(),
        'name': name.text.trim(),
        'phone': phone.text.trim(),
        'mobile': mobile.text.trim(),
        'residence': residence.text.trim(),
        'price': int.parse(price.text.trim()),
        'activated': false
      };
      specialistRef.child(result.uid).set(specialistDataMap);
      // add curent user to globale currentFirebaseUser
      currentFirebaseUser = result;
      // Fluttertoast.showToast(msg: "Speciaslit Account Created has been Successfully , Please create Profile ");
      // Navigator.pushNamed(context, ProfileInfoScreen.idScreen, arguments: (route) => false);
      Fluttertoast.showToast(msg: "Speciaslit Account Created has been Successfully , Plese wait untile activate account");
      Navigator.pushNamed(context, LoginScreen.idScreen, arguments: (route) => false);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "New Speciaslit Account has been not Created");
    }
  }
}
