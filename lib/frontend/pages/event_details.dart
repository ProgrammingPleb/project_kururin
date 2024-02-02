import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ticketing_system/backend/event.dart';
import 'package:ticketing_system/frontend/modules/flex.dart';
import 'package:ticketing_system/frontend/modules/event_details.dart';
import 'package:ticketing_system/frontend/modules/skeletons.dart';
import 'package:ticketing_system/frontend/modules/ticket_card.dart';
import 'package:ticketing_system/models/event.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;

  const EventDetailsPage({super.key, required this.event});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  EventDetails? details;
  List<Widget> ticketCards = [];
  late Image organizerImage;
  late Image bannerImage;
  bool organizerImageLoading = true;
  bool bannerImageLoading = true;
  bool ticketCardsLoading = true;

  @override
  void initState() {
    organizerImage = Image.network(
      widget.event.organizer.pictureUrl,
      fit: BoxFit.cover,
    );
    bannerImage = Image.network(
      widget.event.bannerUrl,
      fit: BoxFit.cover,
    );

    organizerImage.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (image, synchronousCall) {
          if (mounted) {
            setState(
              () {
                organizerImageLoading = false;
              },
            );
          }
        },
      ),
    );
    bannerImage.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (image, synchronousCall) {
          if (mounted) {
            setState(
              () {
                bannerImageLoading = false;
              },
            );
          }
        },
      ),
    );
    super.initState();
    widget.event.details.then((details) {
      if (mounted) {
        setState(() {
          this.details = details;
        });
      }
    });
    getEventTickets(event: widget.event).then((resp) {
      if (resp.success) {
        if (resp.tickets.isEmpty) {
          ticketCards.add(
            const Text("There are no tickets for this event."),
          );
          setState(() {
            ticketCardsLoading = false;
          });
        } else {
          ticketCards = List<Widget>.from(
            resp.tickets.map(
              (ticket) => EventTicketCard(ticket: ticket),
            ),
          );
          setState(() {
            ticketCardsLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An unexpected error has occurred."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                expandedHeight: 200,
                flexibleSpace: KururinFlexibleSpaceBar(
                  title: Text(
                    widget.event.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  titlePaddingTween: EdgeInsetsTween(
                    begin: const EdgeInsets.only(left: 16.0, bottom: 24),
                    end: const EdgeInsets.only(left: 56.0, bottom: 13),
                  ),
                  background: Container(
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.background,
                          Theme.of(context)
                              .colorScheme
                              .background
                              .withAlpha(170),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.35, 0.75],
                      ),
                    ),
                    child: Skeletonizer(
                      enabled: bannerImageLoading,
                      child: Column(
                        children: [
                          Expanded(
                            child: Skeleton.replace(
                              width: 30000,
                              height: 400,
                              child: bannerImage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  foreground: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).viewPadding.top + 9,
                          left: 10,
                        ),
                        child: SizedBox(
                          width: 37.5,
                          height: 37.5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ];
        },
        body: Builder(
          builder: (context) {
            return CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                const SliverPadding(
                  padding: EdgeInsets.only(top: 15),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Skeletonizer(
                              enabled: organizerImageLoading,
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Skeleton.replace(
                                          width: 40,
                                          height: 40,
                                          child: organizerImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "By: ${widget.event.organizer.name}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        EventDetailsLine(
                          title: "Date:",
                          content: widget.event.date.displayText,
                        ),
                        details != null
                            ? details!.pageWidgets
                            : generateEventDetailsSkeleton(),
                        const Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 10),
                          child: Text(
                            "Tickets",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ...ticketCards,
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
