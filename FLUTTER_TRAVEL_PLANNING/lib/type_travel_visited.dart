import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_travel_planning/global/color.dart';
import 'package:flutter_travel_planning/travel_thailand.dart';
import 'package:flutter_travel_planning/travel_visited_thailand.dart';
import 'package:flutter_travel_planning/travel_visited_world.dart';
import 'package:flutter_travel_planning/travel_world.dart';

import 'checklist.dart';

class type_travel_visited extends StatefulWidget {
  static const routeName = '/home';
  @override
  _type_travel_visitedState createState() => _type_travel_visitedState();
}

class _type_travel_visitedState extends State<type_travel_visited> {
  List<String> titleList = [
    'Travel Aboard',
    'Travel in Thailand',
  ];

  var pdfPrivacyPolicy = 'assets/pdf/privacypolicy.pdf';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
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
        body:
        Container(
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Visited',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: "SukhumvitSet", ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0))),
                      child: ListView.builder(
                          itemCount: titleList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                _pushPageTravel(context,false,index == 0 ? "" : "th");
                                // _pushPageChecklist(context,false,index == 0 ? "" : "th");
                              },
                              child:
                              Container(alignment: Alignment.center,
                              padding: EdgeInsets.only(top:50,bottom:50),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                            color: AppColors.color_bg_grey_text,
                            ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Text(titleList[index],style: TextStyle(fontSize: 18),),
                                      )
                              )
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  _pushPageTravel(BuildContext context, bool isHorizontalNavigation,String typeTravel) {
    if(typeTravel == "th"){
      Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
        _buildAdaptivePageRoute(
          builder: (context) => travel_visited_thailand(""),
          fullscreenDialog: !isHorizontalNavigation,
        ),
      ).then((value) {});
    }else{
      Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
        _buildAdaptivePageRoute(
          builder: (context) => travel_visited_world(""),
          fullscreenDialog: !isHorizontalNavigation,
        ),
      ).then((value) {});
    }
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
