import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_n1/Repository/printer_repository_dummy_impl.dart';
import 'package:project_n1/repository/printer_repository.dart';

void main() {
  GetIt.instance.registerSingleton<PrinterRepository>(PrinterRepositoryDummyImpl() as PrinterRepository);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.black);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '3D Printers',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20),
          labelLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 20)
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor:  Colors.white,
        )

      ),
      home: const MyHomePage(title: '3D PRINTER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Project 1 M2 SIME 24 25"),
      ),
    );
  }
}

