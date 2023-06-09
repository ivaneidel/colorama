import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:colorama/configuration/state.dart';

abstract class Storage {
  static String? _firebaseDocId;

  static FirebaseFirestore get _db => FirebaseFirestore.instance;

  static Future<int> createGame({required String ownerName}) async {
    try {
      final matchId = 100000 + Random().nextInt(999999);

      final match = {
        'owner': ownerName,
        'chooser': ownerName,
        'id': matchId,
        'started': false,
        'finished': false,
        'players': [],
      };

      final doc = await _db.collection('matches').add(match);

      _firebaseDocId = doc.id;

      return matchId;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> startGame({
    required int matchId,
  }) async {
    try {
      await _db.runTransaction((transaction) async {
        final matches = await _db.collection('matches').get();

        final match = matches.docs.firstWhereOrNull(
          (element) => element.data()['id'] == matchId,
        );

        if (match != null) {
          _firebaseDocId = match.id;

          final docRef = _db.collection('matches').doc(match.id);
          final snapshot = await transaction.get(docRef);

          transaction.update(
            snapshot.reference,
            {
              'started': true,
              'r': GlobalState.r,
              'g': GlobalState.g,
              'b': GlobalState.b,
            },
          );
        } else {
          throw "La partida no existe";
        }
      }, maxAttempts: 10);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> joinGame({
    required String playerName,
    required int matchId,
  }) async {
    try {
      await _db.runTransaction((transaction) async {
        final matches = await _db.collection('matches').get();

        final match = matches.docs.firstWhereOrNull(
          (element) => element.data()['id'] == matchId,
        );

        if (match != null) {
          _firebaseDocId = match.id;
          final docRef = _db.collection('matches').doc(match.id);
          final snapshot = await transaction.get(docRef);

          final nameDupped = (snapshot.get('players') as List).any(
            (player) => player['name'] == playerName,
          );

          if (!nameDupped) {
            transaction.update(
              snapshot.reference,
              {
                'players': [
                  ...snapshot.get('players'),
                  {'name': playerName}
                ],
              },
            );
          } else {
            throw "Ya existe un jugador con el mismo nombre";
          }
        } else {
          throw "La partida no existe";
        }
      }, maxAttempts: 10);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> guessColor({
    required int matchId,
  }) async {
    try {
      await _db.runTransaction((transaction) async {
        final matches = await _db.collection('matches').get();

        final match = matches.docs.firstWhereOrNull(
          (element) => element.data()['id'] == matchId,
        );

        if (match != null) {
          _firebaseDocId = match.id;
          final docRef = _db.collection('matches').doc(match.id);
          final snapshot = await transaction.get(docRef);

          final newPlayers = [];

          for (var player in snapshot.get('players')) {
            if (player['name'] == GlobalState.userName) {
              newPlayers.add({
                'name': GlobalState.userName,
                'r': GlobalState.r,
                'g': GlobalState.g,
                'b': GlobalState.b,
              });
            } else {
              newPlayers.add(player);
            }
          }

          final finished = newPlayers.every(
            (player) =>
                player['r'] != null &&
                player['g'] != null &&
                player['b'] != null,
          );

          transaction.update(
            snapshot.reference,
            {
              'players': newPlayers,
              'finished': finished,
            },
          );
        } else {
          throw "La partida no existe";
        }
      }, maxAttempts: 10);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> startNextRound({
    required int matchId,
    required String newChooser,
  }) async {
    try {
      await _db.runTransaction((transaction) async {
        final matches = await _db.collection('matches').get();

        final match = matches.docs.firstWhereOrNull(
          (element) => element.data()['id'] == matchId,
        );

        if (match != null) {
          _firebaseDocId = match.id;
          final docRef = _db.collection('matches').doc(match.id);
          final snapshot = await transaction.get(docRef);

          final nobodyWon = newChooser == snapshot.get('chooser');

          final newMatch = {
            'chooser': newChooser,
            'started': false,
            'finished': false,
            'r': null,
            'g': null,
            'b': null,
            'players': [],
          };

          for (var player in match.get('players')) {
            if (!nobodyWon && player['name'] == newChooser) {
              (newMatch['players'] as List).add({'name': match.get('chooser')});
            } else {
              (newMatch['players'] as List).add({'name': player['name']});
            }
          }

          transaction.update(snapshot.reference, {...newMatch});
        } else {
          throw "La partida no existe";
        }
      }, maxAttempts: 10);
    } catch (e) {
      rethrow;
    }
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getStream() =>
      _db.collection('matches').doc(_firebaseDocId!).snapshots();
}
