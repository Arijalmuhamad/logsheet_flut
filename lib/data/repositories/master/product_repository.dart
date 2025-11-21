import 'package:logsheet_app/data/remote/master/product_entity.dart';
import 'package:logsheet_app/data/services/master/product_mysql_service.dart';

class ProductRepository {
  final ProductMySQLService _mySQLService;

  ProductRepository(this._mySQLService);

  Future<List<ProductEntity>> fetchProducts() async {
    final List<Map<String, dynamic>> productMaps =
        await _mySQLService.fetchProducts();
    return productMaps.map((map) => ProductEntity.fromMap(map)).toList();
  }
}
