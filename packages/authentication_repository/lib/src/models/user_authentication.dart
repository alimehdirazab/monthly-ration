part of 'models.dart';

class UserAuthentication extends Equatable {
  final Customer? customer;
  final String? token;

  const UserAuthentication({
    this.customer,
    this.token,
  });

  static const empty = UserAuthentication(token: "");

  bool get isEmpty => this == UserAuthentication.empty;

  bool get isNotEmpty => this != UserAuthentication.empty;
  
  UserAuthentication copyWith({
    Customer? customer,
    String? token,
  }) =>
      UserAuthentication(
        customer: customer ?? this.customer,
        token: token ?? this.token,
      );

  factory UserAuthentication.fromJson(Map<String, dynamic> json) =>
      UserAuthentication(
        customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "customer": customer?.toJson(),
        "token": token,
      };

  @override
  List<Object?> get props => [customer, token];
}

class Customer {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final String? dob;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? profileImage;
  final String? walletBalance;
  final String? status;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? otp;
  final DateTime? otpExpiresAt;

  Customer({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.profileImage,
    this.walletBalance,
    this.status,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.otp,
    this.otpExpiresAt,
  });

  Customer copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? dob,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? profileImage,
    String? walletBalance,
    String? status,
    DateTime? emailVerifiedAt,
    DateTime? phoneVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? otp,
    DateTime? otpExpiresAt,
  }) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        gender: gender ?? this.gender,
        dob: dob ?? this.dob,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        postalCode: postalCode ?? this.postalCode,
        profileImage: profileImage ?? this.profileImage,
        walletBalance: walletBalance ?? this.walletBalance,
        status: status ?? this.status,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        otp: otp ?? this.otp,
        otpExpiresAt: otpExpiresAt ?? this.otpExpiresAt,
      );

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        gender: json["gender"],
        dob: json["dob"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postalCode: json["postal_code"],
        profileImage: json["profile_image"],
        walletBalance: json["wallet_balance"],
        status: json["status"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        phoneVerifiedAt: json["phone_verified_at"] == null
            ? null
            : DateTime.parse(json["phone_verified_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        otp: json["otp"],
        otpExpiresAt: json["otp_expires_at"] == null
            ? null
            : DateTime.parse(json["otp_expires_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "gender": gender,
        "dob": dob,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "city": city,
        "state": state,
        "country": country,
        "postal_code": postalCode,
        "profile_image": profileImage,
        "wallet_balance": walletBalance,
        "status": status,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "phone_verified_at": phoneVerifiedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "otp": otp,
        "otp_expires_at": otpExpiresAt?.toIso8601String(),
      };
}

// class UserAuthentication extends Equatable {
//   final User? user;
//   final String? token;
//   final String? refreshToken;

//   const UserAuthentication({
//     this.user,
//     this.token,
//     this.refreshToken,
//   });

//   static const empty = UserAuthentication(token: "");

//   bool get isEmpty => this == UserAuthentication.empty;

//   bool get isNotEmpty => this != UserAuthentication.empty;

//   UserAuthentication copyWith({
//     User? user,
//     String? token,
//     String? refreshToken,
//   }) =>
//       UserAuthentication(
//         user: user ?? this.user,
//         token: token ?? this.token,
//         refreshToken: refreshToken ?? this.refreshToken,
//       );

//   factory UserAuthentication.fromJson(Map<String, dynamic> json) =>
//       UserAuthentication(
//         user: json["data"] == null ? null : User.fromJson(json["data"]),
//         token: json["access_token"],
//         refreshToken: json["refreshToken"],
//       );

//   Map<String, dynamic> toJson() => {
//         "data": user?.toJson(),
//         "access_token": token,
//         "refreshToken": refreshToken,
//       };
//   @override
//   List<Object?> get props => [user, token, refreshToken];
// }

// class User extends Equatable {
//   final int? id;
//   final String? name;
//   final String? email;
//   final int? roleId;
//   final String? phoneNumber;
//   final String? profilePicture;
//   final bool? notification;
//   final String? socialType;
//   final bool? isActive;
//   final dynamic fcm;
//   final bool? verifyOtp;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final Role? role;

//   const User({
//     this.id,
//     this.name,
//     this.email,
//     this.roleId,
//     this.phoneNumber,
//     this.profilePicture,
//     this.notification,
//     this.socialType,
//     this.isActive,
//     this.fcm,
//     this.verifyOtp,
//     this.createdAt,
//     this.updatedAt,
//     this.role,
//   });

//   User copyWith({
//     int? id,
//     String? name,
//     String? email,
//     int? roleId,
//     String? phoneNumber,
//     String? profilePicture,
//     bool? notification,
//     String? socialType,
//     bool? isActive,
//     dynamic fcm,
//     bool? verifyOtp,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     Role? role,
//   }) =>
//       User(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         email: email ?? this.email,
//         roleId: roleId ?? this.roleId,
//         phoneNumber: phoneNumber ?? this.phoneNumber,
//         profilePicture: profilePicture ?? this.profilePicture,
//         notification: notification ?? this.notification,
//         socialType: socialType ?? this.socialType,
//         isActive: isActive ?? this.isActive,
//         fcm: fcm ?? this.fcm,
//         verifyOtp: verifyOtp ?? this.verifyOtp,
//         createdAt: createdAt ?? this.createdAt,
//         updatedAt: updatedAt ?? this.updatedAt,
//         role: role ?? this.role,
//       );

//   factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         roleId: json["role_id"],
//         phoneNumber: json["phone_number"],
//         profilePicture: json["profile_picture"],
//         notification: json["notification"],
//         socialType: json["social_type"],
//         isActive: json["is_active"],
//         fcm: json["fcm"],
//         verifyOtp: json["verify_otp"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//         role: json["role"] == null ? null : Role.fromJson(json["role"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "role_id": roleId,
//         "phone_number": phoneNumber,
//         "profile_picture": profilePicture,
//         "notification": notification,
//         "social_type": socialType,
//         "is_active": isActive,
//         "fcm": fcm,
//         "verify_otp": verifyOtp,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "role": role?.toJson(),
//       };

//   @override
//   // TODO: implement props
//   List<Object?> get props => [
//         id,
//         name,
//         email,
//         roleId,
//         phoneNumber,
//         profilePicture,
//         notification,
//         socialType,
//         isActive,
//         fcm,
//         verifyOtp,
//         createdAt,
//         updatedAt,
//         role,
//       ];
// }

// class Role {
//   final int? id;
//   final String? name;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   Role({
//     this.id,
//     this.name,
//     this.createdAt,
//     this.updatedAt,
//   });

//   Role copyWith({
//     int? id,
//     String? name,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) =>
//       Role(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         createdAt: createdAt ?? this.createdAt,
//         updatedAt: updatedAt ?? this.updatedAt,
//       );

//   factory Role.fromJson(Map<String, dynamic> json) => Role(
//         id: json["id"],
//         name: json["name"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//       };
// }
