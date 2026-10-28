import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TentsminorsRecord extends FirestoreRecord {
  TentsminorsRecord._(DocumentReference reference, Map<String, dynamic> data)
    : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  bool hasPhone() => _phone != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _location = snapshotData['location'] as LatLng?;
    _phone = snapshotData['phone'] as String?;
    _address = snapshotData['address'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('tentsminors');

  static Stream<TentsminorsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TentsminorsRecord.fromSnapshot(s));

  static Future<TentsminorsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TentsminorsRecord.fromSnapshot(s));

  static TentsminorsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TentsminorsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TentsminorsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) => TentsminorsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TentsminorsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TentsminorsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTentsminorsRecordData({
  String? name,
  LatLng? location,
  String? phone,
  String? address,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'location': location,
      'phone': phone,
      'address': address,
    }.withoutNulls,
  );

  return firestoreData;
}

class TentsminorsRecordDocumentEquality implements Equality<TentsminorsRecord> {
  const TentsminorsRecordDocumentEquality();

  @override
  bool equals(TentsminorsRecord? e1, TentsminorsRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.location == e2?.location &&
        e1?.phone == e2?.phone &&
        e1?.address == e2?.address;
  }

  @override
  int hash(TentsminorsRecord? e) =>
      const ListEquality().hash([e?.name, e?.location, e?.phone, e?.address]);

  @override
  bool isValidKey(Object? o) => o is TentsminorsRecord;
}
