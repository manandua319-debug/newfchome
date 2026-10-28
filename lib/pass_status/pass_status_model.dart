import '/flutter_flow/flutter_flow_util.dart';
import 'pass_status_widget.dart' show PassStatusWidget;
import 'package:flutter/material.dart';

class PassStatusModel extends FlutterFlowModel<PassStatusWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
