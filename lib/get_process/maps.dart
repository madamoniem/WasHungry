import 'dart:async';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:washungrystable/customwidgets.dart';

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
  double distanceInMeters = 1;
  Uint8List? imageData;
  Timer? timer;
  double latitude = 38.87165;
  double longitude = -76.9897191;
  double heading = 0;
  double headingAccuracy = 0;
  StreamSubscription? _locationSubscription;
  Marker? marker;
  Circle? circle;
  GoogleMapController? _controller;

  getMarkerasBytes() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/car.png");
    setState(() {
      imageData = byteData.buffer.asUint8List();
    });
  }

  void updateMarkerAndCircle() {
    LatLng latlng = LatLng(latitude, longitude);
    setState(
      () {
        marker = Marker(
            markerId: const MarkerId("home"),
            position: latlng,
            rotation: 40,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: const Offset(0.5, 0.5),
            icon: BitmapDescriptor.fromBytes(imageData!));
        circle = Circle(
            circleId: const CircleId("car"),
            radius: headingAccuracy,
            zIndex: 1,
            strokeColor: Colors.blue,
            center: latlng,
            fillColor: Colors.blue.withAlpha(70));
      },
    );
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
      (Timer t) {
        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(latitude, longitude),
                tilt: 0,
                zoom: 18.00),
          ),
        );
        updateMarkerAndCircle();
      },
    );
    // getMarker();
    getMarkerasBytes();
    super.initState();
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
      FirebaseDatabase.instance.ref("users/${widget.dUid}/").update(
        {
          'isCheckingLocation': "false",
        },
      );
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    _controller!.dispose();
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference userLatitude =
        FirebaseDatabase.instance.ref('users/${widget.dUid}/latitute');
    DatabaseReference userLongitude =
        FirebaseDatabase.instance.ref('users/${widget.dUid}/longitude');
    DatabaseReference userHeading =
        FirebaseDatabase.instance.ref('users/${widget.dUid}/heading');
    DatabaseReference userHeadingAccuracy =
        FirebaseDatabase.instance.ref('users/${widget.dUid}/headingAccuracy');
    userLatitude.onValue.listen(
      (DatabaseEvent event) async {
        DatabaseEvent userHeadingValue = await userHeading.once();
        DatabaseEvent userHeadingAccuracyValue =
            await userHeadingAccuracy.once();
        setState(
          () {
            heading = double.parse(
                userHeadingAccuracyValue.snapshot.value.toString());
            headingAccuracy =
                double.parse(userHeadingValue.snapshot.value.toString());
            latitude = double.parse(
              event.snapshot.value.toString(),
            );
          },
        );
      },
    );
    userLongitude.onValue.listen(
      (DatabaseEvent event) async {
        DatabaseEvent userHeadingValue = await userHeading.once();
        DatabaseEvent userHeadingAccuracyValue =
            await userHeadingAccuracy.once();
        setState(
          () {
            heading = double.parse(
                userHeadingAccuracyValue.snapshot.value.toString());
            headingAccuracy =
                double.parse(userHeadingValue.snapshot.value.toString());

            longitude = double.parse(
              event.snapshot.value.toString(),
            );
          },
        );
      },
    );

    // if (_controller != null) {
    //   _controller!.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(
    //         bearing: 192.8334901395799,
    //         target: LatLng(latitude, longitude),
    //         tilt: 0,
    //         zoom: 9,
    //       ),
    //     ),
    //   );
    //   // setState(
    //   //   () {
    //   //     marker = Marker(
    //   //       markerId: const MarkerId("home"),
    //   //       position: latlng,
    //   //       draggable: false,
    //   //       zIndex: 2,
    //   //       flat: true,
    //   //       anchor: const Offset(0.5, 0.5),
    //   //       icon: BitmapDescriptor.fromBytes(imageData!),
    //   //     );
    //   //     circle = Circle(
    //   //         circleId: const CircleId("car"),
    //   //         zIndex: 1,
    //   //         strokeColor: Colors.blue,
    //   //         center: latlng,
    //   //         fillColor: Colors.blue.withAlpha(70));
    //   //   },
    //   // );
    // }

    CameraPosition initialLocation = CameraPosition(
      target: LatLng(
        latitude.toDouble(),
        longitude.toDouble(),
      ),
      zoom: 18,
    );
    return Scaffold(
      backgroundColor: CustomColors.secondary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
              mapType: MapType.hybrid,
              initialCameraPosition: initialLocation,
              markers: {marker!},
              circles: {circle!},
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
