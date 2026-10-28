import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/place.dart';
import 'health_minors_widget.dart' show HealthMinorsWidget;
import 'package:flutter/material.dart';

class HealthMinorsModel extends FlutterFlowModel<HealthMinorsWidget> {
  ///  Local state fields for this page.

  List<LatLng> healthMinorCoords = [];
  void addToHealthMinorCoords(LatLng item) => healthMinorCoords.add(item);
  void removeFromHealthMinorCoords(LatLng item) =>
      healthMinorCoords.remove(item);
  void removeAtIndexFromHealthMinorCoords(int index) =>
      healthMinorCoords.removeAt(index);
  void insertAtIndexInHealthMinorCoords(int index, LatLng item) =>
      healthMinorCoords.insert(index, item);
  void updateHealthMinorCoordsAtIndex(int index, Function(LatLng) updateFn) =>
      healthMinorCoords[index] = updateFn(healthMinorCoords[index]);

  LatLng? userLoc;

  List<HealthminorsRecord> healthMinorDocs = [];
  void addToHealthMinorDocs(HealthminorsRecord item) =>
      healthMinorDocs.add(item);
  void removeFromHealthMinorDocs(HealthminorsRecord item) =>
      healthMinorDocs.remove(item);
  void removeAtIndexFromHealthMinorDocs(int index) =>
      healthMinorDocs.removeAt(index);
  void insertAtIndexInHealthMinorDocs(int index, HealthminorsRecord item) =>
      healthMinorDocs.insert(index, item);
  void updateHealthMinorDocsAtIndex(
    int index,
    Function(HealthminorsRecord) updateFn,
  ) => healthMinorDocs[index] = updateFn(healthMinorDocs[index]);

  LatLng? searchLoc;

  HealthminorsRecord? selectedhealthMinor;

  int? markerIndex;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - healthminors] action in HealthMinors widget.
  List<LatLng>? healthMinorCoords1;
  // Stores action output result for [Firestore Query - Query a collection] action in HealthMinors widget.
  List<HealthminorsRecord>? docsOuthealthMinor;
  // Stores action output result for [Custom Action - getCurrentLatLng] action in HealthMinors widget.
  LatLng? userLocLLHM;
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
