part of 'models.dart';
class CategoryModel {
    final List<Category> data;

    CategoryModel({
        required this.data,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        data: List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Category {
    final int id;
    final String name;
    final String slug;
    final String? image;
    final dynamic bannerImage;
    final List<Category> subCategories;
    final List<Category>? subSubCategories;

    Category({
        required this.id,
        required this.name,
        required this.slug,
        this.image,
        this.bannerImage,
        required this.subCategories,
        this.subSubCategories,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        image: json["image"],
        bannerImage: json["banner_image"],
        subCategories: List<Category>.from(json["sub_categories"]?.map((x) => Category.fromJson(x)) ?? []),
        subSubCategories: json["sub_sub_categories"] != null 
            ? List<Category>.from(json["sub_sub_categories"].map((x) => Category.fromJson(x)))
            : null,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "image": image,
        "banner_image": bannerImage,
        "sub_categories": List<dynamic>.from(subCategories.map((x) => x.toJson())),
        "sub_sub_categories": subSubCategories != null 
            ? List<dynamic>.from(subSubCategories!.map((x) => x.toJson()))
            : null,
    };
}
