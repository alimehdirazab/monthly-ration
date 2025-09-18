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
    final String? subcategory;  // Added subcategory field
    final String? brand;  // Made nullable
    final String mrpPrice;
    final String salePrice;
    final List<String> images;
    final List<String> imagesUrls;

    Product({
        required this.id,
        required this.name,
        required this.category,
        this.subcategory,  // Made optional
        this.brand,  // Made optional
        required this.mrpPrice,
        required this.salePrice,
        required this.images,
        required this.imagesUrls,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        subcategory: json["subcategory"],
        brand: json["brand"],
        mrpPrice: json["mrp_price"],
        salePrice: json["sale_price"],
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
        "category": category,
        "subcategory": subcategory,
        "brand": brand,
        "mrp_price": mrpPrice,
        "sale_price": salePrice,
        "images": List<dynamic>.from(images.map((x) => x)),
        "images_urls": List<dynamic>.from(imagesUrls.map((x) => x)),
    };
}
