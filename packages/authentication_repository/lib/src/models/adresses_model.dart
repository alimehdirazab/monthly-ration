part of 'models.dart';

class AddressesResponse {
  final List<Address> data;

  AddressesResponse({
    required this.data,
  });

  factory AddressesResponse.fromJson(Map<String, dynamic> json) =>
      AddressesResponse(
        data: List<Address>.from(json["data"].map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Address {
  final int? id;
  final int? customerId;
  final String? name;
  final String? phone;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final int? isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Address({
    this.id,
    this.customerId,
    this.name,
    this.phone,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  Address copyWith({
    int? id,
    int? customerId,
    String? name,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? country,
    String? pincode,
    int? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Address(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        pincode: pincode ?? this.pincode,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        customerId: json["customer_id"],
        name: json["name"],
        phone: json["phone"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        isDefault: json["is_default"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "name": name,
        "phone": phone,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "is_default": isDefault,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  // Helper getter to check if this is the default address
  bool get isDefaultAddress => isDefault == 1;
}
