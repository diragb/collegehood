// Packages:
import 'package:collegehood/components/bottom_bar.dart';
import 'package:collegehood/components/topbar.dart';
import 'package:collegehood/utils/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widgets:
class ViewEvent extends StatefulWidget {
  const ViewEvent({super.key});

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  bool buttonPressed = false;
  String eventID = '';
  String picture = '', title = '', description = '';
  bool isEventLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeData =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      loadEvent(routeData['eventID'] ?? '');
    });
  }

  loadEvent(String eventID_) async {
    Map<String, dynamic> event = await getEvent(eventID_);
    String _picture =
        'https://images.pexels.com/photos/1749057/pexels-photo-1749057.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
    if (event['picture'] !=
        'https://images.pexels.com/photos/1749057/pexels-photo-1749057.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1') {
      try {
        _picture = await FirebaseStorage.instance
            .ref()
            .child(event['picture'])
            .getDownloadURL();
      } catch (e) {
        _picture = event['picture'];
      }
    }

    setState(() {
      isEventLoaded = true;
      eventID = eventID_;
      picture = _picture;
      title = event['title'];
      description = event['description'];
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
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                topBar(context),
                const SizedBox(
                  height: 50,
                ),
                (isEventLoaded
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
                                ),
                              ),
                            ),
                            Container(
                              height: 220,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(picture),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    child: Column(children: [
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
                                                child: Expanded(
                                                    child: Column(children: [
                                                  Text(
                                                    description,
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
                                                ]))),
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
