import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/agency_logo_widget.dart';
import 'package:flutter/material.dart';
import '/ui/fc_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'pass_status_model.dart';
export 'pass_status_model.dart';

class PassStatusWidget extends StatefulWidget {
  const PassStatusWidget({super.key});

  static String routeName = 'PassStatus';
  static String routePath = '/passStatus';

  @override
  State<PassStatusWidget> createState() => _PassStatusWidgetState();
}

class _PassStatusWidgetState extends State<PassStatusWidget> {
  late PassStatusModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showAllPasses = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PassStatusModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _formatDate(Timestamp? timestamp) {
    final date = timestamp?.toDate() ?? DateTime.now();
    return '${date.month}/${date.day}/${date.year}';
  }

  Widget _buildProgressBar(String status) => FcTracker(status: status);

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final requestId = FFAppState().lastTTRequestId;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 20.0,
            borderWidth: 1.0,
            buttonSize: 40.0,
            fillColor: Colors.transparent,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: kFcInk,
              size: 28.0,
            ),
            onPressed: () async => context.safePop(),
          ),
          title: Text(
            'Pass Status',
            style: fcHeadline(
              color: kFcInk,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
            ),
          ),
          actions: [
            FlutterFlowIconButton(
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: Colors.transparent,
              icon: Icon(
                Icons.admin_panel_settings,
                color: theme.error,
                size: 24.0,
              ),
              onPressed: () async {
                context.pushNamed('AdminDashboard');
              },
            ),
            const SizedBox(width: 8),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Current request status
                if (!_showAllPasses)
                  Expanded(
                    child: (requestId != null && requestId.isNotEmpty)
                        ? StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('ttRequests')
                                .where('uid', isEqualTo: currentUserUid)
                                .orderBy('createdAt', descending: true)
                                .limit(1)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error loading request: ${snapshot.error}',
                                    style: theme.bodyMedium.override(
                                      color: theme.error,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                // Hardcoded case - show success
                                return _buildHardcodedSuccess();
                              }

                              final doc = snapshot.data!.docs.first;
                              final data = doc.data() as Map<String, dynamic>;
                              final status =
                                  data['status'] as String? ?? 'pending';
                              final agencyId =
                                  data['agencyId'] as String? ?? '';
                              final phone = data['phone'] as String? ?? '';
                              final createdAt = data['createdAt'] as Timestamp?;

                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    // Main status card
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.08,
                                            ),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Agency & time
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  AgencyLogoWidget(
                                                    agencyId: agencyId,
                                                    size: 56,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        agencyId,
                                                        style: fcHeadline(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: kFcInk,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        'Single Ride Pass',
                                                        style:
                                                            GoogleFonts.inter(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: kFcMuted,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: kFcSurface,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  _formatDate(createdAt),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: kFcMuted,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 24),

                                          // Progress bar
                                          _buildProgressBar(status),

                                          const SizedBox(height: 24),

                                          // Phone info
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: kFcTint,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: kFcPrimary,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.smartphone_outlined,
                                                  color: kFcPrimary,
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Your pass will be sent to:',
                                                        style:
                                                            GoogleFonts.inter(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: kFcPrimary,
                                                            ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        phone,
                                                        style:
                                                            GoogleFonts.inter(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  const Color(
                                                                    0xFF1E3A8A,
                                                                  ),
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // View all passes button
                                    Material(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: theme.primary,
                                          width: 1,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _showAllPasses = true;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.history,
                                                color: theme.primary,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'View All Passes',
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: theme.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : _buildHardcodedSuccess(),
                  ),

                // All passes view
                if (_showAllPasses)
                  Expanded(
                    child: Column(
                      children: [
                        // Back to status button
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showAllPasses = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.primary,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: theme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Back to Current Status',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // All passes list
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('ttRequests')
                                .where('uid', isEqualTo: currentUserUid)
                                .orderBy('createdAt', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error Loading Passes',
                                    style: theme.bodyMedium,
                                  ),
                                );
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No Passes Found',
                                    style: theme.bodyMedium,
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final doc = snapshot.data!.docs[index];
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  final status =
                                      data['status'] as String? ?? 'pending';
                                  final agencyId =
                                      data['agencyId'] as String? ?? '';
                                  final createdAt =
                                      data['createdAt'] as Timestamp?;

                                  Color statusColor;
                                  if (status == 'sent') {
                                    statusColor = kFcSuccess;
                                  } else if (status == 'purchased' ||
                                      status == 'processing') {
                                    statusColor = kFcWarning;
                                  } else {
                                    statusColor = kFcDanger;
                                  }

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: kFcLine,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            borderRadius: BorderRadius.circular(
                                              3,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                agencyId,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: kFcInk,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text(
                                                    status.toUpperCase(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: statusColor,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    '• ${_formatDate(createdAt)}',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      color: kFcMuted,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHardcodedSuccess() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            'Loading your request...',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kFcMuted,
            ),
          ),
        ],
      ),
    );
  }
}
