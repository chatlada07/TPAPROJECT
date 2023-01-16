import 'package:flutter/widgets.dart';

class ModelNotificationDB {
  var notification_id ;
  var title ;
  var date_trip ;

  ModelNotificationDB (
      { this.notification_id,
         this.title,
         this.date_trip,   });
 
  ModelNotificationDB.fromJson(Map<dynamic, dynamic> json) {
    notification_id  = json['notification_id'];
    title  = json['title'];
    date_trip  = json['date_trip'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['notification_id'] = this.notification_id;
    data['title'] = this.title;
    data['date_trip'] = this.date_trip;

    return data;
  }
}
