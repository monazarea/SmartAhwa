import '../models/customer.dart';
import '../models/order.dart';
import '../models/drink.dart';

abstract class IOrderService {
  List<Order> get pendingOrders;
  void addOrder({required String customerName, required Drink drink});
  void completeOrder(Order order);
  List<Order> get allOrders; // هنحتاجها للتقرير
}

class OrderService implements IOrderService {
  final List<Order> _orders = [];

  @override
  List<Order> get pendingOrders =>
      _orders.where((order) => order.status == OrderStatus.pending).toList();

  @override
  List<Order> get allOrders => List.unmodifiable(_orders); // نسخة للقراءة فقط

  @override
  void addOrder({required String customerName, required Drink drink}) {
    final customer = Customer(name: customerName);
    final newOrder = Order(customer: customer, drink: drink);
    _orders.add(newOrder);
  }

  @override
  void completeOrder(Order order) {
    final orderIndex = _orders.indexOf(order);
    if (orderIndex != -1) {
      _orders[orderIndex].markCompleted();
    }
  }
}