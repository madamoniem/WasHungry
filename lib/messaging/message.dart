import 'package:firebase_auth/firebase_auth.dart';
import 'package:washungrystable/userdashboard.dart' as user_dashboard;

class Message {
  final String text;
  final String uid;
  final String name;
  final DateTime date;

  Message(this.text, this.date, this.name, this.uid);

  Message.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        text = json['text'] as String,
        uid = json['uid'] as String,
        name = json['name'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date.toString(),
        'text': text,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'name': user_dashboard.firstName + ' ' + user_dashboard.lastName
      };
}
