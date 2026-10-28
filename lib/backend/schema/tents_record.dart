import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TentsRecord extends FirestoreRecord {
  TentsRecord._(DocumentReference reference, Map<String, dynamic> data)
    : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  bool hasPhone() => _phone != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _address = snapshotData['address'] as String?;
    _phone = snapshotData['phone'] as String?;
    _location = snapshotData['location'] as LatLng?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('tents');

  static Stream<TentsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TentsRecord.fromSnapshot(s));

  static Future<TentsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TentsRecord.fromSnapshot(s));

  static TentsRecord fromSnapshot(DocumentSnapshot snapshot) => TentsRecord._(
    snapshot.reference,
    mapFromFirestore(snapshot.data() as Map<String, dynamic>),
  );

  static TentsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) => TentsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TentsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TentsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTentsRecordData({
  String? name,
  String? address,
  String? phone,
  LatLng? location,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'address': address,
      'phone': phone,
      'location': location,
    }.withoutNulls,
  );

  return firestoreData;
}

class TentsRecordDocumentEquality implements Equality<TentsRecord> {
  const TentsRecordDocumentEquality();

  @override
  bool equals(TentsRecord? e1, TentsRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.address == e2?.address &&
        e1?.phone == e2?.phone &&
        e1?.location == e2?.location;
  }

  @override
  int hash(TentsRecord? e) =>
      const ListEquality().hash([e?.name, e?.address, e?.phone, e?.location]);

  @override
  bool isValidKey(Object? o) => o is TentsRecord;
}
