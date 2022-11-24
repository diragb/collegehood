// Packages:
import 'dart:io';

import 'package:collegehood/components/input.dart';
import 'package:collegehood/components/text.dart';
import 'package:collegehood/components/topbar.dart';
import 'package:collegehood/utils/database.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// Widgets:
class EventsAddEvent extends StatefulWidget {
  const EventsAddEvent({super.key});

  @override
  State<EventsAddEvent> createState() => _EventsAddEventState();
}

class _EventsAddEventState extends State<EventsAddEvent> {
  String username = '';
  ImagePicker? imagePicker;
  String title = '', description = '', picturePath = '';
  var uploadedPicture;
  bool buttonPressed = false;
  List<String> errorPrompts = ['', '', ''];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          username = user.displayName ?? '';
        });
      } else {
        Navigator.pushNamed(context, PublicRoutes.login);
      }
    });
  }

  String processPicturePath(String raw) {
    List<String> components = raw.split('/');
    return components[components.length - 1];
  }

  bool validation() {
    bool isError = false;
    List<String> values = [title, description, picturePath];
    List<String> prompts = ['', '', ''];
    values.asMap().forEach((index, value) {
      if (value.trim() == '') {
        isError = true;
        prompts[index] = 'Field is empty!';
      }
    });
    setState(() {
      errorPrompts = prompts;
    });
    return !isError;
  }

  void submitEvent() async {
    if (!validation()) return;
    String eventID = UniqueKey().toString();
    String eventPictureID = UniqueKey().toString();
    if (uploadedPicture != null) {
      (await FirebaseStorage.instance
          .ref()
          .child(eventPictureID)
          .putFile(uploadedPicture));
    }
    await saveNewEvent(
        eventID: eventID,
        title: title,
        description: description,
        picture: eventPictureID);
    Navigator.pushNamed(context, AuthRoutes.itemAdded,
        arguments: {'itemID': eventID, 'isEventsRedirect': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
            color: Colors.black,
            child: SingleChildScrollView(
                child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                Container(
                    height: 150,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0.0),
                            bottomRight: Radius.circular(40.0),
                            topLeft: Radius.circular(0.0),
                            bottomLeft: Radius.circular(40.0))),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Column(children: [
                          const SizedBox(
                            height: 20,
                          ),
                          topBar(context, beDark: true),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(children: [
                            const Icon(
                              Icons.shopping_cart_rounded,
                              color: Colors.black,
                              size: 24.0,
                              semanticLabel: 'Add Event',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Tell us about the event',
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                )))
                          ])
                        ]))),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Title of the Event',
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ))),
                              const SizedBox(
                                height: 5,
                              ),
                              input('Title', onChanged: (value) {
                                setState(() {
                                  title = value;
                                });
                              }),
                              const SizedBox(
                                height: 7.5,
                              ),
                              errorText(errorPrompts[0]),
                              const SizedBox(
                                height: 7.5,
                              ),
                              Text('Description',
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ))),
                              const SizedBox(
                                height: 5,
                              ),
                              input('Description', onChanged: (value) {
                                setState(() {
                                  description = value;
                                });
                              }, isMultiline: true),
                              const SizedBox(
                                height: 7.5,
                              ),
                              errorText(errorPrompts[1]),
                              const SizedBox(
                                height: 7.5,
                              ),
                              Text('Image',
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ))),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                  onTap: () async {
                                    XFile? image = await imagePicker!.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50,
                                        preferredCameraDevice:
                                            CameraDevice.rear);
                                    if (image != null) {
                                      setState(() {
                                        picturePath = image.path;
                                        uploadedPicture = File(image.path);
                                      });
                                    } else {
                                      setState(() {
                                        picturePath =
                                            'An error occured while selecting the photo';
                                      });
                                    }
                                  },
                                  child: Container(
                                      height: 70,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 15.0),
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                picturePath == ''
                                                    ? 'Upload image(s) of event'
                                                    : processPicturePath(
                                                        picturePath),
                                                style: GoogleFonts.montserrat(
                                                    textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                overflow: TextOverflow.fade,
                                                maxLines: 2,
                                                softWrap: false,
                                              ))))),
                              const SizedBox(
                                height: 7.5,
                              ),
                              errorText(errorPrompts[2]),
                              const SizedBox(
                                height: 7.5,
                              ),
                              authButton('Submit',
                                  isPrimary: true, buttonPressed: buttonPressed,
                                  onTap: () async {
                                setState(() {
                                  buttonPressed = true;
                                });
                                await Future.delayed(
                                    const Duration(milliseconds: 500));
                                setState(() {
                                  buttonPressed = false;
                                });
                                submitEvent();
                              })
                            ]))),
              ]),
            ))));
  }
}
