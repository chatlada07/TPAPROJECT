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

class search_reccommend extends StatefulWidget {
  const search_reccommend({Key? key}) : super(key: key);
  @override
  State<search_reccommend> createState() => _search_reccommendState();
}

class _search_reccommendState extends State<search_reccommend> with InputValidationMixin{

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
  }

  Future<dynamic> FindPlaceByText(strSearch) async {
    if(strSearch != "") {
      AppLoader.show();
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(
          "https://trueway-places.p.rapidapi.com/FindPlaceByText?text=${strSearch}&language=en"));
      request.headers.set('X-RapidAPI-Key',
          'beb2a52503msh60cc67b5cc227fdp10b693jsn65bca9151d69');
      request.headers.set("X-RapidAPI-Host", "trueway-places.p.rapidapi.com");
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      try {
        var jsonResponse = json.decode(reply);
        List<dynamic> results = jsonResponse["results"];
        if(results.length >0) {
          for (var i = 0; i < results.length; i++) {
            var modelsearch_reccommend = ModelReccommend.fromJson(results[i]);
            setState(() {
              listModelReccommend.add(modelsearch_reccommend);
            });
            if (i == results.length - 1) {
              AppLoader.hide();
            }
          };
        }else{
          AppLoader.hide();
        }
      } catch (e) {
        e.toString();
      }
    }else{
      setState(() {
        listModelReccommend.clear();
      });
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  'Search place',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "SukhumvitSet", ),
                ), 
            Container(
              padding: EdgeInsets.all(20),
              child:   TextField(
                  onChanged: (v){
                    FindPlaceByText(v);
                  },
                  controller: txtName,
                  autofocus: false,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    contentPadding:
                    EdgeInsets.only(left: 14.0, bottom: 2.0, top: 2.0),
                    filled: true,
                    fillColor: AppColors.color_white,
                    hintText: 'Search..',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
            ),
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
                                              padding: EdgeInsets.all(10),
                                              height: 150.0,
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
                            fontWeight: FontWeight.bold),),
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