import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/place.dart';
import 'tents_t_a_y_widget.dart' show TentsTAYWidget;
import 'package:flutter/material.dart';

class TentsTAYModel extends FlutterFlowModel<TentsTAYWidget> {
  ///  Local state fields for this page.

  List<LatLng> tentCoords = [];
  void addToTentCoords(LatLng item) => tentCoords.add(item);
  void removeFromTentCoords(LatLng item) => tentCoords.remove(item);
  void removeAtIndexFromTentCoords(int index) => tentCoords.removeAt(index);
  void insertAtIndexInTentCoords(int index, LatLng item) =>
      tentCoords.insert(index, item);
  void updateTentCoordsAtIndex(int index, Function(LatLng) updateFn) =>
      tentCoords[index] = updateFn(tentCoords[index]);

  LatLng? userLocT;

  List<TentsRecord> tentDocs = [];
  void addToTentDocs(TentsRecord item) => tentDocs.add(item);
  void removeFromTentDocs(TentsRecord item) => tentDocs.remove(item);
  void removeAtIndexFromTentDocs(int index) => tentDocs.removeAt(index);
  void insertAtIndexInTentDocs(int index, TentsRecord item) =>
      tentDocs.insert(index, item);
  void updateTentDocsAtIndex(int index, Function(TentsRecord) updateFn) =>
      tentDocs[index] = updateFn(tentDocs[index]);

  LatLng? searchLoc;

  TentsRecord? selectedTent;

  int? markerIndex;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - tents] action in TentsTAY widget.
  List<LatLng>? tentsCoords1;
  // Stores action output result for [Firestore Query - Query a collection] action in TentsTAY widget.
  List<TentsRecord>? docsOuttents;
  // Stores action output result for [Custom Action - getCurrentLatLng] action in TentsTAY widget.
  LatLng? userLocLLT;
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
  Future h2(BuildContext context) async {
    searchLoc = placePickerValue.latLng;
    FFAppState().centerLoc = searchLoc;
  }
}
