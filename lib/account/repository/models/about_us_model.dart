part of 'models.dart';
class AboutUsModel {
    final AboutUs data;

    AboutUsModel({
        required this.data,
    });

    factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
        data: AboutUs.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class AboutUs {
    final String title;
    final String content;
    final String image;

    AboutUs({
        required this.title,
        required this.content,
        required this.image,
    });

    factory AboutUs.fromJson(Map<String, dynamic> json) => AboutUs(
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
