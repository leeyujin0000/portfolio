import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/services/notification_services.dart';
import 'package:laundry/services/server_domain.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String email;
  String? pw;
  String name;
  String sex;
  List<String> ban;

  User(
    this.email,
    this.pw,
    this.name,
    this.sex,
    this.ban
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
      json["user"]["email"],
      json["user"]["pw"],
      json["user"]["name"],
      json["user"]["sex"],
      List<String>.from(json["ban"])
  );
}

class UserServices with ChangeNotifier {

  User user = User('', '', '', '', []);

  String genderText(String gender) {
    String text = '';
    switch (gender) {
      case 'm': text = '남'; break;
      case 'f': text = '여'; break;
      default: text = 'null'; break;
    }
    return text;
  }

  Future<bool> sendCode(String email) async {
    String url = '${Server().domain}user/send-email-code?email=$email';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkCode(String email, String code) async {
    String url = '${Server().domain}user/check-email-code';
    Map<String, dynamic> body = {
      "email": email,
      "code": code
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getUserInfo(String email) async {
    String url = '${Server().domain}user/user-info?email=$email';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      User result = User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      user = result;
      print(user.ban.toString());
      notifyListeners();
    } else {
      print('getUserInfoFailed');
    }
  }

  Future<bool> updateUserInfo(String email, String pw, String name) async {
    String url = '${Server().domain}user/update';
    Map<String, dynamic> body = {
      "email": email,
      "pw": pw,
      "name": name
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      await getUserInfo(email);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendChangedPW(String email) async {
    String url = '${Server().domain}user/send-changedPW?email=$email';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changeUserPW(String email, String nowPW, String newPW) async {
    String url = '${Server().domain}user/change-pw';
    Map<String, dynamic> body = {
      "email": email,
      "nowPW": nowPW,
      "newPW": newPW,
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      print('dsfs');
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUser(String email, String pw) async {
    String url = '${Server().domain}user/delete';
    Map<String, dynamic> body = {
      "email": email,
      "pw": pw,
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.delete(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      await NotificationServices().deleteToken(email);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userEmail');
      user = User('', '', '', '', []);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logIn(String email, String pw) async {
    String url = '${Server().domain}user/login';
    Map<String, dynamic> body = {
      "email": email,
      "pw": pw
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);
      await getUserInfo(email);
      return true;
    } else {
      return false;
    }
  }

  Future<void> logOut(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    user = User('', '', '', '', []);
  }

  Future<bool> signUp(String email, String pw, String name, String sex) async {
    String url = '${Server().domain}user/sign-up';
    Map<String, dynamic> body = {
      "email": email,
      "pw": pw,
      "sex": sex,
      "name": name,
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      await NotificationServices().saveToken(email);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> blockUser(String userEmail, String partnerEmail) async {
    String url = '${Server().domain}ban/insert?myEmail=$userEmail&targetEmail=$partnerEmail';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await getUserInfo(userEmail);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unblockUser(String userEmail, String partnerEmail) async {
    String url = '${Server().domain}ban/delete?myEmail=$userEmail&targetEmail=$partnerEmail';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await getUserInfo(userEmail);
      return true;
    } else {
      return false;
    }
  }
}