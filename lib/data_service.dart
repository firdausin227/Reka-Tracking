import 'package:firebase_database/firebase_database.dart';
import 'package:rekatracking/services/firebase_services.dart';

class DataService {
  final DatabaseReference _dbRef = FirebaseService().databaseRef.child('items');

  Future<void> createItem(String name, String description) async {
    final newItemRef = _dbRef.push();
    await newItemRef.set({
      'name': name,
      'description': description,
    });
  }

  Future<DatabaseEvent> readItems() async {
    return await _dbRef.once();
  }

  Future<void> updateItem(
      String itemId, String newName, String newDescription) async {
    final itemRef = _dbRef.child(itemId);
    await itemRef.update({
      'name': newName,
      'description': newDescription,
    });
  }

  Future<void> deleteItem(String itemId) async {
    final itemRef = _dbRef.child(itemId);
    await itemRef.remove();
  }
}
