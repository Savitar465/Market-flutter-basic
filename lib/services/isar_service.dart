import 'package:isar/isar.dart';
import 'package:market/models/product.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [ProductSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> addProduct(Product product) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.products.putSync(product));
  }

  Future<void> updateProduct(Product product) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.products.putSync(product));
  }

  Future<void> deleteProduct(int id) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.products.deleteSync(id));
  }

  Future<List<Product>> getProducts({String? filter}) async {
    final isar = await db;
    if (filter == null || filter.isEmpty) {
      return await isar.products.where().findAll();
    }
    return await isar.products.filter().nameContains(filter, caseSensitive: false).findAll();
  }
}