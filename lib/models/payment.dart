import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class Payment {
  String customer;
  String ephemeralKey;
  String paymentIntent;
  String publishableKey;

  Payment({
    required this.customer,
    required this.ephemeralKey,
    required this.paymentIntent,
    required this.publishableKey,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      customer: json["customer"],
      ephemeralKey: json["ephemeralKey"],
      paymentIntent: json["paymentIntent"],
      publishableKey: json["publishableKey"],
    );
  }

  Future<void> initPaymentSheet() async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        customFlow: false,
        merchantDisplayName: 'Project Kururin',
        paymentIntentClientSecret: paymentIntent,
        customerEphemeralKeySecret: ephemeralKey,
        customerId: customer,
        googlePay: const PaymentSheetGooglePay(
          merchantCountryCode: 'MY',
          testEnv: true,
        ),
        style: ThemeMode.dark,
      ),
    );

    return;
  }

  Future<void> showPaymentSheet() async {
    PaymentSheetPaymentOption? result =
        await Stripe.instance.presentPaymentSheet();
    if (result != null) {
      print(result.toJson());
    }
  }
}

class PaymentBackendResponse {
  bool success;
  String? message;
  Payment? data;

  PaymentBackendResponse({required this.success, this.message, this.data});

  factory PaymentBackendResponse.fromJson(Map<String, dynamic> json) {
    return PaymentBackendResponse(
      success: json["success"],
      message: json["message"],
      data: Payment.fromJson(json["data"]),
    );
  }
}
