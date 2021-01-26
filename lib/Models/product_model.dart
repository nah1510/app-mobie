import 'dart:convert';

import 'package:app/Models/image_model.dart';

class ProductModel {
  final int id;
  final String tittle;
  final int price;
  final String rating;
  final String image;
  final String description;
  final List<ImageModel> images;

  ProductModel(
      {this.id,
      this.tittle,
      this.price,
      this.rating,
      this.description,
      this.image,
      this.images});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<ImageModel> images = json['images'] != null
        ? List<ImageModel>.from(
            json["images"].map((i) => new ImageModel.fromJson(i)))
        : null;
    return ProductModel(
        id: json['id'],
        tittle: json['tittle'],
        price: json['price'],
        rating: json['rating'],
        image: json['image'],
        description: json['description'],
        images: images);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tittle'] = this.tittle;
    data['price'] = this.price;
    data['rating'] = this.rating;
    data['description'] = this.description;
    data['images'] = this.images;
    data['image'] = this.image;
    return data;
  }
}
