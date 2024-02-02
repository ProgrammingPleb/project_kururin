import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_system/frontend/modules/text.dart';
import 'package:ticketing_system/models/ticket.dart';

class EventTicketCard extends StatelessWidget {
  final TicketInfo ticket;

  const EventTicketCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 2,
                    ),
                    child: Text(
                      ticket.description,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "RM${ticket.price}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DigitalTicketCard extends StatelessWidget {
  final PurchasedTicket ticket;

  const DigitalTicketCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: null,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      BarcodeWidget(
                        height: 50,
                        margin: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        textPadding: 0,
                        data: ticket.data,
                        barcode: Barcode.pdf417(moduleHeight: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                ticket.event.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const CardSpaceBetweenText(
                left: "Ticket Type",
                right: "Saturday Pass",
              ),
              const CardSpaceBetweenText(
                left: "Date of Validity",
                right: "23 March 2024",
              ),
              CardSpaceBetweenText(
                left: "Location",
                right: ticket.event.location,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhysicalTicketCard extends StatelessWidget {
  final PurchasedTicket ticket;

  const PhysicalTicketCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          print("Navigate to ticket page");
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(
                            Icons.local_shipping,
                            size: 40,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "On it's way!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "In Transit",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Sent via: DHL eCommerce Asia",
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              Text(
                ticket.event.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const CardSpaceBetweenText(
                left: "Ticket Type",
                right: "Three Days Pass",
              ),
              const CardSpaceBetweenText(
                left: "Date of Validity",
                right: "1-3 March 2024",
              ),
              CardSpaceBetweenText(
                left: "Location",
                right: ticket.event.location,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
