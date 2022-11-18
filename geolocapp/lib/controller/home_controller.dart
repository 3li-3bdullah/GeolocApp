import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  /// Declaring Variables 😀🔥
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  bool isNormalPosition = true;

  /// Declaring Mehods 😉🔥
  
  @override
  onInit(){
    super.onInit();
    addCustomMarker();
  }
  
  void addCustomMarker() {
    BitmapDescriptor.fromAssetImage(
           const ImageConfiguration(), 'assets/images/marker.png')
        .then((icon) {
          markerIcon = icon;
          update();
        });
  }

  void changePosition(){
    isNormalPosition = !isNormalPosition;
    update();
  }


}
