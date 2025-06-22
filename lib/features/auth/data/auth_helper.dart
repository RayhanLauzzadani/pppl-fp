// lib/features/auth/data/auth_helper.dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getLaundryIdForUser(String uid) async {
  final laundrySnap = await FirebaseFirestore.instance.collection('laundries').get();
  for (var doc in laundrySnap.docs) {
    final userDoc = await doc.reference.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return doc.id;
    }
  }
  return null;
}
