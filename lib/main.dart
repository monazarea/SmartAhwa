import 'package:ahwago/services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// 1. هنعمل import للحزمة اللي ضفناها
import 'package:flutter_localizations/flutter_localizations.dart';

import 'cubits/ahwa_cubit.dart';
import 'screens/dashboard_screen.dart';
import 'services/report_generator.dart';

void main() {
  runApp(const SmartAhwaApp());
}

class SmartAhwaApp extends StatelessWidget {
  const SmartAhwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IOrderService>(
          create: (context) => OrderService(),
        ),
        RepositoryProvider<IReportGenerator>(
          create: (context) => ReportGenerator(),
        ),
      ],
      child: BlocProvider(
        create: (context) => AhwaCubit(
          context.read<IOrderService>(),
          context.read<IReportGenerator>(),
        )..getInitialOrders(),
        child: MaterialApp(
          title: 'Smart Ahwa Manager',
          debugShowCheckedModeBanner: false,

            locale: const Locale('ar'),

          supportedLocales: const [
            Locale('ar'),
          ],

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],


          theme: ThemeData(
            fontFamily: 'Cairo',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
            useMaterial3: true,
          ),
          home: const DashboardScreen(),
        ),
      ),
    );
  }
}