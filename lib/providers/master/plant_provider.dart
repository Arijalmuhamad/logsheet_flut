import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/plant_entity.dart';
import 'package:logsheet_app/data/repositories/master/plant_repository.dart';

class PlantProvider with ChangeNotifier {
  final PlantRepository _plantRepository;

  PlantProvider(this._plantRepository);

  PlantEntity? _plantEntity;
  PlantEntity? get plantEntity => _plantEntity;

  List<PlantEntity> _plantList = [];
  List<PlantEntity> get plantList => _plantList;

  PlantEntity? _currentPlant;
  PlantEntity? get currentPlant => _currentPlant;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setCurrentPlant(PlantEntity plantEntity) {
    _currentPlant = plantEntity;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchAllPlant() async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _plantList = await _plantRepository.getAllPlants();
      notifyListeners();

      log("List length: ${_plantList.length}");

      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Failed to fetch plants: $e');
      _setLoading(false);
    }
  }

  Future<void> fetchPlantsByBusinessUnit(String buCode) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _plantList = await _plantRepository.getPlantsByBusinessUnits(buCode);
      notifyListeners();

      log("List length: ${_plantList.length}");

      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Failed to fetch plants: $e');
      _setLoading(false);
    }
  }

  void clearPlants() {
    _plantList.clear();
  }

  Future<bool?> createPlant(PlantEntity plant) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final response = await _plantRepository.createPlant(plant);
      _setLoading(false);
      _setErrorMessage(null);

      _plantList.insert(0, plant);
      notifyListeners();

      return response;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to create plant: $e');
      return null;
    }
  }

  Future<bool> editPlant(PlantEntity plant) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final response = await _plantRepository.updatePlant(plant);
      _setLoading(false);
      _setErrorMessage(null);

      // if (response) {
      _setLoading(false);
      _setErrorMessage(null);
      return response;
      // } else {
      //   _setLoading(false);
      //   _setErrorMessage('Failed to edit plant.');
      //   return false;
      // }
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to edit plant: $e');
      return false;
    }
  }

  Future<bool> deletePlant(String plantCode) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final response = await _plantRepository.deletePlant(plantCode);
      _setLoading(false);
      _setErrorMessage(null);

      _plantList.removeWhere((element) => element.code == plantCode);
      notifyListeners();

      return response;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to delete plant: $e');

      return false;
    }
  }
}
