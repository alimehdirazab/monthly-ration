part of 'models.dart';

class CartListModel {
    final bool? success;  // New field
    final List<CartItem>? data;

    CartListModel({
        this.success,  // New field
        this.data,
    });

    factory CartListModel.fromJson(Map<String, dynamic> json) => CartListModel(
        success: json["success"],  // New field
        data: json["data"] == null ? [] : List<CartItem>.from(json["data"]!.map((x) => CartItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,  // New field
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class CartItem {
    final int? id;
    final int? customerId;
    final int? productId;
    final int? quantity;
    final dynamic attributes;
    final int? attributeValueId;  // Keep this for product variants (optional)
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Produc? product;
    final List<dynamic>? attributesValues;  // New field

    CartItem({
        this.id,
        this.customerId,
        this.productId,
        this.quantity,
        this.attributes,
        this.attributeValueId,
        this.createdAt,
        this.updatedAt,
        this.product,
        this.attributesValues,  // New field
    });

    factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        customerId: json["customer_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        attributes: json["attributes"],
        attributeValueId: json["attribute_value_id"],  // Optional field for product variants
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        product: json["product"] == null ? null : Produc.fromJson(json["product"]),
        attributesValues: json["attributesValues"] == null ? [] : List<dynamic>.from(json["attributesValues"]!.map((x) => x)),  // New field
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "product_id": productId,
        "quantity": quantity,
        "attributes": attributes,
        "attribute_value_id": attributeValueId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "product": product?.toJson(),
        "attributesValues": attributesValues == null ? [] : List<dynamic>.from(attributesValues!.map((x) => x)),  // New field
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
    final String? purchasePrice;  // New field
    final String? tax;
    final String? discount;
    final String? shippingCost;
    final int? stock;  // Changed from addStock to stock
    final List<dynamic>? tagIds;
    final String? unit;
    final bool? published;
    final String? weight;
    final String? pieces;
    final dynamic colorsIds;
    final List<String> imagesUrls;  // Changed from images to imagesUrls
    final List<dynamic>? extraFields;
    final int? isTranding;  // New field
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
        this.purchasePrice,  // New field
        this.tax,
        this.discount,
        this.shippingCost,
        this.stock,  // Changed from addStock to stock
        this.tagIds,
        this.unit,
        this.published,
        this.weight,
        this.pieces,
        this.colorsIds,
        required this.imagesUrls,  // Changed from images to imagesUrls
        this.extraFields,
        this.isTranding,  // New field
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
        purchasePrice: json["purchase_price"],  // New field
        tax: json["tax"],
        discount: json["discount"],
        shippingCost: json["shipping_cost"],
        stock: json["stock"],  // Changed from add_stock to stock
        tagIds: json["tag_ids"] == null ? [] : List<dynamic>.from(json["tag_ids"]!.map((x) => x)),
        unit: json["unit"],
        published: json["published"],
        weight: json["weight"],
        pieces: json["pieces"],
        colorsIds: json["colors_ids"],
        imagesUrls: _parseImages(json["images"]),  // Parse images JSON string
        extraFields: json["extra_fields"] == null ? [] : List<dynamic>.from(json["extra_fields"]!.map((x) => x)),
        isTranding: json["is_tranding"],  // New field
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
        "purchase_price": purchasePrice,  // New field
        "tax": tax,
        "discount": discount,
        "shipping_cost": shippingCost,
        "stock": stock,  // Changed from add_stock to stock
        "tag_ids": tagIds == null ? [] : List<dynamic>.from(tagIds!.map((x) => x)),
        "unit": unit,
        "published": published,
        "weight": weight,
        "pieces": pieces,
        "colors_ids": colorsIds,
        "images": imagesUrls,
        "extra_fields": extraFields == null ? [] : List<dynamic>.from(extraFields!.map((x) => x)),
        "is_tranding": isTranding,  // New field
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
