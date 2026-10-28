import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:ui';
import '/index.dart';
import 'main_page_minors_widget.dart' show MainPageMinorsWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainPageMinorsModel extends FlutterFlowModel<MainPageMinorsWidget> {
  ///  Local state fields for this page.

  String? mood;

  bool showSadAnim = false;

  bool showGoodAnim = false;

  String? journalEntry;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Create Document] action in Stack widget.
  JournalEntriesRecord? newMoodDoc;
  // Stores action output result for [Backend Call - Create Document] action in Container widget.
  JournalEntriesRecord? newMoodDoc1;
  // Stores action output result for [Backend Call - Create Document] action in Stack widget.
  JournalEntriesRecord? newMoodDoc2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
