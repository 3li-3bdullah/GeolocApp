import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeController extends GetxController {
  /// Declaring Variables 😀🔥
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  bool isNormalPosition = true;

  StreamSubscription? streamSubscriptionLocation;
  Location location = Location();
  Marker? marker;
  Circle? circle;
  Set<Polyline> polyLinePath = <Polyline>{};
  List<LatLng> listOfLatLng = [];
  GoogleMapController? googleMapController;
  LatLng? latLng;

  /// Declaring Mehods 😉🔥

  @override
  onInit() {
    super.onInit();
    // addCustomMarker();
  }

  @override
  void onClose() {
    if (streamSubscriptionLocation != null) {
      streamSubscriptionLocation!.cancel();
    }
    super.onClose();
  }

  //* ---------------- Convert Image To Marker By Unit8List ----------------------
  Future<Uint8List> convertImageToMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(Get.context!)
        .load("assets/images/car.png");
    return byteData.buffer.asUint8List();
  }

  //* ---------------- Here To Show Up The Path And Update The Marker And Circle ----------------------
  showPathAndUpdateMarkerAndCircle(
      {required LocationData newLocalData, required Uint8List imageData}) {
    latLng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    marker = Marker(
      markerId: const MarkerId('home'),
      position: latLng!,
      anchor: const Offset(0.5, 0.5),
      draggable: false,
      flat: true,
      rotation: newLocalData.heading!,
      zIndex: 2,
      icon: BitmapDescriptor.fromBytes(imageData),
    );
    circle = Circle(
        circleId: const CircleId('motor'),
        radius: newLocalData.accuracy!,
        center: latLng!,
        strokeColor: Colors.purple.shade200,
        fillColor: Colors.purple.withAlpha(70),
        zIndex: 1);
    listOfLatLng.add(latLng!);
    polyLinePath.clear();
    polyLinePath.add(
      Polyline(
          polylineId: const PolylineId('7'),
          points: listOfLatLng,
          color: Colors.white,
          width: 4,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)]),
    );
  }

  //* ------------------To Get Current locations -----------------------

  getCurrentLocation() async {
    try {
      Uint8List uintImage = await convertImageToMarker();

      var currentLocation = await location.getLocation();
      showPathAndUpdateMarkerAndCircle(
          newLocalData: currentLocation, imageData: uintImage);

      streamSubscriptionLocation != null
          ? streamSubscriptionLocation!.cancel()
          : null;

      streamSubscriptionLocation = location.onLocationChanged.listen((event) {
        if (googleMapController != null) {
          googleMapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                bearing: 90.8334901395799,
                tilt: 0,
                target: LatLng(event.latitude!, event.longitude!),
                zoom: 18.0,
              ),
            ),
          );
        }
        showPathAndUpdateMarkerAndCircle(
            newLocalData: event, imageData: uintImage);
        update();
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('Permission Denied');
      }
    }
  }
}
