import 'dart:async';
import 'package:app/Models/product_list_model.dart';
import 'package:app/Networking/api_provider.dart';

class ProductListRepository {
  ApiProvider _provider = ApiProvider();

  Future<ProductListModel> fetchProductListData({int page = 1}) async {
    final response =
        await _provider.get(url: "product/?page=" + page.toString());
    return ProductListModel.fromJson(response);
  }
}
