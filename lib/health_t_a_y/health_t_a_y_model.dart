import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/place.dart';
import 'health_t_a_y_widget.dart' show HealthTAYWidget;
import 'package:flutter/material.dart';

class HealthTAYModel extends FlutterFlowModel<HealthTAYWidget> {
  ///  Local state fields for this page.

  List<LatLng> healthCoords = [];
  void addToHealthCoords(LatLng item) => healthCoords.add(item);
  void removeFromHealthCoords(LatLng item) => healthCoords.remove(item);
  void removeAtIndexFromHealthCoords(int index) => healthCoords.removeAt(index);
  void insertAtIndexInHealthCoords(int index, LatLng item) =>
      healthCoords.insert(index, item);
  void updateHealthCoordsAtIndex(int index, Function(LatLng) updateFn) =>
      healthCoords[index] = updateFn(healthCoords[index]);

  LatLng? userLoc;

  List<HealthRecord> healthDocs = [];
  void addToHealthDocs(HealthRecord item) => healthDocs.add(item);
  void removeFromHealthDocs(HealthRecord item) => healthDocs.remove(item);
  void removeAtIndexFromHealthDocs(int index) => healthDocs.removeAt(index);
  void insertAtIndexInHealthDocs(int index, HealthRecord item) =>
      healthDocs.insert(index, item);
  void updateHealthDocsAtIndex(int index, Function(HealthRecord) updateFn) =>
      healthDocs[index] = updateFn(healthDocs[index]);

  LatLng? searchLoc;

  HealthRecord? selectedhealth;

  int? markerIndex;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - health] action in HealthTAY widget.
  List<LatLng>? healthCoords1;
  // Stores action output result for [Firestore Query - Query a collection] action in HealthTAY widget.
  List<HealthRecord>? docsOutHealth;
  // Stores action output result for [Custom Action - getCurrentLatLng] action in HealthTAY widget.
  LatLng? userLocLLH;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue = FFPlace();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future h1(BuildContext context) async {
    searchLoc = placePickerValue.latLng;
    FFAppState().centerLoc = searchLoc;
  }
}
