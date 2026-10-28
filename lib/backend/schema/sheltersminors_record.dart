import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SheltersminorsRecord extends FirestoreRecord {
  SheltersminorsRecord._(DocumentReference reference, Map<String, dynamic> data)
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

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  bool hasPhone() => _phone != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _location = snapshotData['location'] as LatLng?;
    _address = snapshotData['address'] as String?;
    _phone = snapshotData['phone'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('sheltersminors');

  static Stream<SheltersminorsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SheltersminorsRecord.fromSnapshot(s));

  static Future<SheltersminorsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SheltersminorsRecord.fromSnapshot(s));

  static SheltersminorsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SheltersminorsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SheltersminorsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) => SheltersminorsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SheltersminorsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SheltersminorsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSheltersminorsRecordData({
  String? name,
  LatLng? location,
  String? address,
  String? phone,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'location': location,
      'address': address,
      'phone': phone,
    }.withoutNulls,
  );

  return firestoreData;
}

class SheltersminorsRecordDocumentEquality
    implements Equality<SheltersminorsRecord> {
  const SheltersminorsRecordDocumentEquality();

  @override
  bool equals(SheltersminorsRecord? e1, SheltersminorsRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.location == e2?.location &&
        e1?.address == e2?.address &&
        e1?.phone == e2?.phone;
  }

  @override
  int hash(SheltersminorsRecord? e) =>
      const ListEquality().hash([e?.name, e?.location, e?.address, e?.phone]);

  @override
  bool isValidKey(Object? o) => o is SheltersminorsRecord;
}
