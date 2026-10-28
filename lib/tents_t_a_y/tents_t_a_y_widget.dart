import '/backend/backend.dart';
import '/components/simple_resource_sheet_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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
import 'tents_t_a_y_model.dart';
export 'tents_t_a_y_model.dart';

/// move it down and also make sure it works in tandom that in one page the
/// map shows first and then i can put my location and things in there
///
class TentsTAYWidget extends StatefulWidget {
  const TentsTAYWidget({super.key});

  static String routeName = 'TentsTAY';
  static String routePath = '/tentsTAY';

  @override
  State<TentsTAYWidget> createState() => _TentsTAYWidgetState();
}

// Supply data class
class SupplyData {
  final String name;
  final String phone;
  final String address;
  final LatLng location;
  double? distance;

  SupplyData({
    required this.name,
    required this.phone,
    required this.address,
    required this.location,
    this.distance,
  });
}

class _TentsTAYWidgetState extends State<TentsTAYWidget> {
  late TentsTAYModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? _currentLocation;
  List<SupplyData> _supplies = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TentsTAYModel());
    _initializeSupplies();
    _getCurrentLocation();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.tentsCoords1 = await actions.tents();
      _model.tentCoords = _model.tentsCoords1!.toList().cast<LatLng>();
      safeSetState(() {});
      _model.docsOuttents = await queryTentsRecordOnce(
        queryBuilder: (tentsRecord) => tentsRecord.orderBy('location'),
      );
      _model.tentDocs = _model.docsOuttents!.toList().cast<TentsRecord>();
      safeSetState(() {});
      _model.tentCoords = _model.docsOuttents!
          .map((e) => e.location)
          .withoutNulls
          .toList()
          .toList()
          .cast<LatLng>();
      safeSetState(() {});
      await requestPermission(locationPermission);
      _model.userLocLLT = await actions.getCurrentLatLng();
      if (_model.userLocLLT != null) {
        FFAppState().centerLoc = _model.userLocLLT;
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

  void _initializeSupplies() {
    _supplies = [
      SupplyData(
        name: 'Bill Wilson Center – Street Outreach / Drop-In',
        phone: '(408) 243-0222',
        address: '693 S 2nd St, San Jose, CA 95112',
        location: LatLng(37.3305, -121.8826),
      ),
      SupplyData(
        name: 'Larkin Street Youth Services – Drop-In Sites',
        phone: '(800) 669-6196',
        address: '134 Golden Gate Ave, San Francisco, CA 94102',
        location: LatLng(37.7820, -122.4125),
      ),
      SupplyData(
        name: 'Covenant House California – Oakland',
        phone: '(510) 379-1010',
        address: '200 Harrison St, Oakland, CA 94607',
        location: LatLng(37.7965, -122.2816),
      ),
      SupplyData(
        name: 'The HUB – Santa Clara County',
        phone: '(408) 792-1750',
        address: '1510 Parkmoor Ave, San Jose, CA 95126',
        location: LatLng(37.3184, -121.9082),
      ),
      SupplyData(
        name: 'Social Advocates for Youth (SAY)',
        phone: '(707) 544-3299',
        address: '2447 Summerfield Rd, Santa Rosa, CA 95405',
        location: LatLng(38.4175, -122.6644),
      ),
      SupplyData(
        name: 'Community Solutions – South County Youth',
        phone: '(408) 779-2113',
        address: '1165 Monterey St, Suite A-140, Morgan Hill, CA 95037',
        location: LatLng(37.1297, -121.6538),
      ),
      SupplyData(
        name: 'Youth Spirit Artworks (Berkeley)',
        phone: '(510) 282-0396',
        address: '1740 Alcatraz Ave, Berkeley, CA 94703',
        location: LatLng(37.8729, -122.2986),
      ),
      SupplyData(
        name: 'Downtown Streets Team – Dignity on Wheels',
        phone: '(408) 899-7350',
        address: 'Mobile shower/laundry services (locations vary)',
        location: LatLng(37.3387, -121.8853),
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

    for (var supply in _supplies) {
      supply.distance = _calculateDistance(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        supply.location.latitude,
        supply.location.longitude,
      );
    }

    _supplies.sort((a, b) {
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
        bottomNavigationBar: const FcAudienceNav(minors: false, current: 4),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: FlutterFlowGoogleMap(
                controller: _model.googleMapsController,
                onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
                initialLocation: _model.googleMapsCenter ??= LatLng(
                  37.5,
                  -122.0,
                ),
                markers: [
                  FlutterFlowMarker(
                    'supplies_1',
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
                              name:
                                  'Bill Wilson Center – Street Outreach / Drop-In',
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
                    'supplies_2',
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
                              name:
                                  'Larkin Street Youth Services – Drop-In Sites',
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
                    'supplies_3',
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
                    'supplies_4',
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
                    'supplies_5',
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
                    'supplies_6',
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
                    'supplies_7',
                    LatLng(37.8729, -122.2986),
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
                              name: 'Youth Spirit Artworks (Berkeley)',
                              phone: '(510) 282-0396',
                              address: '1740 Alcatraz Ave, Berkeley, CA 94703',
                              showRideButton: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FlutterFlowMarker(
                    'supplies_8',
                    LatLng(37.3387, -121.8853),
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
                              name: 'Downtown Streets Team – Dignity on Wheels',
                              phone: '(408) 899-7350',
                              address:
                                  'Mobile shower/laundry services (locations vary)',
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
            // Scrollable supply list
            Expanded(
              flex: 2,
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
                    // Scrollable list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _supplies.length,
                        itemBuilder: (context, index) {
                          final supply = _supplies[index];
                          return FcLocationCard(
                            title: supply.name,
                            subtitle: supply.phone,
                            detail: supply.distance != null
                                ? '${(supply.distance! * 0.621371).toStringAsFixed(1)} mi away'
                                : null,
                            directionsQuery: supply.address,
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
                                        name: supply.name,
                                        phone: supply.phone,
                                        address: supply.address,
                                        showRideButton: true,
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
