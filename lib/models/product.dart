import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String categoryId;

  @HiveField(3)
  final String categoryName;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final String imageUrl;

  @HiveField(7)
  final double rating;

  @HiveField(8)
  final int reviews;

  @HiveField(9)
  final int stock;

  @HiveField(10)
  final bool isPromo;

  @HiveField(11)
  final double? promoPrice;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.stock,
    this.isPromo = false,
    this.promoPrice,
  });

  double get finalPrice => isPromo && promoPrice != null ? promoPrice! : price;

  int get discountPercent {
    if (!isPromo || promoPrice == null) return 0;
    return ((price - promoPrice!) / price * 100).toInt();
  }
}