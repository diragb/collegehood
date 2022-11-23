import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegehood/components/input.dart';
import 'package:collegehood/utils/database.dart';
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
                color: isMe ? Colors.blue[600] : Colors.blue,
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
        }
      });
    });
  }

  handleLoadConvoFromUsername(String username2) async {
    List<dynamic> fetchedMessages =
        await loadConversationFromUsername(username, username2);
    setState(() {
      to = username2;
      messages = fetchedMessages.whereType<Map>().toList();
    });
  }

  simpleLoadConvoFromChatID(String chatID) async {
    List<dynamic> fetchedMessages = await loadConversationFromChatID(chatID);
    setState(() {
      chattID = chatID;
      messages = fetchedMessages.whereType<Map>().toList();
    });
  }

  handleSendMessage(String message) async {
    setState(() {
      messageValue = '';
    });
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
        bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            elevation: 0,
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
                child: input('Send message..', onChanged: (value) {
                  setState(() {
                    messageValue = value;
                  });
                }, onFieldSubmitted: (message) async {
                  handleSendMessage(message);
                }))),
        body: Material(
            color: Colors.black,
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Column(children: [
                          ...[
                            ...messages.map((messageObj) => Column(
                                  children: [
                                    message(
                                        isMe: messageObj['name'] == username,
                                        message: messageObj['message']),
                                    const SizedBox(height: 20)
                                  ],
                                ))
                          ],
                        ]))))));
  }
}
