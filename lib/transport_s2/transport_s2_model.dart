import '/flutter_flow/flutter_flow_util.dart';
import 'transport_s2_widget.dart' show TransportS2Widget;
import 'package:flutter/material.dart';

class TransportS2Model extends FlutterFlowModel<TransportS2Widget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
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
