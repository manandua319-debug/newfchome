import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/place.dart';
import 'shelters_minors_widget.dart' show SheltersMinorsWidget;
import 'package:flutter/material.dart';

class SheltersMinorsModel extends FlutterFlowModel<SheltersMinorsWidget> {
  ///  Local state fields for this page.

  List<LatLng> shelterMinorsCoords = [];
  void addToShelterMinorsCoords(LatLng item) => shelterMinorsCoords.add(item);
  void removeFromShelterMinorsCoords(LatLng item) =>
      shelterMinorsCoords.remove(item);
  void removeAtIndexFromShelterMinorsCoords(int index) =>
      shelterMinorsCoords.removeAt(index);
  void insertAtIndexInShelterMinorsCoords(int index, LatLng item) =>
      shelterMinorsCoords.insert(index, item);
  void updateShelterMinorsCoordsAtIndex(int index, Function(LatLng) updateFn) =>
      shelterMinorsCoords[index] = updateFn(shelterMinorsCoords[index]);

  LatLng? userLoc;

  List<SheltersminorsRecord> shelterMinorsDocs = [];
  void addToShelterMinorsDocs(SheltersminorsRecord item) =>
      shelterMinorsDocs.add(item);
  void removeFromShelterMinorsDocs(SheltersminorsRecord item) =>
      shelterMinorsDocs.remove(item);
  void removeAtIndexFromShelterMinorsDocs(int index) =>
      shelterMinorsDocs.removeAt(index);
  void insertAtIndexInShelterMinorsDocs(int index, SheltersminorsRecord item) =>
      shelterMinorsDocs.insert(index, item);
  void updateShelterMinorsDocsAtIndex(
    int index,
    Function(SheltersminorsRecord) updateFn,
  ) => shelterMinorsDocs[index] = updateFn(shelterMinorsDocs[index]);

  LatLng? searchLoc;

  SheltersminorsRecord? selectedshelterMinors;

  int? markerIndex;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - sheltersminors] action in SheltersMinors widget.
  List<LatLng>? shelterCoords1;
  // Stores action output result for [Firestore Query - Query a collection] action in SheltersMinors widget.
  List<SheltersminorsRecord>? docsOutMinorsShelter;
  // Stores action output result for [Custom Action - getCurrentLatLng] action in SheltersMinors widget.
  LatLng? userLocLLSM;
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
