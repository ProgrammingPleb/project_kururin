import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketing_system/backend/event.dart';
import 'package:ticketing_system/exceptions.dart';
import 'package:ticketing_system/frontend/modules/event_card.dart';
import 'package:ticketing_system/frontend/modules/event_details.dart';
import 'package:ticketing_system/models/ticket.dart';

class Event {
  EventDate date;
  String location;
  String name;
  String bannerUrl;
  int eventID;
  EventOrganizer organizer;
  EventDetails? _details;

  Event({
    required this.date,
    required this.location,
    required this.name,
    required this.bannerUrl,
    required this.eventID,
    required this.organizer,
    details,
  }) {
    if (details != null) {
      _details = details;
    }
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      date: EventDate.fromJson(json['date']),
      location: json['location'],
      name: json['name'],
      bannerUrl: json['pictureURL'],
      eventID: json['id'],
      organizer: EventOrganizer.fromJson(json['organizer']),
    );
  }

  EventCard get card {
    return EventCard(key: Key(name), event: this);
  }

  Future<EventDetails> get details {
    Completer<EventDetails> c = Completer();

    if (_details != null) {
      c.complete(_details);
    } else {
      getEventDetails(eventID).then((resp) {
        if (resp.success) {
          _details = resp.details;
          c.complete(resp.details);
        } else {
          c.completeError(BackendFetchError(resp.errorMessage));
        }
      });
    }

    return c.future;
  }
}

class EventDetails {
  String description;
  String location;
  EventTime time;

  EventDetails({
    required this.description,
    required this.location,
    required this.time,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      description: json["description"],
      location: json["location"],
      time: EventTime.fromJson(json["time"]),
    );
  }

  Widget get pageWidgets {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventDetailsLine(title: "Time:", content: time.displayText),
        EventDetailsSection(title: "Location:", content: location),
        EventDetailsSection(title: "Description", content: description),
      ],
    );
  }
}

class EventDate {
  FormattedDate formatted;
  RawDate raw;

  EventDate({required this.formatted, required this.raw});

  factory EventDate.fromJson(Map<String, dynamic> json) {
    return EventDate(
      formatted: FormattedDate(
        start: json['formattedStart'],
        end: json['formattedEnd'],
      ),
      raw: RawDate(
        start: json['rawStart'],
        end: json['rawEnd'],
      ),
    );
  }

  String get displayText {
    String isoStartDate =
        "${raw.start.substring(0, 4)}-${raw.start.substring(4, 6)}-"
        "${raw.start.substring(6, 8)}";
    String isoEndDate = "${raw.end.substring(0, 4)}-${raw.end.substring(4, 6)}-"
        "${raw.end.substring(6, 8)}";

    DateTime startDate = DateTime.parse(isoStartDate);
    DateTime endDate = DateTime.parse(isoEndDate);
    int daysDifference = endDate.difference(startDate).inDays + 1;
    DateFormat monthWord = DateFormat.MMMM();

    if (daysDifference > 1) {
      if (startDate.month != endDate.month) {
        return "${startDate.day} ${monthWord.format(startDate)} - "
            "${endDate.day} ${monthWord.format(endDate)} "
            "($daysDifference ${properDayWord(daysDifference)})";
      }
      return "${startDate.day} - ${endDate.day} ${monthWord.format(endDate)} "
          "($daysDifference ${properDayWord(daysDifference)})";
    }
    return "${startDate.day} ${monthWord.format(endDate)}";
  }
}

class FormattedDate {
  String start;
  String end;

  FormattedDate({required this.start, required this.end});
}

class RawDate {
  String start;
  String end;

  RawDate({required this.start, required this.end});
}

class EventTime {
  FormattedTime formatted;
  RawTime raw;

  EventTime({required this.formatted, required this.raw});

  factory EventTime.fromJson(Map<String, dynamic> json) {
    return EventTime(
      formatted: FormattedTime(
        start: json['formattedStart'],
        end: json['formattedEnd'],
      ),
      raw: RawTime(
        start: json['rawStart'],
        end: json['rawEnd'],
      ),
    );
  }

  String get displayText {
    String isoStartTime =
        "1970-01-01 ${raw.start.substring(0, 2)}:${raw.start.substring(2, 4)}";
    String isoEndTime =
        "1970-01-01 ${raw.end.substring(0, 2)}:${raw.end.substring(2, 4)}";
    String resultText = "";

    DateTime startTime = DateTime.parse(isoStartTime);
    DateTime endTime = DateTime.parse(isoEndTime);
    DateFormat timeWithMinuteFormat = DateFormat("h:ma");
    DateFormat timeWithoutMinuteFormat = DateFormat("ha");

    if (startTime.minute != 0) {
      resultText += "${timeWithMinuteFormat.format(startTime)} - ";
    } else {
      resultText += "${timeWithoutMinuteFormat.format(startTime)} - ";
    }

    if (endTime.minute != 0) {
      resultText += timeWithMinuteFormat.format(endTime);
    } else {
      resultText += timeWithoutMinuteFormat.format(endTime);
    }

    return resultText;
  }
}

class FormattedTime {
  String start;
  String end;

  FormattedTime({required this.start, required this.end});
}

class RawTime {
  String start;
  String end;

  RawTime({required this.start, required this.end});
}

class EventOrganizer {
  String name;
  String pictureUrl;

  EventOrganizer({required this.name, required this.pictureUrl});

  factory EventOrganizer.fromJson(Map<String, dynamic> json) {
    return EventOrganizer(name: json['name'], pictureUrl: json['pictureURL']);
  }

  Image loadProfilePicture() {
    return Image.network(pictureUrl);
  }
}

class BackendResponse {
  bool success;
  String? errorMessage;

  BackendResponse({
    required this.success,
    this.errorMessage,
  });
}

class BackendEventListResponse extends BackendResponse {
  List<Event> events;

  BackendEventListResponse({
    required super.success,
    super.errorMessage,
    this.events = const [],
  });

  factory BackendEventListResponse.fromJson(Map<String, dynamic> json) {
    return BackendEventListResponse(
      success: json["success"],
      errorMessage: json.containsKey("msg") ? json["msg"] : null,
      events: List<Event>.from(json['events'].map((x) => Event.fromJson(x))),
    );
  }
}

class BackendEventInfoResponse extends BackendResponse {
  Event? event;

  BackendEventInfoResponse({
    required super.success,
    super.errorMessage,
    this.event,
  });

  factory BackendEventInfoResponse.fromJson(Map<String, dynamic> json) {
    return BackendEventInfoResponse(
      success: json["success"],
      errorMessage: json.containsKey("msg") ? json["msg"] : null,
      event: json.containsKey("info") ? Event.fromJson(json["info"]) : null,
    );
  }
}

class BackendEventDetailsResponse extends BackendResponse {
  EventDetails? details;

  BackendEventDetailsResponse({
    required super.success,
    super.errorMessage,
    this.details,
  });

  factory BackendEventDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BackendEventDetailsResponse(
      success: json["success"],
      errorMessage: json.containsKey("msg") ? json["msg"] : null,
      details: json.containsKey("details")
          ? EventDetails.fromJson(json["details"])
          : null,
    );
  }
}

class BackendEventTicketsResponse extends BackendResponse {
  List<TicketInfo> tickets;

  BackendEventTicketsResponse({
    required super.success,
    super.errorMessage,
    this.tickets = const [],
  });

  factory BackendEventTicketsResponse.fromJson(Map<String, dynamic> json) {
    return BackendEventTicketsResponse(
      success: json["success"],
      errorMessage: json.containsKey("msg") ? json["msg"] : null,
      tickets: List<TicketInfo>.from(
          json['tickets'].map((x) => TicketInfo.fromJson(x))),
    );
  }
}

String properDayWord(int difference) {
  return difference == 1 ? "day" : "days";
}
