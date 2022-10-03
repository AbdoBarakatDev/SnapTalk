class NotificationDataModel {
  String ?to;
  NotificationData? notificationData;
  NotificationDetails? notificationDetails;
  PhoneProperties? phoneProperties;
  PhoneNotificationsProperties? phoneNotificationsProperties;


  NotificationDataModel.fromJson(Map<String, dynamic>? json) {
    to = json!['to'];
    notificationData = json['notification'] !=null? NotificationData.fromJson(json['notification']) : null;
    notificationDetails = json['data'] !=null? NotificationDetails.fromJson(json['data']) : null;
    phoneProperties = json['android'] !=null? PhoneProperties.fromJson(json['android']) : null;
  }
}

class NotificationData {
  String? body;
  String? title;
  String? sound;
  NotificationData.fromJson(Map<String, dynamic>? json) {
    body = json!['body'];
    title = json['title'];
    sound = json['sound'];
  }
}
class NotificationDetails {
  String? id;
  int? type;
  String? clickAction;
  NotificationDetails.fromJson(Map<String, dynamic>? json) {
    id = json!['id'];
    type = json['type'];
    clickAction = json['click_action'];
  }
}
class PhoneProperties {
  String? priority;
  PhoneNotificationsProperties ?properties;
  PhoneProperties.fromJson(Map<String, dynamic>? json) {
    priority = json!['priority'];
    properties = json['properties'] !=null? PhoneNotificationsProperties.fromJson(json['properties']) : null;
  }
}
class PhoneNotificationsProperties {
  int? notificationPriority;
  String? sound;
  bool? defaultSound;
  bool? defaultVibrateTimings;
  bool ?defaultLightSettings;

  PhoneNotificationsProperties.fromJson(Map<String, dynamic>? json) {
    notificationPriority = json!['notification_priority'];
    sound = json['sound'];
    defaultSound = json['default_sound'];
    defaultVibrateTimings = json['default_vibrate_timings'];
    defaultLightSettings = json['default_light_settings'];
  }
}
