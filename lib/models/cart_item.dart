import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 2)
class CartItem extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final double price;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  final double? promoPrice;

  CartItem({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.promoPrice,
  });

  double get totalPrice {
    final finalPrice = promoPrice ?? price;
    return finalPrice * quantity;
  }
}