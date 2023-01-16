import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'firstlogin.dart';
import 'global/url.dart';
import 'model/profile_model.dart';

// final databaseReference = FirebaseDatabase.instance;
final DatabaseReference db = FirebaseDatabase.instance.ref();
// late DatabaseReference _db;

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}
class _profileState extends State<profile> {
  late Profile_model profile_model = Profile_model(username: "", email: "", number: "", password: "", name: "", cpassword: "");
  var txt1 = TextEditingController();
  var txt2 = TextEditingController();
  var txt3 = TextEditingController();
  var txt4 = TextEditingController();
  //var txt5 = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late File file = File("");
  late String img64;

  late SharedPreferences prefsProfile;
  late String urlimages =  "";

  getDatafromDatabase() async {
    Map<dynamic, dynamic> json = {};
    db.child('Users').child(AppUrl.UserID).once().then((result) async  {
      var response = result.snapshot;
      Map<dynamic, dynamic> values = response.value as Map;
      json = values;
        setState(() {
          profile_model = Profile_model.fromJson(json);
          txt1.text = profile_model.name;
          txt2.text = profile_model.number;
          txt3.text = profile_model.username;
          txt4.text = profile_model.password;
        });

    });
  }

  _downloadAndSavePhoto() async {
    // Get file from internet
    String  strtime =DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    var response = await get(Uri.parse(urlimages));
    // documentDirectory is the unique device path to the area you'll be saving in
    if(response.statusCode == 200){
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + "/ImgProfile";
      //You'll have to manually create subdirectories
      await Directory(firstPath).create(recursive: true);
      // Name the file, create the file, and save in byte form.
      var filePathAndName = documentDirectory.path + '/ImgProfile/' + AppUrl.UserID + strtime+ '.jpg';
      File fileTemp = new File(filePathAndName);
      fileTemp.writeAsBytesSync(response.bodyBytes);
      setState(() {
        // When the data is available, display it
        file = fileTemp;
      });
    }
  }
  void initState(){
    super.initState();
    // _db = FirebaseDatabase(
    //     databaseURL: AppUrl.Firebase_Database_URL
    // ).ref();

    getDatafromDatabase();
    setPrefsProfile();
  }
  Future<void> setPrefsProfile() async {
    prefsProfile = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    double sc_width = MediaQuery.of(context).size.width;
    double sc_height = MediaQuery.of(context).size.height;
    double font_size = sc_height * 0.01;

    return new Scaffold(
        backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
        body: SingleChildScrollView(
          child :  Column(
              children: [
                Container(
                  child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipPath(
                            clipper: OvalBottomBorderClipper(),
                            child: Container(
                              height: 220,
                              decoration: BoxDecoration(color: Color.fromRGBO(77, 141, 110, 1.0)),
                              child:   Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top:20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget> [
                                      InkWell(
                                        splashColor: Color.fromRGBO(
                                            231, 231, 231, 1.0),
                                             onTap: () => {
                                               //เพิ่ม function ถ่ายรูปและอัพโหลดรูปภาพ
                                            },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(color: Colors.white, width: 5),
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: ClipOval(
                                               child:  file.path == "" ? Image.asset("images/icon9.png") :  Image.file(file,width: 100, height: 100,fit: BoxFit.cover)
                                          ),
                                          //   child: IconButton(
                                          //     icon: file.path == "" ? Image.asset("images/icon9.png") :  Image.file(file),
                                          //     iconSize: 100,
                                          //     onPressed: () => {
                                          //       _openPopupUploadImg(context)
                                          //       //เพิ่ม function ถ่ายรูปและอัพโหลดรูปภาพ
                                          //     },
                                          //   )
                                        ),
                                      ),

                                      SizedBox(height: 5,),
                                      Text(txt1.text, style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                                      ),
                                    ]
                                ) ,
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
                Center(
                    child: SingleChildScrollView(
                      child : Container(
                        margin:EdgeInsets.all(20),
                        padding: EdgeInsets.all(10),
                        decoration:  const BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius:BorderRadius.all(Radius.circular(25))
                        ),
                        child :Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              color: Colors.transparent,
                              child:  Container(
                                  decoration:  const BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 0),
                                      borderRadius:BorderRadius.all(Radius.circular(20))
                                  ),
                                  child:  Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,

                                      children : <Widget> [
                                        ListTile(
                                          title: Text("ชื่อ"),
                                          subtitle: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                            child: TextFormField(
                                              controller: txt1,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter a search term',
                                              ),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("เบอร์โทรศัพท์"),
                                          subtitle: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                            child: TextFormField(
                                              keyboardType: TextInputType.phone,
                                              maxLength: 10,
                                              controller: txt2,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter a search term',
                                                counterText: '',
                                              ),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("Username"),
                                          subtitle: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                            child: TextFormField(
                                              controller: txt3,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter a search term',
                                              ),
                                            ),
                                          ),
                                        ),
                                        ListTile(

                                          title: Text("รหัสผ่าน"),
                                          subtitle:  Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                            child: TextFormField(
                                              controller: txt4,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter a search term',
                                              ),
                                            ),
                                          ),
                                        ),


                                        // SizedBox(height: 10,),
                                        // Spacer(),
                                        Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                                            child :
                                            SizedBox(
                                              height: 40,
                                              width: sc_width - 200,
                                              child:  ElevatedButton(
                                                style: ElevatedButton.styleFrom(primary: Color.fromRGBO(77, 141, 110, 1.0)),
                                                onPressed: () async {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(builder: (context) => supposedly()),
                                                  // )
                                                  if (formKey.currentState!.validate()) {
                                                    formKey.currentState!.save();
                                                    var bCheck = false;
                                                    // if(profile_model.username != txt3.text.toString()) {
                                                    //   bCheck =false;
                                                    // }
                                                    if(!bCheck){
                                                      DatabaseReference newRef = db.child('Users');
                                                      await newRef.child(AppUrl.UserID).set({
                                                        'user_id':'${AppUrl.UserID}',
                                                        'username': '${txt3.text}',
                                                        'phone': '${txt2.text}',
                                                        'name': '${txt1.text}',
                                                        'password': '${txt4.text}',
                                                      }).then((onValue) {
                                                        print(
                                                            "username = ${txt3.text} phone = ${txt2.text} name = ${txt1.text} password = ${txt4.text}");
                                                        // formKey.currentState!.reset();
                                                        EasyLoading.showSuccess(
                                                          "บันทึกเสร็จสิ้น",);
                                                        return true;
                                                      }).catchError((onError) {
                                                        return false;
                                                      });
                                                    }
                                                  }

                                                },
                                                child: Container(
                                                  child: Text('บันทึก',
                                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                                ),
                                              ),
                                            ),
                                          ) ,
                                        Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                            child :
                                            SizedBox(
                                              height: 40,
                                              width: sc_width - 200,
                                              child:  ElevatedButton(
                                                style: ElevatedButton.styleFrom(primary: Color.fromRGBO(
                                                    205, 0, 0, 1.0)),
                                                onPressed: (){
                                                  prefsProfile.setString('user_id',"");
                                                  AppUrl.UserID ="";
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => firstlogin()),
                                                  );
                                                },
                                                child: Container(
                                                  child: Text('ออกจากระบบ',
                                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                                ),
                                              ),
                                            )
                                        ),
                                      ],

                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),)),

              ]

          ),
        ));
  }

}
class OvalBottomBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 4.5, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(
        size.width - size.width / 4.5, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}
