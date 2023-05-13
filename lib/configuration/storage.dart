import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Storage {
  static FirebaseFirestore get _db => FirebaseFirestore.instance;

  static Future<int> startGame({required String ownerName}) async {
    try {
      final matchId = 100000 + Random().nextInt(999999);

      final match = {
        'owner': ownerName,
        'id': matchId,
        'players': [],
      };

      // await _db.collection('matches').add(match);

      return matchId;
    } catch (e) {
      rethrow;
    }
  }
}
