import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/crisis_case.dart';
import '../../models/profile_models.dart';

abstract class AppStorage {
  Future<void> saveCrisis(CrisisCase crisis);
  Future<CrisisCase?> loadCrisis();
  Future<void> clearCrisis();
  Future<void> saveProfile(SafetyProfile profile);
  Future<SafetyProfile?> loadProfile();
  Future<void> saveFamily(List<FamilyMemberCard> members);
  Future<List<FamilyMemberCard>> loadFamily();
  Future<void> clearAllUserData();
}

class LocalAppStorage implements AppStorage {
  static const _crisisKey = 'ssl_crisis_case';
  static const _profileKey = 'ssl_safety_profile';
  static const _familyKey = 'ssl_family_cards';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _p async =>
      _prefs ??= await SharedPreferences.getInstance();

  @override
  Future<void> saveCrisis(CrisisCase crisis) async {
    final p = await _p;
    await p.setString(_crisisKey, jsonEncode(crisis.toJson()));
  }

  @override
  Future<CrisisCase?> loadCrisis() async {
    final p = await _p;
    final raw = p.getString(_crisisKey);
    if (raw == null) return null;
    try {
      return CrisisCase.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Failed to load crisis: $e');
      return null;
    }
  }

  @override
  Future<void> clearCrisis() async {
    final p = await _p;
    await p.remove(_crisisKey);
  }

  @override
  Future<void> saveProfile(SafetyProfile profile) async {
    final p = await _p;
    await p.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  @override
  Future<SafetyProfile?> loadProfile() async {
    final p = await _p;
    final raw = p.getString(_profileKey);
    if (raw == null) return null;
    return SafetyProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> saveFamily(List<FamilyMemberCard> members) async {
    final p = await _p;
    await p.setString(
      _familyKey,
      jsonEncode(members.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<List<FamilyMemberCard>> loadFamily() async {
    final p = await _p;
    final raw = p.getString(_familyKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => FamilyMemberCard.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> clearAllUserData() async {
    final p = await _p;
    await p.remove(_crisisKey);
    await p.remove(_profileKey);
    await p.remove(_familyKey);
  }
}
