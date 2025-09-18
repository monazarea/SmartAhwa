import '../models/order.dart';
import '../models/report.dart';

abstract class IReportGenerator {
  DailySalesReport generate(List<Order> orders);
}


class ReportGenerator implements IReportGenerator {
  @override
  DailySalesReport generate(List<Order> orders) {
    final today = DateTime.now();
    final completedToday = orders.where((order) {
      return order.status == OrderStatus.completed &&
          order.date.year == today.year &&
          order.date.month == today.month &&
          order.date.day == today.day;
    }).toList();

    if (completedToday.isEmpty) {
      return DailySalesReport(date: today, totalOrders: 0, topSelling: []);
    }

    final Map<String, int> drinkCounts = {};
    for (var order in completedToday) {
      drinkCounts[order.drink.name] = (drinkCounts[order.drink.name] ?? 0) + 1;
    }

    final sortedDrinks = drinkCounts.entries.map((entry) {
      final drink = completedToday.firstWhere((o) => o.drink.name == entry.key).drink;
      return ReportEntry(drink: drink, quantity: entry.value);
    }).toList();

    sortedDrinks.sort((a, b) => b.quantity.compareTo(a.quantity));

    return DailySalesReport(
      date: today,
      totalOrders: completedToday.length,
      topSelling: sortedDrinks.take(3).toList(),
    );
  }
}