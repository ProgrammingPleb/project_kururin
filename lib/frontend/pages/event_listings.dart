import 'package:flutter/material.dart';
import 'package:ticketing_system/backend/event.dart';
import 'package:ticketing_system/frontend/app_states.dart';
import 'package:ticketing_system/models/app.dart';
import 'package:ticketing_system/models/event.dart';

class EventListingsPage extends StatefulWidget {
  final ValueNotifier<ListRefreshData> refreshListener;
  final List<Widget> events;

  const EventListingsPage({
    super.key,
    required this.events,
    required this.refreshListener,
  });

  @override
  State<EventListingsPage> createState() => _EventListingsPageState();
}

class _EventListingsPageState extends State<EventListingsPage> {
  late bool listRefreshing;
  List<Widget> events = [];

  @override
  void initState() {
    listRefreshing = widget.refreshListener.value.ongoing;
    if (widget.refreshListener.value.events == []) {
      events = widget.events;
    } else {
      events = widget.refreshListener.value.events;
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
            actions: _refreshAction(listRefreshing, (status) {
              if (mounted) {
                setState(() {
                  listRefreshing = status.ongoing;
                });

                if (!status.ongoing) {
                  if (status.success) {
                    events = [];
                    for (Event event in status.response!.events) {
                      events.add(event.card);
                    }

                    widget.refreshListener.value = ListRefreshData(
                      ongoing: false,
                      events: events,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Refreshed event listings!",
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          status.response!.errorMessage!,
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              }
            }),
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
}

List<Widget> _refreshAction(
  bool loading,
  ValueSetter<EventListRefreshStatus> onStatusChanged,
) {
  if (loading) {
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
        onStatusChanged(
          EventListRefreshStatus(
            ongoing: true,
            success: false,
          ),
        );
        getEventsList().then(
          (eventsListResp) {
            onStatusChanged(
              EventListRefreshStatus(
                ongoing: false,
                success: eventsListResp.success,
                response: eventsListResp,
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.refresh),
    ),
  ];
}
