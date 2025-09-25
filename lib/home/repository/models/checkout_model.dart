part of 'models.dart';

class CheckoutRequest {
  final int addressId;
  final String paymentMethod;
  final List<CheckoutCartItem> cart;
  final String? couponId;
  final double? couponDiscountAmount;
  final double? shippingCharge;
  final double? handlingCharge;

  CheckoutRequest({
    required this.addressId,
    required this.paymentMethod,
    required this.cart,
    this.couponId,
    this.couponDiscountAmount,
    this.shippingCharge,
    this.handlingCharge,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "address_id": addressId,
      "payment_method": paymentMethod,
      "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
    };
    
    if (couponId != null) {
      json["coupon_id"] = couponId;
    }
    
    if (couponDiscountAmount != null) {
      json["coupon_discount_amount"] = couponDiscountAmount;
    }
    
    if (shippingCharge != null) {
      json["shipping_charge"] = shippingCharge;
    }
    
    if (handlingCharge != null) {
      json["handling_charge"] = handlingCharge;
    }
    
    return json;
  }
}

class CheckoutCartItem {
  final int productId;
  final int quantity;
  final Map<String, dynamic>? attributes;

  CheckoutCartItem({
    required this.productId,
    required this.quantity,
    this.attributes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "product_id": productId,
      "quantity": quantity,
    };
    
    if (attributes != null && attributes!.isNotEmpty) {
      json["attributes"] = attributes;
    }
    
    return json;
  }
}

class CheckoutResponse {
  final String? status;
  final String? orderId;
  final String? razorpayOrderId;
  final String? razorpayKey;
  final double? amount;
  final String? currency;

  CheckoutResponse({
    this.status,
    this.orderId,
    this.razorpayOrderId,
    this.razorpayKey,
    this.amount,
    this.currency,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) => CheckoutResponse(
        status: json["status"],
        orderId: json["order_id"]?.toString(),
        razorpayOrderId: json["razorpay_order_id"]?.toString(),
        razorpayKey: json["razorpay_key"]?.toString(),
        amount: json["amount"]?.toDouble(),
        currency: json["currency"]?.toString(),
      );
}

class PaymentVerifyRequest {
  final String razorpayPaymentId;
  final String razorpayOrderId;
  final String razorpaySignature;

  PaymentVerifyRequest({
    required this.razorpayPaymentId,
    required this.razorpayOrderId,
    required this.razorpaySignature,
  });

  Map<String, dynamic> toJson() => {
        "razorpay_payment_id": razorpayPaymentId,
        "razorpay_order_id": razorpayOrderId,
        "razorpay_signature": razorpaySignature,
      };
}

class PaymentVerifyResponse {
  final bool? success;
  final String? message;
  final PaymentVerifyData? data;

  PaymentVerifyResponse({
    this.success,
    this.message,
    this.data,
  });

  factory PaymentVerifyResponse.fromJson(Map<String, dynamic> json) => PaymentVerifyResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null ? PaymentVerifyData.fromJson(json["data"]) : null,
      );
}

class PaymentVerifyData {
  final String? orderId;
  final String? status;
  final String? paymentStatus;

  PaymentVerifyData({
    this.orderId,
    this.status,
    this.paymentStatus,
  });

  factory PaymentVerifyData.fromJson(Map<String, dynamic> json) => PaymentVerifyData(
        orderId: json["order_id"]?.toString(),
        status: json["status"]?.toString(),
        paymentStatus: json["payment_status"]?.toString(),
      );
}