import 'package:flutter/material.dart';
import 'package:project_n1/data/product.dart';
import 'package:get_it/get_it.dart';
import 'package:project_n1/repository/printer_repository.dart';

abstract class StockPresenter extends ChangeNotifier {
  List<Product> get products;

  void setProductType(Product product, String newType);
  void setProductId(Product product, int newId);
  void setProductDate(Product product, DateTime newDate);
}

class StockPresenterImpl extends StockPresenter {
  @override
  List<Product> products = GetIt.instance<PrinterRepository>().getProducts();

  @override
  void setProductType(Product product, String newType) {
    product.title = newType;
    GetIt.instance<PrinterRepository>().updateProduct(product);
    notifyListeners();
  }

  @override
  void setProductId(Product product, int newId) {
    product.id = newId;
    GetIt.instance<PrinterRepository>().updateProduct(product);
    notifyListeners();
  }

  @override
  void setProductDate(Product product, DateTime newDate) {
    product.date = newDate;
    GetIt.instance<PrinterRepository>().updateProduct(product);
    notifyListeners();
  }
}


