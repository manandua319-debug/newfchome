import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

/// Trust Score Behavior Tracker
/// Tracks user behaviors that indicate legitimate use of services
class TrustScoreTracker {
  static final TrustScoreTracker _instance = TrustScoreTracker._internal();
  factory TrustScoreTracker() => _instance;
  TrustScoreTracker._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Track when user views service details
  /// Includes viewing hours, requirements, eligibility info
  Future<void> trackServiceDetailView({
    required String serviceName,
    required String serviceType, // 'shelter', 'health', 'food', 'tents'
    String? address,
  }) async {
    try {
      final uid = currentUserUid;
      if (uid.isEmpty) return; // Skip if not authenticated

      await _logBehavior(
        behaviorType: 'service_detail_view',
        metadata: {
          'serviceName': serviceName,
          'serviceType': serviceType,
          'address': address,
        },
      );
    } catch (e) {
      print('Error tracking service detail view: $e');
    }
  }

  /// Track when user uses directions/navigation
  Future<void> trackDirectionsUsed({
    required String destinationName,
    required String destinationAddress,
  }) async {
    try {
      final uid = currentUserUid;
      if (uid.isEmpty) return;

      await _logBehavior(
        behaviorType: 'directions_used',
        metadata: {
          'destinationName': destinationName,
          'destinationAddress': destinationAddress,
        },
      );
    } catch (e) {
      print('Error tracking directions: $e');
    }
  }

  /// Track when user calls a service
  Future<void> trackServiceCall({
    required String serviceName,
    required String phoneNumber,
  }) async {
    try {
      final uid = currentUserUid;
      if (uid.isEmpty) return;

      await _logBehavior(
        behaviorType: 'service_call',
        metadata: {
          'serviceName': serviceName,
          'phoneNumber': phoneNumber, // Store without formatting for privacy
        },
      );
    } catch (e) {
      print('Error tracking service call: $e');
    }
  }

  /// Track when user selects a destination for transport
  /// This helps verify they're selecting eligible destinations (not random)
  Future<void> trackDestinationSelected({
    required String destinationName,
    required String destinationAddress,
    required String serviceType,
  }) async {
    try {
      final uid = currentUserUid;
      if (uid.isEmpty) return;

      await _logBehavior(
        behaviorType: 'destination_selected',
        metadata: {
          'destinationName': destinationName,
          'destinationAddress': destinationAddress,
          'serviceType': serviceType,
        },
      );
    } catch (e) {
      print('Error tracking destination selection: $e');
    }
  }

  /// Track transport request attempt
  /// This is called right before the AI evaluates
  Future<void> trackTransportRequestAttempt({
    required String destinationAddress,
    required String agencyId,
    required String fareLabel,
  }) async {
    try {
      final uid = currentUserUid;
      if (uid.isEmpty) return;

      await _logBehavior(
        behaviorType: 'transport_request_attempt',
        metadata: {
          'destinationAddress': destinationAddress,
          'agencyId': agencyId,
          'fareLabel': fareLabel,
        },
      );
    } catch (e) {
      print('Error tracking transport request attempt: $e');
    }
  }

  /// Internal method to log behavior to Firestore
  Future<void> _logBehavior({
    required String behaviorType,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final uid = currentUserUid;
      if (uid.isEmpty) return;

      final behaviorDoc = {
        'uid': uid,
        'behaviorType': behaviorType,
        'metadata': metadata,
        'timestamp': FieldValue.serverTimestamp(),
        'date': DateTime.now().toIso8601String().split('T')[0], // YYYY-MM-DD
        'hour': DateTime.now().hour, // 0-23
      };

      // Store in userBehavior collection
      await _firestore.collection('userBehaviors').add(behaviorDoc);
    } catch (e) {
      print('Error logging behavior: $e');
      // Don't throw - tracking failures shouldn't break the app
    }
  }

  /// Get behavior summary for current user (last 7 days)
  /// Used by trust score evaluation
  Future<Map<String, dynamic>> getBehaviorSummary({int days = 7}) async {
    try {
      final uid = currentUserUid;
      if (uid.isEmpty) {
        return _emptySummary();
      }

      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      final cutoffTimestamp = Timestamp.fromDate(cutoffDate);

      // Query behaviors from last N days
      final querySnapshot = await _firestore
          .collection('userBehaviors')
          .where('uid', isEqualTo: uid)
          .where('timestamp', isGreaterThan: cutoffTimestamp)
          .orderBy('timestamp', descending: true)
          .get();

      final behaviors = querySnapshot.docs.map((doc) => doc.data()).toList();

      // Count behaviors by type
      final behaviorCounts = <String, int>{};
      final serviceViews = <String>{};
      final destinationsSelected = <String>{};
      final times = <int>[]; // Track hours of day

      for (var behavior in behaviors) {
        final type = behavior['behaviorType'] as String? ?? '';
        behaviorCounts[type] = (behaviorCounts[type] ?? 0) + 1;

        if (type == 'service_detail_view') {
          final serviceName = behavior['metadata']?['serviceName'] as String?;
          if (serviceName != null) {
            serviceViews.add(serviceName);
          }
        }

        if (type == 'destination_selected') {
          final dest = behavior['metadata']?['destinationAddress'] as String?;
          if (dest != null) {
            destinationsSelected.add(dest);
          }
        }

        final hour = behavior['hour'] as int?;
        if (hour != null) {
          times.add(hour);
        }
      }

      // Calculate timing pattern metrics
      final timingMetrics = _calculateTimingMetrics(times, behaviors.length);

      return {
        'totalBehaviors': behaviors.length,
        'behaviorCounts': behaviorCounts,
        'uniqueServiceViews': serviceViews.length,
        'uniqueDestinations': destinationsSelected.length,
        'hasDirectionsUsed':
            behaviorCounts['directions_used'] != null &&
            behaviorCounts['directions_used']! > 0,
        'hasServiceCalls':
            behaviorCounts['service_call'] != null &&
            behaviorCounts['service_call']! > 0,
        'timingMetrics': timingMetrics,
        'behaviors': behaviors,
      };
    } catch (e) {
      print('Error getting behavior summary: $e');
      return _emptySummary();
    }
  }

  Map<String, dynamic> _emptySummary() {
    return {
      'totalBehaviors': 0,
      'behaviorCounts': <String, int>{},
      'uniqueServiceViews': 0,
      'uniqueDestinations': 0,
      'hasDirectionsUsed': false,
      'hasServiceCalls': false,
      'timingMetrics': <String, dynamic>{},
      'behaviors': <Map<String, dynamic>>[],
    };
  }

  /// Calculate timing pattern metrics
  /// Realistic patterns: behaviors spread over time, not all at once
  Map<String, dynamic> _calculateTimingMetrics(
    List<int> times,
    int totalBehaviors,
  ) {
    if (times.isEmpty || totalBehaviors == 0) {
      return {
        'avgTimeBetweenActions': null,
        'timeDistribution': <String, int>{},
        'hasSpamPattern': false,
      };
    }

    // Group behaviors by hour
    final hourDistribution = <int, int>{};
    for (var hour in times) {
      hourDistribution[hour] = (hourDistribution[hour] ?? 0) + 1;
    }

    // Check for spam pattern: many actions in short time
    // If >70% of actions happen in <3 different hours, likely spam
    final uniqueHours = hourDistribution.length;
    final spamThreshold = (totalBehaviors * 0.7).ceil();
    bool hasSpamPattern = false;

    // Check if any single hour has too many actions
    for (var count in hourDistribution.values) {
      if (count > spamThreshold) {
        hasSpamPattern = true;
        break;
      }
    }

    // Calculate average time between actions (if we have timestamps)
    // For now, return distribution info
    return {
      'uniqueHours': uniqueHours,
      'hourDistribution': hourDistribution,
      'hasSpamPattern': hasSpamPattern,
      'totalBehaviors': totalBehaviors,
    };
  }
}
