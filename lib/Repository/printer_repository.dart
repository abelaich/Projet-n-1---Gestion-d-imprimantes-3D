import 'package:project_n1/data/product.dart';

abstract class PrinterRepository {
  // Fetch the list of products from the repository
  List<Product> getProducts();

  // Update a product in the repository
  void updateProduct(Product product);
}
