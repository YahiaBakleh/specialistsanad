import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:specialistsanad/Models/userDetails.dart';
import 'package:specialistsanad/configMaps.dart';

class NotificationDialog extends StatelessWidget {
  // const NotificationDialog({Key? key}) : super(key: key);
  final UserDetails? uerDetails;
  NotificationDialog(this.uerDetails);
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
            Image.asset('images/normalSession.jpg',width: 120.0,),
            SizedBox(height: 18.0,),
            Text('New Session Request',style:TextStyle(fontFamily: BrandBold,fontSize:18.0),),
            SizedBox(height: 30.0,),
            Padding(
              padding:EdgeInsets.all(18.0) ,
              child: Column(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('images/desticon.png',height: 16.0,width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(
                          child: Container(
                              child: Text(
                                uerDetails!.session_address.toString(),
                                style: TextStyle(fontSize: 18.0),
                              )
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('images/user_icon.png',height: 16.0,width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(
                          child: Container(
                              child: Text(
                                uerDetails!.user_name.toString(),
                                style: TextStyle(fontSize: 18.0),
                              )
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0,),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Divider(height: 2.0,color: Colors.black,thickness: 2.0,),
            SizedBox(height: 8.0,),
            Padding(padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color:Colors.red),
                      ),
                      color:Colors.white,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      onPressed:(){
                        assetsAudioPlayers.stop();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                  ),
                  SizedBox(width: 8.0,),
                  RaisedButton(
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color:Colors.green),
                    ),
                    color:Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    onPressed:(){
                      assetsAudioPlayers.stop();
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
