import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_travel_planning/global/color.dart';
import 'package:flutter_travel_planning/visited_detail.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'checklist.dart';
import 'global/url.dart';

class travel_visited_thailand extends StatefulWidget {

  final String strTravelIDUpdate;
  travel_visited_thailand(this.strTravelIDUpdate, {Key? key}) : super(key: key);
  @override
  _travel_visited_thailandState createState() => _travel_visited_thailandState(this.strTravelIDUpdate);
}

class _travel_visited_thailandState extends State<travel_visited_thailand> {
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  late List<Model> data;
  late MapShapeSource dataSource;
  late List<ModelTravelWorld> itemTravelWorld = [];

  DatabaseReference _db = FirebaseDatabase.instance.ref();
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(13.7953268, 100.5864872),
    zoom: 0,
  );

  var txtMapAddress = TextEditingController();
  var txtTitle = TextEditingController();
  var counterId = 0;

  _travel_visited_thailandState(strTravelIDUpdate);
  var checkUpdate = false;
  var strTitle = "";
  @override
  void initState() {
    super.initState();
    data = <Model>[
      Model('India', Colors.yellow),
      Model('United States of America', Colors.orange),
      Model('Thailand', Colors.blue),
      Model('Pakistan', Colors.green),
      Model('Australia',   Color.fromRGBO(0, 45, 179, 0.8)),
    ];

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
    loadData();
  }
  void loadData() async{
    primaryFocus!.unfocus(disposition: disposition);
    await FirebaseDatabase.instance.ref()
        .child('Travel_Thailand')
        .child(AppUrl.UserID)
        .orderByChild("travel_thailand_id")
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
                counterId = int.parse(dataTravelWorld.travel_thailand_id);
                itemTravelWorld.add(dataTravelWorld);
              }
            };
          } catch (e) {
            var list = response.value as Map;
            list.forEach((key, value) {
              var dataTravelWorld = ModelTravelWorld.fromJson(value);
              counterId = int.parse(dataTravelWorld.travel_thailand_id);
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
          title: Text("Travel Planning",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
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
            Container(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 300,
                    ),
                    Column(
                      children: [
                        SingleChildScrollView(
                          child: new Container(
                            width: double.maxFinite,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListView(
                                  primary: false,
                                  shrinkWrap: true,
                                  children: [
                                    new  Column(
                                        children: new List<InkWell>.generate(
                                            itemTravelWorld.length,
                                                (int index) {
                                                  var no = index+1;
                                              return widget.strTravelIDUpdate == "" ? InkWell(
                                                onTap: (){
                                                  _pushPageVisitedDetail(context,false,"",itemTravelWorld[index].travel_thailand_id,itemTravelWorld[index].title);
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
                                                          },
                                                          child: const Text("Click",
                                                              style: TextStyle(fontSize: 14,
                                                                  fontWeight: FontWeight.w400)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ) :
                                              widget.strTravelIDUpdate == itemTravelWorld[index].travel_thailand_id ?
                                                  InkWell(
                                                  onTap: (){
                                                    _pushPageVisitedDetail(context,false,"",itemTravelWorld[index].travel_thailand_id,itemTravelWorld[index].title);
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
                                                    ),
                                                  )) :
                                              InkWell();
                                            }
                                        )
                                    ),
                                  ],),

                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 300,
              child: Stack(
                children: [
                  MapPicker(
                    // pass icon widget
                    iconWidget: Image.asset(
                      "images/location_icon.png",
                      height: 30,
                    ),
                    //add map picker controller
                    mapPickerController: mapPickerController,
                    child: GoogleMap(
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      // hide location button
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      //  camera position
                      initialCameraPosition: cameraPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMoveStarted: () {
                        // notify map is moving
                        mapPickerController.mapMoving!();
                        txtMapAddress.text = "checking ...";
                      },
                      onCameraMove: (cameraPosition) {
                        this.cameraPosition = cameraPosition;
                      },
                      onCameraIdle: () async {
                        // notify map stopped moving
                        mapPickerController.mapFinishedMoving!();
                        //get address name from camera position
                        List<Placemark> placemarks = await placemarkFromCoordinates(
                          cameraPosition.target.latitude,
                          cameraPosition.target.longitude,
                        );

                        // update the ui with the address
                        // txtMapAddress.text =
                        // '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                        txtMapAddress.text = '${placemarks.first.country}';
                      },
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).viewPadding.top + 20,
                    width: MediaQuery.of(context).size.width - 50,
                    height: 50,
                    child: TextFormField(
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      readOnly: true,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero, border: InputBorder.none),
                      controller: txtMapAddress,
                    ),
                  ),
                ],
              ),
            ),

          ],
        )
    );
  }
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
class Model {
  const Model(this.country, this.color);

  final String country;
  final Color color;
}
class ModelTravelWorld {

  late final String travel_thailand_id;
  late final String title;
  late final String country;

  ModelTravelWorld(this.travel_thailand_id, this.title,this.country);

  ModelTravelWorld.fromJson(Map<dynamic, dynamic> json) {
    travel_thailand_id  = json['travel_thailand_id'];
    title  = json['title'];
    country  = json['country'];
  }
}
