part of 'models.dart';

class ProductModel {
    final List<Product> data;

    ProductModel({
        required this.data,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        data: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Product {
    final int id;
    final String name;
    final dynamic category;
    final String brand;
    final String mrpPrice;
    final String salePrice;
    final List<String> images;
    final List<String> imagesUrls;

    Product({
        required this.id,
        required this.name,
        required this.category,
        required this.brand,
        required this.mrpPrice,
        required this.salePrice,
        required this.images,
        required this.imagesUrls,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        brand: json["brand"],
        mrpPrice: json["mrp_price"],
        salePrice: json["sale_price"],
        images: List<String>.from(json["images"].map((x) => x)),
        imagesUrls: List<String>.from(json["images_urls"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category,
        "brand": brand,
        "mrp_price": mrpPrice,
        "sale_price": salePrice,
        "images": List<dynamic>.from(images.map((x) => x)),
        "images_urls": List<dynamic>.from(imagesUrls.map((x) => x)),
    };
}
