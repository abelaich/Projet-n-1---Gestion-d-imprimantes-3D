import 'printer_repository.dart';
import 'package:project_n1/data/product.dart';

class PrinterRepositoryDummyImpl implements PrinterRepository {
  @override
  List<Product> getProducts() {
    return [
      Product(
        id: 23,
        image: 'package:project_n1/source/images/powder-printer.png',
        title: 'Powder printer',
        date: DateTime(2024, 10, 14),
      ),
      Product(
        id: 7,
        image: 'package:project_n1/source/images/wire-printer.png',
        title: 'Wire printer',
        date: DateTime(2024, 10, 10),
      ),
      Product(
        id: 98,
        image: 'package:project_n1/source/images/wire-printer.png',
        title: 'Wire printer',
        date: DateTime(2024, 10, 11),
      ),
      Product(
        id: 63,
        image: 'package:project_n1/source/images/resin-printer.png',
        title: 'Resin printer',
        date: DateTime(2023, 02, 05),
      ),
      Product(
        id: 26,
        image: 'package:project_n1/source/images/wire-printer.png',
        title: 'Wire printer',
        date: DateTime(2023, 07, 20),
      ),
    ];
  }
}