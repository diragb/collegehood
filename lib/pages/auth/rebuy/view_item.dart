// Packages:
import 'package:collegehood/components/bottom_bar.dart';
import 'package:collegehood/components/input.dart';
import 'package:collegehood/components/topbar.dart';
import 'package:collegehood/utils/database.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// Widgets:
class RebuyViewItem extends StatefulWidget {
  const RebuyViewItem({super.key});

  @override
  State<RebuyViewItem> createState() => _RebuyViewItemState();
}

class _RebuyViewItemState extends State<RebuyViewItem> {
  String username = '';
  bool buttonPressed = false;
  String itemID = '';
  String photoURL = '',
      itemName = '',
      itemDetail = '',
      itemPrice = '',
      itemDescription = '',
      sellerPhone = '';
  bool isSold = false;
  String userProfilePicture = '', sellerUsername = '', userDetails = '';
  bool isItemLoaded = false;

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
          loadItem(routeData['itemID'] ?? '');
        } else {
          Navigator.pushNamed(context, PublicRoutes.login);
        }
      });
    });
  }

  loadItem(String itemID_) async {
    Map<String, dynamic> item = await getItem(itemID_);
    if (item['username'] is! String) {
      return;
    }
    String _photoURL =
        'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Z2lmdHxlbnwwfHwwfHw%3D&w=1000&q=80';
    if (item['photoURL'] !=
        'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Z2lmdHxlbnwwfHwwfHw%3D&w=1000&q=80') {
      try {
        _photoURL = await FirebaseStorage.instance
            .ref()
            .child(item['photoURL'])
            .getDownloadURL();
      } catch (e) {
        _photoURL = item['photoURL'];
      }
    }

    Map<String, dynamic> user = await getUserDetails(item['username']);
    setState(() {
      isItemLoaded = true;
      itemID = itemID_;
      photoURL = _photoURL;
      itemName = item['itemName'] ?? '';
      itemDetail = item['itemDetail'] ?? '';
      itemPrice = item['itemPrice'] ?? '';
      itemDescription = item['itemDescription'] ?? '';
      sellerUsername = item['username'] ?? '';
      isSold = item['isSold'] ?? false;
      userProfilePicture = user['userProfilePicture'] ?? '';
      userDetails = user['userDetails'] ?? '';
      sellerPhone = user['phone'] ?? '000';
    });
  }

  makePhoneCall(String phone) async {
    if (await canLaunchUrl('tel:$phone' as Uri)) {
      await launchUrl('tel:$phone' as Uri);
    } else {
      throw 'Could not launch tel:$phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: rebuyBottomBar(context),
        body: Material(
            color: Colors.black,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                topBar(context),
                const SizedBox(
                  height: 50,
                ),
                (isItemLoaded
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(children: [
                            SizedBox(
                              height: 60,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          userProfilePicture),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40))),
                                          const SizedBox(
                                            width: 7.5,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(sellerUsername,
                                                  style: GoogleFonts.montserrat(
                                                      textStyle:
                                                          const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ))),
                                              Text(userDetails,
                                                  style: GoogleFonts.montserrat(
                                                      textStyle: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  )))
                                            ],
                                          )
                                        ],
                                      ),
                                      Icon(
                                        Icons.more_vert,
                                        color: Colors.grey[700],
                                        size: 20.0,
                                        semanticLabel: 'More',
                                      )
                                    ],
                                  )),
                            ),
                            Container(
                              height: 220,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(photoURL),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    child: Column(children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  itemName,
                                                  style: GoogleFonts.montserrat(
                                                      textStyle:
                                                          const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                ),
                                                Text(
                                                  itemDetail,
                                                  style: GoogleFonts.montserrat(
                                                      textStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                )
                                              ],
                                            )),
                                            Text('₹$itemPrice',
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey[900],
                                                  fontWeight: FontWeight.w500,
                                                )))
                                          ]),
                                      const SizedBox(height: 10),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blueGrey[50],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15.0,
                                                        horizontal: 15.0),
                                                child: Column(children: [
                                                  Text(
                                                    itemDescription,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            textStyle:
                                                                const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    )),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 5,
                                                    softWrap: true,
                                                  ),
                                                  const SizedBox(height: 30),
                                                  (sellerUsername == username
                                                      ? const SizedBox(
                                                          height: 1)
                                                      : button('Contact Seller',
                                                          buttonPressed:
                                                              buttonPressed,
                                                          onTap: () async {
                                                          setState(() {
                                                            buttonPressed =
                                                                true;
                                                          });
                                                          await Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      500));
                                                          setState(() {
                                                            buttonPressed =
                                                                false;
                                                          });
                                                          Navigator.pushNamed(
                                                              context,
                                                              AuthRoutes
                                                                  .rebuyConversation,
                                                              arguments: {
                                                                'username':
                                                                    sellerUsername
                                                              });
                                                        }))
                                                ])),
                                          ))
                                    ])))
                          ]),
                        ))
                    : Text('Loading...',
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        )))),
              ]),
            )));
  }
}
