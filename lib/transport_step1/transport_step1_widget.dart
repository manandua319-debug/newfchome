import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/app_state.dart';
import '/index.dart';
import '/services/transit_service.dart';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'transport_step1_model.dart';
import 'trip_plan_view.dart';
export 'transport_step1_model.dart';

/// Trip plan for the chosen place: walk to the nearest stop, which bus or
/// train to take and when, where to get off, and the last walk. The pass
/// buttons open the request form with the right agency already selected.
class TransportStep1Widget extends StatefulWidget {
  const TransportStep1Widget({super.key});

  static String routeName = 'TransportStep1';
  static String routePath = '/transportStep1';

  @override
  State<TransportStep1Widget> createState() => _TransportStep1WidgetState();
}

class _TransportStep1WidgetState extends State<TransportStep1Widget> {
  late TransportStep1Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _originController = TextEditingController();

  TripPlan? _plan;
  TransitException? _error;
  bool _loading = true;

  // Dynamic destination from app state, fallback to default
  String get destinationTitle =>
      FFAppState().selectedDestinationName ??
      'Bill Wilson Center - Safety Net Shelter';
  String get destinationAddr =>
      FFAppState().selectedDestinationAddress ??
      '3490 The Alameda, Santa Clara, CA 95050';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransportStep1Model());
    _load();
  }

  @override
  void dispose() {
    _originController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _load({String? origin}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final plan = await TransitService.plan(
        destinationAddress: destinationAddr,
        destinationName: destinationTitle,
        originAddress: origin,
      );
      if (!mounted) return;
      setState(() {
        _plan = plan;
        _loading = false;
      });
    } on TransitException catch (e) {
      if (!mounted) return;
      setState(() {
        _plan = null;
        _error = e;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _plan = null;
        _error = TransitException(
          TransitErrorKind.network,
          "Couldn't get bus directions right now.",
        );
        _loading = false;
      });
    }
  }

  void _requestPass(String? agency) {
    context.pushNamed(
      TransportS2Widget.routeName,
      queryParameters: {
        if (agency != null) 'agency': agency,
        if (_plan != null) 'trip': _plan!.summary,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 20.0,
            buttonSize: 40.0,
            fillColor: Colors.transparent,
            icon: Icon(Icons.arrow_back, color: theme.primaryText, size: 26.0),
            onPressed: () async => context.safePop(),
          ),
          title: Text(
            'Getting There',
            style: GoogleFonts.inter(
              color: theme.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Refresh Times',
              onPressed: _loading ? null : () => _load(),
              icon: Icon(Icons.refresh_rounded, color: theme.primaryText),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: _destinationCard(theme),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: _body(theme),
                ),
              ),
              _actions(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _destinationCard(FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: theme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destinationTitle,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  destinationAddr,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: theme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(FlutterFlowTheme theme) {
    if (_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 56),
        child: Column(
          children: [
            CircularProgressIndicator(color: theme.primary),
            const SizedBox(height: 16),
            Text(
              'Finding the closest stop and the next bus...',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: theme.secondaryText,
              ),
            ),
          ],
        ),
      );
    }
    if (_error != null) return _errorView(theme, _error!);

    final plan = _plan!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TripPlanView(plan: plan),
        if (plan.uncoveredAgencies.isNotEmpty) ...[
          const SizedBox(height: 20),
          _notice(
            theme,
            Icons.info_outline_rounded,
            '${plan.uncoveredAgencies.join(' and ')} is not covered by our '
            'free passes. Call the shelter and they can help you find another '
            'way.',
          ),
        ],
        if (plan.walkOnly) ...[
          const SizedBox(height: 20),
          _notice(
            theme,
            Icons.directions_walk_rounded,
            "It's close enough to walk, so you don't need a pass.",
          ),
        ],
      ],
    );
  }

  Widget _errorView(FlutterFlowTheme theme, TransitException e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _notice(theme, Icons.directions_bus_outlined, e.message),
        if (e.kind == TransitErrorKind.noLocation ||
            e.kind == TransitErrorKind.noRoute) ...[
          const SizedBox(height: 16),
          Text(
            'Where are you starting from?',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _originController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.search,
            onSubmitted: (v) => _load(origin: v),
            style: GoogleFonts.inter(fontSize: 16, color: theme.primaryText),
            decoration: InputDecoration(
              hintText: 'Street address or nearest cross streets',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                color: theme.secondaryText.withOpacity(0.6),
              ),
              filled: true,
              fillColor: theme.secondaryBackground,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.alternate),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _button(
            theme,
            label: 'Get Directions',
            icon: Icons.directions_rounded,
            primary: true,
            onTap: () => _load(origin: _originController.text),
          ),
        ] else
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _button(
              theme,
              label: 'Try Again',
              icon: Icons.refresh_rounded,
              onTap: () => _load(),
            ),
          ),
      ],
    );
  }

  Widget _notice(FlutterFlowTheme theme, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kFcTint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: theme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 1.4,
                color: theme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Pinned buttons: a pass per agency on the trip, then the always-there
  /// options. A pass is only offered when the trip actually uses a covered
  /// agency (or when we have no route at all, so nobody is stuck).
  Widget _actions(FlutterFlowTheme theme) {
    final plan = _plan;
    final agencies = plan?.passAgencies ?? const <String>[];
    final canRequestBlind = !_loading && plan == null;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(top: BorderSide(color: theme.alternate)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (agencies.isNotEmpty)
            for (var i = 0; i < agencies.length; i++) ...[
              _button(
                theme,
                label: 'Request ${agencies[i]} Pass',
                icon: Icons.confirmation_number_outlined,
                primary: i == 0,
                onTap: () => _requestPass(agencies[i]),
              ),
              const SizedBox(height: 10),
            ]
          else if (canRequestBlind) ...[
            _button(
              theme,
              label: 'Request Pass',
              icon: Icons.confirmation_number_outlined,
              primary: true,
              onTap: () => _requestPass(null),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(
                child: _button(
                  theme,
                  label: 'My Passes',
                  icon: Icons.receipt_long_outlined,
                  onTap: () => context.pushNamed('PassStatus'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _button(
                  theme,
                  label: 'Call Shelter',
                  icon: Icons.call_outlined,
                  onTap: () async {
                    await launchUrl(Uri(scheme: 'tel', path: '4082558033'));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _button(
    FlutterFlowTheme theme, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool primary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Material(
        color: primary ? theme.primary : theme.secondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: primary ? BorderSide.none : BorderSide(color: theme.alternate),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: primary ? Colors.white : theme.secondaryText,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primary ? Colors.white : theme.primaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
