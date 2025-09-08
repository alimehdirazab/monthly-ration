part of 'models.dart';

class ProductDetailsModel {
    final ProductDetails data;

    ProductDetailsModel({
        required this.data,
    });

    factory ProductDetailsModel.fromJson(Map<String, dynamic> json) => ProductDetailsModel(
        data: ProductDetails.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class ProductDetails {
    final int? id;
    final String? name;
    final String? category;
    final String? subcategory;
    final String? mrpPrice;
    final int? sellPrice;
    final String? discount;
    final List<String>? images;
    final List<dynamic>? extraFields;
    final String? brand;
    final List<dynamic>? attributeValues;
    final List<RelatedProduct>? relatedProducts;

    ProductDetails({
        this.id,
        this.name,
        this.category,
        this.subcategory,
        this.mrpPrice,
        this.sellPrice,
        this.discount,
        this.images,
        this.extraFields,
        this.brand,
        this.attributeValues,
        this.relatedProducts,
    });

    factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        subcategory: json["subcategory"],
        mrpPrice: json["mrp_price"],
        sellPrice: json["sell_price"],
        discount: json["discount"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        extraFields: json["extra_fields"] == null ? [] : List<dynamic>.from(json["extra_fields"]!.map((x) => x)),
        brand: json["brand"],
        attributeValues: json["attribute_values"] == null ? [] : List<dynamic>.from(json["attribute_values"]!.map((x) => x)),
        relatedProducts: json["related_products"] == null ? [] : List<RelatedProduct>.from(json["related_products"]!.map((x) => RelatedProduct.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category,
        "subcategory": subcategory,
        "mrp_price": mrpPrice,
        "sell_price": sellPrice,
        "discount": discount,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "extra_fields": extraFields == null ? [] : List<dynamic>.from(extraFields!.map((x) => x)),
        "brand": brand,
        "attribute_values": attributeValues == null ? [] : List<dynamic>.from(attributeValues!.map((x) => x)),
        "related_products": relatedProducts == null ? [] : List<dynamic>.from(relatedProducts!.map((x) => x.toJson())),
    };
}

class RelatedProduct {
    final int? id;
    final String? name;
    final String? category;
    final String? mrpPrice;
    final String? salePrice;
    final String? brand;

    RelatedProduct({
        this.id,
        this.name,
        this.category,
        this.mrpPrice,
        this.salePrice,
        this.brand,
    });

    factory RelatedProduct.fromJson(Map<String, dynamic> json) => RelatedProduct(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        mrpPrice: json["mrp_price"],
        salePrice: json["sale_price"],
        brand: json["brand"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category,
        "mrp_price": mrpPrice,
        "sale_price": salePrice,
        "brand": brand,
    };
}
