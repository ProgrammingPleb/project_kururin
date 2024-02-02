import 'dart:convert';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ticketing_system/backend/event.dart';
import 'package:ticketing_system/frontend/app_states.dart';
import 'package:ticketing_system/frontend/navbar.dart';
import 'package:ticketing_system/frontend/pages/admin_page.dart';
import 'package:ticketing_system/frontend/pages/event_listings.dart';
import 'package:ticketing_system/frontend/pages/intro.dart';
import 'package:ticketing_system/frontend/pages/ticket_listings.dart';
import 'package:ticketing_system/frontend/pages/user_profile.dart';
import 'package:ticketing_system/frontend/modules/skeletons.dart';
import 'package:ticketing_system/models/app.dart';
import 'package:ticketing_system/models/event.dart';
import 'package:ticketing_system/models/user.dart';

void main() {
  stripe.Stripe.publishableKey = "pk_test_t7b9hRM1sUizVLFKJXDsoAgV";
  runApp(const MyApp());
}

// TODO: Frontend - History, User, Validation, Admin Panel
// TODO: Both Ends - Payment Method (Mock Interface)
// TODO: Database - More data in database (Can include outside events)
// TODO: Ticket Price
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
  final ValueNotifier<ListRefreshData> publicListRefreshListener =
      ValueNotifier(
    ListRefreshData(
      ongoing: true,
      events: [],
    ),
  );
  final ValueNotifier<ListRefreshData> selfListRefreshListener = ValueNotifier(
    ListRefreshData(
      ongoing: true,
      events: [],
    ),
  );

  void gatherEvents() {
    getEventsList().then(
      (eventsListResp) {
        setState(() {
          List<Widget> events = [];
          if (eventsListResp.success) {
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
          publicListRefreshListener.value = ListRefreshData(
            ongoing: false,
            events: events,
          );
        });
      },
    );
  }

  void getUserAccount() {
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
        showIntroPage(prefs: prefs);
      }
    });
  }

  void generatePlaceholderCards() {
    List<Card> dummyCards = [];
    for (int i = 0; i < 3; i++) {
      dummyCards.add(generateCardSkeleton());
    }
    publicListRefreshListener.value = ListRefreshData(
      ongoing: true,
      events: [
        Skeletonizer(
          child: Column(
            children: dummyCards,
          ),
        ),
      ],
    );
  }

  // TODO: Tickets Page
  Widget getQuickActionPage() {
    if (currentUser.value != null) {
      if (currentUser.value!.type == UserType.organizer) {
        return EventListingsPage(
          key: const Key("SelfEventList"),
          refreshListener: selfListRefreshListener,
          user: currentUser.value,
        );
      }
      if (currentUser.value!.type == UserType.sysAdmin) {
        return AdminPanelPage(
          key: const Key("AdminPage"),
          user: currentUser.value!,
        );
      }
      if (currentUser.value!.type == UserType.attendee) {
        return TicketListingPage(
          key: const Key("TicketListPage"),
          user: currentUser.value!,
        );
      }
    }
    return const Column();
  }

  void showIntroPage({SharedPreferences? prefs}) {
    Navigator.of(context)
        .push(
      MaterialPageRoute<User>(
        builder: (context) => const IntroPage(),
      ),
    )
        .then((user) {
      if (mounted) {
        if (user != null) {
          if (prefs != null) {
            prefs.setString(AppSharedPrefKeys.userData, user.toString());
          } else {
            sharedPrefs.then(
              (prefs) {
                prefs.setString(
                  AppSharedPrefKeys.userData,
                  user.toString(),
                );
              },
            );
          }
        }
        setState(() {
          currentUser.value = user;
        });
      }
    });
  }

  @override
  void initState() {
    generatePlaceholderCards();
    super.initState();
    getUserAccount();
    gatherEvents();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> navButtons = [
      const NavigationDestination(
        icon: Icon(Icons.calendar_view_day),
        label: "Events",
      ),
      getQuickNavButton(currentUser.value),
    ];

    if (currentUser.value != null) {
      navButtons.add(
        const NavigationDestination(
          icon: Icon(Icons.account_circle),
          label: "Account",
        ),
      );
    }

    return Scaffold(
      body: [
        // Events Page
        EventListingsPage(
          key: const Key("PublicEventList"),
          refreshListener: publicListRefreshListener,
        ),
        getQuickActionPage(),
        // Profile Page
        UserProfilePage(
          user: currentUser,
          sharedPrefs: sharedPrefs,
          onLogout: () {
            showIntroPage();
            currentPageIndex = 0;
          },
        ),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          int validValue = 0;
          if (currentUser.value != null) {
            validValue = value;
          } else if (value == 1) {
            showIntroPage();
          }
          setState(() {
            currentPageIndex = validValue;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: navButtons,
      ),
    );
  }
}
