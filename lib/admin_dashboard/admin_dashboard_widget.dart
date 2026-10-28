import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_dashboard_model.dart';
export 'admin_dashboard_model.dart';

class AdminDashboardWidget extends StatefulWidget {
  const AdminDashboardWidget({super.key});

  @override
  State<AdminDashboardWidget> createState() => _AdminDashboardWidgetState();
}

class _AdminDashboardWidgetState extends State<AdminDashboardWidget> {
  late AdminDashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminDashboardModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _markAsProcessing(String requestId) async {
    final theme = FlutterFlowTheme.of(context);

    try {
      await FirebaseFirestore.instance
          .collection('ttRequests')
          .doc(requestId)
          .update({
            'status': 'processing',
            'updatedAt': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Status Updated to Processing'),
            backgroundColor: kFcWarning, // Orange
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Couldn't update the request. Try again."),
            backgroundColor: theme.error,
          ),
        );
      }
    }
  }

  Future<void> _markAsSent(String requestId) async {
    final theme = FlutterFlowTheme.of(context);

    try {
      await FirebaseFirestore.instance
          .collection('ttRequests')
          .doc(requestId)
          .update({'status': 'sent', 'sentAt': FieldValue.serverTimestamp()});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pass Marked as Sent'),
            backgroundColor: kFcSuccess, // Green
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Couldn't update the request. Try again."),
            backgroundColor: theme.error,
          ),
        );
      }
    }
  }

  void _toast(String message, {Color? color}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: color ?? kFcInk,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2000),
        ),
      );
  }

  Future<void> _copyPhone(String phone) async {
    await Clipboard.setData(ClipboardData(text: phone));
    if (mounted) _toast('Phone Number Copied');
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          buttonSize: 56,
          fillColor: Colors.transparent,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.primaryText,
            size: 26,
          ),
          onPressed: () async => context.pop(),
        ),
        title: Text(
          'Staff Dashboard',
          style: fcHeadline(
            color: theme.primaryText,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<TtRequestsRecord>>(
          stream: queryTtRequestsRecord(
            queryBuilder: (q) => q
                .where('status', whereIn: ['pending', 'processing'])
                .orderBy('createdAt', descending: true),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _centered(
                theme,
                Icons.error_outline,
                "Couldn't Load Requests",
                'Check your connection and try again.',
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: theme.primary),
              );
            }
            final requests = snapshot.data!;
            final pending = requests.where((r) => r.status == 'pending').length;
            final processing = requests.length - pending;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _stat(theme, 'Pending', pending, kFcDanger),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _stat(theme, 'Processing', processing, kFcWarning),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _workflow(theme),
                const SizedBox(height: 20),
                Text(
                  'Active Requests',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                if (requests.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: _centered(
                      theme,
                      Icons.check_circle_outline,
                      'No Pending Requests',
                      'New requests will show up here.',
                    ),
                  )
                else
                  for (final r in requests) _requestCard(theme, r),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _centered(
    FlutterFlowTheme theme,
    IconData icon,
    String title,
    String body,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: theme.secondaryText),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, color: theme.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _stat(FlutterFlowTheme theme, String label, int count, Color dot) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.secondaryText,
              ),
            ),
          ),
          Text(
            '$count',
            style: fcHeadline(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: theme.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _workflow(FlutterFlowTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Icon(Icons.info_outline, color: theme.primary),
          title: Text(
            'Manual Fulfillment Workflow',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.primaryText,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '1. Open Token Transit app\n'
                '2. Select the requested agency\n'
                '3. Tap "Send a Pass" or "Gift a Pass"\n'
                '4. Enter the phone number below\n'
                '5. Pay with org card\n'
                '6. Mark as "Sent" in this dashboard',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.6,
                  color: theme.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _requestCard(FlutterFlowTheme theme, TtRequestsRecord r) {
    final processing = r.status == 'processing';
    final statusColor = processing ? kFcWarning : kFcDanger;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  processing ? 'Processing' : 'Pending',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: processing ? const Color(0xFF9A6200) : kFcDanger,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                dateTimeFormat('relative', r.createdAt),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: theme.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            r.name.isNotEmpty ? r.name : 'Name Not Provided',
            style: fcHeadline(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: r.name.isNotEmpty
                  ? theme.primaryText
                  : theme.secondaryText,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: r.phone.isEmpty ? null : () => _copyPhone(r.phone),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.smartphone_outlined,
                    size: 20,
                    color: theme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      r.phone.isEmpty ? 'No Phone Number' : r.phone,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
                    ),
                  ),
                  if (r.phone.isNotEmpty)
                    Icon(
                      Icons.copy_rounded,
                      size: 18,
                      color: theme.secondaryText,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _detail(theme, 'Age', r.age > 0 ? '${r.age}' : ''),
          _detail(theme, 'Aged Out', r.agedOut),
          _detail(theme, 'Starting Location', r.startLocation),
          _detail(theme, 'Destination', r.destination),
          _detail(theme, 'Planned Trip', r.tripPlan),
          _detail(theme, 'Agency', r.agencyId),
          _detail(theme, 'Fare Type', r.fareLabel),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FFButtonWidget(
              onPressed: () => processing
                  ? _markAsSent(r.reference.id)
                  : _markAsProcessing(r.reference.id),
              text: processing ? 'Mark as Sent' : 'Start Processing',
              icon: Icon(
                processing ? Icons.check_rounded : Icons.play_arrow_rounded,
                size: 20,
              ),
              options: FFButtonOptions(
                height: 46,
                color: processing ? kFcSuccess : theme.primary,
                textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                elevation: 0,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail(FlutterFlowTheme theme, String label, String value) {
    final empty = value.trim().isEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.secondaryText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              empty ? 'Not Provided' : value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: empty ? theme.secondaryText : theme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
