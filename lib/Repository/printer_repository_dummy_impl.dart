import 'printer_repository.dart';
import 'package:project_n1/data/product.dart';

class PrinterRepositoryDummyImpl implements PrinterRepository {
  @override
  List<Product> getProducts() {
    return [
      Product(
        id: 23,
        image: 'assets/images/powder-printer.png',
        title: 'Powder printer',
        date: DateTime(2024, 10, 14),
      ),
      Product(
        id: 7,
        image: 'assets/images/wire-printer.png',
        title: 'Wire printer',
        date: DateTime(2024, 10, 10),
      ),
      Product(
        id: 98,
        image: 'assets/images/wire-printer.png',
        title: 'Wire printer',
        date: DateTime(2024, 10, 11),
      ),
      Product(
        id: 63,
        image: 'assets/images/resin-printer.png',
        title: 'Resin printer',
        date: DateTime(2023, 02, 05),
      ),
      Product(
        id: 26,
        image: 'assets/images/wire-printer.png',
        title: 'Wire printer',
        date: DateTime(2023, 07, 20),
      ),
    ];
  }
}