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
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'tents_minors_model.dart';
export 'tents_minors_model.dart';

/// move it down and also make sure it works in tandom that in one page the
/// map shows first and then i can put my location and things in there
///
class TentsMinorsWidget extends StatefulWidget {
  const TentsMinorsWidget({super.key});

  static String routeName = 'TentsMinors';
  static String routePath = '/tentsMinors';

  @override
  State<TentsMinorsWidget> createState() => _TentsMinorsWidgetState();
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

class _TentsMinorsWidgetState extends State<TentsMinorsWidget> {
  late TentsMinorsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? _currentLocation;
  List<ResourceData> _resources = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TentsMinorsModel());
    _initializeResources();
    _getCurrentLocation();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.tentMinorsCoords1 = await actions.tentsminors();
      _model.tentMinorsCoords = _model.tentMinorsCoords.toList().cast<LatLng>();
      safeSetState(() {});
      _model.docsOutMinorsTent = await queryTentsminorsRecordOnce();
      _model.tentMinorsDocs = _model.docsOutMinorsTent!
          .toList()
          .cast<TentsminorsRecord>();
      safeSetState(() {});
      _model.tentMinorsCoords = _model.docsOutMinorsTent!
          .map((e) => e.location)
          .withoutNulls
          .toList()
          .toList()
          .cast<LatLng>();
      safeSetState(() {});
      await requestPermission(locationPermission);
      _model.userLocLLTM = await actions.getCurrentLatLng();
      if (_model.userLocLLTM != null) {
        FFAppState().centerLoc = _model.userLocLLTM;
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
        name: 'Bill Wilson Center – Minors Street Outreach',
        phone: '(408) 243-0222',
        address: '3490 The Alameda, Santa Clara, CA 95050',
        location: LatLng(37.352, -121.9446),
      ),
      ResourceData(
        name: 'Sacred Heart Community Service – SF',
        phone: '(408) 278-2160',
        address: '1381 S 1st St, San Jose, CA 95110',
        location: LatLng(37.3171, -121.8772),
      ),
      ResourceData(
        name: 'Covenant House California – Minors',
        phone: '(510) 379-1010',
        address: '345 10th St, Oakland, CA 94607',
        location: LatLng(37.7993, -122.2754),
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
    const p = 0.017453292519943295;
    final a =
        0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
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
            'Supplies',
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
        bottomNavigationBar: const FcAudienceNav(minors: true, current: 4),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: FlutterFlowGoogleMap(
                controller: _model.googleMapsController,
                onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
                initialLocation: _model.googleMapsCenter ??=
                    FFAppState().centerLoc!,
                markers: [
                  FlutterFlowMarker(
                    'supplies_minor_1',
                    LatLng(37.3192, -121.8819),
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
                              name:
                                  'Sacred Heart Community Service – Clothing/Basic Needs',
                              phone: '408-278-2160',
                              address: '1381 S 1st St, San Jose, CA 95110',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'supplies_minor_2',
                    LatLng(37.3529, -121.9451),
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
                              name: 'Bill Wilson Center – Drop-in (Youth)',
                              phone: '408-243-0222',
                              address:
                                  '3490 The Alameda, Santa Clara, CA 95050',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'supplies_minor_3',
                    LatLng(37.3515, -121.8813),
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
                              name: 'CityTeam San Jose – Family Services',
                              phone: '408-232-5600',
                              address: '580 Charles St, San Jose, CA 95112',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'supplies_minor_4',
                    LatLng(36.9811, -121.5635),
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
                              name:
                                  'South County Compassion Center (Gilroy) – Showers & Supplies',
                              phone: '408-763-7120',
                              address: '370 Tomkins Ct, Gilroy, CA 95020',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'supplies_minor_5',
                    LatLng(36.9980, -121.5683),
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
                              name:
                                  'Rebekah Children\'s Services (Gilroy) – Family Support',
                              phone: '408-846-2100',
                              address: '290 IOOF Ave, Gilroy, CA 95020',
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nearby Supplies',
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
                                builder: (context) => GestureDetector(
                                  onTap: () => FocusScope.of(context).unfocus(),
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: SimpleResourceSheetWidget(
                                      name: resource.name,
                                      phone: resource.phone,
                                      address: resource.address,
                                      showRideButton: true,
                                    ),
                                  ),
                                ),
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
