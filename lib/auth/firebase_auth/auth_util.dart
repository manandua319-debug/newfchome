import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth_manager.dart';
import '../base_auth_user_provider.dart';
import '../../flutter_flow/flutter_flow_util.dart';

import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_transform/stream_transform.dart';
import 'firebase_auth_manager.dart';

export 'firebase_auth_manager.dart';

final _authManager = FirebaseAuthManager();
FirebaseAuthManager get authManager => _authManager;

String get currentUserEmail =>
    currentUserDocument?.email ?? currentUser?.email ?? '';

String get currentUserUid => currentUser?.uid ?? '';

String get currentUserDisplayName =>
    currentUserDocument?.displayName ?? currentUser?.displayName ?? '';

String get currentUserPhoto =>
    currentUserDocument?.photoUrl ?? currentUser?.photoUrl ?? '';

String get currentPhoneNumber =>
    currentUserDocument?.phoneNumber ?? currentUser?.phoneNumber ?? '';

String get currentJwtToken => _currentJwtToken ?? '';

bool get currentUserEmailVerified => currentUser?.emailVerified ?? false;

/// Create a Stream that listens to the current user's JWT Token, since Firebase
/// generates a new token every hour.
String? _currentJwtToken;
final jwtTokenStream = FirebaseAuth.instance
    .idTokenChanges()
    .asyncMap((user) async {
      try {
        _currentJwtToken = await user?.getIdToken();
        return _currentJwtToken;
      } catch (e) {
        print('Error getting JWT token (safe to ignore): $e');
        return null;
      }
    })
    .handleError((error) {
      print('JWT token stream error (safely handled): $error');
    })
    .asBroadcastStream();

DocumentReference? get currentUserReference =>
    loggedIn ? UsersRecord.collection.doc(currentUser!.uid) : null;

UsersRecord? currentUserDocument;
final authenticatedUserStream = FirebaseAuth.instance
    .authStateChanges()
    .map<String>((user) => user?.uid ?? '')
    .switchMap((uid) {
      if (uid.isEmpty) {
        return Stream<UsersRecord?>.value(null);
      }

      // DISABLED: User document is optional for transit pass system
      // Just return null - we only need Firebase Auth, not Firestore user docs
      print('User authenticated with UID: $uid (user document not required)');
      return Stream<UsersRecord?>.value(null);
    })
    .map((user) {
      currentUserDocument = user;
      return currentUserDocument;
    })
    .handleError((error) {
      // Final safety net for any uncaught errors
      print('Auth stream error (safely handled): $error');
    })
    .asBroadcastStream();

class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({Key? key, required this.builder})
    : super(key: key);

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: authenticatedUserStream,
    builder: (context, _) => builder(context),
  );
}
