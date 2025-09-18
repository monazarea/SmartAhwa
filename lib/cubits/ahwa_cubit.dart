import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/order_services.dart';
import '../services/report_generator.dart';
import '../models/customer.dart';
import '../models/drink.dart';
import '../models/order.dart';
import 'ahwa_state.dart';

class AhwaCubit extends Cubit<AhwaState> {

  final IOrderService _orderService;
  final IReportGenerator _reportGenerator;
  AhwaCubit(this._orderService, this._reportGenerator) : super(AhwaInitial());



  void addOrder({required String customerName, required Drink drink}) {
    _orderService.addOrder(customerName: customerName, drink: drink);
    _emitOrdersUpdatedState();
  }

  void completeOrder(Order order) {
    _orderService.completeOrder(order);
    _emitOrdersUpdatedState();
  }
  void getInitialOrders() {
    _emitOrdersUpdatedState();
  }

  void generateDailyReport() {
    final allOrders = _orderService.allOrders;
    final report = _reportGenerator.generate(allOrders);
    emit(AhwaReportGenerated(report: report));
  }

  void _emitOrdersUpdatedState() {
    final pending = _orderService.pendingOrders;
    final all = _orderService.allOrders;
    emit(AhwaOrdersUpdated(pendingOrders: pending, allOrders: all));
  }
}