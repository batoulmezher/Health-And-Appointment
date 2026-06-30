import 'package:flutter/material.dart';

class SpecialtyModel {
  final String name;
  final IconData icon;
  final int doctorCount;
  final String imageUrl;

  SpecialtyModel({
    required this.name,
    required this.icon,
    required this.doctorCount,
    required this.imageUrl,
  });
}