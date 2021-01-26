import 'dart:async';
import 'package:app/Models/cart_model.dart';
import 'package:app/Networking/api_provider.dart';

class CartRepository {
  ApiProvider _provider = ApiProvider();

  Future<CartModel> fetch() async {
    final response = await _provider.get(url: 'cart');
    print(response);
    return CartModel.fromJson(response);
  }

  Future<CartModel> delete() async {
    final response = await _provider.post(url: 'cart/payment');
    print(response);
    return CartModel.fromJson(response);
  }
}
