import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

String prettyDateHeader(DateTime stamp) {
  if (stamp == null) return '';

  // helper to check same calendar day:
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));

  if (_isSameDay(stamp, now)) {
    // e.g. “Today, August 5”
    return 'Today, ${DateFormat('MMMM d').format(stamp)}';
  } else if (_isSameDay(stamp, yesterday)) {
    // e.g. “Yesterday, August 4”
    return 'Yesterday, ${DateFormat('MMMM d').format(stamp)}';
  } else {
    // any earlier day: “August 1”
    return DateFormat('MMMM d').format(stamp);
  }
}
