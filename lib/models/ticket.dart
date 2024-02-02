import 'package:ticketing_system/models/event.dart';

class TicketInfo {
  int id;
  String name;
  String description;
  int price;
  bool isPhysical;
  bool isPurchaseable;

  TicketInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isPhysical,
    required this.isPurchaseable,
  });

  factory TicketInfo.fromJson(Map<String, dynamic> json) {
    return TicketInfo(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: json["price"],
      isPhysical: json["isPhysical"],
      isPurchaseable: json["isPurchaseable"],
    );
  }
}

class PurchasedTicket {
  int id;
  String data;
  bool isPhysical;
  bool isDelivered;
  String courierName;
  Event event;

  PurchasedTicket({
    required this.id,
    required this.data,
    required this.isPhysical,
    required this.isDelivered,
    required this.courierName,
    required this.event,
  });

  factory PurchasedTicket.fromJson(Map<String, dynamic> json) {
    return PurchasedTicket(
      id: json["id"],
      data: json["data"],
      isPhysical: json["isPhysical"],
      isDelivered: json["isDelivered"],
      courierName: json["courierName"],
      event: Event.fromJson(
        json["event"],
      ),
    );
  }
}
