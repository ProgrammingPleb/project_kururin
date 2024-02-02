import 'package:flutter/material.dart';
import 'package:ticketing_system/backend/event.dart';
import 'package:ticketing_system/frontend/app_states.dart';
import 'package:ticketing_system/models/event.dart';
import 'package:ticketing_system/models/user.dart';

class EventListingsPage extends StatefulWidget {
  final ValueNotifier<ListRefreshData> refreshListener;
  final User? user;

  const EventListingsPage({
    super.key,
    required this.refreshListener,
    this.user,
  });

  @override
  State<EventListingsPage> createState() => _EventListingsPageState();
}

class _EventListingsPageState extends State<EventListingsPage> {
  late bool listRefreshing;
  List<Widget> events = [];

  void getSelfEvents() {
    getEventsList(user: widget.user).then(
      (eventsListResp) {
        setState(() {
          List<Widget> events = [];
          if (eventsListResp.success) {
            for (Event event in eventsListResp.events) {
              events.add(event.card);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  eventsListResp.errorMessage!,
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          widget.refreshListener.value = ListRefreshData(
            ongoing: false,
            events: events,
          );
        });
      },
    );
  }

  @override
  void initState() {
    listRefreshing = widget.refreshListener.value.ongoing;
    events = widget.refreshListener.value.events;
    if (widget.user != null) {
      getSelfEvents();
    }
    super.initState();
    widget.refreshListener.addListener(() {
      if (mounted) {
        setState(() {
          listRefreshing = widget.refreshListener.value.ongoing;
          events = widget.refreshListener.value.events;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar.large(
            title: const Text("Upcoming Events"),
            actions: _refreshAction(),
          ),
        ),
      ],
      body: Builder(
        builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList.list(children: events),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _refreshAction() {
    if (widget.refreshListener.value.ongoing) {
      return [
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 15, 8),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        ),
      ];
    }
    return [
      IconButton(
        onPressed: () {
          widget.refreshListener.value = ListRefreshData(
            ongoing: true,
            events: widget.refreshListener.value.events,
          );
          getEventsList(user: widget.user).then(
            (eventsListResp) {
              if (eventsListResp.success) {
                widget.refreshListener.value = ListRefreshData(
                  ongoing: false,
                  events: List<Widget>.from(
                    eventsListResp.events.map((e) => e.card),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Successfully refreshed the event list!"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(eventsListResp.errorMessage!),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          );
        },
        icon: const Icon(Icons.refresh),
      ),
    ];
  }
}
