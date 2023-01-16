import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'bottom_menu.dart';
import 'global/color.dart';
import 'global/url.dart';
import 'model/profile_model.dart';

class registor extends StatefulWidget {
  const registor({Key? key}) : super(key: key);
  @override
  State<registor> createState() => _registorState();
}

class _registorState extends State<registor> with InputValidationMixin{

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


  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  String? selectedGender = "Male";
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder:(context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(appBar: AppBar(title: const Text("Error"),),
              body: Center(child: Text("${snapshot.error}"),),);
          }
          if (snapshot.connectionState == ConnectionState.done) {
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
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Register',
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
                                          width:120,
                                          margin: EdgeInsets.only(right: 10),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                                children: const <Widget>[
                                                  Text("Name" ,
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
                                                  controller: txtName,
                                                  autofocus: false,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  keyboardType: TextInputType.text,
                                                  decoration: const InputDecoration(
                                                    contentPadding:
                                                    EdgeInsets.only(left: 14.0, bottom: 2.0, top: 2.0),
                                                    filled: true,
                                                    fillColor: AppColors.color_bg_grey_text,
                                                    hintText: 'Name...',
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
                                  const SizedBox(height: 2),
                                  Row(
                                      mainAxisAlignment:  MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width:120,
                                          margin: const EdgeInsets.only(right: 10),
                                          child:
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                                children: const <Widget>[
                                                  Text("Last name" ,
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
                                                  controller: txtLastName,
                                                  autofocus: false,
                                                  keyboardType: TextInputType.text,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  decoration: const InputDecoration(
                                                    contentPadding:
                                                    EdgeInsets.only(left: 14.0, bottom: 2.0, top: 2.0),
                                                    filled: true,
                                                    fillColor: AppColors.color_bg_grey_text,
                                                    hintText: 'Last name...',
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
                                    height: 2,
                                  ),
                                  Row(
                                      mainAxisAlignment:  MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width:120,
                                          margin: EdgeInsets.only(right: 10),
                                          child:
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                                children: const <Widget>[
                                                  Text("Date of birth" ,
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
                                                  controller: txtDateOfBirth,
                                                  autofocus: false,
                                                  keyboardType: TextInputType.text,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  decoration: const InputDecoration(
                                                    contentPadding:
                                                    EdgeInsets.only(left: 14.0, bottom: 2.0, top: 2.0),
                                                    filled: true,
                                                    fillColor: AppColors.color_bg_grey_text,
                                                    hintText: 'Date of birth...',
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
                                                  readOnly: true,  //set it true, so that user will not able to edit text
                                                  onTap: () async {
                                                    DateTime? pickedDate = await showDatePicker(
                                                        context: context, initialDate: DateTime.now(),
                                                        firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                                                        lastDate: DateTime(2101)
                                                    );
                                                    if(pickedDate != null ){
                                                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                                      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                                                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                                      //you can implement different kind of Date Format here according to your requirement

                                                      setState(() {
                                                        txtDateOfBirth.text = formattedDate; //set output date to TextField value.
                                                      });
                                                    }else{
                                                      print("Date is not selected");
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ) ,
                                        ),
                                      ]),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                      mainAxisAlignment:  MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width:120,
                                          margin: EdgeInsets.only(right: 10),
                                          child:
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                                children: const <Widget>[
                                                  Text("Gender" ,
                                                      style:  TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "SukhumvitSet", )
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child:
                                          // Container(
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.only(left: 8.0,bottom: 8.0,top: 8.0),
                                          //     child: Container(
                                          //       height: 32.0,
                                          //       child: TextField(
                                          //         controller: txtGender,
                                          //         autofocus: false,
                                          //         keyboardType: TextInputType.text,
                                          //         style: const TextStyle(
                                          //           color: Colors.black,
                                          //         ),
                                          //         decoration: const InputDecoration(
                                          //           contentPadding:
                                          //           EdgeInsets.only(left: 14.0, bottom: 2.0, top: 2.0),
                                          //           filled: true,
                                          //           fillColor: AppColors.color_bg_grey_text,
                                          //           hintText: 'Gender...',
                                          //           hintStyle: TextStyle(color: Colors.grey),
                                          //           border: OutlineInputBorder(
                                          //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          //           ),
                                          //           enabledBorder: OutlineInputBorder(
                                          //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          //             borderSide: BorderSide(color: Colors.black, width: 1),
                                          //           ),
                                          //           focusedBorder: OutlineInputBorder(
                                          //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          //             borderSide: BorderSide(color: Colors.black),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ) ,
                                          DropdownButtonFormField2(
                                            decoration: InputDecoration(
                                              //Add isDense true and zero Padding.
                                              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(0.5),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                borderSide: BorderSide(color: Colors.white, width: 1),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                borderSide: BorderSide(color: Colors.white, width: 1),
                                              ),
                                              //Add more decoration as you want here
                                              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                            ),
                                            buttonDecoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1
                                              ),
                                              color: AppColors.color_bg_grey_text,
                                            ),
                                            isExpanded: true,
                                            hint: const Text(
                                              'Select Your Gender',
                                              style: TextStyle(fontSize: 14,color: Colors.grey),
                                            ),
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black45,
                                            ),
                                            iconSize: 20,
                                            buttonHeight: 32,
                                            buttonPadding: const EdgeInsets.only(left: 10, right: 10),
                                            dropdownDecoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            items: genderItems
                                                .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                                .toList(),
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Please select gender.';
                                              }
                                            },
                                            onChanged: (value) {
                                              selectedGender = value.toString();
                                            },
                                            onSaved: (value) {
                                              selectedGender = value.toString();
                                            },
                                          ),

                                        ),
                                      ]),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                      mainAxisAlignment:  MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width:120,
                                          margin: EdgeInsets.only(right: 10),
                                          child:
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                                children: const <Widget>[
                                                  Text("Phone number" ,
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
                                                  controller: txtPhoneNumber,
                                                  autofocus: false,
                                                  keyboardType: TextInputType.phone,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  maxLength: 10,
                                                  decoration: const InputDecoration(
                                                    counterText: "",
                                                    contentPadding:
                                                    EdgeInsets.only(left: 14.0, bottom: 2.0, top: 2.0),
                                                    filled: true,
                                                    fillColor: AppColors.color_bg_grey_text,
                                                    hintText: 'Phone number...',
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
                                    height: 2,
                                  ),
                                  Row(
                                      mainAxisAlignment:  MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width:120,
                                          margin: EdgeInsets.only(right: 10),
                                          child:
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                                children: const <Widget>[
                                                  Text("E-mail" ,
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
                                                  controller: txtEmail,
                                                  autofocus: false,
                                                  keyboardType: TextInputType.emailAddress,
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
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ) ,
                                        ),
                                      ]),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                      mainAxisAlignment:  MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width:120,
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
                                                  keyboardType: TextInputType.text,
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
                                    height: 2,
                                  ),
                                  Row(
                                      mainAxisAlignment:  MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width:120,
                                          margin: EdgeInsets.only(right: 10),
                                          child:
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                                children: const <Widget>[
                                                  Text("Address" ,
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
                                                  controller: txtAddress,
                                                  autofocus: false,
                                                  keyboardType: TextInputType.text,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  decoration: const InputDecoration(
                                                    contentPadding:
                                                    EdgeInsets.only(left: 14.0, bottom: 2.0, top: 2.0),
                                                    filled: true,
                                                    fillColor: AppColors.color_bg_grey_text,
                                                    hintText: 'Address...',
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

                                  const SizedBox(height: 30),
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
                                            onPressed: () async {
                                              // if (formKey.currentState!.validate()) {
                                              //   formKey.currentState!.save();
                                              if(txtName == "" || txtLastName.text =="" || txtDateOfBirth.text =="" || selectedGender == "" || txtPhoneNumber.text == "" || txtEmail.text == "" || txtPassword == "" || txtAddress.text == "") {
                                                EasyLoading.showError(
                                                  "Please fill the information in the blank.",);
                                              }else {
                                                if(!isEmailValid(txtEmail.text)){
                                                  EasyLoading.showError(
                                                    "Invalid Email",);
                                                }else {
                                                  AppUrl.UserID = uuid;
                                                  saveUserId();
                                                  DatabaseReference newRef = _db
                                                      .child('Users');
                                                  await newRef.child(uuid).set({
                                                    'user_id': '${uuid}',
                                                    'name': '${txtName.text}',
                                                    'lastname': '${txtLastName
                                                        .text}',
                                                    'date_of_birth': '${txtDateOfBirth
                                                        .text}',
                                                    'gender': '${selectedGender}',
                                                    'email': '${txtEmail.text}',
                                                    'phone_number': '${txtPhoneNumber.text}',
                                                    'password': '${txtPassword
                                                        .text}',
                                                    'address': '${txtAddress
                                                        .text}',
                                                  }).then((onValue) {
                                                    EasyLoading.showSuccess(
                                                      "Register Success",);
                                                    AppUrl.Username = txtName.text;
                                                    Navigator.pop(
                                                        context); //การกลับหน้านั้นหรือ ปิด
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              bottom_menu(
                                                                currentIndex: 0,)),
                                                    );
                                                    return true;
                                                  }).catchError((onError) {
                                                    return false;
                                                  });
                                                }
                                              }
                                            },
                                            child: const Text("Register",
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
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel",
                                                style: TextStyle(fontSize: 14,
                                                    fontWeight: FontWeight.w400)),
                                          ),
                                        ),
                                      ]) ,
                                  const SizedBox(
                                    height: 2,
                                  ),
                                ],
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

          return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              )
          );
        }
    );

  }
  Future<void> saveUserId() async {
    SharedPreferences prefsLogin = await SharedPreferences.getInstance();
    prefsLogin.setString('user_id',AppUrl.UserID);
  }

  final _formKey = GlobalKey<FormState>();

  _buildDropdownGender() {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Enter Your Full Name.',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField2(
                decoration: InputDecoration(
                  //Add isDense true and zero Padding.
                  //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  //Add more decoration as you want here
                  //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                ),
                isExpanded: true,
                hint: const Text(
                  'Select Your Gender',
                  style: TextStyle(fontSize: 14),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 30,
                buttonHeight: 60,
                buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                items: genderItems
                    .map((item) =>
                    DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select gender.';
                  }
                },
                onChanged: (value) {
                  selectedGender = value.toString();
                },
                onSaved: (value) {
                  selectedGender = value.toString();
                },
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                child: const Text('Submit Button'),
              ),
            ],
          ),
        ),
      ),
    );
  }
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