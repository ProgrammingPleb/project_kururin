import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ticketing_system/frontend/pages/event_details.dart';
import 'package:ticketing_system/models/event.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late Image bannerImage;
  bool imageLoading = true;

  @override
  void initState() {
    bannerImage = Image.network(
      widget.event.bannerUrl,
      fit: BoxFit.cover,
    );
    super.initState();
    bannerImage.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (image, synchronousCall) {
          if (mounted) {
            setState(() {
              imageLoading = false;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(event: widget.event),
            ),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Skeletonizer(
                          enabled: imageLoading,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 120,
                              maxHeight: 150,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Skeleton.replace(
                                    height: 150,
                                    child: bannerImage,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "by ${widget.event.organizer.name}",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.pin_drop_outlined),
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(widget.event.location),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range_outlined),
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(widget.event.date.displayText),
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
      ),
    );
  }
}
