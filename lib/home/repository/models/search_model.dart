part of 'models.dart';

class SearchModel {
  final bool? status;
  final List<SearchProduct>? data;

  SearchModel({
    this.status,
    this.data,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<SearchProduct>.from(json["data"]!.map((x) => SearchProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SearchProduct {
  final int? id;
  final String? name;
  final String? description;
  final String? category;
  final String? subcategory;
  final String? brand;
  final String? mrpPrice;
  final String? discount;
  final String? salePrice;
  final String? weight;
  final List<String>? imagesUrls;
  final String? tax;
  final int? cartQuantity;
  final List<SearchAttributeValue>? attributeValues;

  SearchProduct({
    this.id,
    this.name,
    this.description,
    this.category,
    this.subcategory,
    this.brand,
    this.mrpPrice,
    this.discount,
    this.salePrice,
    this.weight,
    this.imagesUrls,
    this.tax,
    this.cartQuantity,
    this.attributeValues,
  });

  factory SearchProduct.fromJson(Map<String, dynamic> json) => SearchProduct(
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
    imagesUrls: json["images_urls"] == null ? [] : List<String>.from(json["images_urls"]!.map((x) => x)),
    tax: json["tax"],
    cartQuantity: json["cart_quantity"] is String 
        ? int.tryParse(json["cart_quantity"]) 
        : json["cart_quantity"],
    attributeValues: json["attribute_values"] == null ? [] : List<SearchAttributeValue>.from(json["attribute_values"]!.map((x) => SearchAttributeValue.fromJson(x))),
  );

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
    "images_urls": imagesUrls == null ? [] : List<dynamic>.from(imagesUrls!.map((x) => x)),
    "tax": tax,
    "cart_quantity": cartQuantity,
    "attribute_values": attributeValues == null ? [] : List<dynamic>.from(attributeValues!.map((x) => x.toJson())),
  };
}

class SearchAttributeValue {
  final SearchAttribute? attribute;

  SearchAttributeValue({
    this.attribute,
  });

  factory SearchAttributeValue.fromJson(Map<String, dynamic> json) => SearchAttributeValue(
    attribute: json["attribute"] == null ? null : SearchAttribute.fromJson(json["attribute"]),
  );

  Map<String, dynamic> toJson() => {
    "attribute": attribute?.toJson(),
  };
}

class SearchAttribute {
  final int? id;
  final String? name;
  final List<SearchAttributeValueDetail>? values;

  SearchAttribute({
    this.id,
    this.name,
    this.values,
  });

  factory SearchAttribute.fromJson(Map<String, dynamic> json) => SearchAttribute(
    id: json["id"],
    name: json["name"],
    values: json["values"] == null ? [] : List<SearchAttributeValueDetail>.from(json["values"]!.map((x) => SearchAttributeValueDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x.toJson())),
  };
}

class SearchAttributeValueDetail {
  final dynamic id;
  final dynamic value;
  final String? mrpPrice;
  final String? discount;
  final String? sellPrice;
  final int? stock;

  SearchAttributeValueDetail({
    this.id,
    this.value,
    this.mrpPrice,
    this.discount,
    this.sellPrice,
    this.stock,
  });

  factory SearchAttributeValueDetail.fromJson(Map<String, dynamic> json) => SearchAttributeValueDetail(
    id: json["id"],
    value: json["value"],
    mrpPrice: json["mrp_price"],
    discount: json["discount"],
    sellPrice: json["sell_price"],
    stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "mrp_price": mrpPrice,
    "discount": discount,
    "sell_price": sellPrice,
    "stock": stock,
  };
}

