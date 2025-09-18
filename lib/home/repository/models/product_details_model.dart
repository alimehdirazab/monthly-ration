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
    final dynamic sellPrice; // Changed to dynamic to handle both int and double
    final String? discount;
    final List<String>? images;
    final List<dynamic>? extraFields;
    final String? brand;
    final List<AttributeValue>? attributeValues; // Changed to proper model
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
        attributeValues: json["attribute_values"] == null ? [] : List<AttributeValue>.from(json["attribute_values"]!.map((x) => AttributeValue.fromJson(x))),
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
        "attribute_values": attributeValues == null ? [] : List<dynamic>.from(attributeValues!.map((x) => x.toJson())),
        "related_products": relatedProducts == null ? [] : List<dynamic>.from(relatedProducts!.map((x) => x.toJson())),
    };
}

class AttributeValue {
    final Attribute? attribute;

    AttributeValue({
        this.attribute,
    });

    factory AttributeValue.fromJson(Map<String, dynamic> json) => AttributeValue(
        attribute: json["attribute"] == null ? null : Attribute.fromJson(json["attribute"]),
    );

    Map<String, dynamic> toJson() => {
        "attribute": attribute?.toJson(),
    };
}

class Attribute {
    final int? id;
    final String? name;
    final List<AttributeValueDetail>? values;

    Attribute({
        this.id,
        this.name,
        this.values,
    });

    factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
        name: json["name"],
        values: json["values"] == null ? [] : List<AttributeValueDetail>.from(json["values"]!.map((x) => AttributeValueDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x.toJson())),
    };
}

class AttributeValueDetail {
    final int? id;
    final String? value;
    final String? extraPrice;

    AttributeValueDetail({
        this.id,
        this.value,
        this.extraPrice,
    });

    factory AttributeValueDetail.fromJson(Map<String, dynamic> json) => AttributeValueDetail(
        id: json["id"],
        value: json["value"],
        extraPrice: json["extra_price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "extra_price": extraPrice,
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
