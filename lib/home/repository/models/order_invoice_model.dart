part of 'models.dart';


class OrderInvoiceModel {
    final Seller? seller;
    final Invoice? invoice;
    final Customer? customer;
    final List<Items>? items;
    final Summary? summary;

    OrderInvoiceModel({
        this.seller,
        this.invoice,
        this.customer,
        this.items,
        this.summary,
    });

    factory OrderInvoiceModel.fromJson(Map<String, dynamic> json) => OrderInvoiceModel(
        seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
        invoice: json["invoice"] == null ? null : Invoice.fromJson(json["invoice"]),
        customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
        items: json["items"] == null ? [] : List<Items>.from(json["items"]!.map((x) => Items.fromJson(x))),
        summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
    );

    Map<String, dynamic> toJson() => {
        "seller": seller?.toJson(),
        "invoice": invoice?.toJson(),
        "customer": customer?.toJson(),
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
        "summary": summary?.toJson(),
    };
}

class Customer {
    final String? name;
    final String? billingAddress;
    final String? shippingAddress;

    Customer({
        this.name,
        this.billingAddress,
        this.shippingAddress,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        name: json["name"],
        billingAddress: json["billing_address"],
        shippingAddress: json["shipping_address"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "billing_address": billingAddress,
        "shipping_address": shippingAddress,
    };
}

class Invoice {
    final String? invoiceNo;
    final String? orderNo;
    final String? placeOfSupply;
    final String? date;

    Invoice({
        this.invoiceNo,
        this.orderNo,
        this.placeOfSupply,
        this.date,
    });

    factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        invoiceNo: json["invoice_no"],
        orderNo: json["order_no"],
        placeOfSupply: json["place_of_supply"],
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "invoice_no": invoiceNo,
        "order_no": orderNo,
        "place_of_supply": placeOfSupply,
        "date": date,
    };
}

class Items {
    final int? srNo;
    final String? productName;
    final String? hsn;
    final int? qty;
    final String? rate;
    final String? discount;
    final double? taxableAmt;
    final String? cgstRate;
    final int? cgstAmt;
    final String? sgstRate;
    final int? sgstAmt;
    final String? igstRate;
    final int? igstAmt;
    final double? totalAmt;

    Items({
        this.srNo,
        this.productName,
        this.hsn,
        this.qty,
        this.rate,
        this.discount,
        this.taxableAmt,
        this.cgstRate,
        this.cgstAmt,
        this.sgstRate,
        this.sgstAmt,
        this.igstRate,
        this.igstAmt,
        this.totalAmt,
    });

    factory Items.fromJson(Map<String, dynamic> json) => Items(
        srNo: json["sr_no"],
        productName: json["product_name"],
        hsn: json["hsn"],
        qty: json["qty"],
        rate: json["rate"],
        discount: json["discount"],
        taxableAmt: json["taxable_amt"]?.toDouble(),
        cgstRate: json["cgst_rate"],
        cgstAmt: json["cgst_amt"],
        sgstRate: json["sgst_rate"],
        sgstAmt: json["sgst_amt"],
        igstRate: json["igst_rate"],
        igstAmt: json["igst_amt"],
        totalAmt: json["total_amt"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "sr_no": srNo,
        "product_name": productName,
        "hsn": hsn,
        "qty": qty,
        "rate": rate,
        "discount": discount,
        "taxable_amt": taxableAmt,
        "cgst_rate": cgstRate,
        "cgst_amt": cgstAmt,
        "sgst_rate": sgstRate,
        "sgst_amt": sgstAmt,
        "igst_rate": igstRate,
        "igst_amt": igstAmt,
        "total_amt": totalAmt,
    };
}

class Seller {
    final String? name;
    final String? address;
    final String? gstin;
    final String? fssai;

    Seller({
        this.name,
        this.address,
        this.gstin,
        this.fssai,
    });

    factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        name: json["name"],
        address: json["address"],
        gstin: json["gstin"],
        fssai: json["fssai"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "gstin": gstin,
        "fssai": fssai,
    };
}

class Summary {
    final double? itemTotal;
    final int? handlingCharge;
    final int? shippingCharge;
    final int? couponDiscount;
    final String? invoiceValue;

    Summary({
        this.itemTotal,
        this.handlingCharge,
        this.shippingCharge,
        this.couponDiscount,
        this.invoiceValue,
    });

    factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        itemTotal: json["item_total"]?.toDouble(),
        handlingCharge: json["handling_charge"],
        shippingCharge: json["shipping_charge"],
        couponDiscount: json["coupon_discount"],
        invoiceValue: json["invoice_value"],
    );

    Map<String, dynamic> toJson() => {
        "item_total": itemTotal,
        "handling_charge": handlingCharge,
        "shipping_charge": shippingCharge,
        "coupon_discount": couponDiscount,
        "invoice_value": invoiceValue,
    };
}
