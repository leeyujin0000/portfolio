import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/services/server_domain.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;

  Location({
    required this.latitude,
    required this.longitude
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json["y"],
    longitude: json["x"]
  );
}

class Laundry {
  String id;
  String name;
  String roadAddress;
  String? time;
  Location location;

  Laundry({
    required this.id,
    required this.name,
    required this.roadAddress,
    this.time,
    required this.location
  });

  factory Laundry.fromJson(Map<String, dynamic> json) => Laundry(
    id: json["_id"],
    name: json["name"],
    roadAddress: json["roadAddress"],
    time: json["time"],
    location: Location.fromJson(json["location"])
  );
}

class MapServices with ChangeNotifier {

  NLatLng userLocation = const NLatLng(0, 0);

  List<Laundry> laundries = [];
  Set<NMarker> laundryMarkers = {};

  Future<void> getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
      userLocation = NLatLng(position.latitude, position.longitude);
      print(userLocation.toString());
    } catch (e) {
      throw Exception(e);
    }
    notifyListeners();
  }

  Future<void> getLaundries() async {
    String url = '${Server().domain}laundry/findNear';
    Map<String, dynamic> body = {
      "lat": userLocation.latitude,
      "lon": userLocation.longitude,
      "distance": 2,
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      List<Laundry> result = jsonDecode(utf8.decode(response.bodyBytes))["laundryInfoList"].map<Laundry>((json) => Laundry.fromJson(json)).toList();
      laundries.clear();
      laundries.addAll(result);
    } else {
      print('getLaundriesFailed');
    }
  }

  void getLaundryMarkers() {
    Set<NMarker> markers = List<NMarker>.generate(laundries.length, (index) =>
        NMarker(
            id: laundries[index].id,
            position: NLatLng(
                laundries[index].location.latitude,
                laundries[index].location.longitude
            ),
            icon: const NOverlayImage.fromAssetImage('assets/images/place_marker.png')
        )
    ).toSet();
    laundryMarkers.clear();
    laundryMarkers.addAll(markers);
  }
}