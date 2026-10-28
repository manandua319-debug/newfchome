// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
// Helper: robust loader + verbose diagnostics.
// - Accepts GeoPoint
// - Also accepts {lat,lng} or {latitude,longitude} maps
// - Logs wrong types per document
Future<List<LatLng>> _loadCoords(
  String collection, {
  String field = 'location',
  int limit = 500,
}) async {
  final coords = <LatLng>[];

  try {
    final col = FirebaseFirestore.instance.collection(collection);
    final snap = await col.limit(limit).get();

    debugPrint('[$collection] docs=${snap.docs.length} (field="$field")');

    for (final d in snap.docs) {
      final data = d.data();
      final loc = data[field];

      // GeoPoint case
      if (loc is GeoPoint) {
        coords.add(LatLng(loc.latitude, loc.longitude));
        continue;
      }

      // {lat,lng} or {latitude,longitude} map case
      if (loc is Map) {
        final latRaw = loc['lat'] ?? loc['latitude'];
        final lngRaw = loc['lng'] ?? loc['longitude'];
        if (latRaw is num && lngRaw is num) {
          final lat = latRaw.toDouble();
          final lng = lngRaw.toDouble();
          final valid = lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
          if (valid) {
            coords.add(LatLng(lat, lng));
          } else {
            debugPrint(
              '[$collection/${d.id}] "$field" out-of-range lat/lng: $lat,$lng',
            );
          }
        } else {
          debugPrint(
            '[$collection/${d.id}] "$field" Map missing numeric lat/lng: $loc',
          );
        }
        continue;
      }

      // List like [lat,lng]
      if (loc is List && loc.length >= 2) {
        final a = loc[0];
        final b = loc[1];
        if (a is num && b is num) {
          coords.add(LatLng(a.toDouble(), b.toDouble()));
        } else {
          debugPrint(
            '[$collection/${d.id}] "$field" List has non-numeric values: $loc',
          );
        }
        continue;
      }

      // Anything else
      debugPrint(
        '[$collection/${d.id}] "$field" unexpected type=${loc?.runtimeType} value=$loc',
      );
    }

    debugPrint('[$collection] loaded ${coords.length} coords');
    return coords;
  } on FirebaseException catch (e, st) {
    debugPrint('Firestore ${e.code}: ${e.message}\n$st');
    rethrow;
  } catch (e, st) {
    debugPrint('Unknown error: $e\n$st');
    rethrow;
  }
}

/// New debug action (safe to call from On Page Load or a test button) Change
/// the two constants below to your actual collection/field.
Future<List<LatLng>> debugLoadCoords() async {
  const String collection = 'tents'; // <-- change if needed (e.g., 'food')
  const String field = 'location'; // <-- change if needed

  try {
    final result = await _loadCoords(collection, field: field);
    debugPrint('[debugLoadCoords] returning ${result.length} coords');
    return result;
  } catch (e, st) {
    debugPrint('[debugLoadCoords] failed: $e\n$st');
    rethrow;
  }
}
