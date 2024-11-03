import 'package:flutter/material.dart';
import 'package:project_n1/data/product.dart';
import 'package:provider/provider.dart';
import 'package:project_n1/presenter/stock_presenter.dart';

class PrinterDetailWidget extends StatelessWidget {
  final Product product;

  const PrinterDetailWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final stockPresenter = context.watch<StockPresenter>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${product.title} #${product.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image widget that updates based on product type
            TextFormField(
              initialValue: '${product.id}',
              decoration: const InputDecoration(labelText: 'Identification Number'),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                try {
                  stockPresenter.setProductId(product, int.parse(text)); // Updates the ID
                } on FormatException {
                  // Handle error if needed
                }
              },
            ),

            DropdownButton<String>(
              value: product.title,
              items: <String>['Powder printer', 'Wire printer', 'Resin printer']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  stockPresenter.setProductType(product, newValue); // Updates the type
                }
              },
            ),

            TextFormField(
              initialValue: product.date.toLocal().toString().split(' ')[0],
              decoration: const InputDecoration(labelText: 'Service Date'),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: product.date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  stockPresenter.setProductDate(product, selectedDate); // Updates the date
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
