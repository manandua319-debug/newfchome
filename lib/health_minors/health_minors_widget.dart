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
import 'health_minors_model.dart';
export 'health_minors_model.dart';

/// move it down and also make sure it works in tandom that in one page the
/// map shows first and then i can put my location and things in there
///
class HealthMinorsWidget extends StatefulWidget {
  const HealthMinorsWidget({super.key});

  static String routeName = 'HealthMinors';
  static String routePath = '/healthMinors';

  @override
  State<HealthMinorsWidget> createState() => _HealthMinorsWidgetState();
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

class _HealthMinorsWidgetState extends State<HealthMinorsWidget> {
  late HealthMinorsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? _currentLocation;
  List<ResourceData> _resources = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HealthMinorsModel());
    _initializeResources();
    _getCurrentLocation();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.healthMinorCoords1 = await actions.healthminors();
      _model.healthMinorCoords = _model.healthMinorCoords1!
          .toList()
          .cast<LatLng>();
      safeSetState(() {});
      _model.docsOuthealthMinor = await queryHealthminorsRecordOnce();
      _model.healthMinorDocs = _model.docsOuthealthMinor!
          .toList()
          .cast<HealthminorsRecord>();
      safeSetState(() {});
      _model.healthMinorCoords = _model.docsOuthealthMinor!
          .map((e) => e.location)
          .withoutNulls
          .toList()
          .toList()
          .cast<LatLng>();
      safeSetState(() {});
      await requestPermission(locationPermission);
      _model.userLocLLHM = await actions.getCurrentLatLng();
      if (_model.userLocLLHM != null) {
        FFAppState().centerLoc = _model.userLocLLHM;
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
        name: 'YMCA Redwoods Camp – Health Services',
        phone: '(650) 851-1963',
        address: '10000 Skyline Blvd, Oakland, CA 94619',
        location: LatLng(37.7749, -122.178),
      ),
      ResourceData(
        name: 'Asian Health Services – Mobile Clinic',
        phone: '(510) 735-5900',
        address: '818 Webster St, Oakland, CA 94607',
        location: LatLng(37.7983, -122.2711),
      ),
      ResourceData(
        name: 'La Clínica de La Raza',
        phone: '(510) 535-4000',
        address: '1515 Fruitvale Ave, Oakland, CA 94601',
        location: LatLng(37.7766, -122.2242),
      ),
      ResourceData(
        name: 'Tiburcio Vasquez Health Center',
        phone: '(408) 885-5600',
        address: '1333 Meridian Ave, San Jose, CA 95125',
        location: LatLng(37.2937, -121.9137),
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
            'Health',
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
        bottomNavigationBar: const FcAudienceNav(minors: true, current: 3),
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
                    'health_minor_1',
                    LatLng(36.9651, -121.5607),
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
                              name: 'SCVMC – Gilroy Clinic (South County)',
                              phone: '888-334-1000',
                              address: '7475 Camino Arroyo, Gilroy, CA 95020',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'health_minor_2',
                    LatLng(37.0115, -121.5721),
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
                              name: 'Gardner South County Health Center',
                              phone: '408-847-0607',
                              address: '7526 Monterey Hwy, Gilroy, CA 95020',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'health_minor_3',
                    LatLng(36.9982, -121.5660),
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
                              name: 'Planned Parenthood – Gilroy',
                              phone: '408-847-1739',
                              address: '760 Renz Ln, Gilroy, CA 95020',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'health_minor_4',
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
                              name: 'Bill Wilson Center – Counseling Services',
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
                    'health_minor_5',
                    LatLng(37.3337, -121.9143),
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
                                  'Santa Clara County Behavioral Health – Child & Adolescent',
                              phone: '800-704-0900',
                              address: '976 Lenzen Ave, San Jose, CA 95126',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'health_minor_6',
                    LatLng(37.4336, -122.1750),
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
                                  'Stanford Children\'s Health – Teen & Adolescent Clinics (Peninsula)',
                              phone: '650-721-1234',
                              address: '300 Pasteur Dr, Palo Alto, CA 94305',
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
                            'Nearby Health Resources',
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
