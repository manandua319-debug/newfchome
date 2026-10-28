import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/journal_service.dart';
import 'journal_responses_model.dart';
export 'journal_responses_model.dart';

/// Day-by-day history of the signed-in user's journal entries and mood
/// check-ins, read live from Firestore.
class JournalResponsesWidget extends StatefulWidget {
  const JournalResponsesWidget({super.key});

  static String routeName = 'JournalResponses';
  static String routePath = '/journalResponses';

  @override
  State<JournalResponsesWidget> createState() => _JournalResponsesWidgetState();
}

class _JournalResponsesWidgetState extends State<JournalResponsesWidget> {
  late JournalResponsesModel _model;
  late final Stream<List<JournalEntriesRecord>> _entries;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => JournalResponsesModel());
    _entries = JournalService.myEntries();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  String _dayLabel(DateTime day) {
    final today = _day(DateTime.now());
    final diff = today.difference(day).inDays;
    final date = DateFormat('MMM d').format(day);
    if (diff == 0) return 'Today, $date';
    if (diff == 1) return 'Yesterday, $date';
    return DateFormat('EEEE, MMM d').format(day);
  }

  String _moodLabel(String mood) {
    switch (mood) {
      case 'sad':
        return 'Sad';
      case 'ok':
        return 'Okay';
      case 'good':
        return 'Good';
      default:
        return mood;
    }
  }

  IconData _moodIcon(String mood) {
    switch (mood) {
      case 'sad':
        return Icons.sentiment_dissatisfied_outlined;
      case 'ok':
        return Icons.sentiment_neutral_outlined;
      default:
        return Icons.sentiment_satisfied_alt_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 8,
          buttonSize: 40,
          fillColor: Colors.transparent,
          icon: Icon(Icons.arrow_back, color: theme.primaryText, size: 24),
          onPressed: () async => context.safePop(),
        ),
        title: Text(
          'Journal History',
          style: fcHeadline(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: theme.primaryText,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<JournalEntriesRecord>>(
          stream: _entries,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _message(
                theme,
                "Couldn't load your journal",
                'Check your connection and try again.',
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: theme.primary),
              );
            }
            final entries = snapshot.data!;
            if (entries.isEmpty) {
              return _message(
                theme,
                'Your journal is empty',
                'Write an entry or check in with your mood on the home screen. It will show up here.',
              );
            }

            final byDay = <DateTime, List<JournalEntriesRecord>>{};
            for (final e in entries) {
              byDay
                  .putIfAbsent(_day(e.createdAt ?? DateTime.now()), () => [])
                  .add(e);
            }
            final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a));

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, i) =>
                  _dayCard(theme, days[i], byDay[days[i]]!),
            );
          },
        ),
      ),
    );
  }

  Widget _message(FlutterFlowTheme theme, String title, String body) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.primaryText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayCard(
    FlutterFlowTheme theme,
    DateTime day,
    List<JournalEntriesRecord> items,
  ) {
    final moods = items.where((e) => e.type == 'mood').toList();
    final notes = items.where((e) => e.type == 'entry').toList();
    final summary = [
      if (notes.isNotEmpty)
        '${notes.length} ${notes.length == 1 ? 'entry' : 'entries'}',
      if (moods.isNotEmpty) 'mood: ${_moodLabel(moods.first.mood)}',
    ].join(' · ');

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _dayLabel(day),
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.primaryText,
            ),
          ),
          if (summary.isNotEmpty)
            Text(
              summary,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: theme.secondaryText,
              ),
            ),
          const SizedBox(height: 12),
          for (final m in moods)
            _row(
              theme,
              icon: _moodIcon(m.mood),
              label: 'Mood Check-In',
              body: _moodLabel(m.mood),
              time: m.createdAt,
            ),
          for (final n in notes)
            _row(
              theme,
              icon: Icons.edit_note_rounded,
              label: 'Entry',
              body: n.content,
              time: n.createdAt,
            ),
        ],
      ),
    );
  }

  Widget _row(
    FlutterFlowTheme theme, {
    required IconData icon,
    required String label,
    required String body,
    DateTime? time,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.secondaryText,
                        ),
                      ),
                    ),
                    if (time != null)
                      Text(
                        DateFormat('h:mm a').format(time),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: theme.secondaryText,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    height: 1.4,
                    color: theme.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
