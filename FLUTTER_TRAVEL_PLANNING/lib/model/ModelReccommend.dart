class ModelReccommend {
  var id ;
  var name ;
  late String address;
  var phone_number;
  var website;
  var location;
  var types;
  var distance; 


  ModelReccommend ({
    this.id,
    this.name,
    required this.address,
    this.phone_number,
    this.website,
    this.location,
    this.types,
    this.distance, 
  }); 
  ModelReccommend.fromJson(Map<dynamic, dynamic> json) {
    id  = json['id'];
    name = json['name'];
    address = json['address'];
    phone_number = json['phone_number'];
    website = json['website'];
    location = json['location'];
    types = json['types'];
    distance = json['distance']; 
  }
}
