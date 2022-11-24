import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegehood/components/input.dart';
import 'package:collegehood/utils/database.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var message = ({
  required String message,
  required bool isMe,
}) =>
    Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Container(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
                color: isMe ? Colors.blueGrey : Colors.blue,
                borderRadius: BorderRadius.circular(40)),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  message,
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )),
                  softWrap: true,
                )),
          ),
        ));

class RebuyConversation extends StatefulWidget {
  const RebuyConversation({super.key});

  @override
  State<RebuyConversation> createState() => _RebuyConversationState();
}

class _RebuyConversationState extends State<RebuyConversation> {
  String username = '', messageValue = '', to = '', chattID = '';
  List messages = [];
  String theirPicture =
          'https://i.pinimg.com/originals/0a/53/c3/0a53c3bbe2f56a1ddac34ea04a26be98.jpg',
      theirDescription = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          setState(() {
            username = user.displayName ?? '';
          });
          final routeData =
              ModalRoute.of(context)?.settings.arguments as Map<String, String>;
          if (routeData['username'] != null) {
            handleLoadConvoFromUsername(routeData['username'] as String);
          } else if (routeData['chatID'] != null) {
            simpleLoadConvoFromChatID(routeData['chatID'] as String);
          } else {
            handleLoadConvoFromUsername('anon');
          }
        } else {
          Navigator.pushNamed(context, PublicRoutes.login);
        }
      });
    });
  }

  handleLoadConvoFromUsername(String username2) async {
    var fetchedMessages =
        await loadConversationFromUsername(username, username2);
    fetchedMessages.sort((a, b) =>
        a['timestamp'].toString().compareTo(b['timestamp'].toString()));
    print(fetchedMessages.length);
    Map<String, dynamic> user = await getUserDetails(username2);
    setState(() {
      to = username2;
      messages = fetchedMessages.whereType<Map>().toList();
      theirPicture = user['userProfilePicture'];
      theirDescription = user['userDetails'];
    });
  }

  simpleLoadConvoFromChatID(String chatID) async {
    // NOTE: Hopefully this is NEVER called.
    List<dynamic> fetchedMessages = await loadConversationFromChatID(chatID);
    setState(() {
      chattID = chatID;
      messages = fetchedMessages.whereType<Map>().toList();
    });
  }

  handleSendMessage(String message) async {
    if (chattID != '') {
      sendMessageCID(username, chattID, message);
    } else {
      sendMessage(username, to, message);
    }
    var newMessages = messages;
    newMessages.add({
      'message': message,
      'name': username,
      'timestamp': Timestamp.now().millisecondsSinceEpoch
    });
    setState(() {
      messages = newMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue,
            flexibleSpace: SafeArea(
                child: Container(
                    child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                children: [
                  Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                              image: NetworkImage(theirPicture),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(30))),
                  const SizedBox(width: 10),
                  Text(to,
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      )))
                ],
              ),
            )))),
        body: Material(
            color: Colors.black,
            child: SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height - 140,
                              child: SingleChildScrollView(
                                  reverse: true,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      child: Column(children: [
                                        ...[
                                          ...messages.map((messageObj) =>
                                              Column(
                                                children: [
                                                  message(
                                                      isMe:
                                                          messageObj['name'] ==
                                                              username,
                                                      message: messageObj[
                                                          'message']),
                                                  const SizedBox(height: 2)
                                                ],
                                              ))
                                        ],
                                      ])))),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(0.0),
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(0.0)),
                                ),
                                child:
                                    input('Send message..', onChanged: (value) {
                                  setState(() {
                                    messageValue = value;
                                  });
                                }, onFieldSubmitted: (message) async {
                                  handleSendMessage(message);
                                })),
                          )
                        ])))));
  }
}
