import 'dart:convert';

class User {
  int id;
  String name;
  String username;
  String hashedPassword;
  String type;
  Uri? pictureUrl;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.hashedPassword,
    required this.type,
    this.pictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print(json);
    return User(
      id: json["id"],
      name: json["name"],
      username: json["username"],
      hashedPassword: json["hash"],
      pictureUrl:
          json.containsKey("pictureURL") ? Uri.parse(json["pictureURL"]) : null,
      type: json["type"],
    );
  }

  factory User.noData() {
    return User(
      id: 1,
      name: "No Data",
      username: "No Data",
      hashedPassword: "No Data",
      pictureUrl: Uri(),
      type: "Attendee",
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> userData = {
      "id": id,
      "name": name,
      "username": username,
      "hash": hashedPassword,
      "pictureURL": pictureUrl.toString(),
      "type": type,
    };

    return userData;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class UserType {
  static String attendee = "Attendee";
  static String organizer = "Organizer";
  static String ticketVendor = "Vendor";
  static String sysAdmin = "Admin";

  static String displayText(String type) {
    if (type == attendee) {
      return "Event Attendee";
    }
    if (type == organizer) {
      return "Event Organizer";
    }
    if (type == ticketVendor) {
      return "Ticket Vendor";
    }
    if (type == sysAdmin) {
      return "System Administrator";
    }
    return "Unknown Type";
  }
}

class UserAuthenticationResponse {
  bool success;
  String? message;
  User? user;

  UserAuthenticationResponse({
    required this.success,
    this.message,
    this.user,
  });

  factory UserAuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return UserAuthenticationResponse(
      success: json["success"],
      message: json["msg"],
      user: json.containsKey("accDetails")
          ? User.fromJson(json["accDetails"])
          : null,
    );
  }
}
