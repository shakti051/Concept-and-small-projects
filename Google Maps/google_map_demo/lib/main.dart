import 'package:flutter/material.dart';
import 'package:google_map_demo/convert_latlong_to_addrss.dart';
import 'package:google_map_demo/current_location.dart';
import 'package:google_map_demo/custom_marker.dart';
import 'package:google_map_demo/custom_marker_info_screen.dart';
import 'package:google_map_demo/custom_marker_network_image.dart';
import 'package:google_map_demo/google_places_api.dart';
import 'package:google_map_demo/home_screen.dart';
import 'package:google_map_demo/polygon_screen.dart';
import 'package:google_map_demo/polyline_screen.dart';

//https://console.cloud.google.com/google/maps-apis/home;onboard=true?project=master-balm-485419-e6&authuser=1
//api key : AIzaSyBZL_fz2aokow4-MXeV4lHYkN4URh8epHo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: CustomMarkerNetworkImage(),
    );
  }
}
