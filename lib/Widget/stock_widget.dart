import 'package:flutter/material.dart';
import 'package:project_n1/data/product.dart';
import 'package:project_n1/widget/product_widget.dart';
import 'package:project_n1/widget/printer_detail_widget.dart';
import 'package:provider/provider.dart';
import 'package:project_n1/resources/app_colors.dart';
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
    final stockPresenter = context.watch<StockPresenter>();
    final List<Product> products = stockPresenter.products;

    List<Product> applyFilters() {
      List<Product> filteredProducts = List.from(products);

      filteredProducts.sort((a, b) {
        if (filterById) {
          int idComparison = a.id.compareTo(b.id);
          if (idComparison != 0) return idComparison;
        }

        if (filterByType) {
          int typeComparison = a.title.compareTo(b.title);
          if (typeComparison != 0) return typeComparison;
        }

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
        title: const Text(
          "3D Printer",
          style: TextStyle(
            fontSize: 32, // Augmente la taille de la police
            color: AppColors.primaryColor, // Texte noir pour le contraste sur fond blanc
          ),
        ),
        centerTitle: true, // Centre le titre dans l'AppBar
        backgroundColor: AppColors.secondaryColor, // Fond blanc pour l'AppBar
      ),
      body: Column(
        children: [
          _buildFilterOptions(),
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

  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        color: AppColors.secondaryColor,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterOption('ID', filterById, (bool? newValue) {
                setState(() {
                  filterById = newValue!;
                });
              }),
              _buildFilterOption('TYPE', filterByType, (bool? newValue) {
                setState(() {
                  filterByType = newValue!;
                });
              }),
              _buildFilterOption('DATE', filterByDate, (bool? newValue) {
                setState(() {
                  filterByDate = newValue!;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          checkColor: AppColors.secondaryColor,
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primaryColor;
            }
            return AppColors.secondaryColor;
          }),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
