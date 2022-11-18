import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
              target: LatLng(37.43296265331129, -122.08832357078792),
              zoom: 14
              ),
              markers: {
                Marker(markerId: const MarkerId('demo'),
                position:  const LatLng(37.43296265331129, -122.08832357078792),
                onDrag: (value){},
                // draggable: true,
                ),
      
              },
        ),
      ),
    );
  }
}
