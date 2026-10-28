import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/place.dart';
import 'shelters_t_a_y_widget.dart' show SheltersTAYWidget;
import 'package:flutter/material.dart';

class SheltersTAYModel extends FlutterFlowModel<SheltersTAYWidget> {
  ///  Local state fields for this page.

  List<LatLng> shelterCoords = [];
  void addToShelterCoords(LatLng item) => shelterCoords.add(item);
  void removeFromShelterCoords(LatLng item) => shelterCoords.remove(item);
  void removeAtIndexFromShelterCoords(int index) =>
      shelterCoords.removeAt(index);
  void insertAtIndexInShelterCoords(int index, LatLng item) =>
      shelterCoords.insert(index, item);
  void updateShelterCoordsAtIndex(int index, Function(LatLng) updateFn) =>
      shelterCoords[index] = updateFn(shelterCoords[index]);

  LatLng? userLoc;

  List<SheltersRecord> shelterDocs = [];
  void addToShelterDocs(SheltersRecord item) => shelterDocs.add(item);
  void removeFromShelterDocs(SheltersRecord item) => shelterDocs.remove(item);
  void removeAtIndexFromShelterDocs(int index) => shelterDocs.removeAt(index);
  void insertAtIndexInShelterDocs(int index, SheltersRecord item) =>
      shelterDocs.insert(index, item);
  void updateShelterDocsAtIndex(int index, Function(SheltersRecord) updateFn) =>
      shelterDocs[index] = updateFn(shelterDocs[index]);

  LatLng? searchLoc;

  SheltersRecord? selectedshelter;

  int? markerIndex;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - newCustomAction2] action in SheltersTAY widget.
  List<LatLng>? shelterCoords1;
  // Stores action output result for [Firestore Query - Query a collection] action in SheltersTAY widget.
  List<SheltersRecord>? docsOut;
  // Stores action output result for [Custom Action - getCurrentLatLng] action in SheltersTAY widget.
  LatLng? userLocLL;
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
