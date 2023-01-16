import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_travel_planning/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_menu.dart';
import 'global/color.dart';
import 'global/screen.dart';
import 'global/url.dart';

class reset_password extends StatefulWidget {
  var email;
  reset_password(this.email,{Key? key}) : super(key: key);
  @override
  State<reset_password> createState() => _reset_passwordState(this.email);
}
class _reset_passwordState extends State<reset_password> {
  String title = "reset_password";

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  late Query ref;
  late StreamSubscription<DatabaseEvent> _defaultiotSubscription;

  _reset_passwordState(email);

  @override
  void initState() {
    super.initState();
    txtEmail.text = widget.email;
  }
  updatePassword() async {
    DatabaseReference newRef = _db.child('Users');
    await newRef.child(AppUrl.UserID).update({
      'password': txtPassword.text,
    }).then((onValue) {

      new Timer(const Duration(milliseconds: 10), () {
        Navigator.pop(context);
      });
      EasyLoading
          .showSuccess(
        "Reset Password Success",);

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color.fromRGBO(255, 254, 254, 1.0),
          appBar: AppBar(
            title: const Text("Travel Planning",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
            backgroundColor: AppColors.colorMain,
          ),
          body:Center(
            child:  ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 36,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: "SukhumvitSet", ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                                mainAxisAlignment:  MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:110,
                                    margin: EdgeInsets.only(right: 10),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                          children: const <Widget>[
                                            Text("E-mail" ,
                                              style:  TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SukhumvitSet", ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                  // SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0,bottom: 8.0,top: 8.0),
                                        child: Container(
                                          height: 32.0,
                                          child: TextField(
                                            controller: txtEmail,
                                            enabled: false,
                                            autofocus: false,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            decoration: const InputDecoration(
                                              contentPadding:
                                              EdgeInsets.only(left: 14.0, bottom: 2.0, top: 2.0),
                                              filled: true,
                                              fillColor: AppColors.color_bg_grey_text,
                                              hintText: 'E-mail...',
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
                                              disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ) ,
                                  ),
                                ]),
                            const SizedBox(height: 30),
                            Row(
                                mainAxisAlignment:  MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:110,
                                    margin: EdgeInsets.only(right: 10),
                                    child:
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                          children: const <Widget>[
                                            Text("Password" ,
                                                style:  TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "SukhumvitSet", )
                                            ),
                                          ]),
                                    ),
                                  ),
                                  // SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0,bottom: 8.0,top: 8.0),
                                        child: Container(
                                          height: 32.0,
                                          child: TextField(
                                            controller: txtPassword,
                                            autofocus: false,
                                            obscureText: true,
                                            keyboardType: TextInputType.visiblePassword,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            decoration: const InputDecoration(
                                              contentPadding:
                                              EdgeInsets.only(left: 14.0, bottom: 2.0, top: 2.0),
                                              filled: true,
                                              fillColor: AppColors.color_bg_grey_text,
                                              hintText: 'Password...',
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
                                      ),
                                    ) ,
                                  ),
                                ]),
                            const SizedBox(
                              height: 30,
                            ),

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
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancle",
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
                                      onPressed: () {
                                        if(txtEmail.text.toString() != "" && txtPassword.text.toString() != "") {
                                          ref = _db.child("Users")
                                              .orderByChild("email")
                                              .equalTo(
                                              txtEmail.text.toString());
                                          _defaultiotSubscription =
                                              ref.onValue.listen(
                                                    (DatabaseEvent event) {
                                                  setState(() {
                                                    Map<String, dynamic>.from(
                                                        event.snapshot
                                                            .value as dynamic)
                                                        .forEach((key,
                                                        value) async {
                                                          AppUrl.UserID = key;
                                                          updatePassword();
                                                    });
                                                  });
                                                },
                                                onError: (Object o) {
                                                  final error = o as FirebaseException;

                                                },
                                              );
                                        }
                                      },
                                      child: const Text("Reset",
                                          style: TextStyle(fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ]) ,
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

}
class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, 80);
    path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 0);
    path.quadraticBezierTo(size.width - size.width / 4, 0, size.width, 80);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}