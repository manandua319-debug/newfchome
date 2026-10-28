import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/components/agency_logo_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/transit_service.dart';

/// The full door-to-door plan: walk to the stop, which bus or train to take
/// and when, where to get off, and the last walk to the destination.
class TripPlanView extends StatelessWidget {
  const TripPlanView({super.key, required this.plan});

  final TripPlan plan;

  static String _time(DateTime? t) =>
      t == null ? '' : DateFormat('h:mm a').format(t);

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final arrive = plan.arriveAt;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _chip(theme, Icons.schedule_rounded, 'Leave Now'),
            const SizedBox(width: 8),
            if (arrive != null)
              _chip(theme, Icons.flag_outlined, 'Arrive ${_time(arrive)}'),
            const SizedBox(width: 8),
            _chip(theme, Icons.timer_outlined, '${plan.totalMinutes} min'),
          ],
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < plan.steps.length; i++)
          _step(theme, plan.steps[i], last: i == plan.steps.length - 1),
      ],
    );
  }

  Widget _chip(FlutterFlowTheme theme, IconData icon, String text) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.alternate),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.primary),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(FlutterFlowTheme theme, TripStep s, {required bool last}) {
    final walk = s.kind == TripStepKind.walk;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (!last)
          Positioned(
            left: 19,
            top: 44,
            bottom: -4,
            width: 2,
            child: ColoredBox(color: theme.alternate),
          ),
        Padding(
          padding: EdgeInsets.only(bottom: last ? 0 : 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: walk
                      ? theme.primaryBackground
                      : theme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.alternate),
                ),
                child: walk
                    ? Icon(
                        last
                            ? Icons.location_on_outlined
                            : Icons.directions_walk_rounded,
                        size: 22,
                        color: theme.secondaryText,
                      )
                    : Icon(
                        s.vehicle == 'Bus'
                            ? Icons.directions_bus_rounded
                            : Icons.train_rounded,
                        size: 22,
                        color: theme.primary,
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(child: walk ? _walk(theme, s, last) : _ride(theme, s)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _walk(FlutterFlowTheme theme, TripStep s, bool last) {
    final dist = s.miles < 0.1
        ? '${(s.meters * 3.281).round()} ft'
        : '${s.miles.toStringAsFixed(1)} mi';
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Walk ${s.minutes} min ($dist)',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.primaryText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            last ? 'to ${s.toName}' : 'to the stop at ${s.toName}',
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.35,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ride(FlutterFlowTheme theme, TripStep s) {
    final name = s.agencyId ?? s.agencyName;
    return Container(
      padding: const EdgeInsets.all(14),
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
              if (s.agencyId != null) ...[
                AgencyLogoWidget(agencyId: s.agencyId!, size: 32),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  '$name ${s.vehicle}${s.line.isEmpty ? '' : ' ${s.line}'}',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryText,
                  ),
                ),
              ),
            ],
          ),
          if (s.headsign.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Toward ${s.headsign}',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.secondaryText,
              ),
            ),
          ],
          const SizedBox(height: 12),
          _stopRow(theme, 'Board', s.fromStop, s.departAt),
          const SizedBox(height: 8),
          _stopRow(
            theme,
            'Get off',
            s.toStop,
            s.arriveAt,
            note: s.stops > 0
                ? '${s.stops} ${s.stops == 1 ? 'stop' : 'stops'}'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _stopRow(
    FlutterFlowTheme theme,
    String label,
    String stop,
    DateTime? at, {
    String? note,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 56,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stop,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.3,
                  color: theme.primaryText,
                ),
              ),
              if (note != null)
                Text(
                  'Ride $note',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: theme.secondaryText,
                  ),
                ),
            ],
          ),
        ),
        if (at != null)
          Text(
            _time(at),
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: theme.primary,
            ),
          ),
      ],
    );
  }
}
