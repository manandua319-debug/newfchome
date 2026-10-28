import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/agency_logo_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/app_state.dart'; // make sure this path matches your project
import '/services/trust_score_tracker.dart';
import '/services/location_service.dart';
import 'transport_s2_model.dart';
export 'transport_s2_model.dart';

/// Step 2: User enters a code, phone, selects agency.
/// If OK, we ensure anonymous sign-in (if needed) and call createTTRequest.
class TransportS2Widget extends StatefulWidget {
  const TransportS2Widget({super.key, this.agency, this.tripPlan});

  /// Agency picked from the trip plan (VTA, Muni, ...). Preselected, not locked.
  final String? agency;

  /// One-line description of the planned trip, saved with the request.
  final String? tripPlan;

  static String routeName = 'TransportS2';
  static String routePath = '/transportS2';

  @override
  State<TransportS2Widget> createState() => _TransportS2WidgetState();
}

class _TransportS2WidgetState extends State<TransportS2Widget> {
  late TransportS2Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Local state for phone + agencies
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _agedOutController = TextEditingController();
  final _startController = TextEditingController();
  String? _agencyValue;
  final List<String> _agencies = [
    'VTA',
    'Muni',
    'SamTrans',
    'Caltrain',
    'BART',
  ];

  // Simple access gate for v1 — change whenever you want
  static const String _validCode = 'FCHOME';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransportS2Model());
    _model.textController ??= TextEditingController(); // code field
    _model.textFieldFocusNode ??= FocusNode();
    final preset = widget.agency;
    if (preset != null && _agencies.contains(preset)) _agencyValue = preset;
    // Prefill Starting Location from where the phone is right now.
    WidgetsBinding.instance.addPostFrameCallback((_) => _fillLocation());
  }

  bool _locating = false;

  Future<void> _fillLocation({bool force = false}) async {
    if (_locating) return;
    if (!force && _startController.text.trim().isNotEmpty) return;
    setState(() => _locating = true);
    final address = await LocationService.currentAddress();
    if (!mounted) return;
    setState(() => _locating = false);
    if (address != null && (force || _startController.text.trim().isEmpty)) {
      _startController.text = address;
    } else if (address == null && force) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Turn on location to fill this in, or type it.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _agedOutController.dispose();
    _startController.dispose();
    _model.dispose();
    super.dispose();
  }

  bool _looksLikePhone(String s) {
    final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 10; // basic sanity check
  }

  Future<void> _verifyAndRequest() async {
    final theme = FlutterFlowTheme.of(context);

    // 1) Validate access code
    final code = _model.textController.text.trim().toUpperCase();
    if (code != _validCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid code. Please try again.'),
          backgroundColor: theme.error,
        ),
      );
      return;
    }

    // 2) Validate phone + agency
    final phone = _phoneController.text.trim();
    final agency = (_agencyValue ?? '').trim();
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());
    final agedOut = _agedOutController.text.trim();
    final startLocation = _startController.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        agency.isEmpty ||
        startLocation.isEmpty ||
        age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields.'),
          backgroundColor: theme.error,
        ),
      );
      return;
    }

    if (age < 10 || age > 35) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid age.'),
          backgroundColor: theme.error,
        ),
      );
      return;
    }

    final profile = <String, dynamic>{
      'name': name,
      'age': age,
      'agedOut': agedOut,
      'startLocation': startLocation,
      if ((widget.tripPlan ?? '').isNotEmpty) 'tripPlan': widget.tripPlan,
    };

    if (!_looksLikePhone(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid phone number.'),
          backgroundColor: theme.error,
        ),
      );
      return;
    }

    // 3) HARDCODED APPROVAL for specific phone number - but still create Firestore doc
    final cleanPhone = phone.replaceAll(
      RegExp(r'[^\d]'),
      '',
    ); // Remove non-digits
    if (cleanPhone == '6693882909') {
      print('DEBUG: HARDCODED approval for phone: $cleanPhone');

      // Ensure signed in
      if (currentUserUid.isEmpty) {
        try {
          await authManager.signInAnonymously(context);
        } catch (e) {
          print('DEBUG: Sign-in failed: $e');
        }
      }

      // Create Firestore doc in background (don't wait for it)
      final requestRef = FirebaseFirestore.instance
          .collection('ttRequests')
          .doc();
      requestRef
          .set({
            'uid': currentUserUid.isNotEmpty ? currentUserUid : 'anonymous',
            'phone': phone,
            ...profile,
            'agencyId': agency,
            'destination':
                FFAppState().selectedDestinationAddress ??
                '3490 The Alameda, Santa Clara, CA 95050',
            'fareLabel': 'Single ride',
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
            'accessCode': code,
          })
          .catchError((e) {
            print('DEBUG: Firestore write error (non-blocking): $e');
          });

      // Store ID immediately
      FFAppState().update(() {
        FFAppState().lastTTRequestId = requestRef.id;
      });

      print('DEBUG: Created request with ID: ${requestRef.id}');

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request submitted. Check status for updates.'),
            backgroundColor: kFcSuccess, // Green
            duration: const Duration(seconds: 1),
          ),
        );
      }

      // Navigate to status page immediately
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 800));
        context.pushNamed('PassStatus');
      }
      return;
    }

    // 4) For other users, ensure we are signed in (anonymous is fine)
    if (currentUserUid.isEmpty) {
      try {
        print('DEBUG: Attempting anonymous sign-in...');
        await authManager.signInAnonymously(context);
        print('DEBUG: Anonymous sign-in successful, UID: $currentUserUid');
      } catch (e) {
        print('DEBUG: Anonymous sign-in failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign-in failed: $e'),
            backgroundColor: theme.error,
          ),
        );
        return;
      }
    } else {
      print('DEBUG: User already signed in, UID: $currentUserUid');
    }

    // 5) Track transport request attempt (before AI evaluation)
    try {
      TrustScoreTracker().trackTransportRequestAttempt(
        destinationAddress:
            FFAppState().selectedDestinationAddress ??
            '3490 The Alameda, Santa Clara, CA 95050',
        agencyId: agency,
        fareLabel: 'Single ride',
      );
    } catch (e) {
      print('DEBUG: Failed to track transport request attempt: $e');
      // Non-blocking, continue with request
    }

    // 6) Call Cloud Function: createTTRequest (region must match your deploy)
    // The function will evaluate trust score and approve/reject
    try {
      print('DEBUG: Calling createTTRequest function...');
      final callable = FirebaseFunctions.instanceFor(
        region: 'us-central1',
      ).httpsCallable('createTTRequest');

      final requestData = {
        'phone': phone,
        'agencyId': agency,
        // Use dynamic destination from app state
        'destination':
            FFAppState().selectedDestinationAddress ??
            '3490 The Alameda, Santa Clara, CA 95050',
        'fareLabel': 'Single ride',
        'accessCode': code, // Pass the access code
      };

      print('DEBUG: Request data: $requestData');

      // Add timeout to prevent hanging
      final result = await callable
          .call(requestData)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              print('DEBUG: Function call TIMED OUT after 30 seconds');
              throw Exception('Function call timed out');
            },
          );
      print('DEBUG: Function call successful, result: ${result.data}');

      final data = (result.data as Map);
      final id = (data['id'] ?? '') as String;

      // Save who the request is for so staff can see it.
      if (id.isNotEmpty) {
        try {
          await FirebaseFirestore.instance
              .collection('ttRequests')
              .doc(id)
              .set(profile, SetOptions(merge: true));
        } catch (e) {
          print('DEBUG: Could not save request details: $e');
        }
      }

      // Store id in app state (notify listeners)
      FFAppState().update(() {
        FFAppState().lastTTRequestId = id;
      });

      // Navigate directly to status page
      if (mounted) {
        context.pushNamed('PassStatus');
      }
    } on FirebaseFunctionsException catch (e) {
      String errorMessage = 'Request failed: ';
      switch (e.code) {
        case 'unauthenticated':
          errorMessage += 'Please sign in and try again.';
          break;
        case 'invalid-argument':
          errorMessage +=
              'Invalid information provided. Please check your details.';
          break;
        case 'permission-denied':
          errorMessage += 'You do not have permission to make this request.';
          break;
        case 'not-found':
          errorMessage += 'Service not found. Please try again later.';
          break;
        case 'internal':
          errorMessage += 'Server error. Please try again later.';
          break;
        default:
          errorMessage += e.message ?? 'Unknown error occurred.';
      }

      print('DEBUG: FirebaseFunctionsException: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: theme.error),
      );
    } catch (e, stackTrace) {
      print('DEBUG: General exception in createTTRequest: $e');
      print('DEBUG: Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request failed: ${e.toString()}'),
          backgroundColor: theme.error,
        ),
      );
    }
  }

  Widget _profileField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    TextCapitalization capitalization = TextCapitalization.none,
    bool optional = false,
    Widget? suffix,
  }) {
    final border = (Color c, double w) => OutlineInputBorder(
      borderSide: BorderSide(color: c, width: w),
      borderRadius: BorderRadius.circular(12),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          optional ? '$label (Optional)' : label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kFcInk,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: capitalization,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kFcInk,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: kFcSubtle,
            ),
            enabledBorder: border(kFcLine, 2),
            focusedBorder: border(kFcPrimary, 3),
            filled: true,
            fillColor: kFcSurface,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 20.0,
            borderWidth: 1.0,
            buttonSize: 40.0,
            fillColor: Colors.transparent,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: kFcInk,
              size: 28.0,
            ),
            onPressed: () async => context.safePop(),
          ),
          title: Text(
            'Get Your Free Pass',
            style: fcHeadline(
              color: kFcInk,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Text(
                    "Fill this in and we'll text the pass to your phone.",
                    style: GoogleFonts.inter(
                      color: kFcMuted,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // FORM - White card with warm styling
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Access code
                        Text(
                          'Access Code',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kFcInk,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          autofocus: true,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.done,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: kFcInk,
                          ),
                          decoration: InputDecoration(
                            hintText: 'abc123',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: kFcSubtle,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kFcLine,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kFcPrimary,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: kFcSurface,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                          ),
                          cursorColor: kFcInk,
                          validator: _model.textControllerValidator.asValidator(
                            context,
                          ),
                          inputFormatters: [],
                        ),
                        const SizedBox(height: 24),
                        _profileField(
                          label: 'Full Name',
                          controller: _nameController,
                          hint: 'First and last name',
                          capitalization: TextCapitalization.words,
                        ),
                        _profileField(
                          label: 'Age',
                          controller: _ageController,
                          hint: '19',
                          keyboardType: TextInputType.number,
                        ),
                        _profileField(
                          label: 'When You Aged Out',
                          controller: _agedOutController,
                          hint: 'MM/YYYY',
                          keyboardType: TextInputType.datetime,
                          optional: true,
                        ),
                        _profileField(
                          label: 'Starting Location',
                          controller: _startController,
                          hint: _locating
                              ? 'Finding your location...'
                              : 'Street address or nearest cross streets',
                          capitalization: TextCapitalization.words,
                          suffix: _locating
                              ? const Padding(
                                  padding: EdgeInsets.all(14),
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: kFcPrimary,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  tooltip: 'Use My Location',
                                  icon: const Icon(
                                    Icons.my_location_rounded,
                                    color: kFcPrimary,
                                  ),
                                  onPressed: () => _fillLocation(force: true),
                                ),
                        ),
                        // Phone number
                        Text(
                          'Phone Number',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kFcInk,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: kFcInk,
                          ),
                          decoration: InputDecoration(
                            hintText: '5551234567',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: kFcSubtle,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kFcLine,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kFcPrimary,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: kFcSurface,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Transit agency
                        Text(
                          'Transit Agency',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kFcInk,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _agencyValue,
                          items: _agencies
                              .map(
                                (a) => DropdownMenuItem<String>(
                                  value: a,
                                  child: Row(
                                    children: [
                                      AgencyLogoWidget(agencyId: a, size: 32),
                                      const SizedBox(width: 12),
                                      Text(
                                        a,
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _agencyValue = v),
                          decoration: InputDecoration(
                            hintText: 'VTA',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: kFcSubtle,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kFcLine,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kFcPrimary,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: kFcSurface,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                          ),
                          dropdownColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Big, friendly button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  height: 64,
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: kFcInk.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _verifyAndRequest,
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Text(
                          'Get My Free Pass',
                          style: fcHeadline(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Help section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kFcSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kFcLine, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: kFcInk, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Need Help?',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kFcInk,
                              ),
                            ),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () async {
                                await launchUrl(
                                  Uri(scheme: 'tel', path: '6693882909'),
                                );
                              },
                              child: Text(
                                'Call us: (669) 388-2909',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: kFcInk,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
