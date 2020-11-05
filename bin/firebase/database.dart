import 'package:firedart/firedart.dart';

class DatabaseMethods {
  static const projectId = 'flutterchatapp-43ce6';
  Firestore _database;
  uploadUserInfo(userMap) {
    _database = Firestore(projectId);
    _database.collection('users').add(userMap);
  }

  Future getUsersByUserEmail(String userEmail) async {
    _database = Firestore(projectId);
    var list = await _database
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
    return (list.elementAt(0)['name']);
  }
}
