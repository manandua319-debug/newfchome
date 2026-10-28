import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MoodLogsRecord extends FirestoreRecord {
  MoodLogsRecord._(DocumentReference reference, Map<String, dynamic> data)
    : super(reference, data) {
    _initializeFields();
  }

  // "mood" field.
  String? _mood;
  String get mood => _mood ?? '';
  bool hasMood() => _mood != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "userRef" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  void _initializeFields() {
    _mood = snapshotData['mood'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _userRef = snapshotData['userRef'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('moodLogs');

  static Stream<MoodLogsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MoodLogsRecord.fromSnapshot(s));

  static Future<MoodLogsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MoodLogsRecord.fromSnapshot(s));

  static MoodLogsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MoodLogsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MoodLogsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) => MoodLogsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MoodLogsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MoodLogsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMoodLogsRecordData({
  String? mood,
  DateTime? createdAt,
  DocumentReference? userRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'mood': mood,
      'createdAt': createdAt,
      'userRef': userRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class MoodLogsRecordDocumentEquality implements Equality<MoodLogsRecord> {
  const MoodLogsRecordDocumentEquality();

  @override
  bool equals(MoodLogsRecord? e1, MoodLogsRecord? e2) {
    return e1?.mood == e2?.mood &&
        e1?.createdAt == e2?.createdAt &&
        e1?.userRef == e2?.userRef;
  }

  @override
  int hash(MoodLogsRecord? e) =>
      const ListEquality().hash([e?.mood, e?.createdAt, e?.userRef]);

  @override
  bool isValidKey(Object? o) => o is MoodLogsRecord;
}
