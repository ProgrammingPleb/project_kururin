import 'package:flutter/material.dart';
import 'package:ticketing_system/backend/payment.dart';
import 'package:ticketing_system/models/payment.dart';
import 'package:ticketing_system/models/user.dart';

class AdminPanelPage extends StatefulWidget {
  final User user;

  const AdminPanelPage({super.key, required this.user});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  late Payment paymentData;
  bool paymentReady = false;
  int paymentValue = 69;

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            children: [
              FilledButton(
                onPressed: () async {
                  PaymentBackendResponse resp = await getPaymentData(
                    amount: paymentValue,
                    user: widget.user,
                  );
                  if (resp.success) {
                    paymentData = resp.data!;
                    setState(() {
                      paymentReady = true;
                    });
                  } else {
                    showErrorSnackbar(resp.message!);
                  }
                },
                child: const Text("Prep Payment Sheet"),
              ),
              FilledButton(
                onPressed: paymentReady
                    ? () async {
                        await paymentData.initPaymentSheet();
                        await paymentData.showPaymentSheet();
                        setState(() {
                          paymentReady = false;
                        });
                      }
                    : null,
                child: const Text("Show Payment Sheet"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
