import '/flutter_flow/flutter_flow_util.dart';
import '/app_state.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '/services/trust_score_tracker.dart';
import 'simple_resource_sheet_model.dart';
export 'simple_resource_sheet_model.dart';

/// Elegant, minimalistic resource sheet with black/white/grey design
class SimpleResourceSheetWidget extends StatefulWidget {
  const SimpleResourceSheetWidget({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    this.showRideButton = true,
  });

  final String name;
  final String phone;
  final String address;
  final bool showRideButton;

  @override
  State<SimpleResourceSheetWidget> createState() =>
      _SimpleResourceSheetWidgetState();
}

class _SimpleResourceSheetWidgetState extends State<SimpleResourceSheetWidget> {
  late SimpleResourceSheetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SimpleResourceSheetModel());

    // Track service detail view when sheet opens
    _trackServiceView();
  }

  void _trackServiceView() {
    // Determine service type from name/context
    String serviceType = 'general';
    if (widget.name.toLowerCase().contains('shelter')) {
      serviceType = 'shelter';
    } else if (widget.name.toLowerCase().contains('health') ||
        widget.name.toLowerCase().contains('medical')) {
      serviceType = 'health';
    } else if (widget.name.toLowerCase().contains('food') ||
        widget.name.toLowerCase().contains('meal')) {
      serviceType = 'food';
    } else if (widget.name.toLowerCase().contains('tent') ||
        widget.name.toLowerCase().contains('supplies')) {
      serviceType = 'tents';
    }

    TrustScoreTracker().trackServiceDetailView(
      serviceName: widget.name,
      serviceType: serviceType,
      address: widget.address,
    );
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 24.0,
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, -4),
              spreadRadius: 0.0,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kFcLine,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Name
              Text(
                widget.name,
                style: fcHeadline(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: kFcInk,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),

              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: kFcMuted, size: 20.0),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.address,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: kFcMuted,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Phone
              Row(
                children: [
                  const Icon(Icons.phone, color: kFcMuted, size: 20.0),
                  const SizedBox(width: 12),
                  Text(
                    widget.phone,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: kFcMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Divider
              Container(height: 1, color: kFcLine),
              const SizedBox(height: 24),

              // Buttons
              // Call Button - Black
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: kFcPrimary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      // Track service call
                      TrustScoreTracker().trackServiceCall(
                        serviceName: widget.name,
                        phoneNumber: widget.phone,
                      );

                      await launchUrl(Uri(scheme: 'tel', path: widget.phone));
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Call',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Navigate Button - Grey Outline
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kFcLine, width: 1),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      // Track directions usage
                      TrustScoreTracker().trackDirectionsUsed(
                        destinationName: widget.name,
                        destinationAddress: widget.address,
                      );

                      await launchMap(address: widget.address, title: '');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.navigation, size: 18, color: kFcInk),
                          const SizedBox(width: 8),
                          Text(
                            'Navigate',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: kFcInk,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (widget.showRideButton) ...[
                const SizedBox(height: 12),
                // Request a Ride Button - Dark Grey Outline
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: kFcLine, width: 1),
                    ),
                    child: InkWell(
                      onTap: () async {
                        // Track destination selection
                        String serviceType = 'general';
                        if (widget.name.toLowerCase().contains('shelter')) {
                          serviceType = 'shelter';
                        } else if (widget.name.toLowerCase().contains(
                              'health',
                            ) ||
                            widget.name.toLowerCase().contains('medical')) {
                          serviceType = 'health';
                        } else if (widget.name.toLowerCase().contains('food') ||
                            widget.name.toLowerCase().contains('meal')) {
                          serviceType = 'food';
                        } else if (widget.name.toLowerCase().contains('tent') ||
                            widget.name.toLowerCase().contains('supplies')) {
                          serviceType = 'tents';
                        }

                        TrustScoreTracker().trackDestinationSelected(
                          destinationName: widget.name,
                          destinationAddress: widget.address,
                          serviceType: serviceType,
                        );

                        // Set the destination in app state before navigating
                        FFAppState().update(() {
                          FFAppState().selectedDestinationName = widget.name;
                          FFAppState().selectedDestinationAddress =
                              widget.address;
                        });
                        context.pushNamed(TransportStep1Widget.routeName);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.directions_car,
                              size: 18,
                              color: kFcMuted,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Request a Ride',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kFcMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
