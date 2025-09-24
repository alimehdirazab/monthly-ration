part of 'models.dart';  

class ShippingModel {
    final Shipping? data;

    ShippingModel({
        this.data,
    });

    factory ShippingModel.fromJson(Map<String, dynamic> json) => ShippingModel(
        data: json["data"] == null ? null : Shipping.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}

class Shipping {
    final int? shiipingApplicableAmount;
    final int? shippingAmount;

    Shipping({
        this.shiipingApplicableAmount,
        this.shippingAmount,
    });

    factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
        shiipingApplicableAmount: json["shiiping_applicable_amount"],
        shippingAmount: json["shipping_amount"],
    );

    Map<String, dynamic> toJson() => {
        "shiiping_applicable_amount": shiipingApplicableAmount,
        "shipping_amount": shippingAmount,
    };
}
