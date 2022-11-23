import 'package:collegehood/components/bottom_bar.dart';
import 'package:collegehood/components/rebuy_item.dart';
import 'package:collegehood/components/text.dart';
import 'package:collegehood/components/topbar.dart';
import 'package:collegehood/utils/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RebuyLikedItems extends StatefulWidget {
  const RebuyLikedItems({super.key});

  @override
  State<RebuyLikedItems> createState() => _RebuyLikedItemsState();
}

class _RebuyLikedItemsState extends State<RebuyLikedItems> {
  String username = '';
  Iterable<InkWell> items = [];

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
        }
      });
    });
  }

  loadItems() async {
    // List<Map<String, dynamic>> fetchedItems = [
    //   {
    //     'itemID': '',
    //     'isOwn': false,
    //     'isSold': false,
    //     'itemDetails': 'From Lenskart | Year 2020',
    //     'itemName': 'Transparent Frames',
    //     'itemPicture': 'assets/images/publiclandingbackground.jpeg',
    //     'itemPrice': '150'
    //   },
    //   {
    //     'itemID': '',
    //     'isOwn': false,
    //     'isSold': true,
    //     'itemDetails': 'From Lenskart | Year 2020',
    //     'itemName': 'Transparent Frames',
    //     'itemPicture': 'assets/images/publiclandingbackground.jpeg',
    //     'itemPrice': '150'
    //   },
    // ];

    List<Map<String, dynamic>> fetchedItems = await getLikedItems(username);
    List<InkWell> finalItems = [];
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
      finalItems.add(rebuyItem(
          context: context,
          isOwn: isOwn,
          isSold: fetchedItem['isSold'] ?? false,
          itemDetails: fetchedItem['itemDetail'] ?? '',
          itemID: fetchedItem['itemID'] ?? '',
          itemName: fetchedItem['itemName'] ?? '',
          itemPicture: photoURL,
          itemPrice: fetchedItem['itemPrice'] ?? ''));
    }

    setState(() {
      items = finalItems;
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
                              children: [pageTitle('Liked Items')]),
                          const SizedBox(
                            height: 15,
                          ),
                          ...[
                            ...items.map((item) => Column(
                                  children: [item, const SizedBox(height: 20)],
                                ))
                          ],
                        ]))))));
  }
}
