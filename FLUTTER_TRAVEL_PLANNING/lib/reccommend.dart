import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_travel_planning/global/loader.dart';
import 'package:flutter_travel_planning/search_reccommend.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'bottom_menu.dart';
import 'global/color.dart';
import 'global/url.dart';
import 'model/ModelReccommend.dart';
import 'model/profile_model.dart';

import 'package:http/http.dart' as http;

class reccommend extends StatefulWidget {
  const reccommend({Key? key}) : super(key: key);
  @override
  State<reccommend> createState() => _reccommendState();
}

class _reccommendState extends State<reccommend> with InputValidationMixin{

  TextEditingController txtName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtDateOfBirth = TextEditingController();
  TextEditingController txtGender = TextEditingController();
  TextEditingController txtPhoneNumber = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtAddress = TextEditingController();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  Profile_model profile = Profile_model(username: "", email: "", number: "", password: "", cpassword:  "", name:"");

  var uuid = const Uuid().v4();
  // late ModelReccommend modelReccommend = ModelReccommend();
  late List<ModelReccommend> listModelReccommend = [];
  void initState() {
    super.initState();
    _getCurrentPosition();
  }
  _getCurrentPosition() async{
    var position = await Geolocator.getCurrentPosition( desiredAccuracy: LocationAccuracy.best);

    FindPlacesNearby(position.latitude,position.longitude);
  }

   Future<dynamic> FindPlacesNearby(double latitude,double longitude) async {
    AppLoader.show();
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse("https://trueway-places.p.rapidapi.com/FindPlacesNearby?location=${latitude}%2C${longitude}&type=cafe&radius=1000&language=en"));
    request.headers.set('X-RapidAPI-Key', 'beb2a52503msh60cc67b5cc227fdp10b693jsn65bca9151d69');
    request.headers.set("X-RapidAPI-Host", "trueway-places.p.rapidapi.com");
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    try{
      var jsonResponse = json.decode(reply);
      List<dynamic> results = jsonResponse["results"];
      for(var i =0;i<results.length;i++){
        var modelReccommend = ModelReccommend.fromJson(results[i]);
        setState(() {
          listModelReccommend.add(modelReccommend);
        });
        if(i == results.length-1){
          AppLoader.hide();
        }
      };
    }catch(e){
      e.toString();
    }

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(227, 226, 243, 1),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Recommended place',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: "SukhumvitSet", ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      _pushPageSearch(context,false);
                    },
                    child: Container(
                        width: 150,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 20,top: 20,right: 20),
                        decoration: BoxDecoration(
                            color: AppColors.color_bg_grey_text,
                            border: Border.all(color: Colors.black,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Text("Search",style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.right,),
                        )
                    ),
                  ),
                  ]),
                  Container(
                    padding: EdgeInsets.all(20),
                    child:   listModelReccommend.length > 0 ?
                    ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: listModelReccommend.length,
                        itemBuilder: (BuildContext context, int index) {
                          return  Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child:
                            GestureDetector(
                              onTap: () {
                              },
                              child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child:Column(
                                    children: [
                                      Card(
                                          color: AppColors.color_white,
                                          semanticContainer: true,
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          elevation: 5,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 150.0,
                                                padding: EdgeInsets.all(10),
                                                child: Ink.image(
                                                  image: AssetImage("images/ic_restaurant.png"),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),

                                            ],
                                          )),
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            border: Border.all(color: Colors.black, width: 1),
                                          ),
                                          child:  Column(
                                            children: [
                                              Text(listModelReccommend[index].name,
                                                style: GoogleFonts.kanit(
                                                    fontSize: 18,
                                                    color: AppColors.color_black,fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,),
                                              Text(listModelReccommend[index].address,
                                                style: GoogleFonts.kanit(
                                                  fontSize: 16,
                                                  color: AppColors.color_black, ),
                                                textAlign: TextAlign.left,),
                                            ],
                                          )
                                      ),
                                    ],
                                  )

                              ),
                            ),
                          );
                        })
                        : Visibility(
                      visible: listModelReccommend.length == 0 ? true : false,
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        child: new Text("ไม่มีรายการ",
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                              fontWeight: FontWeight.bold),)
                      ),
                    ),
                  )

                ],
              ),
          ),
        )
      ),
    );
  }
  _pushPageSearch(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => search_reccommend(),
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
}

mixin InputValidationMixin {
  bool isPasswordValid(String password) => password.length >= 6;

  bool isPhoneValid(String phone) {
    Pattern pattern =  r'^(0[689]{1})+([0-9]{8})+$' ;
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(phone);

  }
  bool isEmailValid(String email) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(email);
  }
}