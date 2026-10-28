import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Finds the phone's current location and turns it into a street address,
/// so forms can prefill "Starting Location".
class LocationService {
  /// Current position, asking for permission if needed. Null when location
  /// is off or the person said no.
  static Future<Position?> currentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10));
    } catch (_) {
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    }
  }

  /// A readable address for the current location, from the phone's own
  /// geocoder (no API key). Falls back to "lat, lng" when no address is
  /// found or on web, and null when there is no location at all.
  static Future<String?> currentAddress() async {
    final pos = await currentPosition();
    if (pos == null) return null;
    final fallback =
        '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
    if (kIsWeb) return fallback;
    try {
      final marks = await Geocoding()
          .placemarkFromCoordinates(pos.latitude, pos.longitude)
          .timeout(const Duration(seconds: 8));
      if (marks.isEmpty) return fallback;
      final m = marks.first;
      final street = [
        m.subThoroughfare,
        m.thoroughfare,
      ].where((p) => p != null && p.trim().isNotEmpty).join(' ');
      final parts = <String?>[
        street.isNotEmpty ? street : m.name,
        m.locality,
        m.administrativeArea,
      ].where((p) => p != null && p.trim().isNotEmpty).toList();
      return parts.isEmpty ? fallback : parts.join(', ');
    } catch (e) {
      debugPrint('Geocoding error: $e');
      return fallback;
    }
  }
}
