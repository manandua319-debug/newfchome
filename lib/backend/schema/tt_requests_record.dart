import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TtRequestsRecord extends FirestoreRecord {
  TtRequestsRecord._(DocumentReference reference, Map<String, dynamic> data)
    : super(reference, data) {
    _initializeFields();
  }

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  bool hasPhone() => _phone != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "phoneDigits" field.
  String? _phoneDigits;
  String get phoneDigits => _phoneDigits ?? '';
  bool hasPhoneDigits() => _phoneDigits != null;

  // "agencyId" field.
  String? _agencyId;
  String get agencyId => _agencyId ?? '';
  bool hasAgencyId() => _agencyId != null;

  // "destination" field.
  String? _destination;
  String get destination => _destination ?? '';
  bool hasDestination() => _destination != null;

  // "fareLabel" field.
  String? _fareLabel;
  String get fareLabel => _fareLabel ?? '';
  bool hasFareLabel() => _fareLabel != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "purchasedAt" field.
  DateTime? _purchasedAt;
  DateTime? get purchasedAt => _purchasedAt;
  bool hasPurchasedAt() => _purchasedAt != null;

  // "sentAt" field.
  DateTime? _sentAt;
  DateTime? get sentAt => _sentAt;
  bool hasSentAt() => _sentAt != null;

  // "approvedAt" field.
  DateTime? _approvedAt;
  DateTime? get approvedAt => _approvedAt;
  bool hasApprovedAt() => _approvedAt != null;

  // "closedAt" field.
  DateTime? _closedAt;
  DateTime? get closedAt => _closedAt;
  bool hasClosedAt() => _closedAt != null;

  // "purchaseAmount" field.
  double? _purchaseAmount;
  double get purchaseAmount => _purchaseAmount ?? 0.0;
  bool hasPurchaseAmount() => _purchaseAmount != null;

  // "actualProduct" field.
  String? _actualProduct;
  String get actualProduct => _actualProduct ?? '';
  bool hasActualProduct() => _actualProduct != null;

  // "fulfilledBy" field.
  String? _fulfilledBy;
  String get fulfilledBy => _fulfilledBy ?? '';
  bool hasFulfilledBy() => _fulfilledBy != null;

  // "staffNotes" field.
  String? _staffNotes;
  String get staffNotes => _staffNotes ?? '';
  bool hasStaffNotes() => _staffNotes != null;

  // "adminNote" field.
  String? _adminNote;
  String get adminNote => _adminNote ?? '';
  bool hasAdminNote() => _adminNote != null;

  // "redemptionUrl" field.
  String? _redemptionUrl;
  String get redemptionUrl => _redemptionUrl ?? '';
  bool hasRedemptionUrl() => _redemptionUrl != null;

  // "issuedAt" field.
  DateTime? _issuedAt;
  DateTime? get issuedAt => _issuedAt;
  bool hasIssuedAt() => _issuedAt != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "age" field.
  int? _age;
  int get age => _age ?? 0;
  bool hasAge() => _age != null;

  // "agedOut" field (month/year the person aged out of care).
  String? _agedOut;
  String get agedOut => _agedOut ?? '';
  bool hasAgedOut() => _agedOut != null;

  // "startLocation" field.
  String? _startLocation;
  String get startLocation => _startLocation ?? '';
  bool hasStartLocation() => _startLocation != null;

  // "tripPlan" field (planned bus/train route saved with the request).
  String? _tripPlan;
  String get tripPlan => _tripPlan ?? '';
  bool hasTripPlan() => _tripPlan != null;

  void _initializeFields() {
    _uid = snapshotData['uid'] as String?;
    _phone = snapshotData['phone'] as String?;
    _email = snapshotData['email'] as String?;
    _phoneDigits = snapshotData['phoneDigits'] as String?;
    _agencyId = snapshotData['agencyId'] as String?;
    _destination = snapshotData['destination'] as String?;
    _fareLabel = snapshotData['fareLabel'] as String?;
    _status = snapshotData['status'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _purchasedAt = snapshotData['purchasedAt'] as DateTime?;
    _sentAt = snapshotData['sentAt'] as DateTime?;
    _approvedAt = snapshotData['approvedAt'] as DateTime?;
    _closedAt = snapshotData['closedAt'] as DateTime?;
    _purchaseAmount = castToType<double>(snapshotData['purchaseAmount']);
    _actualProduct = snapshotData['actualProduct'] as String?;
    _fulfilledBy = snapshotData['fulfilledBy'] as String?;
    _staffNotes = snapshotData['staffNotes'] as String?;
    _adminNote = snapshotData['adminNote'] as String?;
    _redemptionUrl = snapshotData['redemptionUrl'] as String?;
    _issuedAt = snapshotData['issuedAt'] as DateTime?;
    _name = snapshotData['name'] as String?;
    _age = castToType<int>(snapshotData['age']);
    _agedOut = snapshotData['agedOut'] as String?;
    _startLocation = snapshotData['startLocation'] as String?;
    _tripPlan = snapshotData['tripPlan'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('ttRequests');

  static Stream<TtRequestsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TtRequestsRecord.fromSnapshot(s));

  static Future<TtRequestsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TtRequestsRecord.fromSnapshot(s));

  static TtRequestsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TtRequestsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TtRequestsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) => TtRequestsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TtRequestsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TtRequestsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTtRequestsRecordData({
  String? uid,
  String? phone,
  String? email,
  String? phoneDigits,
  String? agencyId,
  String? destination,
  String? fareLabel,
  String? status,
  DateTime? createdAt,
  DateTime? purchasedAt,
  DateTime? sentAt,
  DateTime? approvedAt,
  DateTime? closedAt,
  double? purchaseAmount,
  String? actualProduct,
  String? fulfilledBy,
  String? staffNotes,
  String? adminNote,
  String? redemptionUrl,
  DateTime? issuedAt,
  String? name,
  int? age,
  String? agedOut,
  String? startLocation,
  String? tripPlan,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid': uid,
      'phone': phone,
      'email': email,
      'phoneDigits': phoneDigits,
      'agencyId': agencyId,
      'destination': destination,
      'fareLabel': fareLabel,
      'status': status,
      'createdAt': createdAt,
      'purchasedAt': purchasedAt,
      'sentAt': sentAt,
      'approvedAt': approvedAt,
      'closedAt': closedAt,
      'purchaseAmount': purchaseAmount,
      'actualProduct': actualProduct,
      'fulfilledBy': fulfilledBy,
      'staffNotes': staffNotes,
      'adminNote': adminNote,
      'redemptionUrl': redemptionUrl,
      'issuedAt': issuedAt,
      'name': name,
      'age': age,
      'agedOut': agedOut,
      'startLocation': startLocation,
      'tripPlan': tripPlan,
    }.withoutNulls,
  );

  return firestoreData;
}

class TtRequestsRecordDocumentEquality implements Equality<TtRequestsRecord> {
  const TtRequestsRecordDocumentEquality();

  @override
  bool equals(TtRequestsRecord? e1, TtRequestsRecord? e2) {
    return e1?.uid == e2?.uid &&
        e1?.phone == e2?.phone &&
        e1?.email == e2?.email &&
        e1?.phoneDigits == e2?.phoneDigits &&
        e1?.agencyId == e2?.agencyId &&
        e1?.destination == e2?.destination &&
        e1?.fareLabel == e2?.fareLabel &&
        e1?.status == e2?.status &&
        e1?.createdAt == e2?.createdAt &&
        e1?.purchasedAt == e2?.purchasedAt &&
        e1?.sentAt == e2?.sentAt &&
        e1?.approvedAt == e2?.approvedAt &&
        e1?.closedAt == e2?.closedAt &&
        e1?.purchaseAmount == e2?.purchaseAmount &&
        e1?.actualProduct == e2?.actualProduct &&
        e1?.fulfilledBy == e2?.fulfilledBy &&
        e1?.staffNotes == e2?.staffNotes &&
        e1?.adminNote == e2?.adminNote &&
        e1?.redemptionUrl == e2?.redemptionUrl &&
        e1?.issuedAt == e2?.issuedAt &&
        e1?.name == e2?.name &&
        e1?.age == e2?.age &&
        e1?.agedOut == e2?.agedOut &&
        e1?.startLocation == e2?.startLocation &&
        e1?.tripPlan == e2?.tripPlan;
  }

  @override
  int hash(TtRequestsRecord? e) => const ListEquality().hash([
    e?.uid,
    e?.phone,
    e?.email,
    e?.phoneDigits,
    e?.agencyId,
    e?.destination,
    e?.fareLabel,
    e?.status,
    e?.createdAt,
    e?.purchasedAt,
    e?.sentAt,
    e?.approvedAt,
    e?.closedAt,
    e?.purchaseAmount,
    e?.actualProduct,
    e?.fulfilledBy,
    e?.staffNotes,
    e?.adminNote,
    e?.redemptionUrl,
    e?.issuedAt,
    e?.name,
    e?.age,
    e?.agedOut,
    e?.startLocation,
    e?.tripPlan,
  ]);

  @override
  bool isValidKey(Object? o) => o is TtRequestsRecord;
}
