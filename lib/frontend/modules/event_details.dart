import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ticketing_system/frontend/modules/text.dart';

class EventDetailsLine extends StatelessWidget {
  final String title;
  final String content;

  const EventDetailsLine({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailsSection extends StatelessWidget {
  final String title;
  final String content;

  const EventDetailsSection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitleText(title),
          SectionDetailText(content),
        ],
      ),
    );
  }
}

class EventDetailsLineSkeleton extends StatelessWidget {
  final String title;

  const EventDetailsLineSkeleton({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            Skeleton.keep(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "Short Placeholder",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDetailsSectionSkeleton extends StatelessWidget {
  final String title;
  late final String description;

  EventDetailsSectionSkeleton.shortText({
    super.key,
    required this.title,
  }) {
    description = "Short Text as Skeleton Here";
  }

  EventDetailsSectionSkeleton.longText({
    super.key,
    required this.title,
  }) {
    description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed"
        " do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut "
        "enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi "
        "ut aliquip ex ea commodo consequat.";
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton.keep(
              child: SectionTitleText(title),
            ),
            SectionDetailText(description),
          ],
        ),
      ),
    );
  }
}
