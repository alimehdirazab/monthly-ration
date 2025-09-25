part of 'models.dart';

class ApplyCouponModel {
    final bool? success;
    final String? message;
    final String? coupon;
    final int? discount;
    final int? finalAmount;

    ApplyCouponModel({
        this.success,
        this.message,
        this.coupon,
        this.discount,
        this.finalAmount,
    });

    factory ApplyCouponModel.fromJson(Map<String, dynamic> json) => ApplyCouponModel(
        success: json["success"],
        message: json["message"],
        coupon: json["coupon"],
        discount: json["discount"],
        finalAmount: json["final_amount"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "coupon": coupon,
        "discount": discount,
        "final_amount": finalAmount,
    };
}
