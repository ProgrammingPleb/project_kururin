import 'dart:async';
import 'dart:convert';

import 'package:ticketing_system/backend/utils.dart';
import 'package:ticketing_system/models/user.dart';
import 'package:http/http.dart' as http;

Future<UserAuthenticationResponse> loginUser({
  required String username,
  required String password,
}) {
  Completer<UserAuthenticationResponse> c =
      Completer<UserAuthenticationResponse>();

  http.get(
    getApiEndpoint("/login"),
    headers: {
      "Username": username,
      "Password": password,
    },
  ).then((resp) {
    String respBody = resp.body;
    c.complete(UserAuthenticationResponse.fromJson(jsonDecode(respBody)));
  });

  return c.future;
}

Future<UserAuthenticationResponse> validateUser({
  required String username,
  required String hashPassword,
}) {
  Completer<UserAuthenticationResponse> c =
      Completer<UserAuthenticationResponse>();

  http.get(
    getApiEndpoint("/validate"),
    headers: {
      "Username": username,
      "Password": hashPassword,
    },
  ).then((resp) {
    String respBody = resp.body;
    print(respBody);
    c.complete(UserAuthenticationResponse.fromJson(jsonDecode(respBody)));
  });

  return c.future;
}
