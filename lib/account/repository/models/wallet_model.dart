part of 'models.dart';

class WalletModel {
    final List<WalletHistory>? data;

    WalletModel({
        this.data,
    });

    factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        data: json["data"] == null ? [] : List<WalletHistory>.from(json["data"]!.map((x) => WalletHistory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class WalletHistory {
    final int? id;
    final int? customerId;
    final String? transactionType;
    final String? source;
    final String? amount;
    final String? balanceAfter;
    final dynamic orderId;
    final String? rzpOrderId;
    final dynamic rzpPaymentId;
    final dynamic referenceId;
    final String? status;
    final String? remarks;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    WalletHistory({
        this.id,
        this.customerId,
        this.transactionType,
        this.source,
        this.amount,
        this.balanceAfter,
        this.orderId,
        this.rzpOrderId,
        this.rzpPaymentId,
        this.referenceId,
        this.status,
        this.remarks,
        this.createdAt,
        this.updatedAt,
    });

    factory WalletHistory.fromJson(Map<String, dynamic> json) => WalletHistory(
        id: json["id"],
        customerId: json["customer_id"],
        transactionType: json["transaction_type"],
        source: json["source"],
        amount: json["amount"],
        balanceAfter: json["balance_after"],
        orderId: json["order_id"],
        rzpOrderId: json["rzp_order_id"],
        rzpPaymentId: json["rzp_payment_id"],
        referenceId: json["reference_id"],
        status: json["status"],
        remarks: json["remarks"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "transaction_type": transactionType,
        "source": source,
        "amount": amount,
        "balance_after": balanceAfter,
        "order_id": orderId,
        "rzp_order_id": rzpOrderId,
        "rzp_payment_id": rzpPaymentId,
        "reference_id": referenceId,
        "status": status,
        "remarks": remarks,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
