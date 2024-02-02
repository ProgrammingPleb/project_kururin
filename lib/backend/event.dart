import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:ticketing_system/models/event.dart';
import 'package:ticketing_system/backend/utils.dart';
import 'package:http/http.dart' as http;
import 'package:ticketing_system/models/user.dart';

Future<BackendEventListResponse> getEventsList({User? user}) async {
  Completer<BackendEventListResponse> c = Completer<BackendEventListResponse>();

  http.Response resp;
  try {
    if (user != null) {
      resp = await http.get(
        getApiEndpoint("/events/listSelf"),
        headers: {"User-Id": user.id.toString()},
      );
    } else {
      resp = await http.get(getApiEndpoint("/events/list"));
    }
    BackendEventListResponse eventList =
        BackendEventListResponse.fromJson(jsonDecode(resp.body));
    c.complete(eventList);
  } on SocketException {
    c.complete(
      BackendEventListResponse(
        success: false,
        errorMessage: "You are currently offline.",
      ),
    );
  } catch (e, stackTrace) {
    Logger().e(e.toString(), stackTrace: stackTrace);
    c.complete(
      BackendEventListResponse(
        success: false,
        errorMessage: "An unexpected error has occurred.",
      ),
    );
  }

  return c.future;
}

Future<BackendEventInfoResponse> getEventInfo(int eventID) async {
  Completer<BackendEventInfoResponse> c = Completer<BackendEventInfoResponse>();
  Uri eventListURL = getApiEndpoint("/events/info");
  try {
    http.Response resp = await http.get(
      eventListURL,
      headers: {"Event-Id": eventID.toString()},
    );
    BackendEventInfoResponse eventDetails =
        BackendEventInfoResponse.fromJson(jsonDecode(resp.body));
    c.complete(eventDetails);
  } on SocketException {
    c.complete(
      BackendEventInfoResponse(
        success: false,
        errorMessage: "You are currently offline.",
      ),
    );
  } catch (e) {
    c.complete(
      BackendEventInfoResponse(
        success: false,
        errorMessage: "An unexpected error has occurred.",
      ),
    );
  }

  return c.future;
}

Future<BackendEventTicketsResponse> getEventTickets(
    {required Event event}) async {
  Completer<BackendEventTicketsResponse> c =
      Completer<BackendEventTicketsResponse>();

  http.Response resp;
  try {
    resp = await http.get(
      getApiEndpoint("/events/tickets"),
      headers: {
        "Event-Id": event.eventID.toString(),
      },
    );
    BackendEventTicketsResponse ticketList =
        BackendEventTicketsResponse.fromJson(jsonDecode(resp.body));
    c.complete(ticketList);
  } on SocketException {
    c.complete(
      BackendEventTicketsResponse(
        success: false,
        errorMessage: "You are currently offline.",
      ),
    );
  } catch (e, stackTrace) {
    Logger().e(e.toString(), stackTrace: stackTrace);
    c.complete(
      BackendEventTicketsResponse(
        success: false,
        errorMessage: "An unexpected error has occurred.",
      ),
    );
  }

  return c.future;
}

Future<BackendEventDetailsResponse> getEventDetails(int eventID) async {
  Completer<BackendEventDetailsResponse> c =
      Completer<BackendEventDetailsResponse>();
  Uri eventListURL = getApiEndpoint("/events/details");
  try {
    http.Response resp = await http.get(
      eventListURL,
      headers: {"Event-Id": eventID.toString()},
    );
    BackendEventDetailsResponse eventDetails =
        BackendEventDetailsResponse.fromJson(jsonDecode(resp.body));
    c.complete(eventDetails);
  } on SocketException {
    c.complete(
      BackendEventDetailsResponse(
        success: false,
        errorMessage: "You are currently offline.",
      ),
    );
  } catch (e) {
    c.complete(
      BackendEventDetailsResponse(
        success: false,
        errorMessage: "An unexpected error has occurred.",
      ),
    );
  }

  return c.future;
}
