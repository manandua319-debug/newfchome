import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HealthRecord extends FirestoreRecord {
  HealthRecord._(DocumentReference reference, Map<String, dynamic> data)
    : super(reference, data) {
    _initializeFields();
  }

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  bool hasPhone() => _phone != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  void _initializeFields() {
    _phone = snapshotData['phone'] as String?;
    _location = snapshotData['location'] as LatLng?;
    _name = snapshotData['name'] as String?;
    _address = snapshotData['address'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('health');

  static Stream<HealthRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HealthRecord.fromSnapshot(s));

  static Future<HealthRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => HealthRecord.fromSnapshot(s));

  static HealthRecord fromSnapshot(DocumentSnapshot snapshot) => HealthRecord._(
    snapshot.reference,
    mapFromFirestore(snapshot.data() as Map<String, dynamic>),
  );

  static HealthRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) => HealthRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HealthRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HealthRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHealthRecordData({
  String? phone,
  LatLng? location,
  String? name,
  String? address,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'phone': phone,
      'location': location,
      'name': name,
      'address': address,
    }.withoutNulls,
  );

  return firestoreData;
}

class HealthRecordDocumentEquality implements Equality<HealthRecord> {
  const HealthRecordDocumentEquality();

  @override
  bool equals(HealthRecord? e1, HealthRecord? e2) {
    return e1?.phone == e2?.phone &&
        e1?.location == e2?.location &&
        e1?.name == e2?.name &&
        e1?.address == e2?.address;
  }

  @override
  int hash(HealthRecord? e) =>
      const ListEquality().hash([e?.phone, e?.location, e?.name, e?.address]);

  @override
  bool isValidKey(Object? o) => o is HealthRecord;
}
