import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:flutter_travel_planning/global/color.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_picker/map_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'checklist.dart';
import 'global/url.dart';
import 'main.dart';
import 'model/ModelNotification.dart';

class visited_detail extends StatefulWidget {
  final _travelId;
  final _travel_type;
  final _travel_title;
  const visited_detail(this._travel_type,this._travelId, this._travel_title, {Key? key,}) : super(key: key);
  @override
  _visited_detailState createState() => _visited_detailState( this._travel_type,this._travelId,this._travel_title);
}

class _visited_detailState extends State<visited_detail> {
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  late List<Model> dataMap = <Model>[];

  late MapShapeSource dataSource;
  late List<ModelTravelTripDay> itemTravelTripDay = [];

  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(13.7953268, 100.5864872),
    zoom: 0,
  );

  var textController = TextEditingController();

  var txtTitle = TextEditingController();
  var txtTitleEdit = TextEditingController();

  var counterId = 0;

  DatabaseReference _db = FirebaseDatabase.instance.ref();
  late DateTime? _chosenDateTime = null;
  late DateTime? _editChosenDateTime = null;
  late int noti_id = 0;
  late int TravelTripDayId = 0;
  bool bEdit =false;

  var titleName = "";
  _visited_detailState(travelId, travel_type, travel_title);
  @override
  void initState() {

    super.initState();

    loadData();
    titleName = widget._travel_title;
  }
  void loadData() async{
    primaryFocus!.unfocus(disposition: disposition);
    await FirebaseDatabase.instance.ref()
        .child('Travel_Trip_Day')
        .child(AppUrl.UserID).child('${widget._travelId}')
        .orderByChild("travel_trip_day_id")
        .once()
        .then((event) {
      try {
        var response = event.snapshot;
        if(response.value != null){
          try {
            itemTravelTripDay.clear();
            List<Object?> list = List<Object?>.from(response.value as dynamic);
            for (var i = 0; i < list.length; i++) {
              if (list[i] != null) {
                Map<dynamic, dynamic> value = list[i] as Map;
                var dataTravelTripDay = ModelTravelTripDay.fromJson(value);
                counterId = int.parse(dataTravelTripDay.travel_trip_day_id);
                itemTravelTripDay.add(dataTravelTripDay);

              }
            };
          } catch (e) {
            var list = response.value as Map;
            list.forEach((key, value) {
              var dataTravelTripDay = ModelTravelTripDay.fromJson(value);
              counterId = int.parse(dataTravelTripDay.travel_trip_day_id);
              itemTravelTripDay.add(dataTravelTripDay);
            });
          };
          setState(()  {
            counterId += 1;
          });
        }else{
          itemTravelTripDay.clear();
        }


      } catch (e) {
        e.toString();
      }
    });
  }
  void _showDatePickerEdit(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height: 500,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              SizedBox(
                height: 400,
                child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (val) {
                      setState(() {
                        // String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(val);
                        _editChosenDateTime = val!;
                      });
                    }),
              ),

              // Close the modal
              CupertinoButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titleName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.colorMain,
          leadingWidth: 70,
          leading:IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              itemTravelTripDay.length > 0 ?
                              ListView(
                                primary: false,
                                shrinkWrap: true,
                                children: [
                                  new  Column(
                                      children: new List<InkWell>.generate(
                                          itemTravelTripDay.length,
                                              (int index) {
                                            var no = index+1;
                                            return InkWell(
                                              onTap: (){
                                                // _pushPageChecklist(context,false,"");
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  height: 150,
                                                  margin: EdgeInsets.only(top: 5.0,bottom: 5),
                                                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),

                                                  decoration:  BoxDecoration(
                                                      border: Border.all(width: 1,color: Colors.black),
                                                      color: AppColors.color_white,
                                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                                  child:Column(
                                                    children: [

                                                      Container(
                                                        alignment: Alignment.topCenter,
                                                        child: ListTile(
                                                          title:   Row(children: [
                                                            Container(
                                                              alignment: Alignment.center,
                                                              padding: EdgeInsets.only(left: 10,top: 8,right: 10,bottom: 8),
                                                              decoration: BoxDecoration(
                                                                  color: AppColors.colorMain,
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  boxShadow: <BoxShadow>[
                                                                    BoxShadow(
                                                                        color: Color.fromRGBO(0, 0, 0, 0.16) ,
                                                                        offset: Offset(5, 5),
                                                                        blurRadius: 10)
                                                                  ]),
                                                              child:Text(
                                                                "Day $no",
                                                                style: GoogleFonts.roboto(
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                          ],),
                                                          trailing: Wrap(
                                                            spacing: 12, // space between two icons
                                                            children: <Widget>[
                                                              ElevatedButton(
                                                                style: ButtonStyle(
                                                                    foregroundColor:
                                                                    MaterialStateProperty.all<Color>(Colors.black),
                                                                    backgroundColor: MaterialStateProperty.all<Color>(
                                                                        const Color.fromRGBO(196, 196, 196, 1)),
                                                                    shape:
                                                                    MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(18.0),
                                                                          side: const BorderSide(
                                                                              width: 1, color: AppColors.color_black, style: BorderStyle.solid),
                                                                        ))),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    bEdit = true;
                                                                    txtTitleEdit.text = itemTravelTripDay[index].title;
                                                                    _editChosenDateTime= DateTime.parse(itemTravelTripDay[index].date_trip);
                                                                    noti_id = itemTravelTripDay[index].noti_id;
                                                                    TravelTripDayId = int.parse(itemTravelTripDay[index].travel_trip_day_id);
                                                                  });
                                                                },
                                                                child:   Text("Edit",
                                                                  style: GoogleFonts.roboto(fontSize: 14),
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                style: ButtonStyle(
                                                                    foregroundColor:
                                                                    MaterialStateProperty.all<Color>(Colors.black),
                                                                    backgroundColor: MaterialStateProperty.all<Color>(
                                                                        const Color.fromRGBO(196, 196, 196, 1)),
                                                                    shape:
                                                                    MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(18.0),
                                                                          side: const BorderSide(
                                                                              width: 1, color: AppColors.color_black, style: BorderStyle.solid),
                                                                        ))),
                                                                onPressed: () {
                                                                  Alert(
                                                                    context: context,
                                                                    // type: obj_status["statusCode"] == 200 ? AlertType.success : AlertType.error,
                                                                    type: AlertType.warning,
                                                                    title: "Confirm Delete",
                                                                    desc: "Do you want to delete the ${itemTravelTripDay[index].title} ? ",
                                                                    buttons: [
                                                                      DialogButton(
                                                                        child: Text(
                                                                          "Cancel",
                                                                          style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Itim",fontWeight: FontWeight.bold),
                                                                        ),
                                                                        onPressed: () {
                                                                          Alert(context: context).dismiss();
                                                                        },
                                                                        color: Colors.redAccent,
                                                                        radius: BorderRadius.circular(25.0),
                                                                        // border: Border.all(
                                                                        //   color: AppColors.colorMain, //Add color of your choice
                                                                        // ),
                                                                      ),
                                                                      DialogButton(
                                                                        child: Text(
                                                                          "Confirm",
                                                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                                                        ),
                                                                        onPressed: () async {
                                                                          setState(()  {
                                                                            Alert(context: context).dismiss();
                                                                            _db = FirebaseDatabase.instance.ref();
                                                                            _db.child('Travel_Trip_Day').child(
                                                                                AppUrl.UserID).child('${widget._travelId}')
                                                                                .child('${itemTravelTripDay[index].travel_trip_day_id}')
                                                                                .remove().then((value) {
                                                                              EasyLoading.showSuccess("Delete Success",);
                                                                              loadData();
                                                                            });
                                                                          });
                                                                        },
                                                                        radius: BorderRadius.circular(25.0),
                                                                        color: Colors.green,
                                                                      )
                                                                    ],
                                                                  ).show();
                                                                },
                                                                child: Text("Delete",
                                                                    style: GoogleFonts.roboto(fontSize: 14)),
                                                              ),
                                                              InkWell(
                                                                onTap: (){
                                                                  var str = "https://www.facebook.com/dialog/feed?"+
                                                                      "app_id=358348359713770"+
                                                                      "&display=popup";
                                                                  // Share.share('check out my website https://example.com', subject: 'Look what I made!');
                                                                  FlutterSocialContentShare.share(
                                                                    type: ShareType.facebookWithoutImage,
                                                                    url: str,
                                                                    quote: "Facebook",
                                                                  );

                                                                  // FacebookShare.shareContent(url: "https://nemob.id", quote: "Dapatkan Promo");
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets.only(top: 5),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(36.0),
                                                                    border: Border.all(width: 1,color: Colors.blueAccent),
                                                                  ),

                                                                  child: ClipOval(
                                                                    child: Image.asset("images/ic_facebook.png",height: 36,width: 36,
                                                                        fit: BoxFit.cover
                                                                    ),
                                                                  ),
                                                                ),
                                                              )

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment: Alignment.center,
                                                        margin: EdgeInsets.only(top: 20),
                                                        child:  Text(
                                                          "${itemTravelTripDay[index].title}",
                                                          style: GoogleFonts.roboto(
                                                              fontSize: 15),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      )

                                                    ],
                                                  )
                                              ),
                                            );
                                          }
                                      )

                                  ),
                                ],)
                                  : Visibility(
                                visible: itemTravelTripDay.length == 0 ? true : false,
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  alignment: Alignment.center,
                                  child: new Text("ไม่มีรายการ",
                                    style: GoogleFonts.kanit(
                                        fontWeight: FontWeight.bold),),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            AnimatedOpacity(
                opacity: 1 ,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 5000),
                child: Stack(
                  children: [
                    Visibility(
                        visible: bEdit,
                        child:  GestureDetector(
                            onTap: (){
                              setState(() {
                                bEdit = false;
                              });
                            },
                            child:  Scaffold(
                                backgroundColor: Color.fromRGBO(0, 0, 0, 100),
                                body: GestureDetector(
                                  onTap: (){
                                    if(!bEdit) return;
                                  },
                                  child:  Center(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 30,top:20,right: 30,bottom: 30),
                                      margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                      ),
                                      child:  Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                                margin: EdgeInsets.only(bottom: 10),
                                                child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Column(
                                                          children: [
                                                            Container(
                                                              child:Row(
                                                                children: [
                                                                  Flexible(child:  Text(
                                                                    'Edit Title',
                                                                    textAlign: TextAlign.left,
                                                                    style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                                                                  ),
                                                                  ),
                                                                  Icon(Icons.add_circle_outline_outlined,color: Colors.black, ),
                                                                ],
                                                              ),
                                                            ),
                                                            TextField(
                                                              controller: txtTitleEdit ,
                                                              decoration: InputDecoration(
                                                                hintText: "Enter Edit Title",
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(top: 10),
                                                              child:Row(
                                                                children: [
                                                                  Flexible(child:  Text(
                                                                    'Date trip',
                                                                    textAlign: TextAlign.left,
                                                                    style: GoogleFonts.roboto(fontSize: 16.0, ),
                                                                  ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: (){
                                                                setState(() {
                                                                  _editChosenDateTime = DateTime.now();
                                                                  _showDatePickerEdit(context);
                                                                });
                                                              },
                                                              child: Container(
                                                                width: double.infinity,
                                                                alignment: Alignment.center,
                                                                padding: EdgeInsets.all(5),

                                                                margin:EdgeInsets.all(5),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                  border: Border.all(color: Colors.black, width: 1),
                                                                ),
                                                                height: 40.0,
                                                                child:Container(
                                                                  child: Text(_editChosenDateTime != null
                                                                      ? DateFormat('yyyy-MM-dd hh:mm').format(_editChosenDateTime!).toString()
                                                                      : 'ระบุวันทีเวลาเดินทาง',style: GoogleFonts.kanit(
                                                                      fontSize: 16
                                                                  ),
                                                                    textAlign: TextAlign.center,),
                                                                ),


                                                              ),
                                                            ),
                                                          ]),
                                                    ])),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:[
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          foregroundColor:
                                                          MaterialStateProperty.all<Color>(Colors.black),
                                                          padding: MaterialStateProperty.all(const EdgeInsets.only(top: 10,bottom: 10)),
                                                          backgroundColor: MaterialStateProperty.all<Color>(
                                                              const Color.fromRGBO(196, 196, 196, 1)),
                                                          shape:
                                                          MaterialStateProperty.all<RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(18.0),
                                                                side: const BorderSide(
                                                                    width: 1, color: AppColors.color_black, style: BorderStyle.solid),
                                                              ))),
                                                      onPressed: () async {
                                                        setState(() {
                                                          bEdit = false;
                                                        });
                                                      },
                                                      child: const Text("Close",
                                                          style: TextStyle(fontSize: 14,
                                                              fontWeight: FontWeight.w400)),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child:     ElevatedButton(
                                                      style: ButtonStyle(
                                                          foregroundColor:
                                                          MaterialStateProperty.all<Color>(Colors.black),
                                                          backgroundColor: MaterialStateProperty.all<Color>(
                                                              const Color.fromRGBO(196, 196, 196, 1)),
                                                          shape:
                                                          MaterialStateProperty.all<RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(18.0),
                                                                side: const BorderSide(
                                                                    width: 1, color: AppColors.color_black, style: BorderStyle.solid),
                                                              ))),
                                                      onPressed: () async {
                                                        // txtTitleEdit.text = itemTravelTripDay[index].title;
                                                        // _editChosenDateTime= DateTime.parse(itemTravelTripDay[index].date_trip);
                                                        // noti_id = itemTravelTripDay[index].noti_id;
                                                        DatabaseReference newRef = _db.child('Travel_Trip_Day');
                                                        // var TravelTripDayId = itemTravelTripDay[index].travel_trip_day_id ;
                                                        await newRef.child(AppUrl.UserID).child('${widget._travelId}').child(TravelTripDayId.toString()).update({
                                                          'travel_trip_day_id':TravelTripDayId.toString(),
                                                          'title':  txtTitleEdit.text,
                                                          'date_trip':DateFormat('yyyy-MM-dd hh:mm:ss').format(_editChosenDateTime!).toString(),
                                                          'noti_id':noti_id
                                                        }).then((onValue) {
                                                          setState(() {
                                                            var strDateList;
                                                            var  timeMessage = DateFormat('hh:mm').format(_editChosenDateTime!).toString();
                                                            strDateList = _editChosenDateTime!.day.toString() +
                                                                "/" +
                                                                _editChosenDateTime!.month.toString() +
                                                                "/" +
                                                                (_editChosenDateTime!.year).toString();
                                                            var strNameTitle = "Date : "+strDateList +"  time : " + timeMessage ;
                                                            var notification = ModelNotification(
                                                                messageDateTime:strNameTitle,
                                                                dateTime: DateTime(
                                                                    _editChosenDateTime!.year,
                                                                    _editChosenDateTime!.month,
                                                                    _editChosenDateTime!.day,
                                                                    _editChosenDateTime!.hour,
                                                                    _editChosenDateTime!.minute),
                                                                name: "Travel alert : ${txtTitleEdit.text}");
                                                            showDailyAtDateTime(notification.dateTime,
                                                                notification,noti_id);
                                                            updateNoti(notification,txtTitleEdit.text,_editChosenDateTime);
                                                            bEdit = false;
                                                            txtTitleEdit.text = "";
                                                            EasyLoading.showSuccess("Edit Success",);
                                                            loadData();
                                                          });
                                                          return true;
                                                        }).catchError((onError) {
                                                          return false;
                                                        });
                                                      },
                                                      child: const Text("Save",
                                                          style: TextStyle(fontSize: 14,
                                                              fontWeight: FontWeight.w400)),
                                                    ),
                                                  ),
                                                ]) ,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            )
                        )
                    ) ,
                  ],
                )

            ),
          ],
        )
    );
  }
  _pushPageChecklist(BuildContext context, bool isHorizontalNavigation,String typeTravel,dataMap) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => checklist(typeTravel,"",dataMap),
        fullscreenDialog: !isHorizontalNavigation,
      ),
    ).then((value) {});
  }
  PageRoute<T> _buildAdaptivePageRoute<T>({
    required WidgetBuilder builder,
    bool fullscreenDialog = false,
  }) =>
      Platform.isAndroid
          ? MaterialPageRoute(
        builder: builder,
        fullscreenDialog: fullscreenDialog,
      )
          : CupertinoPageRoute(
        builder: builder,
        fullscreenDialog: fullscreenDialog,
      );
  void updateNoti(noti_id,title,_selectDateTime) async{
    DatabaseReference newRef = _db.child('Notification');
    // var TravelTripDayId = itemTravelTripDay[index].travel_trip_day_id ;
    await newRef.child(AppUrl.UserID).child(noti_id.toString()).update({
      'notification_id':noti_id.toString(),
      'title': title,
      'date_trip':DateFormat('yyyy-MM-dd hh:mm').format(_selectDateTime!).toString(),
    }).then((onValue) {
      var p = "";
    });
  }
  void showDailyAtDateTime(DateTime scheduledNotificationDateTime,
      ModelNotification notification, int alertId) async {
    var now = scheduledNotificationDateTime;
    var time = new Time(now.hour, now.minute);
    const int insistentFlag = 4;
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription:'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        // ticker: 'ticker',
        fullScreenIntent: true);
    // additionalFlags: Int32List.fromList(<int>[insistentFlag]));
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      //sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        alertId,
        '${notification.name}',
        "${notification.messageDateTime}",
        now,
        platformChannelSpecifics);
  }

}
class Model {
  const Model(this.country, this.color);

  final String country;
  final Color color;
}
class ModelTravelTripDay {
  late final String travel_trip_day_id;
  late final String title;
  late final String date_trip;
  late final int noti_id;

  ModelTravelTripDay(
      this.travel_trip_day_id,
      this.title,
      this.date_trip,
      this.noti_id);

  ModelTravelTripDay.fromJson(Map<dynamic, dynamic> json) {
    travel_trip_day_id  = json['travel_trip_day_id'];
    title  = json['title'];
    date_trip  = json['date_trip'];
    noti_id  = json['noti_id'];
  }
}