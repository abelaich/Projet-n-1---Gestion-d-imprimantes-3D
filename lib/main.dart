import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_n1/repository/printer_repository_dummy_impl.dart';
import 'package:project_n1/repository/printer_repository.dart';
import 'package:project_n1/widget/stock_widget.dart';
import 'package:provider/provider.dart';
import 'package:project_n1/presenter/stock_presenter.dart';

void main() {
  GetIt.instance.registerSingleton<PrinterRepository>(PrinterRepositoryDummyImpl());
  runApp(
    ChangeNotifierProvider<StockPresenter>(
      create: (context) => StockPresenterImpl(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '3D Printers',
      home: const StockWidget(), // Directly set the home widget
    );
  }
}
