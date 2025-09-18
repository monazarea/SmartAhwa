import 'customer.dart';
import 'drink.dart';

enum OrderStatus { pending, completed }

class Order {
  final Customer customer;
  final Drink drink;
  OrderStatus status;
  final DateTime date;

  Order({
    required this.customer,
    required this.drink,
    this.status = OrderStatus.pending,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  void markCompleted() {
    status = OrderStatus.completed;
  }
}
