import 'dart:convert';

import 'package:app/Models/product_model.dart';

class CartDetailModel {
  final int id;
  final int price;
  final int quantity;
  final ProductModel product;
  CartDetailModel({this.id, this.price, this.quantity, this.product});

  factory CartDetailModel.fromJson(Map<String, dynamic> json) {
    return CartDetailModel(
        id: json['id'],
        price: json['unit_price'],
        quantity: json['quantity'],
        product: ProductModel.fromJson(json['product']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unit_price'] = this.price;
    data['quantity'] = this.quantity;
    data['product'] = this.product;
    return data;
  }
}
