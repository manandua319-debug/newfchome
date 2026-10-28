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
import 'shelters_t_a_y_model.dart';
export 'shelters_t_a_y_model.dart';

/// move it down and also make sure it works in tandom that in one page the
/// map shows first and then i can put my location and things in there
///
class SheltersTAYWidget extends StatefulWidget {
  const SheltersTAYWidget({super.key});

  static String routeName = 'SheltersTAY';
  static String routePath = '/sheltersTAY';

  @override
  State<SheltersTAYWidget> createState() => _SheltersTAYWidgetState();
}

// Shelter data class
class ShelterData {
  final String name;
  final String phone;
  final String address;
  final LatLng location;
  double? distance;

  ShelterData({
    required this.name,
    required this.phone,
    required this.address,
    required this.location,
    this.distance,
  });
}

class _SheltersTAYWidgetState extends State<SheltersTAYWidget> {
  late SheltersTAYModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? _currentLocation;
  List<ShelterData> _shelters = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SheltersTAYModel());
    _initializeShelters();
    _getCurrentLocation();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.shelterCoords1 = await actions.newCustomAction2();
      _model.shelterCoords = _model.shelterCoords1!.toList().cast<LatLng>();
      safeSetState(() {});
      _model.docsOut = await querySheltersRecordOnce();
      _model.shelterDocs = _model.docsOut!.toList().cast<SheltersRecord>();
      safeSetState(() {});
      _model.shelterCoords = _model.docsOut!
          .map((e) => e.location)
          .withoutNulls
          .toList()
          .toList()
          .cast<LatLng>();
      safeSetState(() {});
      await requestPermission(locationPermission);
      _model.userLocLL = await actions.getCurrentLatLng();
      if (_model.userLocLL != null) {
        FFAppState().centerLoc = _model.userLocLL;
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

  void _initializeShelters() {
    _shelters = [
      ShelterData(
        name: 'Bill Wilson Center – TAY Drop-In Center',
        phone: '(408) 243-0222',
        address: '693 S 2nd St, San Jose, CA 95112',
        location: LatLng(37.3305, -121.8826),
      ),
      ShelterData(
        name: 'Bill Wilson Center – Main Office',
        phone: '(408) 243-0222',
        address: '3490 The Alameda, Santa Clara, CA 95050',
        location: LatLng(37.3516, -121.9391),
      ),
      ShelterData(
        name: 'The HUB (Santa Clara County Foster Youth)',
        phone: '(408) 792-1750',
        address: '591 N King Rd, Suite 1, San Jose, CA 95133',
        location: LatLng(37.3752, -121.8207),
      ),
      ShelterData(
        name: 'Community Solutions – South County Youth',
        phone: '(408) 779-2113',
        address: '16264 Church St, Morgan Hill, CA 95037',
        location: LatLng(37.1305, -121.6541),
      ),
      ShelterData(
        name: 'Covenant House California – Oakland',
        phone: '(510) 379-1010',
        address: '200 Harrison St, Oakland, CA 94607',
        location: LatLng(37.7965, -122.2816),
      ),
      ShelterData(
        name: 'Larkin Street Youth Services – Lark-Inn',
        phone: '(415) 673-0911',
        address: '869 Ellis St, San Francisco, CA 94109',
        location: LatLng(37.7831, -122.4177),
      ),
      ShelterData(
        name: 'Larkin Street Youth Services – Admin',
        phone: '(415) 673-0911',
        address: '134 Golden Gate Ave, San Francisco, CA 94102',
        location: LatLng(37.7820, -122.4125),
      ),
      ShelterData(
        name: 'Huckleberry Youth Programs – TAY Services',
        phone: '(415) 621-2929',
        address: '3310 Geary Blvd, San Francisco, CA 94118',
        location: LatLng(37.7671, -122.4503),
      ),
      ShelterData(
        name: 'First Place for Youth – Oakland',
        phone: '(510) 272-0979',
        address: '426 17th St, Suite 100, Oakland, CA 94612',
        location: LatLng(37.8048, -122.2711),
      ),
      ShelterData(
        name: 'Youth Spirit Artworks – Tiny House Village',
        phone: '(510) 282-0396',
        address: '633 Hegenberger Rd, Oakland, CA 94621',
        location: LatLng(37.7382, -122.1979),
      ),
      ShelterData(
        name: 'SAY (Social Advocates for Youth) – Dream Center',
        phone: '(707) 544-3299',
        address: '2447 Summerfield Rd, Santa Rosa, CA 95405',
        location: LatLng(38.4175, -122.6644),
      ),
      ShelterData(
        name: 'VOICES Sonoma (Foster Youth Center)',
        phone: '(707) 636-4621',
        address: '465 A Sebastopol Rd, Santa Rosa, CA 95401',
        location: LatLng(38.4310, -122.7253),
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

    for (var shelter in _shelters) {
      shelter.distance = _calculateDistance(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        shelter.location.latitude,
        shelter.location.longitude,
      );
    }

    // Sort by distance
    _shelters.sort((a, b) {
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
        bottomNavigationBar: const FcAudienceNav(minors: false, current: 1),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: FlutterFlowGoogleMap(
                controller: _model.googleMapsController,
                onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
                initialLocation: _model.googleMapsCenter ??= LatLng(
                  37.5,
                  -122.0,
                ), // Default to Bay Area center
                markers: [
                  // Bill Wilson Center – TAY Drop‑In Center
                  FlutterFlowMarker(
                    'tay_shelter_1',
                    LatLng(37.3305, -121.8826),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name: 'Bill Wilson Center – TAY Drop-In Center',
                                phone: '(408) 243-0222',
                                address: '693 S 2nd St, San Jose, CA 95112',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Bill Wilson Center – Main Office
                  FlutterFlowMarker(
                    'tay_shelter_2',
                    LatLng(37.3516, -121.9391),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name: 'Bill Wilson Center – Main Office',
                                phone: '(408) 243-0222',
                                address:
                                    '3490 The Alameda, Santa Clara, CA 95050',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // The HUB
                  FlutterFlowMarker(
                    'tay_shelter_3',
                    LatLng(37.3752, -121.8207),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name:
                                    'The HUB (Santa Clara County Foster Youth)',
                                phone: '(408) 792-1750',
                                address:
                                    '591 N King Rd, Suite 1, San Jose, CA 95133',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Community Solutions
                  FlutterFlowMarker(
                    'tay_shelter_4',
                    LatLng(37.1305, -121.6541),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name:
                                    'Community Solutions – South County Youth',
                                phone: '(408) 779-2113',
                                address:
                                    '16264 Church St, Morgan Hill, CA 95037',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Covenant House California
                  FlutterFlowMarker(
                    'tay_shelter_5',
                    LatLng(37.7965, -122.2816),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name: 'Covenant House California – Oakland',
                                phone: '(510) 379-1010',
                                address: '200 Harrison St, Oakland, CA 94607',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Larkin Street – Lark-Inn
                  FlutterFlowMarker(
                    'tay_shelter_6',
                    LatLng(37.7831, -122.4177),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name: 'Larkin Street Youth Services – Lark-Inn',
                                phone: '(415) 673-0911',
                                address:
                                    '869 Ellis St, San Francisco, CA 94109',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Larkin Street – Admin
                  FlutterFlowMarker(
                    'tay_shelter_7',
                    LatLng(37.7820, -122.4125),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name: 'Larkin Street Youth Services – Admin',
                                phone: '(415) 673-0911',
                                address:
                                    '134 Golden Gate Ave, San Francisco, CA 94102',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Huckleberry Youth Programs
                  FlutterFlowMarker(
                    'tay_shelter_8',
                    LatLng(37.7671, -122.4503),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name:
                                    'Huckleberry Youth Programs – TAY Services',
                                phone: '(415) 386-9398',
                                address: '555 Cole St, San Francisco, CA 94117',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // First Place for Youth
                  FlutterFlowMarker(
                    'tay_shelter_9',
                    LatLng(37.8072, -122.2694),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name: 'First Place for Youth – Oakland',
                                phone: '(510) 272-0979',
                                address:
                                    '426 17th St, Suite 100, Oakland, CA 94612',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Youth Spirit Artworks
                  FlutterFlowMarker(
                    'tay_shelter_10',
                    LatLng(37.7382, -122.1979),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name:
                                    'Youth Spirit Artworks – Tiny House Village',
                                phone: '(510) 282-0396',
                                address:
                                    '633 Hegenberger Rd, Oakland, CA 94621',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // SAY Dream Center
                  FlutterFlowMarker(
                    'tay_shelter_11',
                    LatLng(38.4175, -122.6644),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name:
                                    'SAY (Social Advocates for Youth) – Dream Center',
                                phone: '(707) 544-3299',
                                address:
                                    '2447 Summerfield Rd, Santa Rosa, CA 95405',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // VOICES Sonoma
                  FlutterFlowMarker(
                    'tay_shelter_12',
                    LatLng(38.4310, -122.7253),
                    () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: SimpleResourceSheetWidget(
                                name: 'VOICES Sonoma (Foster Youth Center)',
                                phone: '(707) 636-4621',
                                address:
                                    '465 A Sebastopol Rd, Santa Rosa, CA 95401',
                              ),
                            ),
                          );
                        },
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
            // Scrollable shelter list
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
                        itemCount: _shelters.length,
                        itemBuilder: (context, index) {
                          final shelter = _shelters[index];
                          return FcLocationCard(
                            title: shelter.name,
                            subtitle: shelter.phone,
                            detail: shelter.distance != null
                                ? '${(shelter.distance! * 0.621371).toStringAsFixed(1)} mi away'
                                : null,
                            directionsQuery: shelter.address,
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
                                        name: shelter.name,
                                        phone: shelter.phone,
                                        address: shelter.address,
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
