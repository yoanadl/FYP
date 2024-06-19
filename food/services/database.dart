import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final CollectionReference userAccountC = FirebaseFirestore.instance.collection('UserAccount');
}