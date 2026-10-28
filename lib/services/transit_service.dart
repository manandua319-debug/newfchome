import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:http/http.dart' as http;

import '/services/location_service.dart';

/// Agencies our free passes cover. Matches the list on the pass request form.
const kPassAgencies = ['VTA', 'Muni', 'SamTrans', 'Caltrain', 'BART'];

/// Maps the agency name Google returns to one of [kPassAgencies], or null when
/// the pass program does not cover it (AC Transit, Golden Gate, ...).
String? passAgencyFor(String googleName) {
  final n = googleName.toLowerCase();
  if (n.contains('santa clara valley transportation') || n == 'vta') {
    return 'VTA';
  }
  if (n.contains('san francisco municipal') || n.contains('muni')) {
    return 'Muni';
  }
  if (n.contains('san mateo county transit') || n.contains('samtrans')) {
    return 'SamTrans';
  }
  if (n.contains('peninsula corridor') || n.contains('caltrain')) {
    return 'Caltrain';
  }
  if (n.contains('bay area rapid transit') || n == 'bart') return 'BART';
  return null;
}

enum TripStepKind { walk, transit }

class TripStep {
  const TripStep.walk({
    required this.minutes,
    required this.meters,
    required this.toName,
  }) : kind = TripStepKind.walk,
       agencyName = '',
       agencyId = null,
       line = '',
       vehicle = '',
       headsign = '',
       fromStop = '',
       toStop = '',
       departAt = null,
       arriveAt = null,
       stops = 0;

  const TripStep.transit({
    required this.agencyName,
    required this.agencyId,
    required this.line,
    required this.vehicle,
    required this.headsign,
    required this.fromStop,
    required this.toStop,
    required this.departAt,
    required this.arriveAt,
    required this.stops,
    required this.minutes,
  }) : kind = TripStepKind.transit,
       meters = 0,
       toName = '';

  final TripStepKind kind;
  final int minutes;
  final int meters;

  /// Walk: where this walk ends (a stop name or the destination).
  final String toName;

  // Transit leg details.
  final String agencyName;
  final String? agencyId;
  final String line;
  final String vehicle;
  final String headsign;
  final String fromStop;
  final String toStop;
  final DateTime? departAt;
  final DateTime? arriveAt;
  final int stops;

  double get miles => meters / 1609.344;
}

class TripPlan {
  TripPlan({
    required this.steps,
    required this.totalMinutes,
    required this.destination,
  });

  final List<TripStep> steps;
  final int totalMinutes;
  final String destination;

  List<TripStep> get transitSteps =>
      steps.where((s) => s.kind == TripStepKind.transit).toList();

  /// Pass agencies this trip needs, in the order they are ridden.
  List<String> get passAgencies {
    final out = <String>[];
    for (final s in transitSteps) {
      final id = s.agencyId;
      if (id != null && !out.contains(id)) out.add(id);
    }
    return out;
  }

  /// Agencies on the trip that our passes do not cover.
  List<String> get uncoveredAgencies {
    final out = <String>[];
    for (final s in transitSteps) {
      if (s.agencyId == null &&
          s.agencyName.isNotEmpty &&
          !out.contains(s.agencyName)) {
        out.add(s.agencyName);
      }
    }
    return out;
  }

  bool get walkOnly => transitSteps.isEmpty;

  DateTime? get arriveAt {
    for (final s in steps.reversed) {
      if (s.arriveAt != null) return s.arriveAt;
    }
    return null;
  }

  /// One-line description saved with a pass request so staff can see it.
  String get summary {
    if (walkOnly) return 'Walk $totalMinutes min to $destination';
    final legs = transitSteps
        .map(
          (s) =>
              '${s.agencyId ?? s.agencyName} ${s.line} '
              '${s.fromStop} to ${s.toStop}',
        )
        .join(', then ');
    return '$legs ($totalMinutes min total)';
  }
}

enum TransitErrorKind { noLocation, notConfigured, noRoute, network }

class TransitException implements Exception {
  TransitException(this.kind, this.message);
  final TransitErrorKind kind;
  final String message;
  @override
  String toString() => message;
}

class TransitService {
  // Same Android Maps key the app already ships (AndroidManifest.xml).
  static const _androidKey = 'AIzaSyAJHp7QsdWkG-AgCj8TbJujIiqw3DbYoI8';
  static const _endpoint =
      'https://routes.googleapis.com/directions/v2:computeRoutes';
  static const _fieldMask =
      'routes.duration,routes.legs.steps.distanceMeters,'
      'routes.legs.steps.staticDuration,routes.legs.steps.travelMode,'
      'routes.legs.steps.transitDetails';

  /// Plans a trip from the phone's location (or [originAddress] when given)
  /// to [destinationAddress], leaving now.
  static Future<TripPlan> plan({
    required String destinationAddress,
    required String destinationName,
    String? originAddress,
  }) async {
    if (kIsWeb) {
      throw TransitException(
        TransitErrorKind.notConfigured,
        'Bus directions work in the phone app.',
      );
    }

    Map<String, dynamic> origin;
    if (originAddress != null && originAddress.trim().isNotEmpty) {
      origin = {'address': originAddress.trim()};
    } else {
      final pos = await LocationService.currentPosition();
      if (pos == null) {
        throw TransitException(
          TransitErrorKind.noLocation,
          'Turn on location, or type where you are starting from.',
        );
      }
      origin = {
        'location': {
          'latLng': {'latitude': pos.latitude, 'longitude': pos.longitude},
        },
      };
    }

    final body = {
      'origin': origin,
      'destination': {'address': destinationAddress},
      'travelMode': 'TRANSIT',
      'computeAlternativeRoutes': true,
      'departureTime': DateTime.now().toUtc().toIso8601String(),
      'languageCode': 'en-US',
      'units': 'IMPERIAL',
    };

    http.Response res;
    try {
      final appHeaders = await const GoogleApiHeaders().getHeaders();
      res = await http
          .post(
            Uri.parse(_endpoint),
            headers: {
              'Content-Type': 'application/json',
              'X-Goog-Api-Key': _androidKey,
              'X-Goog-FieldMask': _fieldMask,
              ...appHeaders,
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint('Transit request failed: $e');
      throw TransitException(
        TransitErrorKind.network,
        "Couldn't reach the route service. Check your connection.",
      );
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 403 || res.statusCode == 401) {
      debugPrint('Routes API denied: ${res.body}');
      throw TransitException(
        TransitErrorKind.notConfigured,
        'Bus directions are not set up yet.',
      );
    }
    if (res.statusCode != 200) {
      debugPrint('Routes API error ${res.statusCode}: ${res.body}');
      throw TransitException(
        TransitErrorKind.network,
        "Couldn't get bus directions right now.",
      );
    }

    final plans = parse(json, destinationName: destinationName);
    if (plans.isEmpty) {
      throw TransitException(
        TransitErrorKind.noRoute,
        'No bus or train route found from here right now.',
      );
    }
    return plans.first;
  }

  /// Parses a Routes API response into trip plans, best first: trips that
  /// only use pass agencies come before others, then fewer transfers, then
  /// the shortest trip.
  @visibleForTesting
  static List<TripPlan> parse(
    Map<String, dynamic> json, {
    required String destinationName,
  }) {
    final routes = (json['routes'] as List?) ?? const [];
    final plans = <TripPlan>[];
    for (final r in routes) {
      final route = r as Map<String, dynamic>;
      final legs = (route['legs'] as List?) ?? const [];
      final steps = <TripStep>[];
      for (final l in legs) {
        steps.addAll(
          _parseSteps(
            ((l as Map<String, dynamic>)['steps'] as List?) ?? const [],
            destinationName,
          ),
        );
      }
      if (steps.isEmpty) continue;
      plans.add(
        TripPlan(
          steps: steps,
          totalMinutes: (_seconds(route['duration']) / 60).round(),
          destination: destinationName,
        ),
      );
    }
    plans.sort((a, b) {
      final ac = a.uncoveredAgencies.isEmpty ? 0 : 1;
      final bc = b.uncoveredAgencies.isEmpty ? 0 : 1;
      if (ac != bc) return ac.compareTo(bc);
      final at = a.transitSteps.length, bt = b.transitSteps.length;
      if (at != bt) return at.compareTo(bt);
      return a.totalMinutes.compareTo(b.totalMinutes);
    });
    return plans;
  }

  static List<TripStep> _parseSteps(List raw, String destinationName) {
    // First pass: merge runs of walking steps into one.
    final out = <TripStep>[];
    var walkSeconds = 0.0;
    var walkMeters = 0;
    var hasWalk = false;

    void flushWalk(String toName) {
      if (!hasWalk) return;
      out.add(
        TripStep.walk(
          minutes: (walkSeconds / 60).ceil().clamp(1, 1000),
          meters: walkMeters,
          toName: toName,
        ),
      );
      walkSeconds = 0;
      walkMeters = 0;
      hasWalk = false;
    }

    for (final s in raw) {
      final step = s as Map<String, dynamic>;
      final mode = step['travelMode'] as String? ?? 'WALK';
      if (mode == 'TRANSIT') {
        final td = (step['transitDetails'] as Map<String, dynamic>?) ?? {};
        final stop = (td['stopDetails'] as Map<String, dynamic>?) ?? {};
        final from = (stop['departureStop'] as Map?)?['name'] as String? ?? '';
        final to = (stop['arrivalStop'] as Map?)?['name'] as String? ?? '';
        final line = (td['transitLine'] as Map<String, dynamic>?) ?? {};
        final agencies = (line['agencies'] as List?) ?? const [];
        final agencyName = agencies.isEmpty
            ? ''
            : ((agencies.first as Map)['name'] as String? ?? '');
        final vehicleType =
            ((line['vehicle'] as Map?)?['type'] as String?) ?? 'BUS';
        final lineName =
            (line['nameShort'] as String?)?.trim().isNotEmpty == true
            ? line['nameShort'] as String
            : (line['name'] as String? ?? '');
        flushWalk(from);
        out.add(
          TripStep.transit(
            agencyName: agencyName,
            agencyId: passAgencyFor(agencyName),
            line: lineName,
            vehicle: _vehicleLabel(vehicleType),
            headsign: td['headsign'] as String? ?? '',
            fromStop: from,
            toStop: to,
            departAt: _time(stop['departureTime']),
            arriveAt: _time(stop['arrivalTime']),
            stops: (td['stopCount'] as num?)?.toInt() ?? 0,
            minutes: (_seconds(step['staticDuration']) / 60).round(),
          ),
        );
      } else {
        hasWalk = true;
        walkSeconds += _seconds(step['staticDuration']);
        walkMeters += (step['distanceMeters'] as num?)?.toInt() ?? 0;
      }
    }
    flushWalk(destinationName);
    return out;
  }

  static double _seconds(dynamic v) {
    if (v is String && v.endsWith('s')) {
      return double.tryParse(v.substring(0, v.length - 1)) ?? 0;
    }
    return 0;
  }

  static DateTime? _time(dynamic v) =>
      v is String ? DateTime.tryParse(v)?.toLocal() : null;

  static String _vehicleLabel(String type) {
    switch (type) {
      case 'SUBWAY':
      case 'METRO_RAIL':
        return 'Train';
      case 'HEAVY_RAIL':
      case 'COMMUTER_TRAIN':
      case 'RAIL':
      case 'TRAIN':
        return 'Train';
      case 'TRAM':
      case 'LIGHT_RAIL':
        return 'Light Rail';
      case 'TROLLEYBUS':
      case 'BUS':
      case 'INTERCITY_BUS':
      default:
        return 'Bus';
    }
  }
}
