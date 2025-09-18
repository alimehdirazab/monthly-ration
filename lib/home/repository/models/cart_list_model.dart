part of 'models.dart';

class CartListModel {
    final List<CartItem>? data;

    CartListModel({
        this.data,
    });

    factory CartListModel.fromJson(Map<String, dynamic> json) => CartListModel(
        data: json["data"] == null ? [] : List<CartItem>.from(json["data"]!.map((x) => CartItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class CartItem {
    final int? id;
    final int? customerId;
    final int? productId;
    final int? quantity;
    final dynamic attributes;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Produc? product;

    CartItem({
        this.id,
        this.customerId,
        this.productId,
        this.quantity,
        this.attributes,
        this.createdAt,
        this.updatedAt,
        this.product,
    });

    factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        customerId: json["customer_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        attributes: json["attributes"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        product: json["product"] == null ? null : Produc.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "product_id": productId,
        "quantity": quantity,
        "attributes": attributes,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "product": product?.toJson(),
    };
}

class AttributesClass {
    final String? color;
    final String? size;

    AttributesClass({
        this.color,
        this.size,
    });

    factory AttributesClass.fromJson(Map<String, dynamic> json) => AttributesClass(
        color: json["color"],
        size: json["size"],
    );

    Map<String, dynamic> toJson() => {
        "color": color,
        "size": size,
    };
}

class Produc {
    final int? id;
    final String? name;
    final String? slug;
    final String? description;
    final String? categoryIds;
    final int? subCategory;
    final dynamic subsubCategoryId;
    final String? brandId;
    final String? mrpPrice;
    final String? salePrice;
    final String? tax;
    final String? discount;
    final String? shippingCost;
    final int? addStock;
    final List<dynamic>? tagIds;
    final String? unit;
    final bool? published;
    final String? weight;
    final String? pieces;
    final dynamic colorsIds;
    final String? images;
    final List<dynamic>? extraFields;
    final int? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Produc({
        this.id,
        this.name,
        this.slug,
        this.description,
        this.categoryIds,
        this.subCategory,
        this.subsubCategoryId,
        this.brandId,
        this.mrpPrice,
        this.salePrice,
        this.tax,
        this.discount,
        this.shippingCost,
        this.addStock,
        this.tagIds,
        this.unit,
        this.published,
        this.weight,
        this.pieces,
        this.colorsIds,
        this.images,
        this.extraFields,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory Produc.fromJson(Map<String, dynamic> json) => Produc(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        categoryIds: json["category_ids"],
        subCategory: json["sub_category"],
        subsubCategoryId: json["subsub_category_id"],
        brandId: json["brand_id"],
        mrpPrice: json["mrp_price"],
        salePrice: json["sale_price"],
        tax: json["tax"],
        discount: json["discount"],
        shippingCost: json["shipping_cost"],
        addStock: json["add_stock"],
        tagIds: json["tag_ids"] == null ? [] : List<dynamic>.from(json["tag_ids"]!.map((x) => x)),
        unit: json["unit"],
        published: json["published"],
        weight: json["weight"],
        pieces: json["pieces"],
        colorsIds: json["colors_ids"],
        images: json["images"],
        extraFields: json["extra_fields"] == null ? [] : List<dynamic>.from(json["extra_fields"]!.map((x) => x)),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
        "category_ids": categoryIds,
        "sub_category": subCategory,
        "subsub_category_id": subsubCategoryId,
        "brand_id": brandId,
        "mrp_price": mrpPrice,
        "sale_price": salePrice,
        "tax": tax,
        "discount": discount,
        "shipping_cost": shippingCost,
        "add_stock": addStock,
        "tag_ids": tagIds == null ? [] : List<dynamic>.from(tagIds!.map((x) => x)),
        "unit": unit,
        "published": published,
        "weight": weight,
        "pieces": pieces,
        "colors_ids": colorsIds,
        "images": images,
        "extra_fields": extraFields == null ? [] : List<dynamic>.from(extraFields!.map((x) => x)),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
