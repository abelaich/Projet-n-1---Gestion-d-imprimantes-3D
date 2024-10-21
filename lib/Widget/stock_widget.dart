import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_n1/repository/printer_repository.dart';
import 'package:project_n1/data/product.dart';
import 'product_widget.dart';

class StockWidget extends StatelessWidget {
  const StockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text (" 3D Printer "),
        ),
    );
  }
}
