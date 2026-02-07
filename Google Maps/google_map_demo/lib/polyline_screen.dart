import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineScreen extends StatefulWidget {
  const PolylineScreen({super.key});

  @override
  State<PolylineScreen> createState() => _PolylineScreenState();
}

class _PolylineScreenState extends State<PolylineScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.6139, 77.2090),
    zoom: 14,
  );
  static const LatLng _center = LatLng(33.738045, 73.084488);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  //add your lat and lng where you wants to draw polyline
  final LatLng _lastMapPosition = _center;

  List<LatLng> latlng = [
    LatLng(28.6139, 77.2090), // Start (Delhi)
    LatLng(28.5355, 77.3910), // Mid (Noida)
    LatLng(28.4595, 77.0266),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < latlng.length; i++) {
      setState(() {
        _markers.add(
          Marker(
            // This marker id can be anything that uniquely identifies each marker.
            markerId: MarkerId(i.toString()),
            //_lastMapPosition is any coordinate which should be your default
            //position when map opens up
            position: latlng[i],
            infoWindow: InfoWindow(
              title: 'Really cool place',
              snippet: '5 Star Rating',
            ),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        _polyline.add(
          Polyline(
            polylineId: PolylineId(i.toString()),
            visible: true,
            //latlng is List<LatLng>
            points: latlng,
           width: 5,
            //  points: latlng[i],
            color: Colors.blue,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: GoogleMap(
          //that needs a list<Polyline>
          polylines: _polyline,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
          // onCameraMove: _onCameraMove,
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
        ),
      ),
    );
  }
}
