// Packages:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegehood/components/bottom_bar.dart';
import 'package:collegehood/components/text.dart';
import 'package:collegehood/components/topbar.dart';
import 'package:collegehood/utils/database.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widgets:
var messageItem = (
        {required BuildContext context,
        required String chatID,
        required String username,
        required String lastMessage,
        required String picture,
        required String sentBy,
        required dynamic timestamp}) =>
    InkWell(
        onTap: () {
          Navigator.pushNamed(context, AuthRoutes.rebuyConversation,
              arguments: {'username': username});
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(children: [
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(picture), fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(40))),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                        username,
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        )),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      SizedBox(height: 2.5),
                      Text(
                        lastMessage,
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        )),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      )
                    ])),
              ])),
        ));

class RebuyChats extends StatefulWidget {
  const RebuyChats({super.key});

  @override
  State<RebuyChats> createState() => _RebuyChatsState();
}

class _RebuyChatsState extends State<RebuyChats> {
  String username = '';
  Iterable<Map<String, dynamic>> chatsDetails = [];
  Iterable<InkWell> chats = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          setState(() {
            username = user.displayName ?? '';
          });
          loadChats();
        } else {
          Navigator.pushNamed(context, PublicRoutes.login);
        }
      });
    });
  }

  loadChats() async {
    var fetchedChats = await loadUsersChats(username);
    List<Map<String, dynamic>> finalChats = [];
    for (var fetchedChat in fetchedChats) {
      String picture =
          'https://i.pinimg.com/originals/0a/53/c3/0a53c3bbe2f56a1ddac34ea04a26be98.jpg';
      if (fetchedChat['picture'] !=
          'https://i.pinimg.com/originals/0a/53/c3/0a53c3bbe2f56a1ddac34ea04a26be98.jpg') {
        try {
          picture = await FirebaseStorage.instance
              .ref()
              .child(fetchedChat['picture'])
              .getDownloadURL();
        } catch (e) {
          picture = fetchedChat['picture'];
        }
      }
      finalChats.add({...fetchedChat, 'picture': picture});
    }

    setState(() {
      chatsDetails = finalChats;
      chats = finalChats.map((chat) => messageItem(
          context: context,
          chatID: chat['chatID'] ?? '',
          username: chat['username'] ?? '',
          lastMessage: chat['lastMessage'] ?? '',
          picture: chat['picture'] ?? '',
          sentBy: chat['sentBy'] ?? '',
          timestamp:
              chat['timestamp'] ?? DateTime.now().millisecondsSinceEpoch));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: rebuyBottomBar(context),
        body: Material(
            color: Colors.black,
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            topBar(context),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  pageTitle('Chats'),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            ...[
                              ...chats.map((item) => Column(
                                    children: [
                                      item,
                                      const SizedBox(height: 20)
                                    ],
                                  ))
                            ],
                          ],
                        ))))));
  }
}
