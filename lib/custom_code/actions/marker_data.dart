import '/flutter_flow/lat_lng.dart';

// Simple data classes to hold marker information for hardcoded markers
// These mimic the Firestore record structure but don't require database access

class MarkerData {
  final String name;
  final String phone;
  final String address;
  final LatLng location;
  final String? notes;

  MarkerData({
    required this.name,
    required this.phone,
    required this.address,
    required this.location,
    this.notes,
  });
}
