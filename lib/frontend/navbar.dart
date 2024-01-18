import 'package:flutter/material.dart';
import 'package:ticketing_system/models/user.dart';

NavigationDestination getQuickNavButton(User? user) {
  if (user != null) {
    if (user.type == UserType.attendee) {
      return const NavigationDestination(
        icon: Icon(Icons.book_online),
        label: "Tickets",
      );
    }
    if (user.type == UserType.organizer) {
      return const NavigationDestination(
        icon: Icon(Icons.edit_calendar),
        label: "Your Events",
      );
    }
    if (user.type == UserType.ticketVendor) {
      return const NavigationDestination(
        icon: Icon(Icons.confirmation_number),
        label: "Event Tickets",
      );
    }
    if (user.type == UserType.sysAdmin) {
      return const NavigationDestination(
        icon: Icon(Icons.admin_panel_settings),
        label: "Admin Panel",
      );
    }
    return const NavigationDestination(
      icon: Icon(Icons.no_accounts),
      label: "???",
    );
  }
  return const NavigationDestination(
    icon: Icon(Icons.confirmation_number),
    label: "Log In",
  );
}
