import 'drink.dart';
import 'order.dart';

class ReportEntry {
  final Drink drink;
  final int quantity;

  ReportEntry({required this.drink, required this.quantity});
}

class Report {
  final int totalOrders;
  final List<ReportEntry> topSelling;

  Report({
    required this.totalOrders,
    required this.topSelling,
  });
}


class DailySalesReport extends Report {
  final DateTime date;

  DailySalesReport({
    required this.date,
    required int totalOrders,
    required List<ReportEntry> topSelling,
  }) : super(totalOrders: totalOrders, topSelling: topSelling);
}

