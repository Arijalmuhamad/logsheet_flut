import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/product_entity.dart';
import 'package:logsheet_app/data/repositories/master/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ProductEntity> _productList = [];
  List<ProductEntity> get productList => _productList;

  List<ProductEntity> _productRefineryList = [];
  List<ProductEntity> get productRefineryList => _productRefineryList;

  List<ProductEntity> _productFractionationList = [];
  List<ProductEntity> get productFractionationList => _productFractionationList;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _productList = await _repository.fetchProducts();
      notifyListeners();
      _productRefineryList =
          _productList
              .where((product) => product.processName == 'refinery')
              .toList();
      _productFractionationList =
          _productList
              .where((product) => product.processName == 'fractionation')
              .toList();

      log(
        "FRACTIONATION LIST LENGTH FROM PROVIDER: ${productFractionationList.length}",
      );
    } catch (e) {
      _setErrorMessage("$e");
    } finally {
      _setLoading(false);
    }
  }
}