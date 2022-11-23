import 'package:collegehood/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var rebuyItem = (
        {required BuildContext context,
        required bool isOwn,
        required bool isSold,
        required String itemID,
        required String itemPicture,
        required String itemName,
        required String itemDetails,
        required String itemPrice}) =>
    InkWell(
        onTap: () {
          Navigator.pushNamed(context, AuthRoutes.rebuyViewItem,
              arguments: {'itemID': itemID});
        },
        child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSold ? Colors.green[200] : Colors.blue[200],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(itemPicture),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10))),
                  const SizedBox(
                    width: 15,
                  ),
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
                          fontWeight: FontWeight.w600,
                        )),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        itemDetails,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        )),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '₹$itemPrice',
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        )),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      )
                    ],
                  ))
                ],
              ),
            )));
