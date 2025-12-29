import 'package:hive/hive.dart';
import 'cart_item.dart';

part 'order.g.dart';

@HiveType(typeId: 3)
class Order extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<CartItem> items;

  @HiveField(2)
  final double totalPrice;

  @HiveField(3)
  final DateTime orderDate;

  @HiveField(4)
  final String status; // pending, completed, cancelled

  @HiveField(5)
  final String? notes;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
    this.notes,
  });
}