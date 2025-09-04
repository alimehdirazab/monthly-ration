part of 'models.dart';

class TermsAndConditionModel {
    final TermsAndCondition data;

    TermsAndConditionModel({
        required this.data,
    });

    factory TermsAndConditionModel.fromJson(Map<String, dynamic> json) => TermsAndConditionModel(
        data: TermsAndCondition.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class TermsAndCondition {
    final String title;
    final String content;
    final String image;

    TermsAndCondition({
        required this.title,
        required this.content,
        required this.image,
    });

    factory TermsAndCondition.fromJson(Map<String, dynamic> json) => TermsAndCondition(
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
