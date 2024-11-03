import 'package:project_n1/data/product.dart';

abstract class PrinterRepository {
  List<Product> getProducts();
  void updateProduct(Product product);
}