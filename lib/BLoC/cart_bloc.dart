import 'package:app/Models/cart_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Repositories/cart_repository.dart';
import 'dart:async';
import 'bloc.dart';
import 'package:app/Ultilities/log.dart';

class CartBloc implements Bloc {
  CartRepository _cartRepository;
  StreamController _cartController;
  String token;

  StreamSink<ApiResponse<CartModel>> get cartSink => _cartController.sink;

  Stream<ApiResponse<CartModel>> get cartStream => _cartController.stream;

  CartBloc() {
    _cartController = StreamController<ApiResponse<CartModel>>();
    _cartRepository = CartRepository();
  }

  fetch() async {
    cartSink.add(ApiResponse.loading('Đang lấy dữ liệu người dùng'));
    try {
      CartModel cartStream = await _cartRepository.fetch();
      cartSink.add(ApiResponse.completed(cartStream));
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      Log.error(e.toString());
    }
  }

  delete() async {
    cartSink.add(ApiResponse.loading('Đang thanh toán'));
    try {
      CartModel cartStream = await _cartRepository.delete();
      cartSink.add(ApiResponse.error('Thanh toán thành công'));
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _cartController.close();
  }
}
