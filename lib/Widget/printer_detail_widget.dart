import 'package:flutter/material.dart';
import 'package:project_n1/data/product.dart';

class PrinterDetailWidget extends StatelessWidget {
  final Product product;

  const PrinterDetailWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${product.title} # ${product.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          ],
        ),
      ),
    );
  }
}
