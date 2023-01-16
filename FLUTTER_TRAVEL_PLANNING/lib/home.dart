import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_travel_planning/global/color.dart';
import 'package:flutter_travel_planning/profile.dart';
import 'package:flutter_travel_planning/reccommend.dart';
import 'package:flutter_travel_planning/travel_plans.dart';
import 'package:flutter_travel_planning/travel_visited.dart';
import 'package:flutter_travel_planning/travel_world.dart';
import 'package:flutter_travel_planning/travel_visited_world.dart';
import 'package:flutter_travel_planning/type_travel.dart';
import 'package:flutter_travel_planning/type_travel_visited.dart';

import 'manage_account.dart';

class home extends StatefulWidget {
  static const routeName = '/home';
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  List<String> titleList = [
    'Travel plans',
    'Visited',
    'Manage account',
    'Reccommend'
  ];

  var pdfPrivacyPolicy = 'assets/pdf/privacypolicy.pdf';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body:
        Container(
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: "SukhumvitSet", ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0))),
                      child: GridView.builder(
                          itemCount: titleList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                if(index==2){
                                  _pushPageProfile(context,false);
                                }else if(index==1){
                                  _pushPageVisited(context,false);
                                }else if(index==0){
                                  _pushPageTravelPlaning(context,false);
                                }else if(index==3){
                                  _pushPageReccommend(context,false);
                                }
                              },
                              child:
                              Container(alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                            color: AppColors.color_bg_grey_text,
                            borderRadius: BorderRadius.all(Radius.circular(25))),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Text(titleList[index],style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,),
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
  _pushPageTravelPlaning(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => travel_plans(),
        fullscreenDialog: !isHorizontalNavigation,
      ),
    ).then((value) {});
  }
  _pushPageReccommend(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => reccommend(),
        fullscreenDialog: !isHorizontalNavigation,
      ),
    ).then((value) {});
  }
  // _pushPageTravelPlaning(BuildContext context, bool isHorizontalNavigation) {
  //   Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
  //     _buildAdaptivePageRoute(
  //       builder: (context) => type_travel(),
  //       fullscreenDialog: !isHorizontalNavigation,
  //     ),
  //   ).then((value) {});
  // }
  _pushPageVisited(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => travel_visited(""),
        fullscreenDialog: !isHorizontalNavigation,
      ),
    ).then((value) {});
  }
  _pushPageProfile(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => manage_account(),
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
