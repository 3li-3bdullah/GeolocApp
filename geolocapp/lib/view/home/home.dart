import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocapp/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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

    Future<Uint8List> convertImageToMarker() async {
      ByteData byteData =
          await DefaultAssetBundle.of(context).load("assets/images/car.png");
      return byteData.buffer.asUint8List();
    }

    //* ---------------- Here To Show Up The Path And Update The Marker And Circle ----------------------
    showPathAndUpdateMarkerAndCircle(
        {required LocationData newLocalData, required Uint8List imageData}) {
      setState(() {
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
      });
    }

    //* ------------------To Get Current locations -----------------------

    getCurrentLocation() async {
      try {
        Uint8List uintImage = await convertImageToMarker();

        var currentLocation = await location.getLocation();
        setState(() {
          showPathAndUpdateMarkerAndCircle(
              newLocalData: currentLocation, imageData: uintImage);
          streamSubscriptionLocation != null
              ? streamSubscriptionLocation!.cancel()
              : null;
        });

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

          setState(() {
            showPathAndUpdateMarkerAndCircle(
                newLocalData: event, imageData: uintImage);
          });

          // update();
        });
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          debugPrint('Permission Denied');
        }
      }
    }

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(right: Get.width / 8),
        child: GetBuilder<HomeController>(
          builder: (controller) => Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () => getCurrentLocation(),
                backgroundColor: Colors.deepPurple.shade300,
                child: const Icon(Icons.location_searching),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                onPressed: () => streamSubscriptionLocation != null
                    ? streamSubscriptionLocation!.cancel()
                    : {},
                backgroundColor: Colors.deepPurple.shade300,
                child: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) => GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.43296265331129, -122.08832357078792),
              zoom: 19,
            ),
            mapType: MapType.hybrid,
            circles: Set.of((circle != null) ? [circle!] : []),
            markers: Set.of((marker != null) ? [marker!] : []),
            polylines: polyLinePath,
            onMapCreated: (GoogleMapController mapController) {
              googleMapController = mapController;
            },
            // markers: {
            //   Marker(
            //     markerId: const MarkerId('demo'),
            //     position: const LatLng(37.43296265331129, -122.08832357078792),
            //     onDrag: (value) {},
            //     // draggable: true,
            //     // icon: controller.markerIcon,
            //   ),
            // },
          ),
        ),
      ),
    );
  }
}
