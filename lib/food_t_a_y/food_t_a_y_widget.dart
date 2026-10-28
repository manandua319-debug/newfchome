import '/backend/backend.dart';
import '/components/simple_resource_sheet_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'dart:math' show cos, sqrt, asin;
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/permissions_util.dart';
import 'package:flutter/material.dart';
import '/ui/fc_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'food_t_a_y_model.dart';
export 'food_t_a_y_model.dart';

/// move it down and also make sure it works in tandom that in one page the
/// map shows first and then i can put my location and things in there
///
class FoodTAYWidget extends StatefulWidget {
  const FoodTAYWidget({super.key});

  static String routeName = 'FoodTAY';
  static String routePath = '/foodTAY';

  @override
  State<FoodTAYWidget> createState() => _FoodTAYWidgetState();
}

// Resource data class
class ResourceData {
  final String name;
  final String phone;
  final String address;
  final LatLng location;
  double? distance;

  ResourceData({
    required this.name,
    required this.phone,
    required this.address,
    required this.location,
    this.distance,
  });
}

class _FoodTAYWidgetState extends State<FoodTAYWidget> {
  late FoodTAYModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? _currentLocation;
  List<ResourceData> _resources = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FoodTAYModel());
    _initializeResources();
    _getCurrentLocation();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.foodCoords1 = await actions.food();
      _model.foodCoords = _model.foodCoords1!.toList().cast<LatLng>();
      safeSetState(() {});
      _model.docsOutfood = await queryFoodRecordOnce();
      _model.foodDocs = _model.docsOutfood!.toList().cast<FoodRecord>();
      safeSetState(() {});
      _model.foodCoords = _model.docsOutfood!
          .map((e) => e.location)
          .withoutNulls
          .toList()
          .toList()
          .cast<LatLng>();
      safeSetState(() {});
      await requestPermission(locationPermission);
      _model.userLocLLF = await actions.getCurrentLatLng();
      if (_model.userLocLLF != null) {
        FFAppState().centerLoc = _model.userLocLLF;
        safeSetState(() {});
        await _model.googleMapsController.future.then(
          (c) => c.animateCamera(
            CameraUpdate.newLatLng(FFAppState().centerLoc!.toGoogleMaps()),
          ),
        );
      } else {
        if (_model.searchLoc != null) {
          FFAppState().centerLoc = _model.searchLoc;
          safeSetState(() {});
          await _model.googleMapsController.future.then(
            (c) => c.animateCamera(
              CameraUpdate.newLatLng(FFAppState().centerLoc!.toGoogleMaps()),
            ),
          );
        } else {
          // No location access: keep the default map view. Users can still
          // pick a place with the search box.
        }
      }
    });
  }

  void _initializeResources() {
    _resources = [
      ResourceData(
        name: 'Bill Wilson Center – Drop-In Center',
        phone: '(408) 243-0222',
        address: '693 S 2nd St, San Jose, CA 95112',
        location: LatLng(37.3305, -121.8826),
      ),
      ResourceData(
        name: 'Covenant House California – Oakland',
        phone: '(510) 379-1010',
        address: '200 Harrison St, Oakland, CA 94607',
        location: LatLng(37.7965, -122.2816),
      ),
      ResourceData(
        name: 'Larkin Street Youth Services',
        phone: '(800) 669-6196',
        address: '134 Golden Gate Ave, San Francisco, CA 94102',
        location: LatLng(37.7820, -122.4125),
      ),
      ResourceData(
        name: 'Social Advocates for Youth (SAY)',
        phone: '(707) 544-3299',
        address: '2447 Summerfield Rd, Santa Rosa, CA 95405',
        location: LatLng(38.4175, -122.6644),
      ),
      ResourceData(
        name: 'Huckleberry Youth Programs – SF',
        phone: '(415) 386-9398',
        address: '555 Cole St, San Francisco, CA 94117',
        location: LatLng(37.7671, -122.4503),
      ),
      ResourceData(
        name: 'The HUB – Santa Clara County',
        phone: '(408) 792-1750',
        address: '1510 Parkmoor Ave, San Jose, CA 95126',
        location: LatLng(37.3184, -121.9082),
      ),
      ResourceData(
        name: 'Community Solutions – South County Youth',
        phone: '(408) 779-2113',
        address: '1165 Monterey St, Suite A-140, Morgan Hill, CA 95037',
        location: LatLng(37.1297, -121.6538),
      ),
      ResourceData(
        name: 'RYSE Youth Center (Richmond)',
        phone: '(510) 374-3401',
        address: '3939 Bissell Ave, Richmond, CA 94805',
        location: LatLng(37.9372, -122.3486),
      ),
      ResourceData(
        name: 'DreamCatcher Youth Services (Oakland)',
        phone: '(800) 379-1114',
        address: '422 Jefferson St, Oakland, CA 94607',
        location: LatLng(37.8044, -122.2712),
      ),
    ];
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final request = await Geolocator.requestPermission();
        if (request == LocationPermission.denied ||
            request == LocationPermission.deniedForever) {
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _calculateDistances();
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _calculateDistances() {
    if (_currentLocation == null) return;

    for (var resource in _resources) {
      resource.distance = _calculateDistance(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        resource.location.latitude,
        resource.location.longitude,
      );
    }

    // Sort by distance
    _resources.sort((a, b) {
      if (a.distance == null) return 1;
      if (b.distance == null) return -1;
      return a.distance!.compareTo(b.distance!);
    });
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = 0.017453292519943295; // Pi/180
    final a =
        0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // Returns distance in km
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 20.0,
              buttonSize: 77.1,
              icon: Icon(
                Icons.arrow_back_outlined,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
          ),
          title: Text(
            'Food',
            style: FlutterFlowTheme.of(context).titleLarge.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        bottomNavigationBar: const FcAudienceNav(minors: false, current: 2),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: FlutterFlowGoogleMap(
                controller: _model.googleMapsController,
                onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
                initialLocation: _model.googleMapsCenter ??= LatLng(
                  37.5,
                  -122.0,
                ),
                markers: [
                  FlutterFlowMarker(
                    'food_1',
                    LatLng(37.3305, -121.8826),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) => GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: SimpleResourceSheetWidget(
                              name: 'Bill Wilson Center – Drop-In Center',
                              phone: '(408) 243-0222',
                              address: '693 S 2nd St, San Jose, CA 95112',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'food_2',
                    LatLng(37.7965, -122.2816),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) => GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: SimpleResourceSheetWidget(
                              name: 'Covenant House California – Oakland',
                              phone: '(510) 379-1010',
                              address: '200 Harrison St, Oakland, CA 94607',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'food_3',
                    LatLng(37.7820, -122.4125),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) => GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: SimpleResourceSheetWidget(
                              name: 'Larkin Street Youth Services',
                              phone: '(800) 669-6196',
                              address:
                                  '134 Golden Gate Ave, San Francisco, CA 94102',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'food_4',
                    LatLng(38.4175, -122.6644),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) => GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: SimpleResourceSheetWidget(
                              name: 'Social Advocates for Youth (SAY)',
                              phone: '(707) 544-3299',
                              address:
                                  '2447 Summerfield Rd, Santa Rosa, CA 95405',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'food_5',
                    LatLng(37.7671, -122.4503),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) => GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: SimpleResourceSheetWidget(
                              name: 'Huckleberry Youth Programs – SF',
                              phone: '(415) 386-9398',
                              address: '555 Cole St, San Francisco, CA 94117',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'food_6',
                    LatLng(37.3184, -121.9082),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) => GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: SimpleResourceSheetWidget(
                              name: 'The HUB – Santa Clara County',
                              phone: '(408) 792-1750',
                              address: '1510 Parkmoor Ave, San Jose, CA 95126',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'food_7',
                    LatLng(37.1297, -121.6538),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) => GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: SimpleResourceSheetWidget(
                              name: 'Community Solutions – South County Youth',
                              phone: '(408) 779-2113',
                              address:
                                  '1165 Monterey St, Suite A-140, Morgan Hill, CA 95037',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'food_8',
                    LatLng(37.9372, -122.3486),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) => GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: SimpleResourceSheetWidget(
                              name: 'RYSE Youth Center (Richmond)',
                              phone: '(510) 374-3401',
                              address: '3939 Bissell Ave, Richmond, CA 94805',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'food_9',
                    LatLng(37.8044, -122.2712),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) => GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: SimpleResourceSheetWidget(
                              name: 'DreamCatcher Youth Services (Oakland)',
                              phone: '(800) 379-1114',
                              address: '422 Jefferson St, Oakland, CA 94607',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
                markerColor: GoogleMarkerColor.violet,
                mapType: MapType.normal,
                style: GoogleMapStyle.standard,
                initialZoom: 9.0,
                allowInteraction: true,
                allowZoom: true,
                showZoomControls: true,
                showLocation: true,
                showCompass: true,
                showMapToolbar: true,
                showTraffic: false,
                centerMapOnMarkerTap: true,
                mapTakesGesturePreference: true,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nearby Food Resources',
                            style: fcHeadline(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          if (_currentLocation != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.my_location,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Sorted',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Scrollable list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _resources.length,
                        itemBuilder: (context, index) {
                          final resource = _resources[index];
                          return FcLocationCard(
                            title: resource.name,
                            subtitle: resource.phone,
                            detail: resource.distance != null
                                ? '${(resource.distance! * 0.621371).toStringAsFixed(1)} mi away'
                                : null,
                            directionsQuery: resource.address,
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () =>
                                        FocusScope.of(context).unfocus(),
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: SimpleResourceSheetWidget(
                                        name: resource.name,
                                        phone: resource.phone,
                                        address: resource.address,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
