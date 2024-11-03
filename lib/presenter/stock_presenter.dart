import 'package:flutter/material.dart';
import 'package:project_n1/data/product.dart';
import 'package:get_it/get_it.dart';
import 'package:project_n1/repository/printer_repository.dart';

abstract class StockPresenter extends ChangeNotifier {
  List<Product> get products;

  void setProductType(Product product, String newType);
  void setProductId(Product product, int newId, Function(String) onError);
  void setProductDate(Product product, DateTime newDate);
}

class StockPresenterImpl extends StockPresenter {
  @override
  List<Product> products = GetIt.instance<PrinterRepository>().getProducts();

  @override
  void setProductType(Product product, String newType) {
    product.title = newType;

    // Update the image based on the new type
    product.image = getImageForType(newType); // Call a method to get the image based on type

    GetIt.instance<PrinterRepository>().updateProduct(product);
    notifyListeners();
  }

  // Add a method to get the image path based on the type
  String getImageForType(String type) {
    switch (type) {
      case 'Powder printer':
        return 'assets/images/powder-printer.png';
      case 'Wire printer':
        return 'assets/images/wire-printer.png';
      case 'Resin printer':
        return 'assets/images/resin-printer.png';
      default:
        return '';
    }
  }

  @override
  void setProductId(Product product, int newId, Function(String) onError){
    final printerRepository = GetIt.instance<PrinterRepository>();

    // Check for uniqueness
    if (!printerRepository.getProducts().any((p) => p.id == newId)) {
      product.id = newId;
      printerRepository.updateProduct(product);
      notifyListeners();
    } else {
      // Notify the user about the duplicate ID
      onError('ID $newId is already in use. Please choose another ID.');

    }
  }



  @override
  void setProductDate(Product product, DateTime newDate) {
    product.date = newDate;
    GetIt.instance<PrinterRepository>().updateProduct(product);
    notifyListeners();
  }
}


