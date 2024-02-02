import 'dart:convert';
import 'package:ticketing_system/backend/utils.dart';
import 'package:ticketing_system/models/payment.dart';
import 'package:http/http.dart' as http;
import 'package:ticketing_system/models/user.dart';

Future<PaymentBackendResponse> getPaymentData(
    {required int amount, required User user}) async {
  Uri paymentEndpoint = getApiEndpoint("payment-sheet");

  http.Response resp = await http.post(paymentEndpoint, headers: {
    "Amount": amount.toString(),
    "Username": user.username,
    "Password": user.hashedPassword,
  });
  return PaymentBackendResponse.fromJson(jsonDecode(resp.body));
}
