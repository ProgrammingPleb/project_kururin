import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SimpleTextField extends StatelessWidget {
  final String name;
  final TextEditingController controller;

  const SimpleTextField({
    super.key,
    required this.name,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleTextFormField extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final Color? textColor;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;

  const SimpleTextFormField({
    super.key,
    required this.name,
    required this.controller,
    this.textColor,
    this.autofillHints,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              controller: controller,
              autofillHints: autofillHints,
              validator: validator,
              style: TextStyle(
                color: textColor,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              obscureText: autofillHints != null
                  ? autofillHints!.contains(AutofillHints.password)
                  : false,
            ),
          ),
        ],
      ),
    );
  }
}

class DescriptionTextField extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final String description;
  final bool multiline;

  const DescriptionTextField({
    super.key,
    required this.name,
    required this.controller,
    required this.description,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: multiline ? 10 : 1,
            ),
          ),
          Text(
            description,
          )
        ],
      ),
    );
  }
}

class SkeletonAccountTextField extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final String description;
  final bool multiline;

  const SkeletonAccountTextField({
    super.key,
    required this.name,
    required this.controller,
    required this.description,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton.keep(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: multiline ? 10 : 1,
            ),
          ),
          Skeleton.keep(
            child: Text(
              description,
            ),
          )
        ],
      ),
    );
  }
}
