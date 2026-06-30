import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/specialty_model.dart';

class SpecialtiesController extends GetxController {
  final searchController = TextEditingController();
  var filteredSpecialties = <SpecialtyModel>[].obs;

  final List<SpecialtyModel> allSpecialties = [
    SpecialtyModel(
      name: 'جراحة القلب',
      icon: Icons.favorite,
      doctorCount: 45,
      imageUrl: 'https://images.unsplash.com/photo-1628595351029-d4cbc4c7a1e1?w=150&h=150&fit=crop',
    ),
    SpecialtyModel(
      name: 'طب الأطفال',
      icon: Icons.child_care,
      doctorCount: 62,
      imageUrl: 'https://images.unsplash.com/photo-1581056771107-24ca5f033842?w=150&h=150&fit=crop',
    ),
    SpecialtyModel(
      name: 'طب الأسنان',
      icon: Icons.medical_services,
      doctorCount: 38,
      imageUrl: 'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?w=150&h=150&fit=crop',
    ),
    SpecialtyModel(
      name: 'الأعصاب',
      icon: Icons.psychology,
      doctorCount: 28,
      imageUrl: 'https://images.unsplash.com/photo-1559757175-5700dde675bc?w=150&h=150&fit=crop',
    ),
    SpecialtyModel(
      name: 'الباطنية',
      icon: Icons.healing,
      doctorCount: 55,
      imageUrl: 'https://images.unsplash.com/photo-1583912267553-b9e9d0f4dc19?w=150&h=150&fit=crop',
    ),
    SpecialtyModel(
      name: 'جراحة العظام',
      icon: Icons.accessibility_new,
      doctorCount: 33,
      imageUrl: 'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=150&h=150&fit=crop',
    ),
    SpecialtyModel(
      name: 'طب العيون',
      icon: Icons.visibility,
      doctorCount: 41,
      imageUrl: 'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=150&h=150&fit=crop',
    ),
    SpecialtyModel(
      name: 'الجلدية',
      icon: Icons.spa,
      doctorCount: 25,
      imageUrl: 'https://images.unsplash.com/photo-1580519542036-c47de6196ba5?w=150&h=150&fit=crop',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    filteredSpecialties.value = allSpecialties;
  }

  void filterSpecialties(String query) {
    if (query.isEmpty) {
      filteredSpecialties.value = allSpecialties;
      return;
    }
    filteredSpecialties.value = allSpecialties
        .where((spec) => spec.name.contains(query))
        .toList();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}