import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_n1/repository/printer_repository.dart';
import 'package:project_n1/data/product.dart';
import 'product_widget.dart';

class StockWidget extends StatefulWidget {
  const StockWidget({super.key});

  @override
  State<StockWidget> createState() => _StockWidgetState() ;
}

class _StockWidgetState extends State < StockWidget > {
  // Variables pour les filtres
  bool filterById = false;
  bool filterByType = false;
  bool filterByDate = false;

  @override
  Widget build(BuildContext context) {

    final printRepository = GetIt.instance<PrinterRepository>();
    final List<Product> products = printRepository.getProducts();

    bool ascendingOrder = true;

    // Appliquer les filtres
    List<Product> applyFilters() {
      List<Product> filteredProducts = products;

      if (filterById) {
        filteredProducts.sort((a, b) => ascendingOrder ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
      } else if (filterByType) {
        filteredProducts.sort((a, b) => ascendingOrder ? a.title.compareTo(b.title) : b.title.compareTo(a.title));
      } else if (filterByDate) {
        filteredProducts.sort((a, b) => ascendingOrder ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
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
                Checkbox(
                      value: filterById,
                      activeColor: Colors.green,
                      onChanged: (bool? newValue) {
                        setState (() {
                          filterById = newValue!;
                        });
                      }),
                const Expanded ( child : Text ("ID") ),

                Checkbox(
                        value: filterByType,
                        activeColor: Colors.green,
                        onChanged: (bool? newValue) {
                          setState (() {
                            filterByType = newValue!;
                          });
                        }),
                const Expanded ( child : Text ("TYPE") ),

                Checkbox(
                    value: filterByDate,
                    activeColor: Colors.green,
                    onChanged: (bool? newValue) {
                      setState (() {
                        filterByDate = newValue!;
                      });
                    }),
                const Expanded ( child : Text ("Date") ),
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
