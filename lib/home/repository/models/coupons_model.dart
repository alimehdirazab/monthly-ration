part of 'models.dart';

class CouponsModel {
    final List<CouponsList>? data;

    CouponsModel({
        this.data,
    });

    factory CouponsModel.fromJson(Map<String, dynamic> json) => CouponsModel(
        data: json["data"] == null ? [] : List<CouponsList>.from(json["data"]!.map((x) => CouponsList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class CouponsList {
    final int? id;
    final String? code;
    final String? type;
    final String? value;
    final String? minPurchase;
    final int? maxUses;
    final int? usesCount;
    final DateTime? startDate;
    final DateTime? endDate;
    final String? image;
    final int? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    CouponsList({
        this.id,
        this.code,
        this.type,
        this.value,
        this.minPurchase,
        this.maxUses,
        this.usesCount,
        this.startDate,
        this.endDate,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory CouponsList.fromJson(Map<String, dynamic> json) => CouponsList(
        id: json["id"],
        code: json["code"],
        type: json["type"],
        value: json["value"],
        minPurchase: json["min_purchase"],
        maxUses: json["max_uses"],
        usesCount: json["uses_count"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        image: json["image"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "type": type,
        "value": value,
        "min_purchase": minPurchase,
        "max_uses": maxUses,
        "uses_count": usesCount,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "image": image,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
