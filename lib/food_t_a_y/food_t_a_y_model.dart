import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/place.dart';
import 'food_t_a_y_widget.dart' show FoodTAYWidget;
import 'package:flutter/material.dart';

class FoodTAYModel extends FlutterFlowModel<FoodTAYWidget> {
  ///  Local state fields for this page.

  List<LatLng> foodCoords = [];
  void addToFoodCoords(LatLng item) => foodCoords.add(item);
  void removeFromFoodCoords(LatLng item) => foodCoords.remove(item);
  void removeAtIndexFromFoodCoords(int index) => foodCoords.removeAt(index);
  void insertAtIndexInFoodCoords(int index, LatLng item) =>
      foodCoords.insert(index, item);
  void updateFoodCoordsAtIndex(int index, Function(LatLng) updateFn) =>
      foodCoords[index] = updateFn(foodCoords[index]);

  LatLng? userLoc;

  List<FoodRecord> foodDocs = [];
  void addToFoodDocs(FoodRecord item) => foodDocs.add(item);
  void removeFromFoodDocs(FoodRecord item) => foodDocs.remove(item);
  void removeAtIndexFromFoodDocs(int index) => foodDocs.removeAt(index);
  void insertAtIndexInFoodDocs(int index, FoodRecord item) =>
      foodDocs.insert(index, item);
  void updateFoodDocsAtIndex(int index, Function(FoodRecord) updateFn) =>
      foodDocs[index] = updateFn(foodDocs[index]);

  LatLng? searchLoc;

  FoodRecord? selectedfood;

  int? markerIndex;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - food] action in FoodTAY widget.
  List<LatLng>? foodCoords1;
  // Stores action output result for [Firestore Query - Query a collection] action in FoodTAY widget.
  List<FoodRecord>? docsOutfood;
  // Stores action output result for [Custom Action - getCurrentLatLng] action in FoodTAY widget.
  LatLng? userLocLLF;
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
