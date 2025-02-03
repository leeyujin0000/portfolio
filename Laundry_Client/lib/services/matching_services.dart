import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/services/post_services.dart';
import 'package:laundry/services/server_domain.dart';

class Matching {
  String id;
  String requestId;
  Post laundryRequest;
  String url;
  List<String> users;

  Matching({
    required this.id,
    required this.requestId,
    required this.laundryRequest,
    required this.url,
    required this.users
  });

  factory Matching.fromJson(Map<String, dynamic> json) => Matching(
    id: json["_id"],
    requestId: json["requestId"],
    laundryRequest: Post.fromJson(json["laundryRequest"]),
    url: json["url"],
    users: List<String>.from(json["users"])
  );
}

class MatchingServices with ChangeNotifier {

  List<Matching> matchingList = [];

  String partnerText(List<String> users, String email) {
    String text = '';
    if (users[0] != email) {
      text = users[0];
    } else {
      text = users[1];
    }
    return text;
  }

  Future<void> getMatchingList(String email) async {
    String url = '${Server().domain}match/find/myMatch?email=$email';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<Matching> result = jsonDecode(utf8.decode(response.bodyBytes))["result"].map<Matching>((json) => Matching.fromJson(json)).toList();
      //print(result[0].users[0]);
      matchingList.clear();
      matchingList.addAll(result);
      notifyListeners();
    } else {
      print('getMatchingListFailed');
    }
  }

  Future<bool> createMatching(
      String laundryId, String nowEmail, String requestId, String openChatUrl
      ) async {
    String url = '${Server().domain}match/doMatch?nowEmail=$nowEmail&requestId=$requestId&url=$openChatUrl';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // await PostServices().getLaundryPosts(laundryId);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteMatching(String email, String id) async {
    String url = '${Server().domain}match/delete/myMatch?id=$id';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      await getMatchingList(email);
      return true;
    } else {
      return false;
    }
  }
}