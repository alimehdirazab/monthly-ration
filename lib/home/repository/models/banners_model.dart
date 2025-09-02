part of 'models.dart';

class BannersModel {
    final List<Banners> data;

    BannersModel({
        required this.data,
    });

    factory BannersModel.fromJson(Map<String, dynamic> json) => BannersModel(
        data: List<Banners>.from(json["data"].map((x) => Banners.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Banners {
    final int id;
    final String title;
    final dynamic link;
    final String image;

    Banners({
        required this.id,
        required this.title,
        required this.link,
        required this.image,
    });

    factory Banners.fromJson(Map<String, dynamic> json) => Banners(
        id: json["id"],
        title: json["title"],
        link: json["link"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "link": link,
        "image": image,
    };
}
