import 'dart:async';
import 'package:app/Networking/api_provider.dart';
import 'package:app/Models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterRepository {
  ApiProvider _provider = ApiProvider();
  final _storage = FlutterSecureStorage();

  Future<String> register(UserModel userModel) async {
    final response = await _provider.post(
      url: 'register/',
      data: userModel.toJson(),
    );
    //save response token to secure storage
    await _storage.write(key: "token", value: response);
    return response;
  }
}
