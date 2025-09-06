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
    final int id;
    final String name;
    final String? category;
    final dynamic price;
    final List<dynamic> extraFields;
    final String? brand;
    final List<AttributeValue> attributeValues;
    final List<dynamic> relatedProducts;

    ProductDetails({
        required this.id,
        required this.name,
        this.category,
        required this.price,
        required this.extraFields,
        this.brand,
        required this.attributeValues,
        required this.relatedProducts,
    });

    factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        price: json["price"],
        extraFields: List<dynamic>.from(json["extra_fields"] ?? []),
        brand: json["brand"],
        attributeValues: List<AttributeValue>.from((json["attribute_values"] ?? []).map((x) => AttributeValue.fromJson(x))),
        relatedProducts: List<dynamic>.from(json["related_products"] ?? []),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category,
        "price": price,
        "extra_fields": extraFields,
        "brand": brand,
        "attribute_values": List<dynamic>.from(attributeValues.map((x) => x.toJson())),
        "related_products": List<dynamic>.from(relatedProducts.map((x) => x)),
    };
}

class AttributeValue {
    final Attribute attribute;

    AttributeValue({
        required this.attribute,
    });

    factory AttributeValue.fromJson(Map<String, dynamic> json) => AttributeValue(
        attribute: Attribute.fromJson(json["attribute"]),
    );

    Map<String, dynamic> toJson() => {
        "attribute": attribute.toJson(),
    };
}

class Attribute {
    final int id;
    final String name;
    final List<Value> values;

    Attribute({
        required this.id,
        required this.name,
        required this.values,
    });

    factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
        name: json["name"],
        values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "values": List<dynamic>.from(values.map((x) => x.toJson())),
    };
}

class Value {
    final int id;
    final String value;
    final String extraPrice;

    Value({
        required this.id,
        required this.value,
        required this.extraPrice,
    });

    factory Value.fromJson(Map<String, dynamic> json) => Value(
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

class ExtraFields {
    final String color;
    final String updates;

    ExtraFields({
        required this.color,
        required this.updates,
    });

    factory ExtraFields.fromJson(Map<String, dynamic> json) => ExtraFields(
        color: json["Color"],
        updates: json["Updates"],
    );

    Map<String, dynamic> toJson() => {
        "Color": color,
        "Updates": updates,
    };
}
