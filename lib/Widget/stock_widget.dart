import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_n1/repository/printer_repository.dart';
import 'package:project_n1/data/product.dart';
import 'product_widget.dart';
import 'printer_detail_widget.dart';

class StockWidget extends StatefulWidget {
  const StockWidget({super.key});

  @override
  State<StockWidget> createState() => _StockWidgetState();
}

class _StockWidgetState extends State<StockWidget> {
  // Variables pour les filtres
  bool filterById = false;
  bool filterByType = false;
  bool filterByDate = false;

  @override
  Widget build(BuildContext context) {
    final printRepository = GetIt.instance<PrinterRepository>();
    final List<Product> products = printRepository.getProducts();

    // Appliquer les filtres
    List<Product> applyFilters() {
      List<Product> filteredProducts = List.from(products);

      // Tri en fonction des filtres sélectionnés
      filteredProducts.sort((a, b) {
        // Comparer par ID
        if (filterById) {
          int idComparison = a.id.compareTo(b.id);
          if (idComparison != 0) return idComparison; // Si les IDs sont différents, on retourne le résultat
        }

        // Comparer par Type
        if (filterByType) {
          int typeComparison = a.title.compareTo(b.title);
          if (typeComparison != 0) return typeComparison; // Si les titres sont différents, on retourne le résultat
        }

        // Comparer par Date
        if (filterByDate) {
          return a.date.compareTo(b.date); // Retourner la comparaison de dates
        }

        return 0; // Si tous les critères sont identiques
      });

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

          // Affichage de la liste filtrée
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (BuildContext context, int index) {
                final product = filteredProducts[index];

                return GestureDetector(
                  onTap: () {
                    // Naviguer vers l'écran de détails de l'imprimante
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
