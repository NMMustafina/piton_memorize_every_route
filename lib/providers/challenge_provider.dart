import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/challenge.dart';

class ChallengeProvider extends ChangeNotifier {
  final _box = Hive.box<Challenge>('challengesBox');

  Challenge? get activeChallenge {
    final unfinished = _box.values.where((c) => c.completed == null).toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    return unfinished.firstOrNull;
  }

  List<Challenge> get history =>
      _box.values.where((c) => c.completed != null).toList();

  Future<void> addChallenge(Challenge challenge) async {
    await _box.add(challenge);
    notifyListeners();
  }

  Future<void> completeChallenge(int key, bool success) async {
    final challenge = _box.get(key);
    if (challenge != null) {
      challenge.completed = success;
      await challenge.save();
      notifyListeners();
    }
  }

  Future<void> deleteChallenge(int key) async {
    await _box.delete(key);
    notifyListeners();
  }
}
