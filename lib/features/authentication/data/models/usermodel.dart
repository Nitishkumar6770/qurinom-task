class UserModel {
  final String token;
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String? profile;
  final bool isOnline;
  final String city;
  final String state;
  final String country;
  final Location location;

  UserModel({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.isOnline,
    required this.city,
    required this.state,
    required this.country,
    this.profile,
    required this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    final user = data["user"];

    return UserModel(
      token: data["token"] ?? "",
      id: user["_id"] ?? "",
      name: user["name"] ?? "",
      email: user["email"] ?? "",
      role: user["role"] ?? "",
      phone: user["phone"] ?? "",
      isOnline: user["isOnline"] ?? false,
      city: user["city"] ?? "",
      state: user["state"] ?? "",
      country: user["country"] ?? "",
      profile: user["profile"],
      location: Location.fromJson(user["location"]),
    );
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
    );
  }
}
