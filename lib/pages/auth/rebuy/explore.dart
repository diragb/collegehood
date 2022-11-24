// Packages:
import 'package:collegehood/components/bottom_bar.dart';
import 'package:collegehood/components/input.dart';
import 'package:collegehood/components/text.dart';
import 'package:collegehood/components/topbar.dart';
import 'package:collegehood/utils/database.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widgets:
var tag = (String name,
        {required String currentKey,
        required String myKey,
        required void Function(String tag) onTapCallback}) =>
    InkWell(
        onTap: () {
          if (currentKey == myKey) {
            onTapCallback('');
          } else {
            onTapCallback(myKey);
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: currentKey == myKey ? Colors.blue[700] : Colors.blueGrey[700],
          child: SizedBox(
            width: 100.0,
            height: 40.0,
            child: Center(
                child: Text(name,
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    )))),
          ),
        ));

var cardItem = (
        {required BuildContext context,
        required String username,
        required String userProfilePicture,
        required String userDetails,
        required String photoURL,
        required String itemID,
        required String itemName,
        required String itemPrice,
        required String itemDetail,
        required bool isLiked,
        required void Function(String itemID) handleLikeItem}) =>
    InkWell(
        onTap: () {
          Navigator.pushNamed(context, AuthRoutes.rebuyViewItem,
              arguments: {'itemID': itemID});
        },
        onDoubleTap: () {
          handleLikeItem(itemID);
        },
        child: Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(children: [
            SizedBox(
              height: 60,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(userProfilePicture),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(40))),
                          const SizedBox(
                            width: 7.5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(username,
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
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
                      image: NetworkImage(photoURL), fit: BoxFit.cover)),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.favorite_rounded,
                      color: isLiked ? Colors.pink[300] : Colors.white,
                      size: 30.0,
                      semanticLabel: 'Liked Items',
                    ),
                  )),
            ),
            SizedBox(
                height: 70,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                itemName,
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
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
                        ])))
          ]),
        ));

class RebuyExplore extends StatefulWidget {
  const RebuyExplore({super.key});

  @override
  State<RebuyExplore> createState() => _RebuyExploreState();
}

class _RebuyExploreState extends State<RebuyExplore> {
  String username = '';
  String filterKey = '';
  Iterable<Map<String, dynamic>> itemDetails = [];
  Iterable<InkWell> items = [];
  bool areItemsFetched = false;

  void setFilterKey(String key) {
    setState(() {
      filterKey = key;
    });
  }

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

  handleLikeItem(String itemID) {
    Iterable<Map<String, dynamic>> modifiedItemDetails =
        itemDetails.map((item) {
      if (item['itemID'] == itemID) {
        if (item['isLiked']) {
          unlikeItem(itemID: item['itemID'], username: username);
        } else {
          likeItem(itemID: item['itemID'], username: username);
        }
        return {
          ...item,
          'isLiked': !item['isLiked'],
        };
      }
      return item;
    });

    setState(() {
      itemDetails = modifiedItemDetails;
      items = modifiedItemDetails.map((fetchedItem) => cardItem(
          context: context,
          isLiked: fetchedItem['isLiked'] ?? false,
          itemID: fetchedItem['itemID'] ?? '',
          handleLikeItem: handleLikeItem,
          itemDetail: fetchedItem['itemDetail'] ?? '',
          itemName: fetchedItem['itemName'] ?? '',
          itemPrice: fetchedItem['itemPrice'] ?? '',
          photoURL: fetchedItem['photoURL'] ?? '',
          userDetails: fetchedItem['userDetails'] ?? '',
          userProfilePicture: fetchedItem['userProfilePicture'] ?? '',
          username: fetchedItem['username'] ?? ''));
    });
  }

  bool isLikedByUser(Iterable<dynamic> likedBy, String username) {
    return likedBy.contains(username);
  }

  loadItems() async {
    // Iterable<Map<String, dynamic>> fetchedItems = [
    //   {
    //     'isLiked': false,
    //     'itemID': '1',
    //     'itemDetail': 'From Lenskart | Year 2020',
    //     'itemName': 'Transparent Frame',
    //     'itemPrice': '150',
    //     'photoURL': 'assets/images/publiclandingbackground.jpeg',
    //     'userDetails': '3rd Year, SET',
    //     'userProfilePicture': 'assets/images/publiclandingbackground.jpeg',
    //     'username': 'tsingh'
    //   },
    //   {
    //     'isLiked': false,
    //     'itemID': '2',
    //     'itemDetail': 'From Lenskart | Year 2020',
    //     'itemName': 'Transparent Frame',
    //     'itemPrice': '150',
    //     'photoURL': 'assets/images/publiclandingbackground.jpeg',
    //     'userDetails': '3rd Year, SET',
    //     'userProfilePicture': 'assets/images/publiclandingbackground.jpeg',
    //     'username': 'jsingh'
    //   }
    // ];

    var fetchedItems = await loadRebuyItems();
    List<Map<String, dynamic>> finalItems = [];
    fetchedItems =
        fetchedItems.where((element) => element['username'] != username);
    for (var fetchedItem in fetchedItems) {
      var userDetails = await getUserDetails(fetchedItem['username']);
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
        ...fetchedItem,
        ...userDetails,
        'isLiked': isLikedByUser(fetchedItem['likedBy'], username),
        'photoURL': photoURL
      });
    }

    setState(() {
      areItemsFetched = true;
      itemDetails = finalItems;
      items = finalItems.map((fetchedItem) => cardItem(
          context: context,
          isLiked: fetchedItem['isLiked'] ?? false,
          itemID: fetchedItem['itemID'] ?? '',
          handleLikeItem: handleLikeItem,
          itemDetail: fetchedItem['itemDetail'] ?? '',
          itemName: fetchedItem['itemName'] ?? '',
          itemPrice: fetchedItem['itemPrice'] ?? '',
          photoURL: fetchedItem['photoURL'] ?? '',
          userDetails: fetchedItem['userDetails'] ?? '',
          userProfilePicture: fetchedItem['userProfilePicture'] ?? '',
          username: fetchedItem['username'] ?? ''));
    });
  }

  conditionalItems(bool isFetched) {
    if (isFetched) {
      return items.map((item) => Column(
            children: [item, const SizedBox(height: 20)],
          ));
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
    return WillPopScope(
        child: Scaffold(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      pageTitle('Explore'),
                                      InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                AuthRoutes.rebuyLikedItems);
                                          },
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.pink[300],
                                            size: 24.0,
                                            semanticLabel: 'Liked Items',
                                          ))
                                    ]),
                                const SizedBox(
                                  height: 10,
                                ),
                                input('Search for books, guitars, and more..'),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                    height: 40,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        tag('Books',
                                            currentKey: filterKey,
                                            myKey: 'book',
                                            onTapCallback: setFilterKey),
                                        tag('Games',
                                            currentKey: filterKey,
                                            myKey: 'game',
                                            onTapCallback: setFilterKey),
                                        tag('Music',
                                            currentKey: filterKey,
                                            myKey: 'music',
                                            onTapCallback: setFilterKey),
                                        tag('Camera',
                                            currentKey: filterKey,
                                            myKey: 'camera',
                                            onTapCallback: setFilterKey),
                                      ],
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                ...conditionalItems(areItemsFetched),
                              ],
                            )))))),
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(
              context, AuthRoutes.landing, (route) => false);
          return false;
        });
  }
}
