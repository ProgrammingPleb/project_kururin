import 'package:flutter/material.dart';

class ListRefreshData {
  bool ongoing;
  List<Widget> events;

  ListRefreshData({required this.ongoing, required this.events});
}
