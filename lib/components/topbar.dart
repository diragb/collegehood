import 'package:collegehood/components/text.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var topBar = (BuildContext context, {bool? beDark}) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              color: (beDark ?? false) ? Colors.black : Colors.white,
              size: 24.0,
              semanticLabel: 'Go Back',
            )),
        InkWell(
            onTap: () {
              Navigator.pushNamed(context, AuthRoutes.profile);
            },
            child: Icon(
              Icons.person,
              color: (beDark ?? false) ? Colors.black : Colors.white,
              size: 24.0,
              semanticLabel: 'Profile',
            )),
      ],
    );

var profileTopBar = (BuildContext context, {bool? beDark, bool? isEdit}) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              color: (beDark ?? false) ? Colors.black : Colors.white,
              size: 24.0,
              semanticLabel: 'Go Back',
            )),
        pageTitle((isEdit ?? false) ? 'Edit' : 'Profile'),
        InkWell(
            onTap: () {
              if (isEdit ?? false) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, AuthRoutes.editProfile);
              }
            },
            child: Icon(
              (isEdit ?? false) ? Icons.done : Icons.edit,
              color: (beDark ?? false) ? Colors.black : Colors.white,
              size: 24.0,
              semanticLabel: 'Edit',
            )),
      ],
    );
