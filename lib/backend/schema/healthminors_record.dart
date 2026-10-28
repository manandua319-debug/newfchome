import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HealthminorsRecord extends FirestoreRecord {
  HealthminorsRecord._(DocumentReference reference, Map<String, dynamic> data)
    : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  bool hasPhone() => _phone != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _phone = snapshotData['phone'] as String?;
    _location = snapshotData['location'] as LatLng?;
    _address = snapshotData['address'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('healthminors');

  static Stream<HealthminorsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HealthminorsRecord.fromSnapshot(s));

  static Future<HealthminorsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => HealthminorsRecord.fromSnapshot(s));

  static HealthminorsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      HealthminorsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HealthminorsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) => HealthminorsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HealthminorsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HealthminorsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHealthminorsRecordData({
  String? name,
  String? phone,
  LatLng? location,
  String? address,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'phone': phone,
      'location': location,
      'address': address,
    }.withoutNulls,
  );

  return firestoreData;
}

class HealthminorsRecordDocumentEquality
    implements Equality<HealthminorsRecord> {
  const HealthminorsRecordDocumentEquality();

  @override
  bool equals(HealthminorsRecord? e1, HealthminorsRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.phone == e2?.phone &&
        e1?.location == e2?.location &&
        e1?.address == e2?.address;
  }

  @override
  int hash(HealthminorsRecord? e) =>
      const ListEquality().hash([e?.name, e?.phone, e?.location, e?.address]);

  @override
  bool isValidKey(Object? o) => o is HealthminorsRecord;
}
