// Packages:
import 'package:collegehood/utils/routes.dart';
import 'package:flutter/material.dart';

// Widgets:
var rebuyBottomBar = (BuildContext context) => BottomAppBar(
      color: Colors.black,
      elevation: 0,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(10.0),
              bottomLeft: Radius.circular(0.0)),
        ),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AuthRoutes.rebuyExplore);
                      },
                      child: const Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                        size: 35.0,
                        semanticLabel: 'Home',
                      )),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AuthRoutes.rebuyAdd);
                      },
                      child: const Icon(
                        Icons.add_circle_rounded,
                        color: Colors.white,
                        size: 35.0,
                        semanticLabel: 'Add',
                      )),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AuthRoutes.rebuyChats);
                      },
                      child: const Icon(
                        Icons.chat_bubble,
                        color: Colors.white,
                        size: 35.0,
                        semanticLabel: 'Chat',
                      ))
                ])),
      ),
    );

var eventsBottomBar = (BuildContext context) => BottomAppBar(
      color: Colors.black,
      elevation: 0,
      child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(0.0)),
          ),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AuthRoutes.eventsAdd);
                        },
                        child: const Icon(
                          Icons.add_circle_rounded,
                          color: Colors.white,
                          size: 35.0,
                          semanticLabel: 'Add',
                        )),
                  ]))),
    );
