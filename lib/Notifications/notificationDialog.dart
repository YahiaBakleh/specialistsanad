import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:[
            SizedBox(height: 30.0,),
            Image.asset('images/user_icon.png',width: 120.0,),
            SizedBox(height: 18.0,),
            Text('New Session Request',style:TextStyle(fontFamily: ''),),

          ],
        ),
      ),
    );
  }
}
