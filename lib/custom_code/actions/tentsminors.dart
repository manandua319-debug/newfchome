// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/lat_lng.dart';

/// Returns all coordinates as a List<LatLng>.
///
/// Firestore collection: tentsminors   Field (GeoPoint): location
Future<List<LatLng>> tentsminors() async {
  try {
    final snap = await FirebaseFirestore.instance
        .collection('tentsminors')
        .get();

    final coords = snap.docs
        .map((d) {
          final data = d.data();
          final loc = data['location'];
          if (loc is GeoPoint) {
            return LatLng(loc.latitude, loc.longitude);
          }
          return null;
        })
        .whereType<LatLng>()
        .toList();

    debugPrint('Loaded ${coords.length} tentsminors coords');
    return coords;
  } catch (e, st) {
    debugPrint('tentsminors error: $e\n$st');
    return <LatLng>[];
  }
}
