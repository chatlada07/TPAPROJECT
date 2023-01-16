import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:flutter_travel_planning/global/color.dart';
import 'package:flutter_travel_planning/travel_thailand.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_picker/map_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'checklist.dart';
import 'global/url.dart';
import 'main.dart';
import 'model/ModelNotification.dart';

class travel_detail extends StatefulWidget {
  final _travelId;
  final  dataMap;
  const travel_detail(this._travelId, this.dataMap, {Key? key,}) : super(key: key);
  @override
  _travel_detailState createState() => _travel_detailState(this._travelId,this.dataMap);
}

class _travel_detailState extends State<travel_detail> {
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  late List<Model> data = <Model>[];
  late MapShapeSource  dataSource;
  late List<ModelTravelTripDay> itemTravelTripDay = [];

  // final _controller = Completer<GoogleMapController>();
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

  _travel_detailState(travelId,  dataMap);

  @override
  void initState() {

    super.initState();
    data = <Model>[
      // Model('AngThong', Colors.yellow),
      // Model('United States of America', Colors.orange),
      Model('Thailand', Colors.blue),
      // Model('Pakistan', Colors.green),
      // Model('Australia',   Color.fromRGBO(0, 45, 179, 0.8)),
    ];


setState(() {
  dataSource = MapShapeSource.asset(
    "assets/world_map.json",
    shapeDataField: "name",
    dataCount: data.length,
    primaryValueMapper: (int index) => data[index].country,
    shapeColorValueMapper: (int index) => data[index].color,
    shapeColorMappers: [
      MapColorMapper(color: Colors.red),
    ],
  );
});
    // dataSource = MapShapeSource.asset(
    //   "assets/thailand_map.json",
    //   shapeDataField: "name",
    //   dataCount: data.length,
    //   primaryValueMapper: (int index) =>data[index].country,
    //   shapeColorValueMapper: (int index) => data[index].color,
    //   dataLabelMapper: (int index) => data[index].country,
    //   shapeColorMappers: [
    //     MapColorMapper(color: Colors.red),
    //   ],
    // );

    loadData();
    loadDataMap().then((value){
      setState(() {
        dataSource = MapShapeSource.asset(
          "assets/world_map.json",
          shapeDataField: "name",
          dataCount: widget.dataMap.length,
          primaryValueMapper: (int index) => widget.dataMap[index].country,
          shapeColorValueMapper: (int index) => widget.dataMap[index].color,
          shapeColorMappers: [
            MapColorMapper(color: Colors.red),
          ],
        );
      });
    });
  }

  Future<void> loadDataMap() async{
    // data.clear();
    primaryFocus!.unfocus(disposition: disposition);
    await FirebaseDatabase.instance.ref()
        .child('Travel_World')
        .child(AppUrl.UserID)
        .orderByChild("travel_world_id")
        .once()
        .then((event) {
      try {
        var response = event.snapshot;
        if(response.value != null) {
          data.clear();
          try {
            List<Object?> list = List<Object?>.from(response.value as dynamic);
            for (var i = 0; i < list.length; i++) {
              if (list[i] != null) {
                Map<dynamic, dynamic> value = list[i] as Map;
                var dataTravelWorld = ModelTravelWorld.fromJson(value);
                var m = Model(dataTravelWorld.country, Colors.blue);
                data.add(m);
              }
            };
          } catch (e) {
            var list = response.value as Map;
            list.forEach((key, value) {
              var dataTravelWorld = ModelTravelWorld.fromJson(value);
              var m = Model(dataTravelWorld.country, Colors.blue);
              data.add(m);
            });
          };
        }
      } catch (e) {
        e.toString();
      }
    });
    // return data;
  }
  void saveNoti(noti_id,title,_selectDateTime) async{
    DatabaseReference newRef = _db.child('Notification');
    // var TravelTripDayId = itemTravelTripDay[index].travel_trip_day_id ;
    await newRef.child(AppUrl.UserID).child(noti_id.toString()).set({
      'notification_id':noti_id.toString(),
      'title': title,
      'date_trip':DateFormat('yyyy-MM-dd hh:mm').format(_selectDateTime!).toString(),
    }).then((onValue) {
        var p = "";
    });
  }
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
      } catch (e) {
        e.toString();
      }
    });
  }
  void _showDatePicker(ctx) {
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
                        _chosenDateTime = val!;
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
          title: const Text("Travel Planning",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.colorMain,
          leadingWidth: 70,
          leading:IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:  Scaffold(
          backgroundColor: AppColors.color_bg,
          body: Container(
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                            color: Colors.white,
                            height: 350,
                            child: SfMaps(
                              layers: [
                                MapShapeLayer(
                                  source: dataSource,
                                ),
                              ],
                            )
                        ),

                        Container(
                          margin: EdgeInsets.all(20),
                          decoration:  BoxDecoration(
                              border: Border.all(width: 1,color: Colors.black),
                              color: AppColors.color_white,
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Container(
                                    child:Row(
                                      children: [
                                        Flexible(child:  Text(
                                          'Location',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.roboto(fontSize: 16.0, ),
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        Flexible(child:  Text(
                                          'Day trip',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.roboto(fontSize: 16.0, ),
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        Flexible(child:  Text(
                                          'Details',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.roboto(fontSize: 16.0, ),
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextField(
                                    controller: txtTitle,
                                    minLines: 1,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Title',
                                      hintStyle: GoogleFonts.roboto(
                                          color: Colors.grey
                                      ),
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
                                        _chosenDateTime = DateTime.now();
                                        _showDatePicker(context);
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
                                        child: Text(_chosenDateTime != null
                                            ? DateFormat('yyyy-MM-dd hh:mm').format(_chosenDateTime!).toString()
                                            : 'ระบุวันทีเวลาเดินทาง',style: GoogleFonts.kanit(
                                            fontSize: 16
                                        ),
                                          textAlign: TextAlign.center,),
                                      ),


                                    ),
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
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
                                          onPressed: () async {
                                            if(txtTitle.text != "" && _chosenDateTime != null){
                                              Random random = Random();
                                              noti_id = random.nextInt(100000);
                                              DatabaseReference newRef = _db.child('Travel_Trip_Day');
                                              counterId == 0 ? TravelTripDayId =  counterId +1  : TravelTripDayId = counterId ;
                                              await newRef.child(AppUrl.UserID).child('${widget._travelId}').child(TravelTripDayId.toString()).set({
                                                'travel_trip_day_id':TravelTripDayId.toString(),
                                                'title':  txtTitle.text,
                                                'date_trip':DateFormat('yyyy-MM-dd hh:mm:ss').format(_chosenDateTime!).toString(),
                                                'noti_id':noti_id
                                              }).then((onValue) {
                                                setState(() {
                                                  var strDateList;
                                                  var  timeMessage = DateFormat('hh:mm').format(_chosenDateTime!).toString();
                                                  strDateList = _chosenDateTime!.day.toString() +
                                                      "/" +
                                                      _chosenDateTime!.month.toString() +
                                                      "/" +
                                                      (_chosenDateTime!.year).toString();
                                                  var strNameTitle = "Date : "+strDateList +"  time : " + timeMessage ;
                                                  var notification = ModelNotification(
                                                      messageDateTime:strNameTitle,
                                                      dateTime: DateTime(
                                                          _chosenDateTime!.year,
                                                          _chosenDateTime!.month,
                                                          _chosenDateTime!.day,
                                                          _chosenDateTime!.hour,
                                                          _chosenDateTime!.minute),
                                                      name: "Travel alert : ${txtTitle.text}");

                                                  showDailyAtDateTime(notification.dateTime,
                                                      notification,noti_id);
                                                  saveNoti(noti_id,txtTitle.text,_chosenDateTime);
                                                  txtTitle.text = "";
                                                  _chosenDateTime = null;
                                                  EasyLoading.showSuccess("Add Success",);
                                                  loadData();
                                                });
                                                return true;
                                              }).catchError((onError) {
                                                return false;
                                              });
                                            }
                                          },
                                          child:   Text("Add information",
                                              style: GoogleFonts.roboto(fontSize: 14 )),
                                        ),
                                        SizedBox(
                                          width: 20,
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
                                          },
                                          child:   Text("Cancel",
                                              style: GoogleFonts.roboto(fontSize: 14,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ]),
                                ],
                              )


                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          child:
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
                            ],),
                        ),
                      ],
                    ),
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
                                                              'title': txtTitleEdit.text,
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
            ),
          ),
        ), 

    );
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

  String checkMonthShort(int month) {
    var monthString = "";
    switch (month) {
      case 1:
        monthString = "ม.ค.";
        break;
      case 2:
        monthString = "ก.พ.";
        break;
      case 3:
        monthString = "มี.ค.";
        break;
      case 4:
        monthString = "เม.ย";
        break;
      case 5:
        monthString = "พ.ค.";
        break;
      case 6:
        monthString = "มิ.ย.";
        break;
      case 7:
        monthString = "ก.ค.";
        break;
      case 8:
        monthString = "ส.ค.";
        break;
      case 9:
        monthString = "ก.ย.";
        break;
      case 10:
        monthString = "ต.ค.";
        break;
      case 11:
        monthString = "พ.ย.";
        break;
      case 12:
        monthString = "ธ.ค.";
        break;
    }
    return monthString;
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
