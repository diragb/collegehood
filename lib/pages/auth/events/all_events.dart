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
var cardItem = (
        {required BuildContext context,
        required String eventID,
        required String title,
        required String description,
        required String picture}) =>
    InkWell(
        onTap: () {
          Navigator.pushNamed(context, AuthRoutes.eventView,
              arguments: {'eventID': eventID});
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(children: [
            Container(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: SizedBox(
                      child: Text(
                    title,
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    )),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ))),
            ),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(picture), fit: BoxFit.cover)),
            ),
            Container(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: Text(
                      description,
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      )),
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                      softWrap: false,
                    )))
          ]),
        ));

class AllEvents extends StatefulWidget {
  const AllEvents({super.key});

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  String username = '';
  Iterable<Map<String, dynamic>> eventDetails = [];
  Iterable<InkWell> events = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadevents();
    });
  }

  loadevents() async {
    var fetchedEvents = await loadEvents();
    List<Map<String, dynamic>> finalEvents = [];
    for (var fetchedEvent in fetchedEvents) {
      String picture =
          'https://images.pexels.com/photos/1749057/pexels-photo-1749057.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
      if (fetchedEvent['picture'] !=
          'https://images.pexels.com/photos/1749057/pexels-photo-1749057.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1') {
        try {
          picture = await FirebaseStorage.instance
              .ref()
              .child(fetchedEvent['picture'])
              .getDownloadURL();
        } catch (e) {
          picture = fetchedEvent['picture'];
        }
      }
      finalEvents.add({...fetchedEvent, 'picture': picture});
    }

    setState(() {
      eventDetails = finalEvents;
      events = finalEvents.map((event) => cardItem(
          context: context,
          description: event['description'] ?? '',
          eventID: event['eventID'] ?? '',
          picture: event['picture'] ?? '',
          title: event['title'] ?? ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: eventsBottomBar(context),
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
                                  pageTitle('Events'),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            ...[
                              ...events.map((item) => Column(
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
