import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:washungrystable/userdashboard.dart' as user_dashboard;
import 'package:washungrystable/get_process/foodInfo.dart';
import 'userdashboard.dart';

class NearbyDonations extends StatefulWidget {
  const NearbyDonations({Key? key}) : super(key: key);

  @override
  State<NearbyDonations> createState() => _NearbyDonationsState();
}

class _NearbyDonationsState extends State<NearbyDonations> {
  final geo = Geoflutterfire();
  final ref = FirebaseStorage.instance.ref().child('testimage');

  @override
  Widget build(BuildContext context) {
    GeoFirePoint center = geo.point(
        latitude: user_dashboard.latitude!.toDouble(),
        longitude: user_dashboard.longitude!.toDouble());
    var collectionReference =
        FirebaseFirestore.instance.collection('donations');
    double radius = 4000;
    String field = 'position';

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 50,
            ),
            child: AutoSizeText(
              'Available Items',
              maxLines: 2,
              style: TextStyle(
                color: CustomColors.textColor,
                fontFamily: "RecoletaB",
                fontSize: 50,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: StreamBuilder(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshots) {
                if (snapshots.connectionState == ConnectionState.active &&
                    snapshots.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: snapshots.data!.map(
                      (DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FoodInfo(
                                    adressName: data['adressName'],
                                    email: data['email'],
                                    isVerified: data['isVerified'],
                                    fullAddress: data['fullAddress'],
                                    donationsCompleted:
                                        data['donationsCompleted'],
                                    downloadUrl: data['downloadUrl'],
                                    firstName: data['firstName'],
                                    foodCategory: data['foodCategory'],
                                    donationHours: data['donationHours'],
                                    latitude: data['latitude'],
                                    postalCode: data['postalCode'],
                                    agePhrase: data['agePhrase'],
                                    hoursVolunteered: data['hoursVolunteered'],
                                    lastName: data['lastName'],
                                    locality: data['locality'],
                                    deliverySentence: data['deliverySentence'],
                                    ageUnit: data['ageUnit'],
                                    date: data['date'],
                                    deliveryOption: data['deliveryOption'],
                                    countryCode: data['countryCode'],
                                    rating: data['rating'],
                                    allergens: data['allergens'],
                                    time: data['time'],
                                    sublocality: data['sublocality'],
                                    longitude: data['longitude'],
                                    street: data['street'],
                                    timeStamp: data['timeStamp'],
                                    uid: data['uid'],
                                    subAdministrativeArea: data['city'],
                                    deviceToken: data['deviceToken'],
                                    docID: document.id,
                                    imagePath: data['imagePath'],
                                    administrativeArea: data["adminArea"],
                                  ),
                                ),
                              );
                            },
                            child: Container(
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
                                    padding: const EdgeInsets.only(right: 15),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: Image.network(
                                        data['downloadUrl'],
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 150,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 140,
                                        ),
                                        child: AutoSizeText(
                                          data['foodCategory'].toString(),
                                          maxLines: 1,
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxHeight: 70.0,
                                          maxWidth: 140,
                                        ),
                                        child: AutoSizeText(
                                          data['allergens'],
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
                                        data['ageNum'].toString() +
                                            ' ' +
                                            data['ageUnit'].toString(),
                                        maxLines: 1,
                                        style: GoogleFonts.poppins(
                                          color: CustomColors.textColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
