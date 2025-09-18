import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/ahwa_cubit.dart';
import '../cubits/ahwa_state.dart';
import '../models/order.dart';
import '../models/report.dart';


class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportGenerator = ReportGenerator();

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقرير اليومي'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<AhwaCubit, AhwaState>(
        builder: (context, state) {
          if (state is AhwaOrdersUpdated && state.allOrders.isNotEmpty) {

            final report = reportGenerator.generateDailyReport(state.allOrders);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ملخص اليوم: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.receipt_long, color: Colors.blue),
                      title: Text('إجمالي الأوردرات المكتملة: ${report.totalOrders}'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'الأكثر مبيعاً:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  if (report.topSelling.isEmpty)
                    const Text('لم يتم إكمال أي أوردر بعد.')
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: report.topSelling.length,
                        itemBuilder: (context, index) {
                          final entry = report.topSelling[index];
                          return ListTile(
                            leading: Text('${index + 1} -'),
                            title: Text(entry.drink.name),
                            trailing: Text('${entry.quantity} مرة'),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          }
          return const Center(child: Text('لا توجد بيانات لعرض التقرير.'));
        },
      ),
    );
  }
}


class ReportGenerator {
  DailySalesReport generateDailyReport(List<Order> allOrders) {
    final today = DateTime.now();
    final completedToday = allOrders.where((order) {
      return order.status == OrderStatus.completed &&
          order.date.year == today.year &&
          order.date.month == today.month &&
          order.date.day == today.day;
    }).toList();

    if (completedToday.isEmpty) {
      return DailySalesReport(
        date: today,
        totalOrders: 0,
        topSelling: [],
      );
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
      topSelling: sortedDrinks,
    );
  }
}