import 'package:flutter/material.dart';
import 'package:ticketing_system/backend/user.dart';
import 'package:ticketing_system/frontend/modules/text_fields.dart';
import 'package:ticketing_system/models/user.dart';

class LoginForm extends StatefulWidget {
  final ValueSetter<User> userAccount;

  const LoginForm({super.key, required this.userAccount});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController usernameInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: AutofillGroup(
            child: Column(
              children: [
                SimpleTextFormField(
                  name: "Username",
                  controller: usernameInput,
                  textColor: const Color(0xFF1F1F1F),
                  autofillHints: const [AutofillHints.username],
                ),
                SimpleTextFormField(
                  name: "Password",
                  controller: passwordInput,
                  textColor: const Color(0xFF1F1F1F),
                  autofillHints: const [AutofillHints.password],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Center(
            child: FilledButton(
              onPressed: () {
                loginUser(
                  username: usernameInput.text,
                  password: passwordInput.text,
                ).then((resp) {
                  if (resp.success) {
                    widget.userAccount(resp.user!);
                    FocusManager.instance.primaryFocus?.unfocus();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(resp.message!),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                });
              },
              child: const Text("Log In"),
            ),
          ),
        )
      ],
    );
  }
}
