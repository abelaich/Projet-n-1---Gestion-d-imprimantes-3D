import 'printer_repository.dart';
import 'package:project_n1/data/product.dart';

class PrinterRepositoryDummyImpl implements PrinterRepository {

  final List<Product> _products = [
    Product.withImage(
      id: 23,
      title: 'Powder printer',
      date: DateTime(2024, 10, 14),
    ),
    Product.withImage(
      id: 7,
      title: 'Wire printer',
      date: DateTime(2024, 10, 10),
    ),
    Product.withImage(
      id: 98,
      title: 'Wire printer',
      date: DateTime(2024, 10, 11),
    ),
    Product.withImage(
      id: 63,
      title: 'Resin printer',
      date: DateTime(2023, 02, 05),
    ),
    Product.withImage(
      id: 26,
      title: 'Wire printer',
      date: DateTime(2023, 07, 20),
    ),
  ];

  @override
  List<Product> getProducts() {
    return _products;
  }

  @override
  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    } else {
      // Handle if product does not exist (optional)
      _products.add(product);
    }
  }
}