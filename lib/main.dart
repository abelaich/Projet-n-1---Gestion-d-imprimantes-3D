import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_n1/repository/printer_repository_dummy_impl.dart';
import 'package:project_n1/repository/printer_repository.dart';
import 'package:project_n1/widget/stock_widget.dart';
import 'package:provider/provider.dart';
import 'package:project_n1/presenter/stock_presenter.dart';
import 'package:project_n1/resources/app_colors.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.secondaryColor, // Corps blanc
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.secondaryColor,
          titleTextStyle: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const StockWidget(), // Directly set the home widget
    );
  }
}
