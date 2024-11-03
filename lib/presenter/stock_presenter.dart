import 'package:flutter/material.dart';
import 'package:project_n1/data/product.dart';
import 'package:get_it/get_it.dart';
import 'package:project_n1/repository/printer_repository.dart';

// Every stock needs a presenter!
abstract class StockPresenter extends ChangeNotifier {
  List<Product> get products; // The list of products we're managing

  void setProductType(Product product, String newType);                       // Change a printer's type
  void setProductId(Product product, int newId, Function(String) onError);    // Set a new ID, but no duplicates allowed!
  void setProductDate(Product product, DateTime newDate);                     // Update the service date
}

// Implementation of StockPresenter
class StockPresenterImpl extends StockPresenter {
  @override
  List<Product> products = GetIt.instance<PrinterRepository>().getProducts(); // Fetches the list of products

  @override
  void setProductType(Product product, String newType) {
    product.title = newType; // Changing the title

    // Update the image based on the new type
    product.image = Product.getImageForType(newType); // Call a method to get the image based on type

    GetIt.instance<PrinterRepository>().updateProduct(product); // Update the repository, keeping things synced
    notifyListeners();                                          // Time to tell all listeners
  }

  @override
  void setProductId(Product product, int newId, Function(String) onError) {
    final printerRepository = GetIt.instance<PrinterRepository>(); // Grab the printer repository

    // Check for uniqueness
    if (!printerRepository.getProducts().any((p) => p.id == newId)) {
      product.id = newId;                       // New ID assigned
      printerRepository.updateProduct(product); // Update the repository
      notifyListeners();                        // Spread the word
    } else {
      // Notify the user about the duplicate ID
      onError('ID $newId is already in use. Please choose another ID.');
    }
  }

  @override
  void setProductDate(Product product, DateTime newDate) {
    product.date = newDate;                                     // Update the start date
    GetIt.instance<PrinterRepository>().updateProduct(product); // Sync with the repository
    notifyListeners();                                          // Let everyone know
  }
}
