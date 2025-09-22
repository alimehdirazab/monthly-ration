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
    final String? description;
    final dynamic category;
    final String? subcategory;
    final String? brand;
    final String mrpPrice;
    final String? discount;
    final String salePrice;
    final String? weight;
    final List<String> imagesUrls;
    final String? tax;
    final List<ProductAttributeValue> attributeValues;

    Product({
        required this.id,
        required this.name,
        this.description,
        required this.category,
        this.subcategory,
        this.brand,
        required this.mrpPrice,
        this.discount,
        required this.salePrice,
        this.weight,
        required this.imagesUrls,
        this.tax,
        required this.attributeValues,
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
        imagesUrls: _parseImagesUrls(json["images_urls"]),
        tax: json["tax"],
        attributeValues: json["attribute_values"] != null 
            ? List<ProductAttributeValue>.from(json["attribute_values"].map((x) => ProductAttributeValue.fromJson(x)))
            : [],
    );

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
        "images_urls": List<dynamic>.from(imagesUrls.map((x) => x)),
        "tax": tax,
        "attribute_values": List<dynamic>.from(attributeValues.map((x) => x.toJson())),
    };
}

class ProductAttributeValue {
    final ProductAttribute attribute;

    ProductAttributeValue({
        required this.attribute,
    });

    factory ProductAttributeValue.fromJson(Map<String, dynamic> json) => ProductAttributeValue(
        attribute: ProductAttribute.fromJson(json["attribute"]),
    );

    Map<String, dynamic> toJson() => {
        "attribute": attribute.toJson(),
    };
}

class ProductAttribute {
    final int id;
    final String name;
    final List<ProductAttributeValueDetail> values;

    ProductAttribute({
        required this.id,
        required this.name,
        required this.values,
    });

    factory ProductAttribute.fromJson(Map<String, dynamic> json) => ProductAttribute(
        id: json["id"],
        name: json["name"],
        values: List<ProductAttributeValueDetail>.from(json["values"].map((x) => ProductAttributeValueDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "values": List<dynamic>.from(values.map((x) => x.toJson())),
    };
}

class ProductAttributeValueDetail {
    final int id;
    final String value;
    final String mrpPrice;
    final String discount;
    final String? sellPrice;

    ProductAttributeValueDetail({
        required this.id,
        required this.value,
        required this.mrpPrice,
        required this.discount,
        this.sellPrice,
    });

    factory ProductAttributeValueDetail.fromJson(Map<String, dynamic> json) => ProductAttributeValueDetail(
        id: json["id"],
        value: json["value"],
        mrpPrice: json["mrp_price"],
        discount: json["discount"],
        sellPrice: json["sell_price"]?.toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "mrp_price": mrpPrice,
        "discount": discount,
        "sell_price": sellPrice,
    };
}
