import 'dart:async';
import 'package:app/Models/product_model.dart';
import 'package:app/Networking/api_provider.dart';

class ProductRepository {
  ApiProvider _provider = ApiProvider();

  Future<ProductModel> fetchData({int productId}) async {
    final response =
        await _provider.get(url: "product/" + productId.toString());
    return ProductModel.fromJson(response);
  }

  Future<ProductModel> add(int id) async {
    print(id);
    final response = await _provider.post(
      url: 'cart/' + id.toString(),
    );
    //save response token to secure storage
    return ProductModel.fromJson(response);
  }
}
