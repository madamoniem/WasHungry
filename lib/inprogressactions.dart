import 'package:flutter/material.dart';
import 'package:washungrystable/customwidgets.dart';

class InProgressActions extends StatefulWidget {
  const InProgressActions(
      {Key? key,
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
      required this.subAdministrativeArea,
      required this.email,
      required this.deviceToken,
      required this.firstName,
      required this.lastName,
      required this.foodCategory,
      required this.fullAddress,
      required this.hoursVolunteered,
      required this.isVerified,
      required this.latitude,
      required this.locality,
      required this.administrativeArea,
      required this.longitude,
      required this.postalCode,
      required this.rating,
      required this.street,
      required this.sublocality,
      required this.time,
      required this.timeStamp,
      required this.uid,
      required this.docID})
      : super(key: key);
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
  @override
  State<InProgressActions> createState() => _InProgressActionsState();
}

class _InProgressActionsState extends State<InProgressActions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.secondary,
    );
  }
}
