import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  final List<Marker> _markers = <Marker>[];

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((
      error,
      stackTrace,
    ) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  List<Marker> list = const [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(33.6844, 73.0479),
      infoWindow: InfoWindow(title: 'some Info '),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // _markers.addAll(list);
    loadData();
  }

  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );

  void loadData() {
    _getUserCurrentLocation().then((value) async {
      debugPrint("My current location:");
      debugPrint("${value.longitude},${value.latitude}");

      _markers.add(
        Marker(
          markerId: const MarkerId('SomeId'),
          position: LatLng(value.latitude, value.longitude),
        ),
      );

      final GoogleMapController controller = await _controller.future;
      CameraPosition kGooglePlex = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
        title: Text('Flutter Google Map'),
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: kGooglePlex,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
