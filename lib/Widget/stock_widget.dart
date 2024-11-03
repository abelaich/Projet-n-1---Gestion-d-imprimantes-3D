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
    final stockPresenter = context.watch<StockPresenter>(); // Watching the StockPresenter for changes
    final List<Product> products = stockPresenter.products; // Fetching the list of products

    List<Product> applyFilters() {
      List<Product> filteredProducts = List.from(products);

      // Sorting products based on selected filters
      filteredProducts.sort((a, b) {
        if (filterById) {
          int idComparison = a.id.compareTo(b.id); // Compare IDs
          if (idComparison != 0) return idComparison; // Sort by ID if different
        }

        if (filterByType) {
          int typeComparison = a.title.compareTo(b.title); // Compare by title (type)
          if (typeComparison != 0) return typeComparison; // Sort by type if different
        }

        if (filterByDate) {
          return a.date.compareTo(b.date); // Sort by date
        }

        return 0; // No sorting if no filters are applied
      });

      return filteredProducts;
    }

    List<Product> filteredProducts = applyFilters();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "3D Printer",
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        centerTitle: true, // Centering the title
      ),
      body: Column( // Using a Column to organize filters and product list
        children: [
          _buildFilterOptions(),
          Expanded( // Expanding the ListView to fill available space
            child: ListView.builder(
              itemCount: filteredProducts.length, // Total number of filtered products
              itemBuilder: (BuildContext context, int index) {
                final product = filteredProducts[index]; // Get product at current index

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrinterDetailWidget(product: product), // Navigating to details
                      ),
                    );
                  },
                  child: ProductWidget(product: product), // Displaying the product widget
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
      padding: const EdgeInsets.all(16.0), // Padding for filter card
      child: Card(
        elevation: 4,
        color: AppColors.secondaryColor, // Background color for filter card
        margin: const EdgeInsets.symmetric(horizontal: 25.0), // Margin
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distributing filter options
            children: [
              _buildFilterOption('ID', filterById, (bool? newValue) {
                setState(() {
                  filterById = newValue!; // Updating filter state
                });
              }),
              _buildFilterOption('TYPE', filterByType, (bool? newValue) {
                setState(() {
                  filterByType = newValue!; // Updating filter state
                });
              }),
              _buildFilterOption('DATE', filterByDate, (bool? newValue) {
                setState(() {
                  filterByDate = newValue!; // Updating filter state
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
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged, // Function to call when checkbox is toggled
          checkColor: AppColors.secondaryColor, // Check color
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primaryColor; // Fill color when checked
            }
            return AppColors.secondaryColor; // Fill color when unchecked
          }),
        ),
        Text(
          label, // The label for the checkbox
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor, // Color for label text
          ),
        ),
      ],
    );
  }
}
