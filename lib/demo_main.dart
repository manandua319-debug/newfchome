import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/services/transit_service.dart';
import '/transport_step1/trip_plan_view.dart';
import '/ui/fc_ui.dart';

/// Standalone preview of the new UI pieces with sample data (no Firebase).
void main() => runApp(const _Demo());

Map<String, dynamic> _walk(int m, int s) => {
  'distanceMeters': m,
  'staticDuration': '${s}s',
  'travelMode': 'WALK',
};

Map<String, dynamic> _ride(
  String agency,
  String line,
  String from,
  String to,
  String dep,
  String arr,
  String head,
  int stops,
) => {
  'distanceMeters': 6000,
  'staticDuration': '1080s',
  'travelMode': 'TRANSIT',
  'transitDetails': {
    'stopDetails': {
      'departureStop': {'name': from},
      'arrivalStop': {'name': to},
      'departureTime': dep,
      'arrivalTime': arr,
    },
    'headsign': head,
    'transitLine': {
      'agencies': [
        {'name': agency},
      ],
      'nameShort': line,
      'vehicle': {'type': 'BUS'},
    },
    'stopCount': stops,
  },
};

class _Demo extends StatelessWidget {
  const _Demo();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc();
    String t(int m) => now.add(Duration(minutes: m)).toIso8601String();
    final plan = TransitService.parse({
      'routes': [
        {
          'duration': '2520s',
          'legs': [
            {
              'steps': [
                _walk(420, 330),
                _ride(
                  'Santa Clara Valley Transportation Authority',
                  '22',
                  'El Camino Real & Lawrence Expy',
                  'Alameda & Lincoln Ave',
                  t(8),
                  t(26),
                  'Downtown San Jose',
                  9,
                ),
                _ride(
                  'Santa Clara Valley Transportation Authority',
                  '64A',
                  'Alameda & Lincoln Ave',
                  'The Alameda & Mission St',
                  t(30),
                  t(36),
                  'Santa Clara',
                  4,
                ),
                _walk(260, 200),
              ],
            },
          ],
        },
      ],
    }, destinationName: 'Bill Wilson Center – Main Office').first;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, useMaterial3: false),
      home: Builder(
        builder: (context) => Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            elevation: 0,
            title: const Text(
              'Getting There',
              style: TextStyle(color: kFcInk, fontWeight: FontWeight.w600),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: TripPlanView(plan: plan),
          ),
        ),
      ),
    );
  }
}
