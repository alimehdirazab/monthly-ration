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
    final String? description;  // New field
    final dynamic category;
    final String? subcategory;
    final String? brand;  // Made nullable
    final String mrpPrice;
    final String? discount;  // New field
    final String salePrice;
    final String? weight;  // New field
    final List<String> images;
    final List<String> imagesUrls;

    Product({
        required this.id,
        required this.name,
        this.description,  // New optional field
        required this.category,
        this.subcategory,
        this.brand,
        required this.mrpPrice,
        this.discount,  // New optional field
        required this.salePrice,
        this.weight,  // New optional field
        required this.images,
        required this.imagesUrls,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        category: json["category"],
        subcategory: json["subcategory"],
        brand: json["brand"],
        mrpPrice: json["mrp_price"],
        discount: json["discount"],
        salePrice: json["sale_price"],
        weight: json["weight"],
        images: _parseImages(json["images"]),
        imagesUrls: _parseImagesUrls(json["images_urls"] ?? json["images"]),
    );

    // Helper method to parse images field (can be string or array)
    static List<String> _parseImages(dynamic imagesData) {
      if (imagesData == null) return [];
      
      if (imagesData is List) {
        return List<String>.from(imagesData.map((x) => x.toString()));
      } else if (imagesData is String) {
        try {
          // Try to parse as JSON array
          final decoded = jsonDecode(imagesData);
          if (decoded is List) {
            return List<String>.from(decoded.map((x) => x.toString()));
          }
        } catch (e) {
          // If JSON parsing fails, treat as single image URL
          return [imagesData];
        }
      }
      
      return [];
    }

    // Helper method to parse images_urls field
    static List<String> _parseImagesUrls(dynamic imagesData) {
      if (imagesData == null) return [];
      
      if (imagesData is List) {
        return List<String>.from(imagesData.map((x) => x.toString()));
      } else if (imagesData is String) {
        try {
          // Try to parse as JSON array
          final decoded = jsonDecode(imagesData);
          if (decoded is List) {
            return List<String>.from(decoded.map((x) => x.toString()));
          }
        } catch (e) {
          // If JSON parsing fails, treat as single image URL
          return [imagesData];
        }
      }
      
      return [];
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category,
        "subcategory": subcategory,
        "brand": brand,
        "mrp_price": mrpPrice,
        "discount": discount,
        "sale_price": salePrice,
        "weight": weight,
        "images": List<dynamic>.from(images.map((x) => x)),
        "images_urls": List<dynamic>.from(imagesUrls.map((x) => x)),
    };
}
