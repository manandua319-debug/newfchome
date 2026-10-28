import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/place.dart';
import 'tents_minors_widget.dart' show TentsMinorsWidget;
import 'package:flutter/material.dart';

class TentsMinorsModel extends FlutterFlowModel<TentsMinorsWidget> {
  ///  Local state fields for this page.

  List<LatLng> tentMinorsCoords = [];
  void addToTentMinorsCoords(LatLng item) => tentMinorsCoords.add(item);
  void removeFromTentMinorsCoords(LatLng item) => tentMinorsCoords.remove(item);
  void removeAtIndexFromTentMinorsCoords(int index) =>
      tentMinorsCoords.removeAt(index);
  void insertAtIndexInTentMinorsCoords(int index, LatLng item) =>
      tentMinorsCoords.insert(index, item);
  void updateTentMinorsCoordsAtIndex(int index, Function(LatLng) updateFn) =>
      tentMinorsCoords[index] = updateFn(tentMinorsCoords[index]);

  LatLng? userLoc;

  List<TentsminorsRecord> tentMinorsDocs = [];
  void addToTentMinorsDocs(TentsminorsRecord item) => tentMinorsDocs.add(item);
  void removeFromTentMinorsDocs(TentsminorsRecord item) =>
      tentMinorsDocs.remove(item);
  void removeAtIndexFromTentMinorsDocs(int index) =>
      tentMinorsDocs.removeAt(index);
  void insertAtIndexInTentMinorsDocs(int index, TentsminorsRecord item) =>
      tentMinorsDocs.insert(index, item);
  void updateTentMinorsDocsAtIndex(
    int index,
    Function(TentsminorsRecord) updateFn,
  ) => tentMinorsDocs[index] = updateFn(tentMinorsDocs[index]);

  LatLng? searchLoc;

  TentsminorsRecord? selectedtentMinors;

  int? markerIndex;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - tentsminors] action in TentsMinors widget.
  List<LatLng>? tentMinorsCoords1;
  // Stores action output result for [Firestore Query - Query a collection] action in TentsMinors widget.
  List<TentsminorsRecord>? docsOutMinorsTent;
  // Stores action output result for [Custom Action - getCurrentLatLng] action in TentsMinors widget.
  LatLng? userLocLLTM;
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
