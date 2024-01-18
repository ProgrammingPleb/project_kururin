import 'dart:convert';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ticketing_system/backend/event.dart';
import 'package:ticketing_system/frontend/app_states.dart';
import 'package:ticketing_system/frontend/navbar.dart';
import 'package:ticketing_system/frontend/pages/event_listings.dart';
import 'package:ticketing_system/frontend/pages/login.dart';
import 'package:ticketing_system/frontend/pages/user_profile.dart';
import 'package:ticketing_system/frontend/modules/skeletons.dart';
import 'package:ticketing_system/models/app.dart';
import 'package:ticketing_system/models/event.dart';
import 'package:ticketing_system/models/user.dart';

void main() {
  stripe.Stripe.publishableKey = "pk_test_t7b9hRM1sUizVLFKJXDsoAgV";
  runApp(const MyApp());
}

// TODO: Frontend - History, User
// TODO: Both Ends - Payment Method
// TODO: Database - More data in database
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String appName = "Project Kururin";

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          title: appName,
          theme: ThemeData(
            colorScheme: lightColorScheme ??
                ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ??
                ColorScheme.fromSeed(
                  seedColor: Colors.deepPurple,
                  brightness: Brightness.dark,
                ),
          ),
          home: MyHomePage(title: appName),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  final ValueNotifier<User?> currentUser = ValueNotifier(null);
  int currentPageIndex = 0;
  List<Widget> events = [];
  final ValueNotifier<ListRefreshData> refreshListener = ValueNotifier(
    ListRefreshData(
      ongoing: true,
      events: [],
    ),
  );

  @override
  void initState() {
    List<Card> dummyCards = [];
    for (int i = 0; i < 3; i++) {
      dummyCards.add(generateCardSkeleton());
    }
    events.add(
      Skeletonizer(
        child: Column(
          children: dummyCards,
        ),
      ),
    );
    super.initState();
    sharedPrefs.then((prefs) {
      if (prefs.containsKey(AppSharedPrefKeys.userData)) {
        if (mounted) {
          setState(() {
            currentUser.value = User.fromJson(
              jsonDecode(prefs.getString(AppSharedPrefKeys.userData)!),
            );
          });
        }
      } else {
        Navigator.of(context)
            .push<User>(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        )
            .then(
          (user) {
            if (mounted) {
              setState(() {
                currentUser.value = user!;
                prefs.setString(AppSharedPrefKeys.userData, user.toString());
              });
            }
          },
        );
      }
    });
    getEventsList().then(
      (eventsListResp) {
        setState(() {
          if (eventsListResp.success) {
            events = [];
            for (Event event in eventsListResp.events) {
              events.add(event.card);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  eventsListResp.errorMessage!,
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          print("Listing fetch done!");
          refreshListener.value = ListRefreshData(
            ongoing: false,
            events: events,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        // Events Page
        EventListingsPage(
          events: events,
          refreshListener: refreshListener,
        ),
        // TODO: Tickets Page
        const Column(),
        // Profile Page
        UserProfilePage(
          user: currentUser,
          sharedPrefs: sharedPrefs,
          onLogout: () {
            Navigator.of(context)
                .push<User>(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            )
                .then((user) {
              if (mounted) {
                setState(() {
                  currentUser.value = user!;
                });
              }
            });
          },
        ),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            currentPageIndex = value;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.calendar_view_day),
            label: "Events",
          ),
          getQuickNavButton(currentUser.value),
          const NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
