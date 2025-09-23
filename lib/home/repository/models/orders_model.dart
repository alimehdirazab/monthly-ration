part of 'models.dart';

class OrdersModel {
    final List<Order>? orders;

    OrdersModel({
        this.orders,
    });

    factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        orders: json["orders"] == null ? [] : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "orders": orders == null ? [] : List<dynamic>.from(orders!.map((x) => x.toJson())),
    };
}

class Order {
    final int? id;
    final String? orderId;
    final String? totalAmount;
    final String? status;
    final String? paymentStatus;
    final String? createdAt;
    final List<Item>? items;

    Order({
        this.id,
        this.orderId,
        this.totalAmount,
        this.status,
        this.paymentStatus,
        this.createdAt,
        this.items,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        orderId: json["order_id"],
        totalAmount: json["total_amount"],
        status: json["status"],
        paymentStatus: json["payment_status"],
        createdAt: json["created_at"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "total_amount": totalAmount,
        "status": status,
        "payment_status": paymentStatus,
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
