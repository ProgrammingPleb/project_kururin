import 'package:ticketing_system/models/event.dart';

class EventListRefreshStatus {
  bool ongoing;
  bool success;
  BackendEventListResponse? response;

  EventListRefreshStatus({
    required this.ongoing,
    required this.success,
    this.response,
  });
}

class AppSharedPrefKeys {
  static String userData = "UserData";
}
