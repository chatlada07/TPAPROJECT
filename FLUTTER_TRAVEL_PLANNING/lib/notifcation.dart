import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_travel_planning/global/loader.dart';
import 'package:flutter_travel_planning/model/ModelNotification.dart';
import 'package:google_fonts/google_fonts.dart';
import 'global/color.dart';
import 'global/url.dart';
import 'model/ModelNotificationDB.dart';


class notification extends StatefulWidget {
  const notification({Key? key}) : super(key: key);
  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  late ModelNotificationDB _modelNotification;
  final List<ModelNotificationDB> listNotification = [];
  final DatabaseReference db = FirebaseDatabase.instance.ref();
  void initState(){
    super.initState();
    Timer.periodic(new Duration(seconds: 1), (timer) {
      getListNotification();
    });
  }
  getListNotification() async {
    listNotification.clear();
    db.child('Notification').child(AppUrl.UserID).once().then((result) async  {
      var response = result.snapshot;
      setState(() {
        try{
          var list = response.value as Map;
            list.forEach((key,value) {
              var ii = "";
              // Map<dynamic, dynamic> values = list[i] as Map;
              _modelNotification = ModelNotificationDB.fromJson(value);
              listNotification.add(_modelNotification);

            });
        }catch(e){
          // if(response.value != null) {
          //   Map<dynamic, dynamic> values = response.value as Map;
          //   values.forEach((key, value) {
          //     Map<dynamic, dynamic> value_noti = value as Map;
          //     _modelNotification = ModelNotification.fromJson(value_noti);
          //     // listNotification.add(_modelNotification);
          //     // print(values["description"]);
          //   });
          // }
        }

        listNotification.sort((a,b) {
          return b.date_trip.compareTo(a.date_trip);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: AppBar(
        title: const Text("Travel Planning",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.colorMain,
      ),
      body: Center(
        //color: Colors.transparent,
        child: Container (  
          padding: EdgeInsets.all(20),
        decoration:  const BoxDecoration(
    borderRadius:BorderRadius.all(Radius.circular(10))
    ),
        child: listNotification.length > 0 ?
        ListView.builder(itemCount:listNotification.length,itemBuilder: (context, index){
          return
          Column(
            children: <Widget> [
              Card(
                child: (
                  ListTile(
                    onTap: (){

                    },
                      //isThreeLine: true,
                      leading: Image.asset("images/notification.png",height: 30,width: 30,),
                      title: Text("Travel alert : ${listNotification[index].title}",style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                  subtitle: Text("${listNotification[index].date_trip}",style: TextStyle(color: Colors.black, fontSize: 14), ),
                  )
                ),
              ),
              //Divider(height: 4, color: Colors.black,)
            ],);
        })
        : Visibility(
          visible: listNotification.length == 0 ? true : false,
          child: Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: new Text("ไม่มีรายการ",
              style: GoogleFonts.kanit(
                  fontWeight: FontWeight.bold),),
          ),
        )
        )),
    );
  }
}