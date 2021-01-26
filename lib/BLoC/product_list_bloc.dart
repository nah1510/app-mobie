import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/product_list_model.dart';
import 'package:app/Repositories/product_list_repository.dart';
import 'package:app/Repositories/product_repository.dart';

import 'dart:async';
import 'bloc.dart';

class ProductListBloc implements Bloc {
  ProductListRepository _productListRepository;
  StreamController _productListController;

  StreamSink<ApiResponse<ProductListModel>> get productListSink =>
      _productListController.sink;

  Stream<ApiResponse<ProductListModel>> get productListStream =>
      _productListController.stream;

  ProductListBloc() {
    _productListController = StreamController<ApiResponse<ProductListModel>>();
    _productListRepository = ProductListRepository();
  }

  fetchProductLists() async {
    productListSink.add(ApiResponse.loading('Đang lấy dữ liệu ví'));
    try {
      ProductListModel productList =
          await _productListRepository.fetchProductListData(page: 1);
      productListSink.add(ApiResponse.completed(productList));
    } catch (e) {
      productListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _productListController.close();
  }
}
