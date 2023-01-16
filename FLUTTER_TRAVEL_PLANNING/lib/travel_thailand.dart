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
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'checklist.dart';
import 'global/url.dart';

class travel_thailand extends StatefulWidget {

  final String strTravelIDUpdate;
  final String strTravelTitle_Update;
  travel_thailand(this.strTravelIDUpdate,this.strTravelTitle_Update, {Key? key}) : super(key: key);
  @override
  _travel_thailandState createState() => _travel_thailandState(this.strTravelIDUpdate,this.strTravelTitle_Update);
}

class _travel_thailandState extends State<travel_thailand> {
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  late List<Model> dataMap = <Model>[];
  late MapShapeSource dataSource;
  late List<ModelTravelWorld> itemTravelWorld = [];

  DatabaseReference _db = FirebaseDatabase.instance.ref();
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(13.7953268, 100.5864872),
    zoom: 5,
  );

  var txtMapAddress = TextEditingController();
  var txtTitle = TextEditingController();
  var counterId = 0;

  _travel_thailandState(String strTravelIDUpdate, String strTravelTitle_Update);
  var checkUpdate = false;
  var strTitle = "";
  @override
  void initState() {
    super.initState();
    // data = <Model>[
    //   Model('India', Colors.yellow),
    //   Model('United States of America', Colors.orange),
    //   Model('Thailand', Colors.blue),
    //   Model('Pakistan', Colors.green),
    //   Model('Australia',   Color.fromRGBO(0, 45, 179, 0.8)),
    // ];
    //
    // dataSource = MapShapeSource.asset(
    //   "assets/world_map.json",
    //   shapeDataField: "name",
    //   dataCount: data.length,
    //   primaryValueMapper: (int index) => data[index].country,
    //   shapeColorValueMapper: (int index) => data[index].color,
    //   shapeColorMappers: [
    //     MapColorMapper(color: Colors.red),
    //     MapColorMapper(from: 101, to: 300, color: Colors.green)
    //   ],
    // );
    if(widget.strTravelTitle_Update != ""){
      txtTitle.text = widget.strTravelTitle_Update.toString();
      loadDataById();
    }else{
      loadData();
    }
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
                if(dataTravelWorld.type == "th") {
                  itemTravelWorld.add(dataTravelWorld);
                }
                var m = Model(dataTravelWorld.country, Colors.blue);
                dataMap.add(m);
              }
            };
          } catch (e) {
            var list = response.value as Map;
            list.forEach((key, value) {
              var dataTravelWorld = ModelTravelWorld.fromJson(value);
              counterId = int.parse(dataTravelWorld.travel_world_id);
              if(dataTravelWorld.type == "th") {
                itemTravelWorld.add(dataTravelWorld);
              }
              var m = Model(dataTravelWorld.country, Colors.blue);
              dataMap.add(m);
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
  void loadDataById() async{
    primaryFocus!.unfocus(disposition: disposition);
    await FirebaseDatabase.instance.ref()
        .child('Travel_World')
        .child(AppUrl.UserID)
        .orderByChild("travel_world_id")
        .equalTo(widget.strTravelIDUpdate)
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
                if(dataTravelWorld.type == "gb") {
                  itemTravelWorld.add(dataTravelWorld);
                }
              }
            };
          } catch (e) {
            var list = response.value as Map;
            list.forEach((key, value) {
              var dataTravelWorld = ModelTravelWorld.fromJson(value);
              counterId = int.parse(dataTravelWorld.travel_world_id);
              if(dataTravelWorld.type == "gb") {
                itemTravelWorld.add(dataTravelWorld);
              }
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
          title: Text(widget.strTravelIDUpdate != "" ? "Edit Travel Thailand" : "Travel Thailand",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
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
                        Container(
                          child:Row(
                            children: [
                              Flexible(child:  Text(
                                widget.strTravelIDUpdate != "" ? 'Edit Title' : 'Title',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                              ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: txtTitle,
                          decoration: InputDecoration(
                            hintText: widget.strTravelIDUpdate != "" ?  "Enter Edit Title" :  "Enter Title",
                          ),
                        ),
                        Container(
                          child: Container(
                            margin: EdgeInsets.only(top:20),
                            child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
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
                                        if(widget.strTravelIDUpdate == "") {
                                          if (txtTitle.text != "") {
                                            DatabaseReference newRef = _db.child('Travel_World');
                                            var travelWorldId = "";
                                            counterId == 0
                                                ? travelWorldId = (counterId + 1).toString()
                                                : travelWorldId = counterId.toString();
                                            await newRef.child(AppUrl.UserID + "/" + travelWorldId).set({
                                              'travel_world_id': travelWorldId,
                                              'title': txtTitle.text,
                                              'country': txtMapAddress.text,
                                              'type': "th",
                                            }).then((onValue) {
                                              setState(() {
                                                txtTitle.text = "";
                                                EasyLoading.showSuccess("Add Success",);
                                                loadData();
                                              });
                                              return true;
                                            }).catchError((onError) {
                                              return false;
                                            });
                                          }
                                        }else{
                                          DatabaseReference newRef = _db.child('Travel_World');
                                          await newRef.child(AppUrl.UserID + "/" + widget.strTravelIDUpdate)..update({
                                            'travel_world_id': widget.strTravelIDUpdate,
                                            'title': txtTitle.text,
                                            'country': txtMapAddress.text,
                                            'type': "th",
                                          }).then((onValue) {
                                            setState(() {
                                              txtTitle.text = "";
                                              EasyLoading.showSuccess("Update Success",);
                                              loadData();
                                              travel_thailand("","");
                                            });
                                            return true;
                                          }).catchError((onError) {
                                            return false;
                                          });

                                        }
                                      },
                                      child: Text(widget.strTravelIDUpdate != "" ? "Update information" : "Add information" ,
                                          style: TextStyle(fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ),
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
                                    child: const Text("Cancel",
                                        style: TextStyle(fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ]),

                          ),
                        ),

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
                                                  _pushPageChecklist(context,false,"th",itemTravelWorld[index].travel_world_id,dataMap);
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
                                                            _pushPageTravel(context,true,itemTravelWorld[index].travel_world_id,itemTravelWorld[index].title);
                                                          },
                                                          child: const Text("Edit",
                                                              style: TextStyle(fontSize: 14,
                                                                  fontWeight: FontWeight.w400)),
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
                                                              desc: "Do you want to delete the ${itemTravelWorld[index].title} ? ",
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
                                                                      _db.child('Travel_World').child(
                                                                          AppUrl.UserID)
                                                                          .child('${itemTravelWorld[index].travel_world_id}')
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
                                                          child: const Text("Delete",
                                                              style: TextStyle(fontSize: 14,
                                                                  fontWeight: FontWeight.w400)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ) :
                                              widget.strTravelIDUpdate == itemTravelWorld[index].travel_world_id ?
                                              InkWell(
                                                  onTap: (){
                                                    _pushPageChecklist(context,false,"th",itemTravelWorld[index].travel_world_id,dataMap);
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
  _pushPageTravel(BuildContext context, bool isHorizontalNavigation, String travel_world_id, String title) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => travel_thailand(travel_world_id,title),
        fullscreenDialog: !isHorizontalNavigation,
      ),
    ).then((value) {
      setState(() {
        loadData();
      });
    });
  }
}
_pushPageChecklist(BuildContext context, bool isHorizontalNavigation,String typeTravel, String travelWorldId,   dataMap) {
  Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
    _buildAdaptivePageRoute(
      builder: (context) => checklist(typeTravel,travelWorldId,dataMap),
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

  late final String travel_world_id;
  late final String title;
  late final String country;
  late final String type;

  ModelTravelWorld(this.travel_world_id, this.title,this.country,this.type);

  ModelTravelWorld.fromJson(Map<dynamic, dynamic> json) {
    travel_world_id  = json['travel_world_id'];
    title  = json['title'];
    country  = json['country'];
    type  = json['type'];
  }
}