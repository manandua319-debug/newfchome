import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/services/journal_service.dart';
import '/ui/fc_ui.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page_minors_model.dart';
export 'main_page_minors_model.dart';

class MainPageMinorsWidget extends StatefulWidget {
  const MainPageMinorsWidget({super.key});

  static String routeName = 'MainPageMinors';
  static String routePath = '/mainPageMinors';

  @override
  State<MainPageMinorsWidget> createState() => _MainPageMinorsWidgetState();
}

class _MainPageMinorsWidgetState extends State<MainPageMinorsWidget> {
  late MainPageMinorsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  static final String _selectionRoute = TAYMinorSelectionWidget.routeName;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainPageMinorsModel());

    _model.textController ??= TextEditingController(
      text: valueOrDefault<String>(
        _model.journalEntry,
        'Write your entry here…',
      ),
    );
    _model.textFieldFocusNode ??= FocusNode();
    JournalService.todaysMood()
        .then((m) {
          if (mounted && m != null) safeSetState(() => _model.mood = m);
        })
        .catchError((_) {});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _heroHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: fcHeadline(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              height: 1.15,
              color: theme.primaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 1.4,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  String _tileHint(String label) {
    switch (label) {
      case 'Shelters':
        return 'Safe places to stay nearby';
      case 'Health':
        return 'Clinics and care';
      case 'Food':
        return 'Meals and pantries';
      default:
        return 'Supplies and tents';
    }
  }

  Widget _actionCard({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return FcResourceCard(
      title: label,
      subtitle: _tileHint(label),
      icon: icon,
      color: color,
      onTap: onTap,
      index: const ['Shelters', 'Health', 'Food', 'Supplies'].indexOf(label),
    );
  }

  Widget _buildMoodCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kFcLine, width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'How Are You Feeling Today?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kFcInk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _mood(context, '😢', 'sad'),
              _mood(context, '😐', 'ok'),
              _mood(context, '😊', 'good'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJournalCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kFcLine, width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Daily Journal',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kFcInk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _journalField(context),
          const SizedBox(height: 12),
          _saveEntryButton(context),
          const SizedBox(height: 6),
          Center(
            child: TextButton(
              onPressed: () =>
                  context.pushNamed(JournalResponsesWidget.routeName),
              child: Text(
                'View Past Entries',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
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
        bottomNavigationBar: const FcAudienceNav(minors: true, current: 0),
        body: WillPopScope(
          onWillPop: () async {
            context.goNamed(_selectionRoute);
            return false;
          },
          child: SafeArea(
            top: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => context.goNamed(_selectionRoute),
                          borderRadius: BorderRadius.circular(10),
                          canRequestFocus: false,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: theme.primaryText,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(12),
                              canRequestFocus: false,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: theme.secondaryBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: theme.alternate),
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Hero Header with gradient
                  _heroHeader(
                    context,
                    title: currentUserDisplayName.isNotEmpty
                        ? 'Hi, ${currentUserDisplayName.split(' ').first}'
                        : 'Welcome',
                    subtitle:
                        "Shelter, food, health care and supplies near you.",
                  ),

                  const SizedBox(height: 20),

                  // Action Cards
                  _actionCard(
                    label: 'Shelters',
                    icon: Icons.night_shelter_outlined,
                    color: const Color(0xFF6C63FF),
                    onTap: () =>
                        context.pushNamed(SheltersMinorsWidget.routeName),
                  ),
                  const SizedBox(height: 12),
                  _actionCard(
                    label: 'Health',
                    icon: Icons.health_and_safety_outlined,
                    color: const Color(0xFFFF7A7A),
                    onTap: () =>
                        context.pushNamed(HealthMinorsWidget.routeName),
                  ),
                  const SizedBox(height: 12),
                  _actionCard(
                    label: 'Food',
                    icon: Icons.restaurant_outlined,
                    color: const Color(0xFF00C2A8),
                    onTap: () => context.pushNamed(FoodMinorsWidget.routeName),
                  ),
                  const SizedBox(height: 12),
                  _actionCard(
                    label: 'Supplies',
                    icon: Icons.support_outlined,
                    color: const Color(0xFFF7D154),
                    onTap: () => context.pushNamed(TentsMinorsWidget.routeName),
                  ),

                  const SizedBox(height: 20),

                  // Mood card
                  _buildMoodCard(context),

                  const SizedBox(height: 20),

                  // Journal card
                  _buildJournalCard(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mood(BuildContext context, String emoji, String value) {
    final theme = FlutterFlowTheme.of(context);
    final selected = _model.mood == value;
    final Color bgColor = value == 'sad'
        ? const Color(0xFFE0E7FF)
        : value == 'ok'
        ? const Color(0xFFFFF3CD)
        : const Color(0xFFDFFFE2);
    final label = value == 'ok'
        ? 'Okay'
        : value[0].toUpperCase() + value.substring(1);

    return Column(
      children: [
        Semantics(
          button: true,
          selected: selected,
          label: 'Feeling $label',
          child: InkWell(
            onTap: () => _setMood(value),
            borderRadius: BorderRadius.circular(32),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? theme.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Icon(
                value == 'sad'
                    ? Icons.sentiment_dissatisfied_outlined
                    : value == 'ok'
                    ? Icons.sentiment_neutral_outlined
                    : Icons.sentiment_satisfied_alt_outlined,
                size: 32,
                color: kFcInk,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? theme.primary : theme.secondaryText,
          ),
        ),
      ],
    );
  }

  void _toast(String message, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
          ),
          duration: const Duration(milliseconds: 2500),
          backgroundColor: error ? kFcDanger : kFcInk,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _setMood(String value) async {
    final previous = _model.mood;
    if (previous == value) return;
    safeSetState(() => _model.mood = value);
    try {
      await JournalService.saveMood(value);
      if (mounted) _toast('Mood Saved');
    } catch (_) {
      if (!mounted) return;
      safeSetState(() => _model.mood = previous);
      _toast("Couldn't save your mood. Try again.", error: true);
    }
  }

  bool _saving = false;

  Future<void> _saveJournalEntry() async {
    if (_saving) return;
    final text = _model.textController.text.trim();
    if (text.isEmpty) {
      _toast('Write something first');
      return;
    }
    safeSetState(() => _saving = true);
    try {
      await JournalService.saveEntry(text);
      if (!mounted) return;
      _model.textController?.clear();
      _toast('Entry Saved');
    } catch (_) {
      if (mounted) _toast("Couldn't save your entry. Try again.", error: true);
    } finally {
      if (mounted) safeSetState(() => _saving = false);
    }
  }

  Widget _journalField(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return TextFormField(
      controller: _model.textController,
      focusNode: _model.textFieldFocusNode,
      autofocus: false,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText:
            "Share your thoughts, feelings, or what's on your mind today...",
        hintStyle: theme.bodyMedium.override(
          font: GoogleFonts.inter(
            fontWeight: theme.bodyMedium.fontWeight,
            fontStyle: theme.bodyMedium.fontStyle,
          ),
          color: theme.secondaryText,
          letterSpacing: 0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.alternate, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primary, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.error, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.error, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: theme.primaryBackground,
        contentPadding: const EdgeInsets.all(16),
      ),
      style: theme.bodyMedium.override(
        font: GoogleFonts.inter(
          fontWeight: theme.bodyMedium.fontWeight,
          fontStyle: theme.bodyMedium.fontStyle,
        ),
        fontSize: 16,
        letterSpacing: 0,
        lineHeight: 1.5,
      ),
      maxLines: 6,
      minLines: 4,
      keyboardType: TextInputType.multiline,
      cursorColor: theme.primary,
      validator: _model.textControllerValidator.asValidator(context),
      inputFormatters: [
        if (!isAndroid && !isiOS)
          TextInputFormatter.withFunction((oldValue, newValue) {
            return TextEditingValue(
              selection: newValue.selection,
              text: newValue.text.toCapitalization(
                TextCapitalization.sentences,
              ),
            );
          }),
      ],
    );
  }

  Widget _saveEntryButton(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return FFButtonWidget(
      onPressed: _saveJournalEntry,
      text: _saving ? 'Saving...' : 'Save Entry',
      options: FFButtonOptions(
        width: double.infinity,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: theme.primary,
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: theme.info,
        ),
        elevation: 0,
        borderRadius: BorderRadius.circular(12),
      ),
      showLoadingIndicator: false,
    );
  }
}
