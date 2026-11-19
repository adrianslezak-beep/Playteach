import 'models.dart';

class BadgeDef {
  final String id;
  final String emoji;
  final String name;
  final String desc;
  final bool Function(Profile p) test;
  BadgeDef(this.id, this.emoji, this.name, this.desc, this.test);
}

int _sub(Profile p, String s) => p.subjectCorrect[s] ?? 0;

final List<BadgeDef> allBadges = [
  BadgeDef('first', '🌱', 'Pierwszy krok', 'Pierwsze zrobione zadanie', (p) => p.correct >= 1),
  BadgeDef('stars25', '⭐', 'Zbieracz gwiazdek', 'Zbierz 25 gwiazdek', (p) => p.stars >= 25),
  BadgeDef('stars100', '🌟', 'Gwiezdny odkrywca', 'Zbierz 100 gwiazdek', (p) => p.stars >= 100),
  BadgeDef('stars300', '💫', 'Gwiezdny mistrz', 'Zbierz 300 gwiazdek', (p) => p.stars >= 300),
  BadgeDef('stars1000', '🌌', 'Cała galaktyka', 'Zbierz 1000 gwiazdek', (p) => p.stars >= 1000),
  BadgeDef('math20', '🔢', 'Mały matematyk', '20 zadań z matematyki', (p) => _sub(p, 'math') >= 20),
  BadgeDef('math100', '🧮', 'Mistrz liczenia', '100 zadań z matematyki', (p) => _sub(p, 'math') >= 100),
  BadgeDef('pl20', '📖', 'Miłośnik słów', '20 zadań z polskiego', (p) => _sub(p, 'polish') >= 20),
  BadgeDef('pl100', '✍️', 'Mistrz słówek', '100 zadań z polskiego', (p) => _sub(p, 'polish') >= 100),
  BadgeDef('en20', '🇬🇧', 'Mały poliglota', '20 zadań z angielskiego', (p) => _sub(p, 'english') >= 20),
  BadgeDef('en100', '🗽', 'Mistrz angielskiego', '100 zadań z angielskiego', (p) => _sub(p, 'english') >= 100),
  BadgeDef('hist20', '🏛️', 'Kronikarz', '20 zadań z historii', (p) => _sub(p, 'history') >= 20),
  BadgeDef('sci20', '🔬', 'Młody naukowiec', '20 zadań z przyrody, biologii, geografii, fizyki lub chemii',
      (p) => ['nature', 'biology', 'geography', 'physics', 'chemistry'].fold<int>(0, (a, s) => a + _sub(p, s)) >= 20),
  BadgeDef('sci100', '🧪', 'Wielki odkrywca', '100 zadań z nauk przyrodniczych',
      (p) => ['nature', 'biology', 'geography', 'physics', 'chemistry'].fold<int>(0, (a, s) => a + _sub(p, s)) >= 100),
  BadgeDef('all5', '🌈', 'Wszechstronny', 'Zadania z co najmniej 5 różnych przedmiotów',
      (p) => p.subjectCorrect.values.where((v) => v > 0).length >= 5),
  BadgeDef('art1', '🖍️', 'Mały artysta', 'Pierwszy rysunek', (p) => p.drawings >= 1),
  BadgeDef('art10', '🎨', 'Artysta', '10 rysunków', (p) => p.drawings >= 10),
  BadgeDef('try10', '💪', 'Nie poddaję się', '10 zadań zrobionych po kolejnej próbie', (p) => p.persistence >= 10),
  BadgeDef('run10', '🦉', 'Sowa mądrości', '10 zadań z rzędu za pierwszym razem', (p) => p.bestRun >= 10),
  BadgeDef('days3', '🔥', 'Trzy dni z rzędu', 'Ucz się 3 dni pod rząd', (p) => p.streak >= 3),
  BadgeDef('days7', '🚀', 'Cały tydzień!', 'Ucz się 7 dni pod rząd', (p) => p.streak >= 7),
  BadgeDef('daily1', '🎯', 'Pierwsze wyzwanie', 'Ukończ wyzwanie dnia', (p) => p.dailyDone.isNotEmpty),
  BadgeDef('daily10', '🏅', 'Pogromca wyzwań', 'Ukończ 10 wyzwań dnia', (p) => p.dailyDone.length >= 10),
  BadgeDef('weekly1', '👑', 'Wielkie wyzwanie', 'Ukończ wielkie wyzwanie tygodnia', (p) => p.weeklyDone.isNotEmpty),
  BadgeDef('weekly4', '🏆', 'Król wyzwań', 'Ukończ 4 wielkie wyzwania', (p) => p.weeklyDone.length >= 4),
];
