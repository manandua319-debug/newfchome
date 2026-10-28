import 'package:cloud_firestore/cloud_firestore.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';

/// Reads and writes journal entries and daily mood check-ins.
///
/// A mood check-in is one document per user per day, so changing your mind
/// updates today's mood instead of adding a duplicate. Journal entries are a
/// new document each time.
class JournalService {
  static String _dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static DocumentReference _moodDoc() => JournalEntriesRecord.collection.doc(
    '${currentUserUid}_mood_${_dayKey(DateTime.now())}',
  );

  static void _requireUser() {
    if (currentUserReference == null) {
      throw StateError('Not signed in');
    }
  }

  /// Today's saved mood ('sad', 'ok' or 'good'), or null if none yet.
  static Future<String?> todaysMood() async {
    if (currentUserReference == null) return null;
    final snap = await _moodDoc().get();
    final data = snap.data() as Map<String, dynamic>?;
    final mood = data?['mood'] as String?;
    return (mood == null || mood.isEmpty) ? null : mood;
  }

  static Future<void> saveMood(String mood) async {
    _requireUser();
    await _moodDoc().set({
      ...createJournalEntriesRecordData(
        mood: mood,
        type: 'mood',
        userRef: currentUserReference,
      ),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> saveEntry(String text) async {
    _requireUser();
    await JournalEntriesRecord.collection.doc().set({
      ...createJournalEntriesRecordData(
        type: 'entry',
        userRef: currentUserReference,
        content: text.trim(),
      ),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Newest-first stream of the signed-in user's entries and moods.
  static Stream<List<JournalEntriesRecord>> myEntries() =>
      queryJournalEntriesRecord(
        queryBuilder: (q) => q
            .where('userRef', isEqualTo: currentUserReference)
            .orderBy('createdAt', descending: true),
      );
}
