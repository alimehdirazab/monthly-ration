part of 'models.dart';

class PrivacyPolicyModel {
    final PrivacyPolicy data;

    PrivacyPolicyModel({
        required this.data,
    });

    factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) => PrivacyPolicyModel(
        data: PrivacyPolicy.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class PrivacyPolicy {
    final String title;
    final String content;
    final String image;

    PrivacyPolicy({
        required this.title,
        required this.content,
        required this.image,
    });

    factory PrivacyPolicy.fromJson(Map<String, dynamic> json) => PrivacyPolicy(
        title: json["title"],
        content: json["content"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "image": image,
    };
}
