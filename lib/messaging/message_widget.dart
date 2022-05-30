import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../customwidgets.dart';

class MessageWidget extends StatefulWidget {
  final String message;
  final String id;
  final DateTime date;

  const MessageWidget(this.message, this.date, this.id, {Key? key})
      : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool showDate = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Align(
        alignment: widget.id == FirebaseAuth.instance.currentUser!.uid
            ? Alignment.bottomRight
            : Alignment.bottomLeft,
        child: Padding(
          padding: widget.id == FirebaseAuth.instance.currentUser!.uid
              ? const EdgeInsets.only(right: 20)
              : const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () {
              setState(() {
                showDate == false ? showDate = true : showDate = false;
              });
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Column(
                children: [
                  Align(
                    alignment:
                        widget.id == FirebaseAuth.instance.currentUser!.uid
                            ? Alignment.bottomRight
                            : Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color:
                            widget.id == FirebaseAuth.instance.currentUser!.uid
                                ? CustomColors.primary
                                : const Color(0xff5c6ce7),
                      ),
                      child: Wrap(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.message,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  showDate
                      ? Align(
                          alignment: widget.id ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft,
                          child: Padding(
                            padding: widget.id ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? const EdgeInsets.only(right: 0)
                                : const EdgeInsets.only(left: 0),
                            child: Text(
                              DateFormat('MM-dd-yyyy, hh:mm a')
                                  .format(widget.date)
                                  .toString(),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
