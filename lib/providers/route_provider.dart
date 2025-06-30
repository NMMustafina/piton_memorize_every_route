import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/climbing_route.dart';

class RouteProvider extends ChangeNotifier {
  final _box = Hive.box<ClimbingRoute>('routesBox');

  List<ClimbingRoute> get routes => _box.values.toList();

  void addRoute(ClimbingRoute route) async {
    await _box.add(route);
    notifyListeners();
  }

  void updateRoute(int key, ClimbingRoute updated) async {
    await _box.put(key, updated);
    notifyListeners();
  }

  Future<void> deleteRoute(int key) async {
    await _box.delete(key);
    notifyListeners();
  }

  ClimbingRoute? getRoute(int key) {
    return _box.get(key);
  }
}
