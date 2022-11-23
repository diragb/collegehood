import 'package:collegehood/components/input.dart';
import 'package:collegehood/components/text.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:flutter/material.dart';

class AddedItem extends StatefulWidget {
  const AddedItem({super.key});

  @override
  State<AddedItem> createState() => _AddedItemState();
}

class _AddedItemState extends State<AddedItem> {
  bool buttonPressed = false;
  bool isEventsRedirect = false;
  String itemID = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeData =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      setState(() {
        isEventsRedirect = routeData['isEventsRedirect'];
        itemID = routeData['itemID'];
      });
      delay();
    });
  }

  delay() async {
    await Future.delayed(const Duration(seconds: 3));
    goAhead();
  }

  goAhead() {
    Navigator.pushNamed(context,
        isEventsRedirect ? AuthRoutes.eventView : AuthRoutes.rebuyViewItem,
        arguments: {'itemID': itemID});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.black,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            pageTitle('Thank You!'),
            const SizedBox(height: 10),
            Icon(
              Icons.favorite,
              color: Colors.pink[300],
              size: 24.0,
              semanticLabel: 'Heart',
            ),
            const SizedBox(height: 10),
            pageSubtitle('Successfully posted!'),
            const SizedBox(height: 10),
            button(
              'Continue',
              buttonPressed: buttonPressed,
              onTap: () async {
                setState(() {
                  buttonPressed = true;
                });
                await Future.delayed(const Duration(milliseconds: 500));
                setState(() {
                  buttonPressed = false;
                });
                goAhead();
              },
            )
          ]),
        ));
  }
}
