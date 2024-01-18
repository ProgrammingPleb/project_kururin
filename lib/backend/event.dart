import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ticketing_system/models/event.dart';
import 'package:ticketing_system/backend/utils.dart';
import 'package:http/http.dart' as http;

Future<BackendEventListResponse> getEventsList() async {
  Completer<BackendEventListResponse> c = Completer<BackendEventListResponse>();

  Uri eventListURL = getApiEndpoint("/events/list");
  try {
    http.Response resp = await http.get(eventListURL);
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
  } catch (e) {
    c.complete(
      BackendEventListResponse(
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
