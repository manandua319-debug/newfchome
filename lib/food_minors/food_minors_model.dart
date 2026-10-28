import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/place.dart';
import 'food_minors_widget.dart' show FoodMinorsWidget;
import 'package:flutter/material.dart';

class FoodMinorsModel extends FlutterFlowModel<FoodMinorsWidget> {
  ///  Local state fields for this page.

  List<LatLng> foodMinorCoords = [];
  void addToFoodMinorCoords(LatLng item) => foodMinorCoords.add(item);
  void removeFromFoodMinorCoords(LatLng item) => foodMinorCoords.remove(item);
  void removeAtIndexFromFoodMinorCoords(int index) =>
      foodMinorCoords.removeAt(index);
  void insertAtIndexInFoodMinorCoords(int index, LatLng item) =>
      foodMinorCoords.insert(index, item);
  void updateFoodMinorCoordsAtIndex(int index, Function(LatLng) updateFn) =>
      foodMinorCoords[index] = updateFn(foodMinorCoords[index]);

  LatLng? userLoc;

  List<FoodminorsRecord> foodMinorDocs = [];
  void addToFoodMinorDocs(FoodminorsRecord item) => foodMinorDocs.add(item);
  void removeFromFoodMinorDocs(FoodminorsRecord item) =>
      foodMinorDocs.remove(item);
  void removeAtIndexFromFoodMinorDocs(int index) =>
      foodMinorDocs.removeAt(index);
  void insertAtIndexInFoodMinorDocs(int index, FoodminorsRecord item) =>
      foodMinorDocs.insert(index, item);
  void updateFoodMinorDocsAtIndex(
    int index,
    Function(FoodminorsRecord) updateFn,
  ) => foodMinorDocs[index] = updateFn(foodMinorDocs[index]);

  LatLng? searchLoc;

  FoodminorsRecord? selectedfoodMinor;

  int? markerIndex;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - foodminors] action in FoodMinors widget.
  List<LatLng>? foodMinorCoords1;
  // Stores action output result for [Firestore Query - Query a collection] action in FoodMinors widget.
  List<FoodminorsRecord>? docsOutfoodMinor;
  // Stores action output result for [Custom Action - getCurrentLatLng] action in FoodMinors widget.
  LatLng? userLocLLFM;
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
