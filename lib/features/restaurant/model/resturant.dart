import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int deliveryTime;
  final double deliveryFee;
  final List<String> categories;
  final List<MenuItem> menu;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.categories,
    required this.menu,
  });

  @override
  List<Object> get props => [
    id,
    name,
    description,
    imageUrl,
    rating,
    deliveryTime,
    deliveryFee,
    categories,
    menu,
  ];
}

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> allergens;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.allergens = const [],
  });

  @override
  List<Object> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    category,
    allergens,
  ];
}
