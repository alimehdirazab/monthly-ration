part of 'models.dart';

class HandlingModel {
    final Handling? data;

    HandlingModel({
        this.data,
    });

    factory HandlingModel.fromJson(Map<String, dynamic> json) => HandlingModel(
        data: json["data"] == null ? null : Handling.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}

class Handling {
    final int? handlingApplicableAmount;
    final int? handlingAmount;

    Handling({
        this.handlingApplicableAmount,
        this.handlingAmount,
    });

    factory Handling.fromJson(Map<String, dynamic> json) => Handling(
        handlingApplicableAmount: json["handling_applicable_amount"],
        handlingAmount: json["handling_amount"],
    );

    Map<String, dynamic> toJson() => {
        "handling_applicable_amount": handlingApplicableAmount,
        "handling_amount": handlingAmount,
    };
}
