part of 'models.dart';

class OrdersModel {
    final bool? status;
    final List<Order>? orders;

    OrdersModel({
        this.status,
        this.orders,
    });

    factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        status: json["status"],
        orders: json["orders"] == null ? [] : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "orders": orders == null ? [] : List<dynamic>.from(orders!.map((x) => x.toJson())),
    };
}

class Order {
    final int? id;
    final String? orderId;
    final String? totalAmount;
    final String? status;
    final String? paymentStatus;
    final DeliveryAddress? deliveryAddress;
    final String? createdAt;
    final List<Item>? items;

    Order({
        this.id,
        this.orderId,
        this.totalAmount,
        this.status,
        this.paymentStatus,
        this.deliveryAddress,
        this.createdAt,
        this.items,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        orderId: json["order_id"],
        totalAmount: json["total_amount"],
        status: json["status"],
        paymentStatus: json["payment_status"],
        deliveryAddress: json["delivery_address"] == null ? null : DeliveryAddress.fromJson(json["delivery_address"]),
        createdAt: json["created_at"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "total_amount": totalAmount,
        "status": status,
        "payment_status": paymentStatus,
        "delivery_address": deliveryAddress?.toJson(),
        "created_at": createdAt,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class Item {
    final int? productId;
    final String? productName;
    final String? image;
    final int? quantity;
    final String? price;
    final dynamic attribute;

    Item({
        this.productId,
        this.productName,
        this.image,
        this.quantity,
        this.price,
        this.attribute,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        productId: json["product_id"],
        productName: json["product_name"],
        image: json["image"],
        quantity: json["quantity"],
        price: json["price"],
        attribute: json["attribute"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "image": image,
        "quantity": quantity,
        "price": price,
        "attribute": attribute,
    };
}

class DeliveryAddress {
    final String? name;
    final String? addressLine1;
    final String? addressLine2;
    final String? city;
    final String? state;
    final String? country;
    final String? pincode;
    final String? phone;

    DeliveryAddress({
        this.name,
        this.addressLine1,
        this.addressLine2,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.phone,
    });

    factory DeliveryAddress.fromJson(Map<String, dynamic> json) => DeliveryAddress(
        name: json["name"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "phone": phone,
    };
}
