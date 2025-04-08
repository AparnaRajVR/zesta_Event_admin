

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('event_categories');

  Future<void> addCategory(String category) async {
    await _categoryCollection.add({'name': category});
  }

  Future<void> deleteCategory(String docId) async {
    await _categoryCollection.doc(docId).delete();
  }

  Stream<List<Map<String, dynamic>>> getCategories() {
    return _categoryCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {'id': doc.id, 'name': doc['name']})
          .toList();
    });
  }
}
