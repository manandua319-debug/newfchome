import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class JournalEntriesRecord extends FirestoreRecord {
  JournalEntriesRecord._(DocumentReference reference, Map<String, dynamic> data)
    : super(reference, data) {
    _initializeFields();
  }

  // "mood" field.
  String? _mood;
  String get mood => _mood ?? '';
  bool hasMood() => _mood != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "userRef" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  bool hasContent() => _content != null;

  void _initializeFields() {
    _mood = snapshotData['mood'] as String?;
    _type = snapshotData['type'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _userRef = snapshotData['userRef'] as DocumentReference?;
    _content = snapshotData['content'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('journalEntries');

  static Stream<JournalEntriesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => JournalEntriesRecord.fromSnapshot(s));

  static Future<JournalEntriesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => JournalEntriesRecord.fromSnapshot(s));

  static JournalEntriesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      JournalEntriesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static JournalEntriesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) => JournalEntriesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'JournalEntriesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is JournalEntriesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createJournalEntriesRecordData({
  String? mood,
  String? type,
  DateTime? createdAt,
  DocumentReference? userRef,
  String? content,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'mood': mood,
      'type': type,
      'createdAt': createdAt,
      'userRef': userRef,
      'content': content,
    }.withoutNulls,
  );

  return firestoreData;
}

class JournalEntriesRecordDocumentEquality
    implements Equality<JournalEntriesRecord> {
  const JournalEntriesRecordDocumentEquality();

  @override
  bool equals(JournalEntriesRecord? e1, JournalEntriesRecord? e2) {
    return e1?.mood == e2?.mood &&
        e1?.type == e2?.type &&
        e1?.createdAt == e2?.createdAt &&
        e1?.userRef == e2?.userRef &&
        e1?.content == e2?.content;
  }

  @override
  int hash(JournalEntriesRecord? e) => const ListEquality().hash([
    e?.mood,
    e?.type,
    e?.createdAt,
    e?.userRef,
    e?.content,
  ]);

  @override
  bool isValidKey(Object? o) => o is JournalEntriesRecord;
}
