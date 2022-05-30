import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:washungrystable/messaging/message.dart';
import 'message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/ui/firebase_animated_list.dart';

class MessageList extends StatefulWidget {
  const MessageList({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.imagePath,
    required this.foodCategory,
    required this.downloadUrl,
    required this.dUid,
    required this.uid,
    required this.docId,
  }) : super(key: key);
  final String firstName;
  final String lastName;
  final String imagePath;
  final String downloadUrl;
  final String foodCategory;
  final String dUid;
  final String uid;
  final String docId;

  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? data;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference userStatus =
        FirebaseDatabase.instance.ref('users/${widget.dUid}/status');
    userStatus.onValue.listen((DatabaseEvent event) async {
      setState(() {
        data = event.snapshot.value.toString();
      });
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color(0xffd4cec1),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.firstName + " " + widget.lastName,
              style: GoogleFonts.poppins(
                color: CustomColors.textColor,
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: data.toString() == "Online"
                        ? Colors.green
                        : const Color(0xfff7f0e1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                data.toString() == "Online"
                    ? Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          'Online',
                          style: GoogleFonts.poppins(
                            color: CustomColors.textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          'Offline',
                          style: GoogleFonts.poppins(
                            color: CustomColors.textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              FontAwesomeIcons.chevronLeft,
              color: CustomColors.textColor,
            ),
          ),
        ),
        actions: <Widget>[
          FirebaseAuth.instance.currentUser!.uid == widget.uid
              ? Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: GestureDetector(
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('donations')
                          .doc(widget.docId)
                          .set(
                        {
                          'status': 'Completed',
                        },
                        SetOptions(merge: true),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Icon(
                        FontAwesomeIcons.circleCheck,
                        color: CustomColors.textColor,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      backgroundColor: CustomColors.secondary,
      body: Column(
        children: [
          _getMessageList(),
          Container(
            color: const Color(0xffd4cec1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                //   flex: 2,
                //   child: IconButton(
                //     color: CustomColors.textColor,
                //     icon: const Icon(
                //       FontAwesomeIcons.image,
                //       size: 40,
                //     ),
                //     onPressed: () {
                //       _sendMessage();
                //     },
                //   ),
                // ),
                Expanded(
                  flex: 11,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        color: CustomColors.textColor,
                      ),
                      controller: _messageController,
                      cursorColor: CustomColors.textColor,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.all(20),
                        labelText: 'Enter message',
                        labelStyle:
                            GoogleFonts.poppins(color: CustomColors.textColor),
                        focusColor: CustomColors.textColor,
                        fillColor: CustomColors.textColor,
                        hoverColor: CustomColors.textColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(
                            width: 3,
                            color: CustomColors.textColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(
                              width: 3, color: CustomColors.textColor),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    color: _canSendMessage()
                        ? Colors.green
                        : CustomColors.textColor,
                    icon: const Icon(
                      FontAwesomeIcons.caretRight,
                      size: 30,
                    ),
                    onPressed: () {
                      _sendMessage();
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _scrollToBottom());
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _sendMessage() {
    if (_canSendMessage()) {
      final message =
          Message(_messageController.text, DateTime.now(), 'ee', "eee");
      FirebaseDatabase.instance
          .ref("messages/${widget.imagePath}")
          .push()
          .set(message.toJson());
      _messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      setState(() {});
    }
  }

  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        query: FirebaseDatabase.instance.ref("messages/${widget.imagePath}"),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          return MessageWidget(message.text, message.date, message.uid);
        },
      ),
    );
  }

  bool _canSendMessage() =>
      _messageController.text.isNotEmpty &&
      _messageController.text.trim().isNotEmpty == true;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
