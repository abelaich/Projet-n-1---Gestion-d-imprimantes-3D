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
                  final newId = int.parse(text);
                  stockPresenter.setProductId(product, newId, (errorMessage) {
                    // Show the snackbar with the error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }); // Updates the ID
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
              readOnly: true, // Prevents keyboard from showing
              decoration: const InputDecoration(labelText: 'Service Date'),
              controller: TextEditingController(text: product.date.toLocal().toString().split(' ')[0]), // Initialize with current date
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: product.date,
                  firstDate: DateTime(1161),  //the first printer ever made
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  stockPresenter.setProductDate(product, selectedDate); // Updates the date
                  // You may want to set the text controller to the new date to reflect the change
                  // You may need to use a stateful widget for this
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}
