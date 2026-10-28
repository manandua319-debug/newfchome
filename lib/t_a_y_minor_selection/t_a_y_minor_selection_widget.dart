import '/auth/firebase_auth/auth_util.dart'; // ✅ added
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 't_a_y_minor_selection_model.dart';
export 't_a_y_minor_selection_model.dart';

class TAYMinorSelectionWidget extends StatefulWidget {
  const TAYMinorSelectionWidget({super.key});

  static String routeName = 'TAYMinorSelection';
  static String routePath = '/tAYMinorSelection';

  @override
  State<TAYMinorSelectionWidget> createState() =>
      _TAYMinorSelectionWidgetState();
}

class _TAYMinorSelectionWidgetState extends State<TAYMinorSelectionWidget> {
  late TAYMinorSelectionModel _model;
  String? _choice; // 'tay' or 'minors'

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TAYMinorSelectionModel());

    // ✅ Ensure a Firebase user exists (anonymous if needed)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (currentUserUid.isEmpty) {
        await authManager.signInAnonymously(context);
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ✅ Helper to guarantee sign-in right before navigating
  Future<void> _ensureSignedIn() async {
    if (currentUserUid.isEmpty) {
      await authManager.signInAnonymously(context);
    }
  }

  Future<void> _continue() async {
    if (_choice == null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Pick an age group first.',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
            ),
            backgroundColor: kFcInk,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }
    await _ensureSignedIn();
    if (!mounted) return;
    if (_choice == 'tay') {
      context.pushNamed('MainPageTAY');
    } else {
      context.pushNamed(MainPageMinorsWidget.routeName);
    }
  }

  /// Large selectable card: icon, age range and group name. The selected
  /// card gets a navy outline and a check, like a radio option.
  Widget _option({
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final selected = _choice == value;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      label: '$title, $subtitle',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected
              ? theme.primary.withOpacity(0.05)
              : theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? theme.primary : theme.alternate,
            width: selected ? 2 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _choice = value),
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned(
                  top: 14,
                  right: 14,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? theme.primary : Colors.transparent,
                      border: Border.all(
                        color: selected ? theme.primary : theme.alternate,
                        width: 1.5,
                      ),
                    ),
                    child: selected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 36, color: theme.primary),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: fcHeadline(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: theme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: FlutterFlowIconButton(
          borderRadius: 20,
          buttonSize: 40,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.primaryText,
            size: 24,
          ),
          onPressed: () async => context.goNamed(SignInUpWidget.routeName),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Tooltip(
              message: 'Staff Dashboard',
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 20,
                buttonSize: 40,
                fillColor: Colors.transparent,
                icon: Icon(
                  Icons.admin_panel_settings_outlined,
                  color: theme.secondaryText,
                  size: 22,
                ),
                onPressed: () => context.pushNamed('AdminDashboard'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Who Is This For?',
                style: fcHeadline(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                  color: theme.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pick an age group to see the resources that fit.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  height: 1.4,
                  color: theme.secondaryText,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _option(
                        value: 'tay',
                        icon: Icons.group_rounded,
                        title: 'Ages 18–24',
                        subtitle: 'Transition Age Youth (TAY)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _option(
                        value: 'minors',
                        icon: Icons.child_care_rounded,
                        title: 'Ages 12–17',
                        subtitle: 'Youth Services for Minors',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Material(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: _continue,
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ],
                    ),
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
