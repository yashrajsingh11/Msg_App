import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:messageplus/model/d.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:http/http.dart' as http;

class Message extends ChangeNotifier {
  Message() {
    getMessages();
  }

  bool load = true;
  List<SmsMessage> messages = [];
  List<Prediction> finalmessage = [];

  ///
  SmsQuery query = SmsQuery();

  void addMessage(Map<String, dynamic> map) async {
    try {
      await http.post(
        Uri.parse('http://10.0.2.2:4000/add'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode({"data": map}),
      );
    } catch (E) {
      return;
    }
  }

  Future<void> getMessages() async {
    finalmessage.clear();
    List<String> messageString = [];
    messages = await query.getAllSms;
    for (var mess in messages) {
      messageString.add(mess.body.toString());
    }
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:4000/api'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode({"data": messageString}),
      );
      List<Prediction> _predict =
          ModelPredict.fromJson(json.decode(response.body)).prediction;
      for (int i = 0; i < _predict.length; i++) {
        Prediction p = Prediction(
          result: _predict[i].result,
          url: _predict[i].url,
          dateTime: messages[i].date,
          sendername: messages[i].sender,
        );
        finalmessage.add(p);
      }
      load = false;
      notifyListeners();
    } catch (E) {
      load = false;
      notifyListeners();
    }
  }
}
