import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ticketing_system/backend/event.dart';
import 'package:ticketing_system/frontend/modules/skeletons.dart';
import 'package:ticketing_system/frontend/modules/ticket_card.dart';
import 'package:ticketing_system/models/event.dart';
import 'package:ticketing_system/models/payment.dart';
import 'package:ticketing_system/models/ticket.dart';
import 'package:ticketing_system/models/user.dart';

class TicketListingPage extends StatefulWidget {
  final User user;

  const TicketListingPage({super.key, required this.user});

  @override
  State<TicketListingPage> createState() => _TicketListingPageState();
}

class _TicketListingPageState extends State<TicketListingPage> {
  late Payment paymentData;
  bool paymentReady = false;
  PurchasedTicket? ticket1;
  PurchasedTicket? ticket2;
  bool loading = true;

  Future<void> getEvents() async {
    BackendEventInfoResponse info = await getEventInfo(9);
    if (info.success) {
      ticket1 = PurchasedTicket(
        id: 3,
        data: "STFSY24/8pMoTbHyLB/240119",
        isPhysical: false,
        isDelivered: true,
        courierName: "N/A",
        event: info.event!,
      );
    } else {
      showErrorSnackbar(info.errorMessage!);
    }
    info = await getEventInfo(10);
    if (info.success) {
      setState(() {
        loading = false;
        ticket2 = PurchasedTicket(
          id: 4,
          data: "NJGN24/8A6BEY95Px/240123",
          isPhysical: true,
          isDelivered: false,
          courierName: "DHL",
          event: info.event!,
        );
      });
    } else {
      showErrorSnackbar(info.errorMessage!);
    }
  }

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: const SliverAppBar.medium(
            title: Text("Your Tickets"),
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
              SliverToBoxAdapter(
                child: Skeletonizer(
                  enabled: loading,
                  child: Column(
                    children: ticket1 != null
                        ? [
                            DigitalTicketCard(ticket: ticket1!),
                            PhysicalTicketCard(ticket: ticket2!),
                          ]
                        : [
                            generateCardSkeleton(),
                            generateCardSkeleton(),
                            generateCardSkeleton(),
                          ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
