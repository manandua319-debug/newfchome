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
import 'shelters_minors_model.dart';
export 'shelters_minors_model.dart';

/// move it down and also make sure it works in tandom that in one page the
/// map shows first and then i can put my location and things in there
///
class SheltersMinorsWidget extends StatefulWidget {
  const SheltersMinorsWidget({super.key});

  static String routeName = 'SheltersMinors';
  static String routePath = '/sheltersMinors';

  @override
  State<SheltersMinorsWidget> createState() => _SheltersMinorsWidgetState();
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

class _SheltersMinorsWidgetState extends State<SheltersMinorsWidget> {
  late SheltersMinorsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? _currentLocation;
  List<ResourceData> _resources = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SheltersMinorsModel());
    _initializeResources();
    _getCurrentLocation();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.shelterCoords1 = await actions.sheltersminors();
      _model.shelterMinorsCoords = _model.shelterMinorsCoords
          .toList()
          .cast<LatLng>();
      safeSetState(() {});
      _model.docsOutMinorsShelter = await querySheltersminorsRecordOnce();
      _model.shelterMinorsDocs = _model.docsOutMinorsShelter!
          .toList()
          .cast<SheltersminorsRecord>();
      safeSetState(() {});
      _model.shelterMinorsCoords = _model.docsOutMinorsShelter!
          .map((e) => e.location)
          .withoutNulls
          .toList()
          .toList()
          .cast<LatLng>();
      safeSetState(() {});
      await requestPermission(locationPermission);
      _model.userLocLLSM = await actions.getCurrentLatLng();
      if (_model.userLocLLSM != null) {
        FFAppState().centerLoc = _model.userLocLLSM;
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
        name: 'Bill Wilson Center – Safety Net Shelter (Youth)',
        phone: '408-243-0222',
        address: '3490 The Alameda, Santa Clara, CA 95050',
        location: LatLng(37.3529, -121.9451),
      ),
      ResourceData(
        name: 'Huckleberry House (SF)',
        phone: '415-621-2929',
        address: '555 Cole St, San Francisco, CA 94117',
        location: LatLng(37.7705, -122.4504),
      ),
      ResourceData(
        name: 'DreamCatcher Youth Services (Oakland)',
        phone: '510-379-1010',
        address: '422 Jefferson St, Oakland, CA 94607',
        location: LatLng(37.8007, -122.2730),
      ),
      ResourceData(
        name: 'Bill Wilson Center – Quetzal House (Confidential)',
        phone: '408-243-0222',
        address: 'Confidential – Call for location (Santa Clara County)',
        location: LatLng(37.3541, -121.9552),
      ),
      ResourceData(
        name: 'Santa Clara County Youth Crisis Line',
        phone: '408-850-6125',
        address: 'Countywide – Call for placement',
        location: LatLng(37.3337, -121.8907),
      ),
      ResourceData(
        name: 'Community Solutions – South County (Access)',
        phone: '408-779-2113',
        address: '16264 Church St, Morgan Hill, CA 95037',
        location: LatLng(37.1305, -121.6540),
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
            'Shelters',
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
        bottomNavigationBar: const FcAudienceNav(minors: true, current: 1),
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
                    'shelter_minor_1',
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
                              name:
                                  'Bill Wilson Center – Safety Net Shelter (Youth)',
                              phone: '408-243-0222',
                              address:
                                  '3490 The Alameda, Santa Clara, CA 95050',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'shelter_minor_2',
                    LatLng(37.7705, -122.4504),
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
                              name: 'Huckleberry House (SF)',
                              phone: '415-621-2929',
                              address: '555 Cole St, San Francisco, CA 94117',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'shelter_minor_3',
                    LatLng(37.8007, -122.2730),
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
                              phone: '510-379-1010',
                              address: '422 Jefferson St, Oakland, CA 94607',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'shelter_minor_4',
                    LatLng(37.3541, -121.9552),
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
                                  'Bill Wilson Center – Quetzal House (Confidential)',
                              phone: '408-243-0222',
                              address:
                                  'Confidential – Call for location (Santa Clara County)',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'shelter_minor_5',
                    LatLng(37.3337, -121.8907),
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
                              name: 'Santa Clara County Youth Crisis Line',
                              phone: '408-850-6125',
                              address: 'Countywide – Call for placement',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'shelter_minor_6',
                    LatLng(37.1305, -121.6540),
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
                                  'Community Solutions – South County (Access)',
                              phone: '408-779-2113',
                              address: '16264 Church St, Morgan Hill, CA 95037',
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
                            'Nearby Shelters',
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
