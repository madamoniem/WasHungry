import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:washungrystable/give_process/add_info.dart';
import 'package:washungrystable/give_process/confirm_dono.dart';
import 'package:washungrystable/userdashboard.dart' as user_dashboard;

class AddLocation extends StatefulWidget {
  AddLocation({Key? key}) : super(key: key);

  @override
  State<AddLocation> createState() => _AddLocationState();
}

enum SingingCharacter { deliver, stay }

SingingCharacter? _character = SingingCharacter.deliver;
String? errorMessage;
bool isEnabled = true;
TextEditingController disNum = TextEditingController();

class _AddLocationState extends State<AddLocation> {
  @override
  void initState() {
    super.initState();
  }

  String? ageValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.secondary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddInfo(),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              AutoSizeText(
                'Delivery',
                maxLines: 2,
                style: TextStyle(
                  color: CustomColors.textColor,
                  fontFamily: "RecoletaB",
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                ),
              ),
              AutoSizeText(
                'Address Details',
                maxLines: 1,
                style: GoogleFonts.poppins(
                  color: CustomColors.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CustomColors.secondary,
                  border: Border.all(
                    width: 3,
                    color: CustomColors.textColor,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25, top: 25, right: 25, bottom: 25),
                  child: user_dashboard.place == null
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: CustomColors.secondary,
                            border: Border.all(
                              width: 3,
                              color: CustomColors.textColor,
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: CustomColors.secondary,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user_dashboard.place!.street} ${user_dashboard.place!.subLocality}, ${user_dashboard.place!.locality}, ${user_dashboard.place!.postalCode}',
                                style: GoogleFonts.poppins(
                                    color: CustomColors.textColor,
                                    fontSize: 20),
                              ),
                              Text(
                                '${user_dashboard.place!.administrativeArea}, ${user_dashboard.place!.country}',
                                style: GoogleFonts.poppins(
                                  color: CustomColors.textColor,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    contentPadding:
                        const EdgeInsets.only(left: 0.0, right: 0.0),
                    textColor: CustomColors.textColor,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Deliver',
                          style: GoogleFonts.poppins(fontSize: 20),
                        ),
                        isEnabled == true
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9]")),
                                            ],
                                            enabled: isEnabled,
                                            textInputAction:
                                                TextInputAction.next,
                                            style: TextStyle(
                                              color: CustomColors.textColor,
                                            ),
                                            controller: disNum,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(20),
                                              labelText: "Distance",
                                              labelStyle: GoogleFonts.poppins(
                                                  color:
                                                      CustomColors.textColor),
                                              focusColor:
                                                  CustomColors.textColor,
                                              fillColor: CustomColors.textColor,
                                              hoverColor:
                                                  CustomColors.textColor,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 3,
                                                  color: CustomColors.textColor,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 3,
                                                    color:
                                                        CustomColors.textColor),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: AutoSizeText(
                                            'Miles From',
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(
                                                color: CustomColors.textColor,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Current Location',
                                      style: GoogleFonts.poppins(
                                          color: CustomColors.secondary,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              )
                            : const Text(
                                'Nothing',
                                style: const TextStyle(fontSize: 0),
                              ),
                      ],
                    ),
                    leading: Radio<SingingCharacter>(
                      fillColor: MaterialStateProperty.all<Color>(
                          CustomColors.textColor),
                      value: SingingCharacter.deliver,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          isEnabled = true;
                          _character = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.only(left: 0.0, right: 0.0),
                    selectedColor: CustomColors.textColor,
                    textColor: CustomColors.textColor,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Stay',
                          style: GoogleFonts.poppins(fontSize: 20),
                        ),
                        isEnabled == false
                            ? Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    Text(
                                      'Donees commute to your location.',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w300,
                                        color: CustomColors.textColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const Text(
                                'Nothing',
                                style: TextStyle(fontSize: 0),
                              ),
                      ],
                    ),
                    leading: Radio<SingingCharacter>(
                      fillColor: MaterialStateProperty.all<Color>(
                          CustomColors.textColor),
                      value: SingingCharacter.stay,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(
                          () {
                            isEnabled = false;

                            _character = value;
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: ButtonTheme(
                      height: 100.0,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isEnabled == true && disNum.text == "") {
                            Fluttertoast.showToast(msg: 'No distance entered');
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ConfirmDono(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: CustomColors.textColor,
                          onPrimary: CustomColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          minimumSize: const Size(double.infinity, 60),
                        ),
                        child: Text(
                          'Next >',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
