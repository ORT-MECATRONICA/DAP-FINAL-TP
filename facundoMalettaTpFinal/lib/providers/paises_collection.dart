import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/Pais.dart';

part 'paises_collection.g.dart';

@riverpod
class PaisesCollection extends _$PaisesCollection {
  static final CollectionReference _paisesCollection = FirebaseFirestore.instance.collection('paises');

  static Future<Map<String, Pais>> getAllEmpleados() async {
    final snapshot = await _paisesCollection.get();
    return Map.fromEntries(snapshot.docs
        .map((doc) => MapEntry(doc.id, Pais.fromFirestore(doc.data() as Map<String, dynamic>))));
  }

  Future<void> createPais(Pais pais) async {
    await _paisesCollection.doc().set(pais.toMap());
    ref.invalidateSelf();
  }

  Future<void> updatePais(String id, Pais pais) async {
    await _paisesCollection
        .doc(id)
        .update(pais.toMap());
    ref.invalidateSelf();

    
  }
  Future<void> deletePais(String id) async {
    await _paisesCollection.doc(id).delete();
    ref.invalidateSelf();
  }

  FutureOr<Map<String, Pais>> build() async {
    return await getAllEmpleados();
  }
}
