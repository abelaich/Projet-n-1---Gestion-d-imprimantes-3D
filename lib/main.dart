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
      debugShowCheckedModeBanner: false, // Hiding the debug banner
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,               // Primary color for the app
        scaffoldBackgroundColor: AppColors.secondaryColor,  // Background color for the scaffold
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.secondaryColor,        // AppBar background color
          titleTextStyle: TextStyle(
            color: AppColors.primaryColor,                  // Text color for the AppBar title
            fontSize: 24,                                   // Font size for the title
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const StockWidget(), // Setting StockWidget as the home screen
    );
  }
}
