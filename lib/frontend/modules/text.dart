import 'package:flutter/material.dart';

class SectionTitleText extends StatelessWidget {
  final String text;

  const SectionTitleText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
    );
  }
}

class SectionDetailText extends StatelessWidget {
  final String text;

  const SectionDetailText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
      ),
    );
  }
}
