import 'package:flutter/material.dart';
import 'package:ticketing_system/backend/user.dart';
import 'package:ticketing_system/frontend/modules/text_fields.dart';
import 'package:ticketing_system/models/user.dart';

class RegistrationForm extends StatefulWidget {
  final ValueSetter<User> userAccount;

  const RegistrationForm({super.key, required this.userAccount});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  TextEditingController usernameInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            onDisposeAction: AutofillContextAction.cancel,
            child: Column(
              children: [
                SimpleTextFormField(
                  name: "Username",
                  controller: usernameInput,
                  textColor: const Color(0xFF1F1F1F),
                  autofillHints: const [AutofillHints.username],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please fill in your username.";
                    }
                    return null;
                  },
                ),
                SimpleTextFormField(
                  name: "Password",
                  controller: passwordInput,
                  textColor: const Color(0xFF1F1F1F),
                  autofillHints: const [AutofillHints.password],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please fill in your password.";
                    }
                    return null;
                  },
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
                FocusScope.of(context).requestFocus(FocusNode());
                if (_formKey.currentState!.validate()) {
                  loginUser(
                    username: usernameInput.text,
                    password: passwordInput.text,
                  ).then((resp) {
                    if (resp.success) {
                      widget.userAccount(resp.user!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(resp.message!),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Some fields were not filled in."),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text("Log In"),
            ),
          ),
        )
      ],
    );
  }
}
