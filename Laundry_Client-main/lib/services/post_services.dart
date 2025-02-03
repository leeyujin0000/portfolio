import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/services/server_domain.dart';

class Post {
  String id;
  String laundryId;
  String laundryName;
  String email;
  String gender;
  List<String> colorTypes;
  String weight;
  List<String> machineTypes;
  String extraInfoType;
  String message;
  String date;
  bool matched;

  Post({
    required this.id,
    required this.laundryId,
    required this.laundryName,
    required this.email,
    required this.gender,
    required this.colorTypes,
    required this.weight,
    required this.machineTypes,
    required this.extraInfoType,
    required this.message,
    required this.date,
    required this.matched
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      id: json["_id"],
      laundryId: json["laundryId"],
      laundryName: json["laundryName"],
      email: json["email"],
      gender: json["gender"],
      colorTypes: List<String>.from(json["colorTypes"]),
      weight: json["weight"],
      machineTypes: List<String>.from(json["machineTypes"]),
      extraInfoType: json["extraInfoType"],
      message: json["message"],
      date: json["date"],
      matched: json["matched"]
  );
}

class PostServices with ChangeNotifier {

  List<Post> laundryPosts = [];
  List<Post> myPosts = [];
  Post matchedPost = Post(
      id: '', laundryId: '', laundryName: '',
      email: '', gender: '',
      colorTypes: [], weight: '', machineTypes: [], extraInfoType: '',
      message: '', date: '', matched: true
  );

  String colorTypesText(List<String> colorTypes) {
    String text = '';
    for (int i = 0; i < colorTypes.length; i++) {
      switch (colorTypes[i]) {
        case 'WHITE': text += '흰색'; break;
        case 'COLORED': text += '유색'; break;
        case 'BLUE': text += '청'; break;
        default: text += 'null'; break;
      }
      if (i < colorTypes.length - 1) text += ', ';
    }
    return text;
  }

  String weightText(String weight) {
    String text = '';
    switch (weight) {
      case 'LIGHT': text = '가벼움'; break;
      case 'HEAVY': text = '무거움'; break;
      default: text = 'null'; break;
    }
    return text;
  }

  String machineTypesText(List<String> machineTypes) {
    String text = '';
    for (int i = 0; i < machineTypes.length; i++) {
      switch (machineTypes[i]) {
        case 'WASH': text += '세탁기'; break;
        case 'DRY': text += '건조기'; break;
        default: text += 'null'; break;
      }
      if (i < machineTypes.length - 1) text += ', ';
    }
    return text;
  }

  String extraInfoTypeText(String extraInfoType) {
    String text = '';
    print(extraInfoType);
    switch (extraInfoType) {
      case 'ALLERGY': text = '동물 털 알레르기'; break;
      case 'ETC': text = '기타'; break;
      case 'NOTHING': text = '없음'; break;
      default: text = 'null'; break;
    }
    return text;
  }

  Future<void> getLaundryPosts(String laundryId, String email) async {
    String url = '${Server().domain}laundry/request/allInLaundry?laundryId=$laundryId&email=$email';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<Post> result = jsonDecode(utf8.decode(response.bodyBytes))["result"].map<Post>((json) => Post.fromJson(json)).toList();
      laundryPosts.clear();
      laundryPosts.addAll(result);
      notifyListeners();
    } else {
      print('getPostsFailed');
    }
  }

  Future<void> getMyPosts(String email) async {
    String url = '${Server().domain}laundry/request/findByEmail?email=$email';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<Post> result = jsonDecode(utf8.decode(response.bodyBytes))["result"].map<Post>((json) => Post.fromJson(json)).toList();
      myPosts.clear();
      myPosts.addAll(result);
      notifyListeners();
    } else {
      print('getMyPostsFailed');
    }
  }

  Future<void> getMatchedPost(String id) async {
    String url = '${Server().domain}laundry/request/findById?Id=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(response.body.toString());
      Post result = Post.fromJson(jsonDecode(utf8.decode(response.bodyBytes))["result"]);
      matchedPost = result;
      notifyListeners();
    } else {
      print('getMatchedPostFailed');
    }
  }

  Future<bool> createPost(
      String gender, String laundryId, String email,
      List<String> colorTypes, String weight, List<String> machineTypes,
      String extraInfoType, String message, int expireDay
      ) async {
    String url = '${Server().domain}laundry/myRequest/save';
    Map<String, dynamic> body = {
      "gender": gender,
      "laundryId": laundryId,
      "email": email,
      "colorTypes": colorTypes,
      "weight": weight,
      "machineTypes": machineTypes,
      "extraInfoType": extraInfoType,
      "message": message,
      "expireDay": expireDay
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      await getLaundryPosts(laundryId, email);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updatePost(
      String email, String id, List<String> colorTypes, String weight,
      List<String> machineTypes, String extraInfoType, String message
      ) async {
    String url = '${Server().domain}laundry/myRequest/update';
    Map<String, dynamic> body = {
      "_id": id,
      "colorTypes": colorTypes,
      "weight": weight,
      "machineTypes": machineTypes,
      "extraInfoType": extraInfoType,
      "message": message,
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      await getMyPosts(email);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletePost(String email, String id) async {
    String url = '${Server().domain}laundry/myRequest/delete?Id=$id';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      await getMyPosts(email);
      return true;
    } else {
      return false;
    }
  }
}