import 'package:app/Models/product_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Repositories/product_repository.dart';

import 'dart:async';
import 'bloc.dart';

class ProductBloc implements Bloc {
  ProductRepository _productRepository;
  StreamController _productController;

  StreamSink<ApiResponse<ProductModel>> get productSink =>
      _productController.sink;

  Stream<ApiResponse<ProductModel>> get productStream =>
      _productController.stream;

  ProductBloc() {
    _productController = StreamController<ApiResponse<ProductModel>>();
    _productRepository = ProductRepository();
  }

  fetchproduct(Object args) async {
    productSink.add(ApiResponse.loading('Đang lấy dữ liệu sản phẩm'));

    try {
      ProductModel product =
          await _productRepository.fetchData(productId: args);
      productSink.add(ApiResponse.completed(product));
    } catch (e) {
      productSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  add(int id) async {
    try {
      ProductModel product = await _productRepository.add(id);
      productSink.add(ApiResponse.error('Thêm thành công'));
    } catch (e) {
      productSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _productController.close();
  }
}
