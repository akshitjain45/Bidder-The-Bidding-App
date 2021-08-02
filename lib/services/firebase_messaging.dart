import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class FirebaseMessage {
  final String _serverToken =
      "AAAAHQAhLMw:APA91bHrIEmh2flaEBFbm6vloue1C7r8mmK9W9_i40_01ihT7wQjwySi9mQFL4IA8r5Iq_eIIqK_FLA0d6SEQO_cV6EPzk_zp2TTGZA84cS4_t-xzh57ZzNR1hZ9VUjO3_qs3lGywbS-";

  Future<String?> getToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  static init({BuildContext? context}) async {}

  self() async {
    final token = await getToken();
    final res = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          "notification": <String, dynamic>{"body": 'test', "title": 'note'},
          "priority": "high",
          "data": <String, dynamic>{
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "id": "1",
            "status": "done",
            "sound": "default"
          },
          "to": token
        },
      ),
    );
    print(res.body);
  }

  sendAndRetrieveMessage(String? token, String? title, String? body,
      {Map<String, dynamic>? data}) async {
    data = data ?? <String, dynamic>{};
    data["click_action"] = "FLUTTER_NOTIFICATION_CLICK";
    data["id"] = "1";
    data["status"] = "done";
    data["sound"] = "default";
    print(data);
    final res = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          "notification": <String, dynamic>{"body": body, "title": title},
          "priority": "high",
          "data": data,
          "to": token
        },
      ),
    );
    print(res.body);
  }
}
