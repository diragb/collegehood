import 'package:collegehood/components/bottom_bar.dart';
import 'package:collegehood/components/rebuy_item.dart';
import 'package:collegehood/components/text.dart';
import 'package:collegehood/components/topbar.dart';
import 'package:collegehood/utils/database.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RebuyMyListings extends StatefulWidget {
  const RebuyMyListings({super.key});

  @override
  State<RebuyMyListings> createState() => _RebuyMyListingsState();
}

class _RebuyMyListingsState extends State<RebuyMyListings> {
  String username = '';
  Iterable<Map<String, dynamic>> items = [];
  bool areItemsLoaded = false;
  bool noItems = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          setState(() {
            username = user.displayName ?? '';
          });
          loadItems();
        } else {
          Navigator.pushNamed(context, PublicRoutes.login);
        }
      });
    });
  }

  loadItems() async {
    List<Map<String, dynamic>> fetchedItems = await getUsersItems(username);
    List<Map<String, dynamic>> finalItems = [];
    for (var fetchedItem in fetchedItems) {
      bool isOwn = username == fetchedItem['username'];
      String photoURL =
          'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Z2lmdHxlbnwwfHwwfHw%3D&w=1000&q=80';
      if (fetchedItem['photoURL'] !=
          'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Z2lmdHxlbnwwfHwwfHw%3D&w=1000&q=80') {
        try {
          photoURL = await FirebaseStorage.instance
              .ref()
              .child(fetchedItem['photoURL'])
              .getDownloadURL();
        } catch (e) {
          photoURL = fetchedItem['photoURL'];
        }
      }
      finalItems.add({
        'inkwell': rebuyItem(
            context: context,
            isOwn: isOwn,
            isSold: fetchedItem['isSold'] ?? false,
            itemDetails: fetchedItem['itemDetail'] ?? '',
            itemID: fetchedItem['itemID'] ?? '',
            itemName: fetchedItem['itemName'] ?? '',
            itemPicture: photoURL,
            itemPrice: fetchedItem['itemPrice'] ?? ''),
        'itemID': fetchedItem['itemID']
      });
    }

    setState(() {
      areItemsLoaded = true;
      noItems = finalItems.isEmpty;
      items = finalItems;
    });
  }

  Iterable<dynamic> conditionalItems(bool isFetched, bool isEmpty) {
    if (isFetched) {
      if (isEmpty) {
        return [
          Column(
            children: [
              const SizedBox(height: 20),
              Text('No items to show',
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ))),
              const SizedBox(height: 20)
            ],
          )
        ];
      } else {
        return items.map((item) => Column(
              children: [
                item['inkwell'],
                const SizedBox(height: 10),
                InkWell(
                    onTap: () {
                      deleteItem(itemID: item['itemID'], username: username);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: Text('Delete',
                              style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              )))),
                    )),
                const SizedBox(height: 20)
              ],
            ));
      }
    } else {
      return [
        Column(
          children: [
            const SizedBox(height: 20),
            Text('Loading...',
                style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ))),
            const SizedBox(height: 20)
          ],
        )
      ];
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
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Column(children: [
                          const SizedBox(
                            height: 20,
                          ),
                          topBar(context),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [pageTitle('My Listings')]),
                          const SizedBox(
                            height: 15,
                          ),
                          ...conditionalItems(areItemsLoaded, noItems),
                        ]))))));
  }
}
