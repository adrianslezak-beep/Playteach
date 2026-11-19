import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'badges.dart';
import 'models.dart';
import 'util.dart';

class AppState extends ChangeNotifier {
  static const _key = 'playteach_v1';

  List<Profile> profiles = [];
  String? pin;

  Future<void> load() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final s = sp.getString(_key);
      if (s != null) {
        final j = jsonDecode(s);
        if (j is Map) {
          pin = j['pin'] as String?;
          final list = j['profiles'];
          if (list is List) {
            profiles = list
                .whereType<Map>()
                .map((e) => Profile.fromJson(Map<String, dynamic>.from(e)))
                .toList();
          }
        }
      }
    } catch (_) {}
  }

  Future<void> save() async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setString(
        _key,
        jsonEncode({'pin': pin, 'profiles': profiles.map((p) => p.toJson()).toList()}),
      );
    } catch (_) {}
  }

  void touch() {
    notifyListeners();
    save();
  }

  Profile addProfile(String name, String avatar, int grade) {
    final p = Profile(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      avatar: avatar,
      grade: grade,
    );
    profiles.add(p);
    touch();
    return p;
  }

  void deleteProfile(Profile p) {
    profiles.removeWhere((e) => e.id == p.id);
    touch();
  }

  void setPin(String value) {
    pin = value;
    touch();
  }

  List<BadgeDef> _checkBadges(Profile p) {
    final out = <BadgeDef>[];
    for (final b in allBadges) {
      if (!p.badges.containsKey(b.id) && b.test(p)) {
        p.badges[b.id] = todayKey();
        out.add(b);
      }
    }
    return out;
  }

  void _addSeconds(Profile p, int seconds) {
    if (seconds <= 0) return;
    final k = todayKey();
    p.daySeconds[k] = (p.daySeconds[k] ?? 0) + seconds;
  }

  /// Zapis czasu bez powiadamiania (bezpieczne w dispose()).
  void addSecondsSilently(Profile p, int seconds) {
    _addSeconds(p, seconds);
    save();
  }

  List<BadgeDef> recordResult(Profile p, Task t, int mistakes, int seconds) {
    p.stars += 1;
    p.correct += 1;
    p.subjectCorrect[t.subject] = (p.subjectCorrect[t.subject] ?? 0) + 1;
    final s = p.skills.putIfAbsent(t.skill, () => SkillStat());
    s.attempts++;
    if (mistakes == 0) {
      s.firstTry++;
      p.run++;
      if (p.run > p.bestRun) p.bestRun = p.run;
    } else {
      p.run = 0;
      p.persistence++;
    }
    if (t.kind == TaskKind.trace) p.drawings++;
    final k = todayKey();
    p.dayCorrect[k] = (p.dayCorrect[k] ?? 0) + 1;
    _addSeconds(p, seconds);
    final b = _checkBadges(p);
    touch();
    return b;
  }

  List<BadgeDef> recordChallenge(Profile p, bool weekly) {
    final now = DateTime.now();
    if (weekly) {
      final k = weekKey(now);
      if (!p.weeklyDone.contains(k)) p.weeklyDone.add(k);
    } else {
      final k = dayKey(now);
      if (!p.dailyDone.contains(k)) p.dailyDone.add(k);
    }
    p.stars += weekly ? 10 : 5;
    final b = _checkBadges(p);
    touch();
    return b;
  }
}
