import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ticketing_system/frontend/modules/event_details.dart';
import 'package:ticketing_system/frontend/modules/text_fields.dart';

Card generateCardSkeleton() {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
    clipBehavior: Clip.antiAlias,
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 120,
                  maxHeight: 150,
                ),
                child: const Skeleton.replace(
                  height: 200,
                  width: 600,
                  child: SizedBox(
                    height: 200,
                    width: 600,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Skeleton Name (Long-ish)",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Skeleton.shade(child: Icon(Icons.pin_drop_outlined)),
                          Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Text("Longer Skeleton Location"),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Skeleton.shade(
                              child: Icon(Icons.date_range_outlined)),
                          Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Text("Short Event Date"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Skeletonizer generateFullProfileSkeleton() {
  return Skeletonizer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const Skeleton.replace(
                height: 75,
                width: 75,
                child: SizedBox(
                  height: 200,
                  width: 600,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Comic Fiesta",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    "(comicfiesta)",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "Event Organizer",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SkeletonAccountTextField(
          name: "Name",
          controller: TextEditingController(text: "Comic Fiesta"),
          description: "This will be shown to the public when you "
              "create events.",
        ),
        SkeletonAccountTextField(
          name: "Username",
          controller: TextEditingController(text: "comicfiesta"),
          description: "This will be while logging in.",
        ),
        SkeletonAccountTextField(
          name: "Email",
          controller: TextEditingController(
            text: "organizer@example.com",
          ),
          description: "This will be used for any communication "
              "regarding events hosted by you.",
        ),
        SkeletonAccountTextField(
          name: "Address",
          controller: TextEditingController(
            text: "Kuala Lumpur City Centre,\n"
                "50088 Kuala Lumpur,\n"
                "Federal Territory of Kuala Lumpur\n"
                "Malaysia",
          ),
          description: "This will be used for any communication "
              "regarding events hosted by you.",
          multiline: true,
        ),
      ],
    ),
  );
}

Widget generateEventDetailsSkeleton() {
  return Column(
    children: [
      const EventDetailsLineSkeleton(title: "Time:"),
      const EventDetailsLineSkeleton(title: "Location:"),
      EventDetailsSectionSkeleton.longText(
        title: "Description",
      ),
    ],
  );
}
