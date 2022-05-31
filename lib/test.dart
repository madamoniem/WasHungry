import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

final Location _locationTracker = Location();
GoogleMapController? _controller;
getStuff() {
  _locationTracker.onLocationChanged.listen(
    (newLocalData) {
      if (_controller != null) {
        FirebaseDatabase.instance
            .ref("users/${FirebaseAuth.instance.currentUser!.uid}/")
            .update(
          {
            'latitute': newLocalData.latitude!.toDouble(),
            'longitude': newLocalData.longitude!.toDouble(),
          },
        );
      }
    },
  );
}
