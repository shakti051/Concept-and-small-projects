import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ConvertLatLongToAddress extends StatefulWidget {
  const ConvertLatLongToAddress({super.key});

  @override
  State<ConvertLatLongToAddress> createState() =>
      _ConvertLatLongToAddressState();
}

class _ConvertLatLongToAddressState
    extends State<ConvertLatLongToAddress> {
  String address = "Tap button to get address";

  Future<void> getAddress() async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(28.630420299999997, 77.21772159999999);

      Placemark place = placemarks.first;

      setState(() {
        address =
            "${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        address = "Address not found";
      });
    }
  }


  Future<void> getLatLongFromAddress() async {
  String address = "Connaught Place, New Delhi";

  List<Location> locations = await locationFromAddress(address);

  if (locations.isNotEmpty) {
    Location loc = locations.first;
    debugPrint("Latitude: ${loc.latitude}");
    debugPrint("Longitude: ${loc.longitude}");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Text(
            address,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          ElevatedButton(onPressed: (){
            getLatLongFromAddress();
          }, child: Text("Get Lat long"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getAddress,
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
