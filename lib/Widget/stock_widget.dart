import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_n1/repository/printer_repository.dart';
import 'package:project_n1/data/product.dart';
import 'product_widget.dart';

class StockWidget extends StatelessWidget {
  const StockWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final printRepository = GetIt.instance<PrinterRepository>();
    final List<Product> products = printRepository.getProducts();

    // Variables pour les filtres
    bool filterById = false;
    bool filterByType = false;
    bool filterByDate = false;

    // Appliquer les filtres
    List<Product> applyFilters() {
      List<Product> filteredProducts = products;

      // Filtrer par identifiant
      if (filterById) {
        filteredProducts = filteredProducts.where((product) => product.id == 0).toList();
      }

      // Filtrer par type
      if (filterByType) {
        filteredProducts = filteredProducts.where((product) => product.title == 'Wire').toList();
      }

      // Filtrer par date
      if (filterByDate) {
        final cutoffDate = DateTime(2024, 01, 01);
        filteredProducts = filteredProducts.where((product) => product.date.isBefore(cutoffDate)).toList();
      }

      return filteredProducts;
    }

    // Obtenir les produits filtrés
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
                // Checkbox pour filtrer par ID
                ValueListenableBuilder<bool>(
                  valueListenable: ValueNotifier(filterById),
                  builder: (context, value, child) {
                    return Checkbox(
                      value: value,
                      activeColor: Colors.green,
                      onChanged: (bool? newValue) {
                        filterById = newValue!;
                      },
                    );
                  },
                ),
                const Text("ID"),

                // Checkbox pour filtrer par type
                ValueListenableBuilder<bool>(
                  valueListenable: ValueNotifier(filterByType),
                  builder: (context, value, child) {
                    return Checkbox(
                      value: value,
                      activeColor: Colors.green,
                      onChanged: (bool? newValue) {
                        filterByType = newValue!;
                      },
                    );
                  },
                ),
                const Text("Type"),

                // Checkbox pour filtrer par date
                ValueListenableBuilder<bool>(
                  valueListenable: ValueNotifier(filterByDate),
                  builder: (context, value, child) {
                    return Checkbox(
                      value: value,
                      activeColor: Colors.green,
                      onChanged: (bool? newValue) {
                        filterByDate = newValue!;
                      },
                    );
                  },
                ),
                const Text("Date"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Affichage de la liste filtrée
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return ProductWidget(product: filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
