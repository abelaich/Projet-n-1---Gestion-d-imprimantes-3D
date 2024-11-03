import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_n1/repository/printer_repository.dart';
import 'package:project_n1/data/product.dart';
import 'package:project_n1/widget/product_widget.dart';
import 'package:project_n1/widget/printer_detail_widget.dart';
import 'package:provider/provider.dart';

import '../presenter/stock_presenter.dart';

class StockWidget extends StatefulWidget {
  const StockWidget({super.key});

  @override
  State<StockWidget> createState() => _StockWidgetState();
}

class _StockWidgetState extends State<StockWidget> {
  bool filterById = false;
  bool filterByType = false;
  bool filterByDate = false;

  @override
  Widget build(BuildContext context) {
    final stockPresenter = context.watch<StockPresenter>(); // Watch the presenter for updates
    final List<Product> products = stockPresenter.products; // Get the updated products

    // Apply filters
    List<Product> applyFilters() {
      List<Product> filteredProducts = List.from(products);

      // Sorting logic based on filters
      filteredProducts.sort((a, b) {
        // Compare by ID
        if (filterById) {
          int idComparison = a.id.compareTo(b.id);
          if (idComparison != 0) return idComparison;
        }

        // Compare by Type
        if (filterByType) {
          int typeComparison = a.title.compareTo(b.title);
          if (typeComparison != 0) return typeComparison;
        }

        // Compare by Date
        if (filterByDate) {
          return a.date.compareTo(b.date);
        }

        return 0;
      });

      return filteredProducts;
    }

    List<Product> filteredProducts = applyFilters();

    return Scaffold(
      appBar: AppBar(
        title: const Text("3D Printer"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Checkbox(
                  value: filterById,
                  onChanged: (bool? newValue) {
                    setState(() {
                      filterById = newValue!;
                    });
                  },
                ),
                const Expanded(child: Text("ID")),
                Checkbox(
                  value: filterByType,
                  onChanged: (bool? newValue) {
                    setState(() {
                      filterByType = newValue!;
                    });
                  },
                ),
                const Expanded(child: Text("TYPE")),
                Checkbox(
                  value: filterByDate,
                  onChanged: (bool? newValue) {
                    setState(() {
                      filterByDate = newValue!;
                    });
                  },
                ),
                const Expanded(child: Text("Date")),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (BuildContext context, int index) {
                final product = filteredProducts[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrinterDetailWidget(product: product),
                      ),
                    );
                  },
                  child: ProductWidget(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
