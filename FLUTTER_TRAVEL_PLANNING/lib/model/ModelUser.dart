class ModelUser {
  var user_id ;
  var name ;
  var address;
  var phone_number;
  var date_of_birth;
  var email;
  var gender;
  var lastname;
  var password;


  ModelUser ({
    this.user_id,
    this.name,
    this.address,
    this.phone_number,
    this.date_of_birth,
    this.email,
    this.gender,
    this.lastname,
    this.password,
  }); 
  ModelUser.fromJson(Map<dynamic, dynamic> json) {
    user_id  = json['user_id'];
    name = json['name'];
    address = json['address'];
    phone_number = json['phone_number'];
    date_of_birth = json['date_of_birth'];
    email = json['email'];
    gender = json['gender'];
    lastname = json['lastname'];
    password = json['password'];
  }
}
