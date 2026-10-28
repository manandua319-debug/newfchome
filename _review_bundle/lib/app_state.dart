import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();
  factory FFAppState() => _instance;
  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  /// Call this early in app start (e.g., main.dart) BEFORE runApp(...)
  Future initializePersistedState() async {
    final prefs = await SharedPreferences.getInstance();

    _lastTTRequestId = prefs.getString('ff_lastTTRequestId');

    final cLat = prefs.getDouble('ff_centerLoc_lat');
    final cLng = prefs.getDouble('ff_centerLoc_lng');
    if (cLat != null && cLng != null) {
      _centerLoc = LatLng(cLat, cLng);
    }

    final c1Lat = prefs.getDouble('ff_centerLoc1_lat');
    final c1Lng = prefs.getDouble('ff_centerLoc1_lng');
    if (c1Lat != null && c1Lng != null) {
      _centerLoc1 = LatLng(c1Lat, c1Lng);
    }
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  // ----------------- centerLoc -----------------
  LatLng? _centerLoc;
  LatLng? get centerLoc => _centerLoc;
  set centerLoc(LatLng? value) {
    _centerLoc = value;
    _persistLatLng('ff_centerLoc', value);
    notifyListeners();
  }

  // ----------------- newMoodDoc -----------------
  DocumentReference? _newMoodDoc;
  DocumentReference? get newMoodDoc => _newMoodDoc;
  set newMoodDoc(DocumentReference? value) {
    _newMoodDoc = value;
    notifyListeners();
  }

  // ----------------- centerLoc1 -----------------
  LatLng? _centerLoc1;
  LatLng? get centerLoc1 => _centerLoc1;
  set centerLoc1(LatLng? value) {
    _centerLoc1 = value;
    _persistLatLng('ff_centerLoc1', value);
    notifyListeners();
  }

  // ----------------- lastTTRequestId -----------------
  String? _lastTTRequestId;
  String? get lastTTRequestId => _lastTTRequestId;
  set lastTTRequestId(String? value) {
    _lastTTRequestId = value;
    _persistString('ff_lastTTRequestId', value);
    notifyListeners();
  }

  // ----------------- helpers -----------------
  Future<void> _persistString(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }

  Future<void> _persistLatLng(String prefix, LatLng? value) async {
    final prefs = await SharedPreferences.getInstance();
    final latKey = '${prefix}_lat';
    final lngKey = '${prefix}_lng';
    if (value == null) {
      await prefs.remove(latKey);
      await prefs.remove(lngKey);
    } else {
      await prefs.setDouble(latKey, value.latitude);
      await prefs.setDouble(lngKey, value.longitude);
    }
  }
}
