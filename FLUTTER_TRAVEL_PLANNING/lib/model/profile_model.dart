class Profile_model{

  String username = "" ;
  String email = "" ;
  String number = "" ;
  String password = "" ;
  String name = "";
  String cpassword = "";

  Profile_model({ required this.username,required this.email,required this.number,required this.password,required this.name,required this.cpassword});

  Profile_model.fromJson(Map<dynamic, dynamic> json):
        username = json['username'] as String,
  //email = json['text'] as String,
        number = json['phone'] as String,
        password = json['password'] as String,
        name = json['name'] as String;


  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{
        'username' : username.toString(),
        // 'text' : email.toString(),
        'phone' : number.toString(),
        'password' : password.toString(),
        'name' : name.toString()
      };

}



// class Message {
//   final String text;
//   final DateTime date;
//
//   Message(this.text, this.date);
//
//
//   Message.fromJson(Map<dynamic, dynamic> json)
//       : date = DateTime.parse(json['date'] as String),
//         text = json['text'] as String;
//
//   Map<dynamic, dynamic> toJson() =>
//       <dynamic, dynamic>{
//         'date': date.toString(),
//         'text': text,
//
//
//       };
// }