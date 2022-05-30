import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:washungrystable/userdashboard.dart' as user_dashboard;
import 'package:washungrystable/give_process/add_info.dart' as globals1;

class FoodInfo extends StatefulWidget {
  final String imagePath;
  final String adressName;
  final String agePhrase;
  final String ageUnit;
  final String allergens;
  final String countryCode;
  final String date;
  final String deliveryOption;
  final String deliverySentence;
  final int donationHours;
  final int donationsCompleted;
  final String downloadUrl;
  final String subAdministrativeArea;
  final String email;
  final String deviceToken;
  final String firstName;
  final String lastName;
  final String foodCategory;
  final String fullAddress;
  final int hoursVolunteered;
  final bool isVerified;
  final double latitude;
  final String locality;
  final String administrativeArea;
  final double longitude;
  final String postalCode;
  final int rating;
  final String street;
  final String sublocality;
  final String time;
  final String timeStamp;
  final String uid;
  final String docID;

  const FoodInfo({
    Key? key,
    required this.imagePath,
    required this.adressName,
    required this.agePhrase,
    required this.ageUnit,
    required this.allergens,
    required this.countryCode,
    required this.date,
    required this.deliveryOption,
    required this.deliverySentence,
    required this.donationHours,
    required this.donationsCompleted,
    required this.downloadUrl,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.foodCategory,
    required this.fullAddress,
    required this.hoursVolunteered,
    required this.isVerified,
    required this.latitude,
    required this.locality,
    required this.longitude,
    required this.postalCode,
    required this.rating,
    required this.street,
    required this.sublocality,
    required this.time,
    required this.timeStamp,
    required this.uid,
    required this.subAdministrativeArea,
    required this.deviceToken,
    required this.docID,
    required this.administrativeArea,
  }) : super(key: key);

  @override
  State<FoodInfo> createState() => _FoodInfoState();
}

class _FoodInfoState extends State<FoodInfo> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String? mtoken = " ";
  final geo = Geoflutterfire();
  double? distanceInMeters;
  @override
  void initState() {
    distanceInMeters = Geolocator.distanceBetween(
      widget.latitude,
      widget.longitude,
      user_dashboard.latitude!.toDouble(),
      user_dashboard.longitude!.toDouble(),
    );
    requestPermission();
    loadFCM();
    listenFCM();
    super.initState();
  }

  void sendPushMessage() async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAO-W0vyU:APA91bFPEuZ1B7B9NrlX-7M4zCTXGmL2dmctqDnZ9BRARS7KKd0ao1NdXmdknGEY_z8JCUDj8Cxg31FadVRoqSRjrP5fYuWFKgtikEWGVhQ1IM5dTTk8F00GmXgBOcdW5s8yAQKOCCbK',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': user_dashboard.firstName +
                ' has claimed ' +
                widget.foodCategory +
                ' just now!',
            'title': widget.foodCategory + ' was just claimed!',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          "to": widget.deviceToken.toString(),
        },
      ),
    );
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } else {
      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  String? data;

  @override
  Widget build(BuildContext context) {
    DatabaseReference userStatus =
        FirebaseDatabase.instance.ref('users/${widget.uid}/status');
    userStatus.onValue.listen((DatabaseEvent event) async {
      setState(() {
        data = event.snapshot.value.toString();
      });
    });
    GeoFirePoint myLocation = geo.point(
      latitude: user_dashboard.latitude!.toDouble(),
      longitude: user_dashboard.longitude!.toDouble(),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.textColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(FontAwesomeIcons.chevronLeft),
          ),
        ),
        backgroundColor: CustomColors.secondary,
        body: ListView(
          children: [
            SizedBox(
              height: 290,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.topCenter,
                children: [
                  SizedBox(
                    height: 150,
                    child: ClipPath(
                      clipper: CurvedBottomClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomColors.textColor,
                        ),
                        height: 250.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Image.network(
                            widget.downloadUrl,
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: CustomColors.getColor,
                              onPrimary: CustomColors.textColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              minimumSize: const Size(200, 50), //////// HERE
                            ),
                            onPressed: () async {
                              showMaterialModalBottomSheet(
                                bounce: true,
                                backgroundColor: CustomColors.secondary,
                                context: context,
                                builder: (context) => SingleChildScrollView(
                                  controller: ModalScrollController.of(context),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 40, left: 30, right: 50),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Confirm',
                                          style: GoogleFonts.poppins(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        widget.deliveryOption == 'Stay'
                                            ? Text(
                                                'The donor will be notified of your claim and will decide to accept or decline your request. \n \nNote: You will be expected to proceed to the donor\'s location to accept the food item. \n \nKeep an eye on your notifications for updates regarding the donor\'s decision. \n \nAn item will also be deducted from your daily quota.',
                                                style: GoogleFonts.poppins(
                                                  color: CustomColors.textColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            : Text(
                                                'The donor will be notified of your claim and will decide to accept or decline your request.\n \nKeep an eye on your notifications for updates regarding the donor\'s decision. \n \nAn item will also be deducted from your daily quota.',
                                                style: GoogleFonts.poppins(
                                                  color: CustomColors.textColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 50),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: CustomColors.getColor,
                                              onPrimary: CustomColors.textColor,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  140.0,
                                                ),
                                              ),
                                              minimumSize: const Size(
                                                double.infinity,
                                                50,
                                              ),
                                            ),
                                            onPressed: () async {
                                              sendPushMessage();
                                              await FirebaseFirestore.instance
                                                  .collection('donations')
                                                  .doc(widget.docID)
                                                  .set(
                                                {
                                                  'status': 'AwaitingApproval',
                                                  'dFirstName':
                                                      user_dashboard.firstName,
                                                  'dLastName':
                                                      user_dashboard.lastName,
                                                  'dRating':
                                                      user_dashboard.rating,
                                                  'dLongitude':
                                                      user_dashboard.longitude,
                                                  'dPeopleHelped':
                                                      user_dashboard
                                                          .peopleHelped,
                                                  'dLatitude':
                                                      user_dashboard.latitude,
                                                  'dDeviceToken':
                                                      user_dashboard.fcmToken,
                                                  'dAdminArea': user_dashboard
                                                      .place!
                                                      .administrativeArea,
                                                  'dCity': user_dashboard.place!
                                                          .subAdministrativeArea
                                                          .toString() +
                                                      ', ' +
                                                      user_dashboard.place!
                                                          .administrativeArea
                                                          .toString(),
                                                  'dMillisecondsSinceEpoch':
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch
                                                          .toString(),
                                                  'dPosition': myLocation.data,
                                                  'dFullAddress':
                                                      '${user_dashboard.place!.street}, ${user_dashboard.place!.subLocality}${user_dashboard.place!.locality}, ${user_dashboard.place!.postalCode}',
                                                  'dStreet': user_dashboard
                                                      .place!.street,
                                                  'dSublocality': user_dashboard
                                                      .place!.subLocality,
                                                  'dLocality': user_dashboard
                                                      .place!.locality,
                                                  'dPostalCode': user_dashboard
                                                      .place!.postalCode,
                                                  'dAdressName': user_dashboard
                                                      .place!.name,
                                                  'dCountryCode': user_dashboard
                                                      .place!.isoCountryCode,
                                                  'dFoodCategory': globals1
                                                      .foodCategory.text,
                                                  'dDate': DateFormat(
                                                          "MMMM dd, yyyy")
                                                      .format(DateTime.now()),
                                                  'dTime': DateFormat("hh:mm a")
                                                      .format(DateTime.now()),
                                                  'dSafetyTime': DateFormat(
                                                          "hh:mm:ss a")
                                                      .format(DateTime.now()),
                                                  'dUid': FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  'dEmail': FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .email,
                                                  'dIsVerified': FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .emailVerified,
                                                  'dHoursVolunteered':
                                                      user_dashboard
                                                          .hoursVolunteered,
                                                  'dDonationsCompleted':
                                                      user_dashboard
                                                          .donationsCompleted,
                                                  'dDonationHours':
                                                      user_dashboard
                                                          .hoursVolunteered,
                                                },
                                                SetOptions(merge: true),
                                              );
                                              setState(
                                                () {
                                                  user_dashboard.selectedIndex =
                                                      2;
                                                },
                                              );

                                              await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const user_dashboard
                                                          .UserDashboard(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Confirm',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Claim',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          widget.foodCategory.capitalize(),
                          style: TextStyle(
                              height: 1.0,
                              color: CustomColors.textColor,
                              fontFamily: "RecoletaB",
                              fontSize: 40,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: AutoSizeText(
                          "  " +
                              (distanceInMeters! / 1609).toStringAsFixed(2) +
                              " mi",
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            color: CustomColors.textColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   'Posted on: ' + widget.time + ' on ' + widget.date,
                  //   style: GoogleFonts.poppins(
                  //     color: CustomColors.textColor,
                  //     fontSize: 15,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  AutoSizeText(
                    widget.firstName + ' ' + widget.lastName,
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      color: CustomColors.textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Rating: ' + widget.rating.toString() + '.0/5.0',
                    style: GoogleFonts.poppins(
                      color: CustomColors.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: data.toString() == "Online"
                              ? Colors.green
                              : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      data.toString() == "Online"
                          ? Text(
                              'Online',
                              style: GoogleFonts.poppins(),
                            )
                          : Text(
                              'Offline',
                              style: GoogleFonts.poppins(),
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Information',
                    style: TextStyle(
                      fontFamily: "Recoleta",
                      color: CustomColors.textColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Delivery Status: ',
                                style: GoogleFonts.poppins(
                                  color: CustomColors.textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              widget.deliveryOption == "Deliver"
                                  ? TextSpan(
                                      text: "Donor will deliver to you.",
                                      style: GoogleFonts.poppins(
                                        color: CustomColors.textColor,
                                        fontWeight: FontWeight.w200,
                                        fontSize: 20,
                                      ),
                                    )
                                  : TextSpan(
                                      text: "You will proceed to the donor.",
                                      style: GoogleFonts.poppins(
                                        color: CustomColors.textColor,
                                        fontWeight: FontWeight.w200,
                                        fontSize: 20,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Allergy Info: ',
                                style: GoogleFonts.poppins(
                                  color: CustomColors.textColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              TextSpan(
                                text: widget.allergens,
                                style: GoogleFonts.poppins(
                                  color: CustomColors.textColor,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        'Age: ',
                        maxLines: 10,
                        style: GoogleFonts.poppins(
                          color: CustomColors.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        widget.agePhrase,
                        maxLines: 10,
                        style: GoogleFonts.poppins(
                          color: CustomColors.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Location',
                    style: TextStyle(
                      fontFamily: "Recoleta",
                      color: CustomColors.textColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30, bottom: 40),
                    child: AutoSizeText(
                      widget.locality + ", " + widget.administrativeArea,
                      maxLines: 10,
                      style: GoogleFonts.poppins(
                        color: CustomColors.textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // I've taken approximate height of curved part of view
    // Change it if you have exact spec for it
    final roundingHeight = size.height * 4 / 5;

    // this is top part of path, rectangle without any rounding
    final filledRectangle =
        Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);

    // this is rectangle that will be used to draw arc
    // arc is drawn from center of this rectangle, so it's height has to be twice roundingHeight
    // also I made it to go 5 units out of screen on left and right, so curve will have some incline there
    final roundingRectangle = Rect.fromLTRB(
        -5, size.height - roundingHeight * 2, size.width + 5, size.height);

    final path = Path();
    path.addRect(filledRectangle);

    // so as I wrote before: arc is drawn from center of roundingRectangle
    // 2nd and 3rd arguments are angles from center to arc start and end points
    // 4th argument is set to true to move path to rectangle center, so we don't have to move it manually
    path.arcTo(roundingRectangle, 3.14159265359, -3.14159265359, true);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // returning fixed 'true' value here for simplicity, it's not the part of actual question, please read docs if you want to dig into it
    // basically that means that clipping will be redrawn on any changes
    return true;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
