import 'util.dart';

enum TaskKind { choice, order, match, trace }

class Pair {
  final String a;
  final String b;
  const Pair(this.a, this.b);
}

/// Jedna karta w feedzie – interaktywne zadanie.
class Task {
  final String skill;
  final String subject; // math | polish | art
  final TaskKind kind;
  final String prompt;
  final String speak;
  final String visual; // duży tekst (np. "3 + 4 = ?")
  final List<String> items; // emoji do liczenia
  final List<String> options; // odpowiedzi (choice)
  final int answer;
  final List<String> pieces; // poprawna kolejność (order)
  final List<Pair> pairs; // pary (match)
  final String shape; // kształt do rysowania (trace)
  final String hint;
  final String explain;

  Task({
    required this.skill,
    required this.subject,
    required this.kind,
    required this.prompt,
    String? speak,
    this.visual = '',
    this.items = const [],
    this.options = const [],
    this.answer = 0,
    this.pieces = const [],
    this.pairs = const [],
    this.shape = '',
    this.hint = '',
    this.explain = '',
  }) : speak = speak ?? prompt;
}

class SkillStat {
  int attempts;
  int firstTry;
  SkillStat({this.attempts = 0, this.firstTry = 0});

  double get rate => attempts == 0 ? 0 : firstTry / attempts;

  Map<String, dynamic> toJson() => {'a': attempts, 'f': firstTry};

  factory SkillStat.fromJson(dynamic j) {
    if (j is! Map) return SkillStat();
    return SkillStat(
      attempts: (j['a'] as num?)?.toInt() ?? 0,
      firstTry: (j['f'] as num?)?.toInt() ?? 0,
    );
  }
}

class Profile {
  String id;
  String name;
  String avatar;
  int grade;

  int stars = 0;
  int correct = 0;
  int drawings = 0;
  int persistence = 0; // zadania zrobione po kolejnej próbie
  int run = 0;
  int bestRun = 0;
  Map<String, int> subjectCorrect = {};
  Map<String, SkillStat> skills = {};
  Map<String, int> dayCorrect = {};
  Map<String, int> daySeconds = {};
  List<String> dailyDone = [];
  List<String> weeklyDone = [];
  Map<String, String> badges = {};

  Profile({
    required this.id,
    required this.name,
    required this.avatar,
    required this.grade,
  });

  int get streak {
    final now = DateTime.now();
    var d = DateTime(now.year, now.month, now.day);
    if (!dayCorrect.containsKey(dayKey(d))) {
      d = DateTime(d.year, d.month, d.day - 1);
    }
    int s = 0;
    while (dayCorrect.containsKey(dayKey(d))) {
      s++;
      d = DateTime(d.year, d.month, d.day - 1);
    }
    return s;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'grade': grade,
        'stars': stars,
        'correct': correct,
        'drawings': drawings,
        'persistence': persistence,
        'run': run,
        'bestRun': bestRun,
        'subjectCorrect': subjectCorrect,
        'skills': skills.map<String, dynamic>((k, v) => MapEntry(k, v.toJson())),
        'dayCorrect': dayCorrect,
        'daySeconds': daySeconds,
        'dailyDone': dailyDone,
        'weeklyDone': weeklyDone,
        'badges': badges,
      };

  static Map<String, int> _mi(dynamic v) {
    if (v is! Map) return <String, int>{};
    return v.map<String, int>((k, x) => MapEntry(k.toString(), (x as num).toInt()));
  }

  static List<String> _ls(dynamic v) {
    if (v is! List) return <String>[];
    return v.map((e) => e.toString()).toList();
  }

  factory Profile.fromJson(Map<String, dynamic> j) {
    final p = Profile(
      id: j['id']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: j['name']?.toString() ?? 'Uczeń',
      avatar: j['avatar']?.toString() ?? '🦊',
      grade: (j['grade'] as num?)?.toInt() ?? 1,
    );
    p.stars = (j['stars'] as num?)?.toInt() ?? 0;
    p.correct = (j['correct'] as num?)?.toInt() ?? 0;
    p.drawings = (j['drawings'] as num?)?.toInt() ?? 0;
    p.persistence = (j['persistence'] as num?)?.toInt() ?? 0;
    p.run = (j['run'] as num?)?.toInt() ?? 0;
    p.bestRun = (j['bestRun'] as num?)?.toInt() ?? 0;
    p.subjectCorrect = _mi(j['subjectCorrect']);
    final sk = j['skills'];
    if (sk is Map) {
      p.skills = sk.map<String, SkillStat>((k, v) => MapEntry(k.toString(), SkillStat.fromJson(v)));
    }
    p.dayCorrect = _mi(j['dayCorrect']);
    p.daySeconds = _mi(j['daySeconds']);
    p.dailyDone = _ls(j['dailyDone']);
    p.weeklyDone = _ls(j['weeklyDone']);
    final b = j['badges'];
    if (b is Map) {
      p.badges = b.map<String, String>((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return p;
  }
}
