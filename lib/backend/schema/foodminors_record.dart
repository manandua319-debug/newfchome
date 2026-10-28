import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FoodminorsRecord extends FirestoreRecord {
  FoodminorsRecord._(DocumentReference reference, Map<String, dynamic> data)
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
      FirebaseFirestore.instance.collection('foodminors');

  static Stream<FoodminorsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FoodminorsRecord.fromSnapshot(s));

  static Future<FoodminorsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FoodminorsRecord.fromSnapshot(s));

  static FoodminorsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FoodminorsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FoodminorsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) => FoodminorsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FoodminorsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FoodminorsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFoodminorsRecordData({
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

class FoodminorsRecordDocumentEquality implements Equality<FoodminorsRecord> {
  const FoodminorsRecordDocumentEquality();

  @override
  bool equals(FoodminorsRecord? e1, FoodminorsRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.phone == e2?.phone &&
        e1?.location == e2?.location &&
        e1?.address == e2?.address;
  }

  @override
  int hash(FoodminorsRecord? e) =>
      const ListEquality().hash([e?.name, e?.phone, e?.location, e?.address]);

  @override
  bool isValidKey(Object? o) => o is FoodminorsRecord;
}
