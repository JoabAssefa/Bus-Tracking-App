import 'dart:convert';

import 'package:Bus_Tracking_App/Model/bus_user.dart';
import 'package:Bus_Tracking_App/services/userlocation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocationController extends GetxController {
  var user = User().obs;
  var autoList = <String>[].obs;
  var isLoadedMap = false.obs;
  var isLoadedAutoText = false.obs;
  @override
  void onInit() {
    getIcon();
    getAutoCompleteData();
    addMarker();
    getLocation();

    super.onInit();
  }

  Future<void> getLocation() async {
    isLoadedMap(false);
    var position = await UserLocation().determinePosition();
    user.value =
        User(latitude: position.latitude, longitude: position.longitude);
    isLoadedMap(true);
  }

  Future getAutoCompleteData() async {
    isLoadedAutoText(false);
    final String stringData =
        await rootBundle.loadString("assets/autoCompleteData.json");
    List<dynamic> dynamicList = jsonDecode(stringData);
    List<String> realData = dynamicList.cast<String>();
    autoList.value = realData;
    isLoadedAutoText(true);
  }

  var markers = <MarkerId, Marker>{}.obs;

  void addMarker() {
    const MarkerId mi = MarkerId("initialPosition");
    final Marker m = Marker(
      markerId: mi,
      position: LatLng(
        user.value.latitude ?? 9.041061,
        user.value.longitude ?? 38.762909,
      ),
      icon: icon.value,
    );

    markers[mi] = m;
  }

  var icon = BitmapDescriptor.defaultMarker.obs;
  var isIconLoaded = false.obs;
  Future getIcon() async {
    isIconLoaded(false);
    BitmapDescriptor b = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 3.2),
        "assets/image/BusIcon.jpg");
    icon.value = b;
    isIconLoaded(true);
  }
}
