import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/firebase_auth/auth_util.dart';

import '../flutter_flow/flutter_flow_util.dart';
import 'schema/util/firestore_util.dart';

import 'schema/shelters_record.dart';
import 'schema/mood_logs_record.dart';
import 'schema/users_record.dart';
import 'schema/journal_entries_record.dart';
import 'schema/food_record.dart';
import 'schema/tents_record.dart';
import 'schema/health_record.dart';
import 'schema/sheltersminors_record.dart';
import 'schema/healthminors_record.dart';
import 'schema/tentsminors_record.dart';
import 'schema/foodminors_record.dart';
import 'schema/tt_requests_record.dart';

export 'dart:async' show StreamSubscription;
export 'package:cloud_firestore/cloud_firestore.dart' hide Order;
export 'package:firebase_core/firebase_core.dart';
export 'schema/index.dart';
export 'schema/util/firestore_util.dart';
export 'schema/util/schema_util.dart';

export 'schema/shelters_record.dart';
export 'schema/mood_logs_record.dart';
export 'schema/users_record.dart';
export 'schema/journal_entries_record.dart';
export 'schema/food_record.dart';
export 'schema/tents_record.dart';
export 'schema/health_record.dart';
export 'schema/sheltersminors_record.dart';
export 'schema/healthminors_record.dart';
export 'schema/tentsminors_record.dart';
export 'schema/foodminors_record.dart';
export 'schema/tt_requests_record.dart';

/// Functions to query SheltersRecords (as a Stream and as a Future).
Future<int> querySheltersRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  SheltersRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<SheltersRecord>> querySheltersRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  SheltersRecord.collection,
  SheltersRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<SheltersRecord>> querySheltersRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  SheltersRecord.collection,
  SheltersRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

/// Functions to query MoodLogsRecords (as a Stream and as a Future).
Future<int> queryMoodLogsRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  MoodLogsRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<MoodLogsRecord>> queryMoodLogsRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  MoodLogsRecord.collection,
  MoodLogsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<MoodLogsRecord>> queryMoodLogsRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  MoodLogsRecord.collection,
  MoodLogsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

/// Functions to query UsersRecords (as a Stream and as a Future).
Future<int> queryUsersRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  UsersRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<UsersRecord>> queryUsersRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  UsersRecord.collection,
  UsersRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<UsersRecord>> queryUsersRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  UsersRecord.collection,
  UsersRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

/// Functions to query JournalEntriesRecords (as a Stream and as a Future).
Future<int> queryJournalEntriesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  JournalEntriesRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<JournalEntriesRecord>> queryJournalEntriesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  JournalEntriesRecord.collection,
  JournalEntriesRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<JournalEntriesRecord>> queryJournalEntriesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  JournalEntriesRecord.collection,
  JournalEntriesRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

/// Functions to query FoodRecords (as a Stream and as a Future).
Future<int> queryFoodRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  FoodRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<FoodRecord>> queryFoodRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  FoodRecord.collection,
  FoodRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<FoodRecord>> queryFoodRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  FoodRecord.collection,
  FoodRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

/// Functions to query TentsRecords (as a Stream and as a Future).
Future<int> queryTentsRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  TentsRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<TentsRecord>> queryTentsRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  TentsRecord.collection,
  TentsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<TentsRecord>> queryTentsRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  TentsRecord.collection,
  TentsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

/// Functions to query HealthRecords (as a Stream and as a Future).
Future<int> queryHealthRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  HealthRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<HealthRecord>> queryHealthRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  HealthRecord.collection,
  HealthRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<HealthRecord>> queryHealthRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  HealthRecord.collection,
  HealthRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

/// Functions to query SheltersminorsRecords (as a Stream and as a Future).
Future<int> querySheltersminorsRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  SheltersminorsRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<SheltersminorsRecord>> querySheltersminorsRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  SheltersminorsRecord.collection,
  SheltersminorsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<SheltersminorsRecord>> querySheltersminorsRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  SheltersminorsRecord.collection,
  SheltersminorsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

/// Functions to query HealthminorsRecords (as a Stream and as a Future).
Future<int> queryHealthminorsRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  HealthminorsRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<HealthminorsRecord>> queryHealthminorsRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  HealthminorsRecord.collection,
  HealthminorsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<HealthminorsRecord>> queryHealthminorsRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  HealthminorsRecord.collection,
  HealthminorsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

/// Functions to query TentsminorsRecords (as a Stream and as a Future).
Future<int> queryTentsminorsRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  TentsminorsRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<TentsminorsRecord>> queryTentsminorsRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  TentsminorsRecord.collection,
  TentsminorsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<TentsminorsRecord>> queryTentsminorsRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  TentsminorsRecord.collection,
  TentsminorsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

/// Functions to query FoodminorsRecords (as a Stream and as a Future).
Future<int> queryFoodminorsRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  FoodminorsRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<FoodminorsRecord>> queryFoodminorsRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  FoodminorsRecord.collection,
  FoodminorsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<FoodminorsRecord>> queryFoodminorsRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  FoodminorsRecord.collection,
  FoodminorsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

/// Functions to query TtRequestsRecords (as a Stream and as a Future).
Future<int> queryTtRequestsRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) => queryCollectionCount(
  TtRequestsRecord.collection,
  queryBuilder: queryBuilder,
  limit: limit,
);

Stream<List<TtRequestsRecord>> queryTtRequestsRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollection(
  TtRequestsRecord.collection,
  TtRequestsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<List<TtRequestsRecord>> queryTtRequestsRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) => queryCollectionOnce(
  TtRequestsRecord.collection,
  TtRequestsRecord.fromSnapshot,
  queryBuilder: queryBuilder,
  limit: limit,
  singleRecord: singleRecord,
);

Future<int> queryCollectionCount(
  Query collection, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0) {
    query = query.limit(limit);
  }

  return query
      .count()
      .get()
      .catchError((err) {
        print('Error querying $collection: $err');
        throw err;
      })
      .then((value) => value.count!);
}

Stream<List<T>> queryCollection<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query
      .snapshots()
      .handleError((err) {
        print('Error querying $collection: $err');
      })
      .map(
        (s) => s.docs
            .map(
              (d) => safeGet(
                () => recordBuilder(d),
                (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
              ),
            )
            .where((d) => d != null)
            .map((d) => d!)
            .toList(),
      );
}

Future<List<T>> queryCollectionOnce<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.get().then(
    (s) => s.docs
        .map(
          (d) => safeGet(
            () => recordBuilder(d),
            (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
          ),
        )
        .where((d) => d != null)
        .map((d) => d!)
        .toList(),
  );
}

Filter filterIn(String field, List? list) => (list?.isEmpty ?? true)
    ? Filter(field, whereIn: null)
    : Filter(field, whereIn: list);

Filter filterArrayContainsAny(String field, List? list) =>
    (list?.isEmpty ?? true)
    ? Filter(field, arrayContainsAny: null)
    : Filter(field, arrayContainsAny: list);

extension QueryExtension on Query {
  Query whereIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereIn: null)
      : where(field, whereIn: list);

  Query whereNotIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereNotIn: null)
      : where(field, whereNotIn: list);

  Query whereArrayContainsAny(String field, List? list) =>
      (list?.isEmpty ?? true)
      ? where(field, arrayContainsAny: null)
      : where(field, arrayContainsAny: list);
}

class FFFirestorePage<T> {
  final List<T> data;
  final Stream<List<T>>? dataStream;
  final QueryDocumentSnapshot? nextPageMarker;

  FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);
}

Future<FFFirestorePage<T>> queryCollectionPage<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) async {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection).limit(pageSize);
  if (nextPageMarker != null) {
    query = query.startAfterDocument(nextPageMarker);
  }
  Stream<QuerySnapshot>? docSnapshotStream;
  QuerySnapshot docSnapshot;
  if (isStream) {
    docSnapshotStream = query.snapshots();
    docSnapshot = await docSnapshotStream.first;
  } else {
    docSnapshot = await query.get();
  }
  final getDocs = (QuerySnapshot s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList();
  final data = getDocs(docSnapshot);
  final dataStream = docSnapshotStream?.map(getDocs);
  final nextPageToken = docSnapshot.docs.isEmpty ? null : docSnapshot.docs.last;
  return FFFirestorePage(data, dataStream, nextPageToken);
}

// Creates a Firestore document representing the logged in user if it doesn't yet exist
Future maybeCreateUser(User user) async {
  final userRecord = UsersRecord.collection.doc(user.uid);
  final userExists = await userRecord.get().then((u) => u.exists);
  if (userExists) {
    currentUserDocument = await UsersRecord.getDocumentOnce(userRecord);
    return;
  }

  final userData = createUsersRecordData(
    email:
        user.email ??
        FirebaseAuth.instance.currentUser?.email ??
        user.providerData.firstOrNull?.email,
    displayName:
        user.displayName ?? FirebaseAuth.instance.currentUser?.displayName,
    photoUrl: user.photoURL,
    uid: user.uid,
    phoneNumber: user.phoneNumber,
    createdTime: getCurrentTimestamp,
  );

  await userRecord.set(userData);
  currentUserDocument = UsersRecord.getDocumentFromData(userData, userRecord);
}

Future updateUserDocument({String? email}) async {
  await currentUserDocument?.reference.update(
    createUsersRecordData(email: email),
  );
}
