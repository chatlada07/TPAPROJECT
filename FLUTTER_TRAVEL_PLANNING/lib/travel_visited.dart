import 'dart:async';
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
import 'package:flutter_travel_planning/visited_detail.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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

class travel_visited extends StatefulWidget {
  final _travelId;
  const travel_visited(this._travelId, {Key? key,}) : super(key: key);
  @override
  _travel_visitedState createState() => _travel_visitedState(this._travelId );
}

class _travel_visitedState extends State<travel_visited> {
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  late List<Model> data = <Model>[];
  late MapShapeSource  dataSource;
  late List<ModelTravelWorld> itemTravelWorld = [];

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

  _travel_visitedState(travelId);

  @override
  void initState() {

    data = <Model>[
      Model('Thailand', Colors.blue),
      // Model('United States of America', Colors.orange),
      // Model('Thailand', Colors.blue),
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
    loadData();
    loadDataMap().then((value){
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
    });
    _getCurrentPosition();
    super.initState();
  }
  _getCurrentPosition() async{
    // await till you get actual Position
    var position = await Geolocator.getCurrentPosition( desiredAccuracy: LocationAccuracy.best);
      cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 0,
      );
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

  void loadData() async{
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
          try {
            itemTravelWorld.clear();
            List<Object?> list = List<Object?>.from(response.value as dynamic);
            for (var i = 0; i < list.length; i++) {
              if (list[i] != null) {
                Map<dynamic, dynamic> value = list[i] as Map;
                var dataTravelWorld = ModelTravelWorld.fromJson(value);
                counterId = int.parse(dataTravelWorld.travel_world_id);
                itemTravelWorld.add(dataTravelWorld);
              }
            };
          } catch (e) {
            var list = response.value as Map;
            list.forEach((key, value) {
              var dataTravelWorld = ModelTravelWorld.fromJson(value);
              counterId = int.parse(dataTravelWorld.travel_world_id);
              itemTravelWorld.add(dataTravelWorld);
            });
          };
          setState(() {
            counterId += 1;
          });
        }
      } catch (e) {
        e.toString();
      }
    });
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
        backgroundColor: AppColors.color_white,
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
                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                    child:
                      ListView(
                        primary: false,
                        shrinkWrap: true,
                        children: [
                          new  Column(
                              children: new List<InkWell>.generate(
                                  itemTravelWorld.length,
                                      (int index) {
                                    var no = index+1;
                                    return
                                      InkWell(
                                      onTap: (){
                                        _pushPageVisitedDetail(context,false,"",itemTravelWorld[index].travel_world_id,itemTravelWorld[index].title);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 5.0),
                                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(236, 235, 241, 1),
                                            borderRadius: BorderRadius.circular(8.0)),
                                        child:ListTile(
                                          title: Text(
                                            "$no . ${itemTravelWorld[index].title}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'SukhumvitSet-Medium'),
                                          ),
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
                                                  _pushPageVisitedDetail(context,false,"",itemTravelWorld[index].travel_world_id,itemTravelWorld[index].title);
                                                },
                                                child: const Text("Click",
                                                    style: TextStyle(fontSize: 14,
                                                        fontWeight: FontWeight.w400)),
                                              ),
                                            ],
                                          ),
                                        ),
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
            ],
          ),
        ),
      ),

    );
  }
  _pushPageVisitedDetail(BuildContext context, bool isHorizontalNavigation,String typeTravel, String travelWorldId, String title) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => visited_detail(typeTravel,travelWorldId,title),
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
