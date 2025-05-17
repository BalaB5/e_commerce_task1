
import 'dart:convert';

import 'package:e_commerce/src/model/rating.dart';

List<Product> productFromJson( json) => List<Product>.from(json.map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    int? id;
    String? title;
    double? price;
    String? description;
    String? image;
    Rating? rating;

    Product({
         this.id,
         this.title,
         this.price,
         this.description,
         this.image,
         this.rating,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        price: json["price"]?.toDouble(),
        description: json["description"],
        image: json["image"],
        rating: Rating.fromJson(json["rating"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "image": image,
        "rating": rating!.toJson(),
    };
}
