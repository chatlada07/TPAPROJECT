import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_travel_planning/travel_detail.dart';
import 'package:flutter_travel_planning/travel_world.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'bottom_menu.dart';
import 'global/color.dart';
import 'global/url.dart';
import 'home.dart';

class checklist extends StatefulWidget {
  final _typeTravel;
  final _travelId;
  final  dataMap;
  const checklist(this._typeTravel,this._travelId, this.dataMap, {Key? key,}) : super(key: key);
  @override
  State<checklist> createState() => _checklistState(this._typeTravel,this._travelId, this.dataMap);
}

class _checklistState extends State<checklist> {
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  bool checkBoxIdCard =false;
  bool checkBoxHouseRegistration =false;
  bool checkBoxAccountBookNumber =false;
  bool checkBoxPassports =false;
  bool checkBoxVisa =false;
  bool checkBoxBrushTeeth =false;
  bool checkBoxToothpaste =false;
  bool checkBoxSoap =false;
  bool checkBoxTowel =false;
  ModelCheckList? modelCheckList;
  _checklistState(typeTravel, travelId,   dataMap);

  List<bool> listCheckBoxEct = [];
  var typeTravel = "";
  var counterId = 0;
  var counterIdAdd = 0;
  late List<ModelEtc> itemEtc = [];
  DatabaseReference _db = FirebaseDatabase.instance.ref();
  var txtEtc = TextEditingController();
  var txtEtcEdit = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadData();
    loadCheckBox();
  }

  void loadData() async{
    primaryFocus!.unfocus(disposition: disposition);
    await FirebaseDatabase.instance.ref()
        .child('Etc')
        .child(AppUrl.UserID).child('${widget._travelId}')
        .orderByChild("etc_id")
        .once()
        .then((event) {
      try {
        var response = event.snapshot;
        try {
          itemEtc.clear();
          List<Object?> list = List<Object?>.from(response.value as dynamic);
          for (var i = 0; i < list.length; i++) {
            if (list[i] != null) {
              var lii = list[i] as Map;
                  Map<dynamic, dynamic> value = lii as Map;
                  var dataEtc = ModelEtc.fromJson(value);
                  counterId = int.parse(dataEtc.etc_id);
                  itemEtc.add(dataEtc);
                  listCheckBoxEct.add(dataEtc.checked);
                  counterIdAdd +=1;

            }
          };
        } catch (e) {
          var list = response.value as Map;
          list.forEach((key, value) {
            var dataEtc = ModelEtc.fromJson(value);
            counterId = int.parse(dataEtc.etc_id);
            itemEtc.add(dataEtc);
            listCheckBoxEct.add(dataEtc.checked);
            counterIdAdd +=1;
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

  void loadCheckBox() async{
    await FirebaseDatabase.instance.ref()
        .child('Check_List')
        .child(AppUrl.UserID).child('${widget._travelId}')
        .once()
        .then((event) {
      try {
        var response = event.snapshot;
        try {
          List<Object?> list = List<Object?>.from(response.value as dynamic);
          for (var i = 0; i < list.length; i++) {
            if (list[i] != null) {
              Map<dynamic, dynamic> value = list[i] as Map;
              modelCheckList = ModelCheckList.fromJson(value);
            }
          };
        } catch (e) {
          var value = response.value as Map;
          modelCheckList = ModelCheckList.fromJson(value);
        };
      } catch (e) {
        e.toString();
      }

      setState(()  {
        checkBoxIdCard = modelCheckList!.checkBoxIdCard;
        checkBoxHouseRegistration =  modelCheckList!.checkBoxHouseRegistration;
        checkBoxAccountBookNumber =  modelCheckList!.checkBoxAccountBookNumber;
        checkBoxPassports =  modelCheckList!.checkBoxPassports;
        checkBoxVisa =  modelCheckList!.checkBoxVisa;
        checkBoxBrushTeeth =  modelCheckList!.checkBoxBrushTeeth;
        checkBoxToothpaste =  modelCheckList!.checkBoxToothpaste;
        checkBoxSoap =  modelCheckList!.checkBoxSoap;
        checkBoxTowel =  modelCheckList!.checkBoxTowel;
      });
    });
  }

  Future<void> saveCheckBox() async {
      DatabaseReference newRef = _db.child('Check_List');
       await newRef.child(AppUrl.UserID).child('${widget._travelId}').set({
         'id_card': checkBoxIdCard,
         'house_registration': checkBoxHouseRegistration,
         'account_book_number': checkBoxAccountBookNumber,
         'passports': checkBoxPassports,
         'visa': checkBoxVisa,
         'brush_teeth': checkBoxBrushTeeth,
         'toothpaste': checkBoxToothpaste,
         'soap': checkBoxSoap,
         'towel': checkBoxTowel,
         'type': widget._typeTravel,
      }).then((onValue) {
        return true;
      }).catchError((onError) {
        return false;
      });
    }
  Future<void> saveCheckBoxEtc(EtcIdEdit,checked) async {
    DatabaseReference newRef = _db.child('Etc');
    await newRef.child(AppUrl.UserID).child('${widget._travelId}').child(EtcIdEdit).update({
      'checked': checked,
    }).then((onValue) {
      setState(() {
        // EasyLoading.showSuccess("Edit Success",);
      });
      return true;
    }).catchError((onError) {
      return false;
    });
  }
  @override
  Widget build(BuildContext context) {

    bool? isChecked =false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Travel Planning",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.colorMain,
        leadingWidth: 70,
        leading:IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: () {
            saveCheckBox().then((value){
              Navigator.pop(context);
            });
          },
        ),
      ),
      body:Container(
          child: Stack(
              children: <Widget>[ ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 10),
                              const Text(
                                'Checklist',
                                style: TextStyle(
                                  fontSize: 36,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "SukhumvitSet", ),
                              ),
                              const SizedBox(height: 20),
                              Container(alignment: Alignment.topCenter,
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1,color: Colors.black),
                                    color: AppColors.color_white,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          widget._typeTravel != "th" ?
                                          Column(
                                            children: [
                                              Container(
                                                child:Row(
                                                  children: [
                                                    Flexible(child:  Text(
                                                      'Personal documents',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                                                    ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                    children: [
                                                      Container(
                                                        height: 25,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text: 'ID card',
                                                                  style: const TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Checkbox(
                                                              value: checkBoxIdCard,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  checkBoxIdCard = value!;
                                                                });
                                                              },
                                                            ), //Checkbox
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 25,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text: 'House registration',
                                                                  style: const TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Checkbox(
                                                              value: checkBoxHouseRegistration,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  checkBoxHouseRegistration = value!;
                                                                });
                                                              },
                                                            ), //Checkbox
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 25,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text: 'Account book number',
                                                                  style: const TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Checkbox(
                                                              value: checkBoxAccountBookNumber,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  checkBoxAccountBookNumber = value!;
                                                                });
                                                              },
                                                            ), //Checkbox
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 25,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text: 'Passports',
                                                                  style: const TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Checkbox(
                                                              value: checkBoxPassports,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  checkBoxPassports = value!;
                                                                });
                                                              },
                                                            ), //Checkbox
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 25,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text: 'Visa',
                                                                  style: const TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Checkbox(
                                                              value: checkBoxVisa,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  checkBoxVisa = value!;
                                                                });
                                                              },
                                                            ), //Checkbox
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ],
                                          ):
                                          Column(
                                            children: [
                                              Container(
                                                child:Row(
                                                  children: [
                                                    Flexible(child:  Text(
                                                      'Personal items',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                                                    ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                    children: [
                                                      Container(
                                                        height: 25,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text: 'Brush teeth',
                                                                  style: const TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Checkbox(
                                                              value: checkBoxBrushTeeth,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  checkBoxBrushTeeth = value!;
                                                                });
                                                              },
                                                            ), //Checkbox
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 25,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text: 'Toothpaste',
                                                                  style: const TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Checkbox(
                                                              value: checkBoxToothpaste,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  checkBoxToothpaste = value!;
                                                                });
                                                              },
                                                            ), //Checkbox
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 25,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text: 'Soap',
                                                                  style: const TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Checkbox(
                                                              value: checkBoxSoap,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  checkBoxSoap = value!;
                                                                });
                                                              },
                                                            ), //Checkbox
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 25,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: RichText(
                                                                text: const TextSpan(
                                                                  text: 'Towel',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Checkbox(
                                                              value: checkBoxTowel,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  checkBoxTowel = value!;
                                                                });
                                                              },
                                                            ), //Checkbox
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                child:Row(
                                                  children: [
                                                    Flexible(child:  Text(
                                                      'add etc.',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                                                    ),
                                                    ),
                                                    Icon(Icons.add_circle_outline_outlined,color: Colors.black, ),
                                                  ],
                                                ),
                                              ),
                                              TextField(
                                                controller: txtEtc ,
                                                decoration: InputDecoration(
                                                  hintText: "Enter Etc",
                                                ),
                                              ),

                                              Container(
                                                child: Container(
                                                  margin: EdgeInsets.only(top:20),
                                                  child: Row(
                                                      mainAxisAlignment:  MainAxisAlignment.end,
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
                                                                if(txtEtc.text != ""){
                                                                  listCheckBoxEct.add(false);
                                                                  DatabaseReference newRef = _db.child('Etc');
                                                                  var EtcId = "";
                                                                  counterId == 0 ? EtcId = (counterId +1).toString() : EtcId = counterId.toString();
                                                                  await newRef.child(AppUrl.UserID).child('${widget._travelId}').child(EtcId).set({
                                                                    'etc_id':EtcId,
                                                                    'title': txtEtc.text,
                                                                    'checked': listCheckBoxEct[counterIdAdd],
                                                                  }).then((onValue) {
                                                                    setState(() {
                                                                      txtEtc.text = "";
                                                                      EasyLoading.showSuccess("Add Success",);
                                                                      loadData();
                                                                    });
                                                                    return true;
                                                                  }).catchError((onError) {
                                                                    return false;
                                                                  });
                                                                }
                                                              },
                                                              child: const Text("Add Etc",
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
                                                            txtEtc.text = "";
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
                                                                  itemEtc.length,
                                                                      (int index) {
                                                                    var no = index+1;
                                                                    return InkWell(
                                                                      onTap: (){
                                                                      },
                                                                      child: Container(
                                                                        margin: EdgeInsets.only(top: 5.0),
                                                                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                                                        decoration: BoxDecoration(
                                                                            color: Color.fromRGBO(236, 235, 241, 1),
                                                                            borderRadius: BorderRadius.circular(8.0)),
                                                                        child:ListTile(
                                                                          title: Text(
                                                                            "$no . ${itemEtc[index].title}",
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontFamily: 'SukhumvitSet-Medium'),
                                                                          ),
                                                                          trailing: Wrap(
                                                                            spacing: 12, // space between two icons
                                                                            children: <Widget>[
                                                                              Checkbox(
                                                                                value: listCheckBoxEct[index],
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    listCheckBoxEct[index] = value!;
                                                                                    saveCheckBoxEtc(itemEtc[index].etc_id,value!);
                                                                                  });
                                                                                },
                                                                              ), //Check
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

                                                                                  txtEtcEdit.text = itemEtc[index].title;
                                                                                  Alert(
                                                                                    context: context,
                                                                                      content: Container(
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: <Widget>[
                                                                                            Column(
                                                                                              children: [
                                                                                                Container(
                                                                                                  child:Row(
                                                                                                    children: [
                                                                                                      Checkbox(
                                                                                                        value: checkBoxIdCard,
                                                                                                        onChanged: (value) {
                                                                                                          setState(() {
                                                                                                            checkBoxIdCard = value!;
                                                                                                          });
                                                                                                        },
                                                                                                      ), //Checkbox
                                                                                                      Flexible(child:  Text(
                                                                                                        'Edit etc.',
                                                                                                        textAlign: TextAlign.left,
                                                                                                        style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                                                                                                      ),
                                                                                                      ),
                                                                                                      Icon(Icons.add_circle_outline_outlined,color: Colors.black, ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                                TextField(
                                                                                                  controller: txtEtcEdit ,
                                                                                                  decoration: InputDecoration(
                                                                                                    hintText: "Enter Edit Etc",
                                                                                                  ),
                                                                                                ),
                                                                                  ]),
                                                                                  ])),

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
                                                                                          "Update",
                                                                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        onPressed: () async{
                                                                                            DatabaseReference newRef = _db.child('Etc');
                                                                                            var EtcIdEdit = itemEtc[index].etc_id;
                                                                                            await newRef.child(AppUrl.UserID).child('${widget._travelId}').child(EtcIdEdit).update({
                                                                                              'etc_id':EtcIdEdit,
                                                                                              'title': txtEtcEdit.text,
                                                                                              'checked': listCheckBoxEct[index],
                                                                                            }).then((onValue) {
                                                                                              setState(() {
                                                                                                Alert(context: context).dismiss();
                                                                                                txtEtcEdit.text = "";
                                                                                                EasyLoading.showSuccess("Edit Success",);
                                                                                                loadData();
                                                                                              });
                                                                                              return true;
                                                                                            }).catchError((onError) {
                                                                                              return false;
                                                                                            });
                                                                                        },
                                                                                        radius: BorderRadius.circular(25.0),
                                                                                        color: Colors.green,
                                                                                      )
                                                                                    ],
                                                                                  ).show();

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
                                                                                    desc: "Do you want to delete the ${itemEtc[index].title} ? ",
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
                                                                                            _db.child('Etc').child(
                                                                                                AppUrl.UserID).child('${widget._travelId}')
                                                                                                .child('${itemEtc[index].etc_id}')
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
                                                                    );
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
                                    )
                                ),
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
                                          saveCheckBox().then((value){
                                            _pushPageTravelDetail(context,false,widget._travelId,widget.dataMap);
                                          });
                                        },
                                        child: const Text("Next",
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
              ]
          )
      ),
    );
  }
  _pushPageTravelDetail(BuildContext context, bool isHorizontalNavigation, travelId, dataMap ) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => travel_detail(travelId,dataMap),
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
class ModelEtc {
  late final String etc_id;
  late final String title;
  late final bool checked;

  ModelEtc(this.etc_id, this.title);

  ModelEtc.fromJson(Map<dynamic, dynamic> json) {
    etc_id  = json['etc_id'];
    title  = json['title'];
    checked  = json['checked'];
  }
}
class ModelCheckList {
  late final bool checkBoxIdCard;
  late final bool checkBoxHouseRegistration;
  late final bool checkBoxAccountBookNumber;
  late final bool checkBoxPassports;
  late final bool checkBoxVisa;
  late final bool checkBoxBrushTeeth;
  late final bool checkBoxToothpaste;
  late final bool checkBoxSoap;
  late final bool checkBoxTowel;

  ModelCheckList(
      this.checkBoxIdCard,
      this.checkBoxHouseRegistration,
      this.checkBoxAccountBookNumber,
      this.checkBoxPassports,
      this.checkBoxVisa,
      this.checkBoxBrushTeeth,
      this.checkBoxToothpaste,
      this.checkBoxSoap,
      this.checkBoxTowel,);

  ModelCheckList.fromJson(Map<dynamic, dynamic> json) {
    checkBoxIdCard = json['id_card'];
    checkBoxHouseRegistration = json['house_registration'];
    checkBoxAccountBookNumber = json['account_book_number'];
    checkBoxPassports = json['passports'];
    checkBoxVisa = json['visa'];
    checkBoxBrushTeeth = json['brush_teeth'];
    checkBoxToothpaste = json['toothpaste'];
    checkBoxSoap = json['soap'];
    checkBoxTowel = json['towel'];
  }
}
class Model {
  const Model(this.country, this.color);

  final String country;
  final Color color;
}