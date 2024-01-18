import 'package:ticketing_system/models/user.dart';

class AccountDetailsHints {
  static AccountNameHint name = AccountNameHint();
  static AccountEmailHint email = AccountEmailHint();
  static AccountAddressHint address = AccountAddressHint();
}

class AccountNameHint extends _UserTypeStrings {
  AccountNameHint()
      : super(
          attendee: "This will be shown to the ticket vendors and event "
              "organizers when you purchase event tickets.",
          organizer: "This will be shown to the public when you create events.",
          ticketVendor: "This will be shown to the public when you sell tickets"
              " for events.",
          sysAdmin: "This will be used as a visual account identifier.",
        );
}

class AccountEmailHint extends _UserTypeStrings {
  AccountEmailHint()
      : super(
          attendee: "This will be used for any communication from us.",
          organizer: "This will be used for any communication regarding events "
              "hosted by you.",
          ticketVendor: "This will be used for any communication regarding "
              "tickets for events that you sell tickets for.",
          sysAdmin: "This will be used for any alerts from the system.",
        );
}

class AccountAddressHint extends _UserTypeStrings {
  AccountAddressHint()
      : super(
          attendee: "This will be used to send any physical tickets that you "
              "have purchased.",
          organizer: "This will be used for any physical ticket being shipped "
              "out by you for our delivery partners.",
          ticketVendor:
              "This will be used for any physical ticket being shipped "
              "out by you for our delivery partners.",
          sysAdmin: "This has no effect for the acccount (as of now).",
        );
}

class _UserTypeStrings {
  final String attendee;
  final String organizer;
  final String ticketVendor;
  final String sysAdmin;

  _UserTypeStrings({
    required this.attendee,
    required this.organizer,
    required this.ticketVendor,
    required this.sysAdmin,
  });

  String text(User user) {
    if (user.type == UserType.attendee) {
      return attendee;
    }
    if (user.type == UserType.organizer) {
      return organizer;
    }
    if (user.type == UserType.ticketVendor) {
      return ticketVendor;
    }
    if (user.type == UserType.sysAdmin) {
      return sysAdmin;
    }
    return "???";
  }
}
