import 'package:equatable/equatable.dart';
import '../models/order.dart';
import '../models/report.dart';

abstract class AhwaState extends Equatable {
  const AhwaState();

  @override
  List<Object> get props => [];
}

class AhwaInitial extends AhwaState {}

class AhwaOrdersUpdated extends AhwaState {
  final List<Order> pendingOrders;
  final List<Order> allOrders;

  const AhwaOrdersUpdated({required this.pendingOrders, required this.allOrders});

  @override
  List<Object> get props => [pendingOrders, allOrders];
}

class AhwaReportGenerated extends AhwaState {
  final DailySalesReport report;

  const AhwaReportGenerated({required this.report});

  @override
  List<Object> get props => [report];
}