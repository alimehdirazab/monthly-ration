part of 'models.dart';

class WalletBalanceModel {
  final bool? status;
  final String? message;
  final String? currentWalletBalance;

  WalletBalanceModel({
    this.status,
    this.message,
    this.currentWalletBalance,
  });

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) => WalletBalanceModel(
    status: json["status"],
    message: json["message"],
    currentWalletBalance: json["current_wallet_balance"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "current_wallet_balance": currentWalletBalance,
  };
}