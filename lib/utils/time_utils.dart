// lib/utils/time_utils.dart
import 'package:flutter/material.dart';

DateTime parseAlarmTime(String timeStr, DateTime baseDate) {
  String trimmed = timeStr.trim().toUpperCase();
  int hour, minute;

  if (trimmed.contains('AM') || trimmed.contains('PM')) {
    final parts = trimmed.split(' ');
    final timePart = parts[0];
    final meridian = parts[1];
    final isPM = meridian == 'PM';
    final timeComps = timePart.split(':');
    hour = int.parse(timeComps[0]);
    minute = int.parse(timeComps[1]);
    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;
  } else {
    final timeComps = trimmed.split(':');
    hour = int.parse(timeComps[0]);
    minute = int.parse(timeComps[1]); 
  }

  return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
}