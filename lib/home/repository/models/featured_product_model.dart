part of 'models.dart';


class FeaturedProductsModel {
    final int? categoryId;
    final String? categoryName;
    final List<ProductImage>? products;

    FeaturedProductsModel({
        this.categoryId,
        this.categoryName,
        this.products,
    });

    factory FeaturedProductsModel.fromJson(Map<String, dynamic> json) => FeaturedProductsModel(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        products: json["products"] == null ? [] : List<ProductImage>.from(json["products"]!.map((x) => ProductImage.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    };
}

class ProductImage {
    final String? thumbnailImg;

    ProductImage({
        this.thumbnailImg,
    });

    factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        thumbnailImg: json["thumbnail_img"],
    );

    Map<String, dynamic> toJson() => {
        "thumbnail_img": thumbnailImg,
    };
}
