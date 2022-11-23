// Packages:
import 'package:collegehood/pages/auth/events/add_event.dart';
import 'package:collegehood/pages/auth/events/all_events.dart';
import 'package:collegehood/pages/auth/events/event.dart';
import 'package:collegehood/pages/auth/rebuy/chats.dart';
import 'package:collegehood/pages/auth/rebuy/conversation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:collegehood/utils/routes.dart';

// Pages:
import 'package:collegehood/pages/auth/added.dart';
import 'package:collegehood/pages/auth/edit_profile.dart';
import 'package:collegehood/pages/auth/landing.dart';
import 'package:collegehood/pages/auth/profile.dart';
import 'package:collegehood/pages/auth/rebuy/add_item.dart';
import 'package:collegehood/pages/auth/rebuy/explore.dart';
import 'package:collegehood/pages/auth/rebuy/liked_items.dart';
import 'package:collegehood/pages/auth/rebuy/my_listings.dart';
import 'package:collegehood/pages/auth/rebuy/view_item.dart';
import 'package:collegehood/pages/public/signup.dart';
import 'package:collegehood/pages/public/landing.dart';
import 'package:collegehood/pages/public/login.dart';

// Widgets:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: PublicRoutes.landing,
      routes: {
        '/': (context) => const PublicLanding(),
        PublicRoutes.landing: (context) => const PublicLanding(),
        PublicRoutes.login: (context) => const Login(),
        PublicRoutes.signup: (context) => const Signup(),
        AuthRoutes.landing: (context) => const AuthLanding(),
        AuthRoutes.profile: (context) => const Profile(),
        AuthRoutes.itemAdded: (context) => const AddedItem(),
        AuthRoutes.editProfile: (context) => const EditProfile(),
        AuthRoutes.rebuyExplore: (context) => const RebuyExplore(),
        AuthRoutes.rebuyLikedItems: (context) => const RebuyLikedItems(),
        AuthRoutes.rebuyMyListings: (context) => const RebuyMyListings(),
        AuthRoutes.rebuyAdd: (context) => const RebuyAddItem(),
        AuthRoutes.rebuyViewItem: (context) => const RebuyViewItem(),
        AuthRoutes.rebuyChats: (context) => const RebuyChats(),
        AuthRoutes.rebuyConversation: (context) => const RebuyConversation(),
        AuthRoutes.eventView: (context) => const ViewEvent(),
        AuthRoutes.eventsAdd: (context) => const EventsAddEvent(),
        AuthRoutes.eventsAll: (context) => const AllEvents(),
      },
    );
  }
}
