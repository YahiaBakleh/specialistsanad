import 'package:flutter/material.dart';
import 'package:specialistsanad/Models/userDetails.dart';

//to show user info in dealog for specialist
class NewUserScreen extends StatefulWidget {
  // const NewUserScreen({Key? key}) : super(key: key);
  UserDetails userDetails;
  NewUserScreen(this.userDetails);
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Center(
        child: Text("This Is User's Contact Info"),


      ),
    );
  }
}
