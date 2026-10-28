// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<LatLng>> loadTentCoords() async {
  try {
    final snap = await FirebaseFirestore.instance.collection('tents').get();
    final coords = snap.docs
        .map((d) {
          final data = d.data();
          final loc = data['location']; // GeoPoint in each tent doc
          if (loc is GeoPoint) return LatLng(loc.latitude, loc.longitude);
          return null;
        })
        .whereType<LatLng>()
        .toList();
    debugPrint('Loaded ${coords.length} tent coords');
    return coords;
  } catch (e, st) {
    debugPrint('loadTentCoords error: $e\n$st');
    return <LatLng>[];
  }
}
