import 'package:f_c_home/services/transit_service.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _walk(int meters, int seconds) => {
  'distanceMeters': meters,
  'staticDuration': '${seconds}s',
  'travelMode': 'WALK',
};

Map<String, dynamic> _ride({
  required String agency,
  required String line,
  required String from,
  required String to,
  String vehicle = 'BUS',
}) => {
  'distanceMeters': 5000,
  'staticDuration': '900s',
  'travelMode': 'TRANSIT',
  'transitDetails': {
    'stopDetails': {
      'departureStop': {'name': from},
      'arrivalStop': {'name': to},
      'departureTime': '2026-10-27T21:14:00Z',
      'arrivalTime': '2026-10-27T21:29:00Z',
    },
    'headsign': 'Downtown',
    'transitLine': {
      'agencies': [
        {'name': agency},
      ],
      'nameShort': line,
      'vehicle': {'type': vehicle},
    },
    'stopCount': 7,
  },
};

void main() {
  test('maps Google agency names to pass agencies', () {
    expect(passAgencyFor('Santa Clara Valley Transportation Authority'), 'VTA');
    expect(
      passAgencyFor('San Francisco Municipal Transportation Agency'),
      'Muni',
    );
    expect(passAgencyFor('San Mateo County Transit District'), 'SamTrans');
    expect(passAgencyFor('Peninsula Corridor Joint Powers Board'), 'Caltrain');
    expect(passAgencyFor('Bay Area Rapid Transit'), 'BART');
    expect(passAgencyFor('AC Transit'), isNull);
  });

  test('walk, bus, walk becomes three steps with the right details', () {
    final plans = TransitService.parse({
      'routes': [
        {
          'duration': '2160s',
          'legs': [
            {
              'steps': [
                _walk(200, 150),
                _walk(150, 120), // consecutive walks merge into one
                _ride(
                  agency: 'Santa Clara Valley Transportation Authority',
                  line: '22',
                  from: 'El Camino & Lawrence',
                  to: 'Alameda & Lincoln',
                ),
                _walk(300, 240),
              ],
            },
          ],
        },
      ],
    }, destinationName: 'Bill Wilson Center');

    final plan = plans.single;
    expect(plan.steps.length, 3);
    expect(plan.totalMinutes, 36);

    final first = plan.steps[0];
    expect(first.kind, TripStepKind.walk);
    expect(first.minutes, 5); // 270 s rounds up
    expect(first.meters, 350);
    expect(first.toName, 'El Camino & Lawrence'); // walks to the stop

    final ride = plan.steps[1];
    expect(ride.kind, TripStepKind.transit);
    expect(ride.agencyId, 'VTA');
    expect(ride.line, '22');
    expect(ride.fromStop, 'El Camino & Lawrence');
    expect(ride.toStop, 'Alameda & Lincoln');
    expect(ride.stops, 7);
    expect(ride.departAt, isNotNull);

    final last = plan.steps[2];
    expect(last.kind, TripStepKind.walk);
    expect(last.toName, 'Bill Wilson Center'); // final walk to the shelter

    expect(plan.passAgencies, ['VTA']);
    expect(plan.uncoveredAgencies, isEmpty);
    expect(plan.walkOnly, isFalse);
  });

  test('prefers a trip that only uses pass agencies', () {
    final plans = TransitService.parse({
      'routes': [
        {
          'duration': '1200s',
          'legs': [
            {
              'steps': [
                _ride(agency: 'AC Transit', line: '72', from: 'A', to: 'B'),
              ],
            },
          ],
        },
        {
          'duration': '2400s',
          'legs': [
            {
              'steps': [
                _ride(
                  agency: 'Bay Area Rapid Transit',
                  line: 'Red',
                  from: 'C',
                  to: 'D',
                  vehicle: 'SUBWAY',
                ),
              ],
            },
          ],
        },
      ],
    }, destinationName: 'Shelter');

    expect(plans.first.passAgencies, ['BART']);
    expect(plans.first.transitSteps.first.vehicle, 'Train');
    expect(plans.last.uncoveredAgencies, ['AC Transit']);
  });

  test('a trip with two agencies lists both passes in ride order', () {
    final plans = TransitService.parse({
      'routes': [
        {
          'duration': '3000s',
          'legs': [
            {
              'steps': [
                _ride(
                  agency: 'Santa Clara Valley Transportation Authority',
                  line: '22',
                  from: 'A',
                  to: 'B',
                ),
                _ride(
                  agency: 'Peninsula Corridor Joint Powers Board',
                  line: 'Local',
                  from: 'C',
                  to: 'D',
                  vehicle: 'HEAVY_RAIL',
                ),
              ],
            },
          ],
        },
      ],
    }, destinationName: 'Shelter');
    expect(plans.single.passAgencies, ['VTA', 'Caltrain']);
  });

  test('walking-only trip has no pass needed', () {
    final plans = TransitService.parse({
      'routes': [
        {
          'duration': '600s',
          'legs': [
            {
              'steps': [_walk(800, 600)],
            },
          ],
        },
      ],
    }, destinationName: 'Shelter');
    expect(plans.single.walkOnly, isTrue);
    expect(plans.single.passAgencies, isEmpty);
  });

  test('an empty response gives no plans', () {
    expect(TransitService.parse({}, destinationName: 'Shelter'), isEmpty);
  });
}
