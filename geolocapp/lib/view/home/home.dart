import 'package:flutter/material.dart';
import 'package:geolocapp/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends GetWidget<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: GetBuilder<HomeController>(
          builder:(controller) => FloatingActionButton(
            onPressed: () => controller.changePosition(),
            backgroundColor: Colors.deepPurple.shade300,
            mini: true,
            child: const Icon(Icons.change_circle_outlined),
          ),
        ),
      ),
      body: SafeArea(
        child: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) => GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.43296265331129, -122.08832357078792),
              zoom: 14,
            ),
            mapType: controller.isNormalPosition ? MapType.normal : MapType.satellite,
            markers: {
              Marker(
                markerId: const MarkerId('demo'),
                position: const LatLng(37.43296265331129, -122.08832357078792),
                onDrag: (value) {},
                // draggable: true,
                // icon: controller.markerIcon,
              ),
            },
          ),
        ),
      ),
    );
  }
}
