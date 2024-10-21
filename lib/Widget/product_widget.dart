import 'package:flutter/material.dart';
import 'package:project_n1/data/product.dart';

class ProductWidget extends StatelessWidget {
  final Product product;

  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding : const EdgeInsets .all (16.0) ,
      child: Row(
        children : [

          Expanded(child: Image.asset(product.image)),
          const SizedBox ( width : 16) ,
          Expanded ( child : Text (product.title) ),
          const SizedBox ( width : 16) ,
          Expanded ( child : Text('ID: ${product.id}\nDate: ${product.date.toLocal().toString().split(' ')[0]}') ),
        ]
      ),
    );
  }
}
