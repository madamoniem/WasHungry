import 'dart:io';

import 'package:action_slider/action_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:washungrystable/give_process/add_location.dart';
import 'package:washungrystable/give_process/congrats.dart';
import 'package:washungrystable/storage.dart';
import 'package:washungrystable/userdashboard.dart' as user_dashboard;
import 'package:washungrystable/give_process/add_info.dart' as add_info;
import 'package:washungrystable/give_process/add_location.dart' as add_location;

class ConfirmDono extends StatefulWidget {
  const ConfirmDono({Key? key}) : super(key: key);

  @override
  State<ConfirmDono> createState() => _ConfirmDonoState();
}

class _ConfirmDonoState extends State<ConfirmDono> {
  final Storage storage = Storage();
  final geo = Geoflutterfire();

  String? mtoken = " ";
  String? deliveryOption;
  String? deliverySentence;
  String? downloadUrl;
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });
  }

  String? fcmToken;
  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GeoFirePoint myLocation = geo.point(
        latitude: user_dashboard.latitude!.toDouble(),
        longitude: user_dashboard.longitude!.toDouble());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => AddLocation(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Icon(
              FontAwesomeIcons.chevronLeft,
              color: CustomColors.textColor,
            ),
          ),
        ),
      ),
      backgroundColor: CustomColors.secondary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                'Confirm',
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "RecoletaB",
                  color: CustomColors.textColor,
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 20),
                child: AutoSizeText(
                  'Delivery',
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                    color: CustomColors.textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              add_location.isEnabled
                  ? Text(
                      'Deliver withen ${add_location.disNum.text} miles of ${user_dashboard.place!.street} ${user_dashboard.place!.subLocality}${user_dashboard.place!.locality}, ${user_dashboard.place!.postalCode}',
                      style: GoogleFonts.poppins(
                        color: CustomColors.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  : Text(
                      'Stay at ${user_dashboard.place!.street} ${user_dashboard.place!.subLocality}${user_dashboard.place!.locality}, ${user_dashboard.place!.postalCode}',
                      style: GoogleFonts.poppins(
                        color: CustomColors.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 20),
                child: AutoSizeText(
                  'Preview',
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                    color: CustomColors.textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Confirm public appearence of your donation.',
                style: GoogleFonts.poppins(
                    color: CustomColors.textColor, fontSize: 20),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: CustomColors.secondary,
                  border: Border.all(
                    width: 1,
                    color: CustomColors.textColor,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 15,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Image.file(
                          File(
                            add_info.photo!.path.toString(),
                          ),
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 140,
                          ),
                          child: AutoSizeText(
                            add_info.foodCategory.text,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              color: CustomColors.textColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        add_info.selectedAllergies.isEmpty == true
                            ? ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 70.0,
                                  maxWidth: 140,
                                ),
                                child: AutoSizeText(
                                  "No allergies selected.",
                                  minFontSize: 10,
                                  maxFontSize: 25,
                                  style: GoogleFonts.poppins(
                                    color: CustomColors.textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 70.0,
                                  maxWidth: 140,
                                ),
                                child: AutoSizeText(
                                  add_info.selectedAllergies
                                      .toList()
                                      .join(", "),
                                  minFontSize: 10,
                                  maxFontSize: 25,
                                  style: GoogleFonts.poppins(
                                    color: CustomColors.textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 5,
                        ),
                        AutoSizeText(
                          add_info.ageNum.text +
                              ' ' +
                              add_info.ageValue.toString(),
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            color: CustomColors.textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // SizedBox(
              //   child: ButtonTheme(
              //     height: 100.0,
              //     child: ElevatedButton(
              //       onPressed: () async {
              //         setState(() {
              //           myLocation = geo.point(
              //             latitude: user_dashboard.latitude!.toDouble(),
              //             longitude: user_dashboard.longitude!.toDouble(),
              //           );
              //         });
              //         if (add_location.isEnabled) {
              //           deliverySentence =
              //               'Deliver withen ${add_location.disNum.text} miles of ${user_dashboard.place!.street} ${user_dashboard.place!.subLocality}${user_dashboard.place!.locality}, ${user_dashboard.place!.postalCode}';
              //         } else {
              //           deliverySentence =
              //               'Stay at ${user_dashboard.place!.street} ${user_dashboard.place!.subLocality}${user_dashboard.place!.locality}, ${user_dashboard.place!.postalCode}';
              //         }
              //         if (isEnabled == true) {
              //           deliveryOption = 'Deliver';
              //         } else {
              //           deliveryOption = 'Stay';
              //         }
              //         if (add_info.foodCategory.text == '') {
              //           Fluttertoast.showToast(
              //               msg: 'Food category is left blank');
              //         } else if (add_info.ageNum.text == '') {
              //           Fluttertoast.showToast(msg: 'Age is left blank');
              //         } else if (add_info.ageValue == null) {
              //           Fluttertoast.showToast(msg: 'Age type is left blank');
              //         } else if (add_info.photo == null) {
              //           Fluttertoast.showToast(msg: 'Must upload a photo');
              //         } else {
              //           setState(
              //             () {
              //               add_info.fileID = const Uuid().v4();
              //             },
              //           );

              //           await storage
              //               .uploadFile(add_info.photo!.path.toString(),
              //                   add_info.fileID)
              //               .then(
              //             (value) {
              //               downloadUrl = value;
              //               Fluttertoast.showToast(
              //                 msg: value,
              //               );
              //             },
              //           );
              //           Navigator.of(context).pushReplacement(
              //             MaterialPageRoute(
              //               builder: (context) =>
              //                   const user_dashboard.UserDashboard(),
              //             ),
              //           );
              //           await FirebaseFirestore.instance
              //               .collection("donations")
              //               .add(
              //             {
              //               'adminArea':
              //                   user_dashboard.place!.administrativeArea,
              //               'status': 'Online',
              //               'deviceToken': mtoken,
              //               'city': user_dashboard.place!.subAdministrativeArea
              //                       .toString() +
              //                   ', ' +
              //                   user_dashboard.place!.administrativeArea
              //                       .toString(),
              //               'millisecondsSinceEpoch': DateTime.now()
              //                   .millisecondsSinceEpoch
              //                   .toString(),
              //               'position': myLocation.data,
              //               'latitude': user_dashboard.latitude,
              //               'longitude': user_dashboard.longitude,
              //               'fullAddress':
              //                   '${user_dashboard.place!.street} ${user_dashboard.place!.subLocality}${user_dashboard.place!.locality}, ${user_dashboard.place!.postalCode}',
              //               'street': user_dashboard.place!.street,
              //               'sublocality':
              //                   user_dashboard.place!.subLocality.toString(),
              //               'locality': user_dashboard.place!.locality,
              //               'postalCode': user_dashboard.place!.postalCode,
              //               'adressName': user_dashboard.place!.name,
              //               'countryCode': user_dashboard.place!.isoCountryCode,
              //               'deliverySentence': deliverySentence,
              //               'deliveryOption': deliveryOption,
              //               'imagePath': add_info.fileID,
              //               'allergens':
              //                   add_info.selectedAllergies.isEmpty == true
              //                       ? "No allergies selected."
              //                       : add_info.selectedAllergies
              //                           .toList()
              //                           .join(", "),
              //               'foodCategory': add_info.foodCategory.text,
              //               'ageNum': add_info.ageNum.text,
              //               'ageUnit': add_info.ageValue,
              //               'agePhrase':
              //                   add_info.ageNum.text + ' ${add_info.ageValue}',
              //               'timeStamp': DateTime.now().toString(),
              //               'date': DateFormat("MMMM dd, yyyy")
              //                   .format(DateTime.now()),
              //               'time':
              //                   DateFormat("hh:mm a").format(DateTime.now()),
              //               'safetyTime':
              //                   DateFormat("hh:mm:ss a").format(DateTime.now()),
              //               'uid': FirebaseAuth.instance.currentUser!.uid,
              //               'email': FirebaseAuth.instance.currentUser!.email,
              //               'isVerified': FirebaseAuth
              //                   .instance.currentUser!.emailVerified,
              //               'rating': user_dashboard.rating,
              //               'firstName': user_dashboard.firstName,
              //               'lastName': user_dashboard.lastName,
              //               'hoursVolunteered': user_dashboard.hoursVolunteered,
              //               'donationsCompleted':
              //                   user_dashboard.donationsCompleted,
              //               'donationHours': user_dashboard.hoursVolunteered,
              //               'downloadUrl': downloadUrl,
              //             },
              //           ).then(
              //             (value) {
              //               imageCache.clear();
              //               add_info.ageNum.clear();
              //               add_info.foodCategory.clear();
              //               setState(
              //                 () {
              //                   add_info.ageValue == null;
              //                   add_info.selectedAllergies = [];
              //                   add_info.photo = null;
              //                 },
              //               );
              //               print(add_info.selectedAllergies.toList());
              //               Fluttertoast.showToast(msg: 'Request placed');
              //             },
              //           );
              //         }
              //       },
              //       style: ElevatedButton.styleFrom(
              //         primary: CustomColors.primary,
              //         onPrimary: CustomColors.textColor,
              //         elevation: 0,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15.0),
              //         ),
              //         minimumSize: const Size(double.infinity, 60),
              //       ),
              //       child: Text(
              //         'Confirm',
              //         style: GoogleFonts.poppins(
              //           color: Colors.white,
              //           fontSize: 20,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.bottomRight,
                child: ActionSlider.standard(
                  boxShadow: [],
                  sliderBehavior: SliderBehavior.stretch,
                  rolling: true,
                  height: 70,
                  child: Text(
                    'Swipe right to confirm',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xfff5f5f5),
                    ),
                  ),
                  backgroundColor: CustomColors.textColor,
                  toggleColor: CustomColors.primary,
                  iconAlignment: Alignment.centerRight,
                  loadingIcon: const SizedBox(
                    width: 55,
                    child: Center(
                      child: SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  successIcon: const SizedBox(
                    width: 55,
                    child: Center(
                      child: Icon(Icons.check_rounded),
                    ),
                  ),
                  icon: const SizedBox(
                    width: 55,
                    child: Center(
                      child: Icon(Icons.refresh_rounded, color: Colors.white),
                    ),
                  ),
                  action: (controller) async {
                    controller.loading();
                    setState(() {
                      myLocation = geo.point(
                        latitude: user_dashboard.latitude!.toDouble(),
                        longitude: user_dashboard.longitude!.toDouble(),
                      );
                    });
                    if (add_location.isEnabled) {
                      deliverySentence =
                          'Deliver withen ${add_location.disNum.text} miles of ${user_dashboard.place!.street} ${user_dashboard.place!.subLocality}${user_dashboard.place!.locality}, ${user_dashboard.place!.postalCode}';
                    } else {
                      deliverySentence =
                          'Stay at ${user_dashboard.place!.street} ${user_dashboard.place!.subLocality}${user_dashboard.place!.locality}, ${user_dashboard.place!.postalCode}';
                    }
                    if (isEnabled == true) {
                      deliveryOption = 'Deliver';
                    } else {
                      deliveryOption = 'Stay';
                    }
                    if (add_info.foodCategory.text == '') {
                      Fluttertoast.showToast(
                          msg: 'Food category is left blank');
                    } else if (add_info.ageNum.text == '') {
                      Fluttertoast.showToast(msg: 'Age is left blank');
                    } else if (add_info.ageValue == null) {
                      Fluttertoast.showToast(msg: 'Age type is left blank');
                    } else if (add_info.photo == null) {
                      Fluttertoast.showToast(msg: 'Must upload a photo');
                    } else {
                      setState(
                        () {
                          add_info.fileID = const Uuid().v4();
                        },
                      );

                      await storage
                          .uploadFile(
                              add_info.photo!.path.toString(), add_info.fileID)
                          .then(
                        (value) {
                          downloadUrl = value;
                          Fluttertoast.showToast(
                            msg: value,
                          );
                        },
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => CongratsScreen(),
                        ),
                      );
                      await FirebaseFirestore.instance
                          .collection("donations")
                          .add(
                        {
                          'adminArea': user_dashboard.place!.administrativeArea,
                          'status': 'Online',
                          'deviceToken': mtoken,
                          'city': user_dashboard.place!.subAdministrativeArea
                                  .toString() +
                              ', ' +
                              user_dashboard.place!.administrativeArea
                                  .toString(),
                          'millisecondsSinceEpoch':
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          'position': myLocation.data,
                          'latitude': user_dashboard.latitude,
                          'longitude': user_dashboard.longitude,
                          'fullAddress':
                              '${user_dashboard.place!.street} ${user_dashboard.place!.subLocality}${user_dashboard.place!.locality}, ${user_dashboard.place!.postalCode}',
                          'street': user_dashboard.place!.street,
                          'sublocality':
                              user_dashboard.place!.subLocality.toString(),
                          'locality': user_dashboard.place!.locality,
                          'postalCode': user_dashboard.place!.postalCode,
                          'adressName': user_dashboard.place!.name,
                          'countryCode': user_dashboard.place!.isoCountryCode,
                          'deliverySentence': deliverySentence,
                          'deliveryOption': deliveryOption,
                          'imagePath': add_info.fileID,
                          'allergensList':
                              add_info.selectedAllergies.isEmpty == true
                                  ? "No allergies selected."
                                  : add_info.selectedAllergies.toList(),
                          'allergens': add_info.selectedAllergies.isEmpty ==
                                  true
                              ? "No allergies selected."
                              : add_info.selectedAllergies.toList().join(", "),
                          'foodCategory': add_info.foodCategory.text,
                          'ageNum': add_info.ageNum.text,
                          'ageUnit': add_info.ageValue,
                          'agePhrase':
                              add_info.ageNum.text + ' ${add_info.ageValue}',
                          'timeStamp': DateTime.now().toString(),
                          'date': DateFormat("MMMM dd, yyyy")
                              .format(DateTime.now()),
                          'time': DateFormat("hh:mm a").format(DateTime.now()),
                          'safetyTime':
                              DateFormat("hh:mm:ss a").format(DateTime.now()),
                          'uid': FirebaseAuth.instance.currentUser!.uid,
                          'email': FirebaseAuth.instance.currentUser!.email,
                          'isVerified':
                              FirebaseAuth.instance.currentUser!.emailVerified,
                          'rating': user_dashboard.rating,
                          'firstName': user_dashboard.firstName,
                          'lastName': user_dashboard.lastName,
                          'hoursVolunteered': user_dashboard.hoursVolunteered,
                          'donationsCompleted':
                              user_dashboard.donationsCompleted,
                          'donationHours': user_dashboard.hoursVolunteered,
                          'downloadUrl': downloadUrl,
                        },
                      ).then(
                        (value) {
                          imageCache.clear();
                          add_info.ageNum.clear();
                          add_info.foodCategory.clear();
                          setState(
                            () {
                              add_info.ageValue == null;
                              add_info.selectedAllergies = [];
                              add_info.photo = null;
                            },
                          );
                          print(add_info.selectedAllergies.toList());
                          Fluttertoast.showToast(msg: 'Request placed');
                        },
                      );
                    } //starts loading animation
                    await Future.delayed(const Duration(seconds: 3));
                    controller.success(); //starts success animation
                    await Future.delayed(const Duration(seconds: 1));
                    controller.reset(); //resets the slider
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
