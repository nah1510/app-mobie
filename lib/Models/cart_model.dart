import 'dart:convert';

import 'package:app/Models/cart_detail_model.dart';

class CartModel {
  final int id;
  final int price;
  final List<CartDetailModel> details;

  CartModel({this.id, this.price, this.details});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    List<CartDetailModel> details = json['details'] != null
        ? List<CartDetailModel>.from(
            json["details"].map((i) => new CartDetailModel.fromJson(i)))
        : null;
    return CartModel(
        id: json['id'], price: json['total_price'], details: details);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total_price'] = this.price;
    data['details'] = this.details;

    return data;
  }
}
