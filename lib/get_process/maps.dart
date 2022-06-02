import 'dart:async';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:washungrystable/userdashboard.dart';
import 'package:washungrystable/userdashboard.dart' as user_dashboard;

class MapsPage extends StatefulWidget {
  const MapsPage(
      {Key? key,
      required this.firstName,
      required this.lastName,
      required this.latitute,
      required this.longitude,
      required this.foodCategory,
      required this.dUid})
      : super(key: key);
  final String firstName;
  final String lastName;
  final double latitute;
  final double longitude;
  final String foodCategory;
  final String dUid;
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> with WidgetsBindingObserver {
  Uint8List? imageData;
  double latitude = 38.9420684;
  double longitude = -76.880841;
  double heading = 0;
  double accuracy = 30;
  Marker? marker;
  Circle? circle;
  GoogleMapController? _controller;
  Timer? timer;
  Timer? secondTimer;
  double distanceInMeters = 0;
  getMarkerasBytes() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/car.png");
    if (mounted) {
      setState(
        () {
          imageData = byteData.buffer.asUint8List();
        },
      );
    }
  }

  void updateMarkerAndCircle() {
    LatLng latlng = LatLng(latitude.toDouble(), longitude.toDouble());
    if (mounted) {
      setState(
        () {
          marker = Marker(
            markerId: const MarkerId("home"),
            position: latlng,
            rotation: heading,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: const Offset(0.5, 0.5),
            infoWindow: InfoWindow(
              title: "${widget.firstName} ${widget.lastName}",
            ),
            icon: BitmapDescriptor.fromBytes(imageData!),
          );
          circle = Circle(
            circleId: const CircleId("car"),
            radius: accuracy,
            zIndex: 1,
            strokeColor: Colors.blue,
            center: latlng,
            fillColor: Colors.blue.withAlpha(70),
          );
        },
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    FirebaseDatabase.instance.ref("users/${widget.dUid}/").update(
      {
        'isCheckingLocation': "true",
      },
    );
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer t) => animateCam(),
    );
    getMarkerasBytes();
    super.initState();
    DatabaseReference userLatitude =
        FirebaseDatabase.instance.ref('users/${widget.dUid}/latitude');
    DatabaseReference userLongitude =
        FirebaseDatabase.instance.ref('users/${widget.dUid}/longitude');
    DatabaseReference userHeading =
        FirebaseDatabase.instance.ref('users/${widget.dUid}/heading');
    DatabaseReference userAccuracy =
        FirebaseDatabase.instance.ref('users/${widget.dUid}/accuracy');
    userAccuracy.onValue.listen(
      (DatabaseEvent event) async {
        if (mounted) {
          setState(
            () {
              accuracy = double.parse(
                event.snapshot.value.toString(),
              );
            },
          );
        }
      },
    );
    userHeading.onValue.listen(
      (DatabaseEvent event) async {
        distanceInMeters = Geolocator.distanceBetween(
          widget.latitute,
          widget.longitude,
          user_dashboard.latitude!.toDouble(),
          user_dashboard.longitude!.toDouble(),
        );
        if (mounted) {
          setState(
            () {
              heading = double.parse(
                event.snapshot.value.toString(),
              );
            },
          );
        }
      },
    );
    userLatitude.onValue.listen(
      (DatabaseEvent event) async {
        print("$longitude, $latitude");
        distanceInMeters = Geolocator.distanceBetween(
          widget.latitute,
          widget.longitude,
          user_dashboard.latitude!.toDouble(),
          user_dashboard.longitude!.toDouble(),
        );
        if (mounted) {
          setState(
            () {
              latitude = double.parse(
                event.snapshot.value.toString(),
              );
              distanceInMeters = Geolocator.distanceBetween(
                widget.latitute,
                widget.longitude,
                user_dashboard.latitude!.toDouble(),
                user_dashboard.longitude!.toDouble(),
              );
            },
          );
        }
      },
    );
    userLongitude.onValue.listen(
      (DatabaseEvent event) async {
        print("$longitude, $latitude");

        if (mounted) {
          setState(
            () {
              longitude = double.parse(
                event.snapshot.value.toString(),
              );

              distanceInMeters = Geolocator.distanceBetween(
                widget.latitute,
                widget.longitude,
                user_dashboard.latitude!.toDouble(),
                user_dashboard.longitude!.toDouble(),
              );
            },
          );
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseDatabase.instance.ref("users/${widget.dUid}/").update(
        {
          'isCheckingLocation': "true",
        },
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const UserDashboard(),
        ),
      );
      FirebaseDatabase.instance.ref("users/${widget.dUid}/").update(
        {
          'isCheckingLocation': "false",
        },
      );
    }
  }

  animateCam() {
    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: -193,
          target: LatLng(latitude.toDouble(), longitude.toDouble()),
          tilt: 0,
          zoom: 17,
        ),
      ),
    );
    setState(() {});
    updateMarkerAndCircle();
  }

  @override
  void dispose() {
    _controller!.dispose();
    timer!.cancel();
    secondTimer!.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
      target: LatLng(
        user_dashboard.latitude!.toDouble(),
        user_dashboard.longitude!.toDouble(),
      ),
      zoom: 17,
    );
    return Scaffold(
      backgroundColor: CustomColors.secondary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserDashboard(),
              ),
            );
            FirebaseDatabase.instance.ref("users/${widget.dUid}/").update(
              {
                'isCheckingLocation': "false",
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Icon(
              FontAwesomeIcons.chevronLeft,
              color: CustomColors.textColor,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 16,
            child: GoogleMap(
              // polylines: Polyline(
              //   points: [],
              // ),

              zoomControlsEnabled: false,
              indoorViewEnabled: true,
              tiltGesturesEnabled: false,
              trafficEnabled: true,
              buildingsEnabled: false,
              myLocationButtonEnabled: true,
              mapType: MapType.hybrid,
              initialCameraPosition: initialLocation,

              markers: Set.of((marker != null) ? [marker!] : []),
              circles: Set.of((circle != null) ? [circle!] : []),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    widget.firstName + " " + widget.lastName,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: "RecoletaB",
                      color: CustomColors.textColor,
                      fontSize: 40,
                    ),
                  ),
                  AutoSizeText(
                    "" +
                        (distanceInMeters / 1609).toStringAsFixed(2) +
                        " mi away",
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      color: CustomColors.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.foodCategory,
                    style: GoogleFonts.poppins(
                      color: CustomColors.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
