import 'dart:math';

import '../models.dart';
import '../util.dart';
import 'common.dart';
import 'words.dart';

const _p = 'polish';

const String _vowels = 'aeiouyąęó';
const List<String> _consonants = [
  'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'ł', 'm', 'n', 'p', 'r', 's', 't', 'w', 'z'
];
const List<String> _letters = [
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'Ł', 'M', 'N', 'O', 'P', 'R', 'S', 'Ś', 'T', 'U', 'W', 'Z', 'Ż'
];

// ───────────────────────── KLASA 1 ─────────────────────────

Task p1Letter(Random r) {
  final w = pick(r, words);
  final first = w.w[0].toUpperCase();
  final others = pickN(r, _letters.where((l) => l != first).toList(), 2);
  return choice('p1_letter', _p, 'Od jakiej litery zaczyna się to słowo?', shuffled(r, [first, ...others]), first,
      speak: 'Od jakiej litery zaczyna się słowo: ${w.w}?',
      visual: '${w.e}\n_${w.w.substring(1)}',
      hint: 'Powiedz głośno: ${w.w}. Jaki dźwięk słyszysz na początku?',
      explain: '${w.w[0].toUpperCase()}${w.w.substring(1)}');
}

Task p1Syllables(Random r) {
  final w = pick(r, words);
  final c = w.sylCount;
  return choice('p1_syllables', _p, 'Ile sylab ma to słowo?', const ['1', '2', '3', '4'], '$c',
      speak: 'Ile sylab ma słowo: ${w.w}?',
      visual: '${w.e}\n${w.w}',
      hint: 'Powiedz słowo powoli i klaśnij przy każdej części 👏',
      explain: w.syl.replaceAll('-', ' – '));
}

Task p1Build(Random r) {
  final pool = words.where((w) => w.w.length >= 3 && w.w.length <= 5).toList();
  final w = pick(r, pool);
  return Task(
    skill: 'p1_build',
    subject: _p,
    kind: TaskKind.order,
    prompt: 'Ułóż słowo z literek',
    speak: 'Ułóż słowo: ${w.w}',
    visual: w.e,
    pieces: w.w.split(''),
    hint: 'Powiedz powoli: ${w.w}. Jaka literka jest pierwsza?',
    explain: w.w,
  );
}

Task p1Match(Random r) {
  final ws = pickN(r, words, 3);
  return Task(
    skill: 'p1_match',
    subject: _p,
    kind: TaskKind.match,
    prompt: 'Połącz obrazek ze słowem',
    pairs: ws.map((w) => Pair(w.e, w.w)).toList(),
    hint: 'Dotknij obrazka, a potem pasującego słowa.',
  );
}

Task p1Vowel(Random r) {
  final v = _vowels[r.nextInt(_vowels.length)];
  final cs = pickN(r, _consonants, 2);
  return choice('p1_vowel', _p, 'Która litera to samogłoska?', shuffled(r, [v, ...cs]), v,
      hint: 'Samogłoski to: a, e, i, o, u, y, ą, ę, ó.',
      explain: 'Samogłoski: a, e, i, o, u, y, ą, ę, ó');
}

// ───────────────────────── KLASA 2 ─────────────────────────

const List<List<String>> _ou = [
  ['g_ra', 'ó'], ['kr_l', 'ó'], ['st_ł', 'ó'], ['r_ża', 'ó'], ['w_z', 'ó'], ['n_ż', 'ó'],
  ['og_rek', 'ó'], ['oł_wek', 'ó'], ['m_zg', 'ó'], ['k_łko', 'ó'],
  ['m_cha', 'u'], ['k_ra', 'u'], ['b_t', 'u'], ['_l', 'u'], ['_cho', 'u'], ['z_pa', 'u'],
  ['l_stro', 'u'], ['k_bek', 'u'], ['szn_rek', 'u'], ['chm_ra', 'u'],
];

const List<List<String>> _rz = [
  ['_eka', 'rz'], ['d_ewo', 'rz'], ['mo_e', 'rz'], ['bu_a', 'rz'], ['_epa', 'rz'],
  ['g_yb', 'rz'], ['o_ech', 'rz'], ['k_esło', 'rz'], ['wa_ywa', 'rz'], ['_odkiewka', 'rz'],
  ['_aba', 'ż'], ['_ółw', 'ż'], ['_yrafa', 'ż'], ['ły_ka', 'ż'], ['wie_a', 'ż'],
  ['je_', 'ż'], ['_uk', 'ż'], ['_aglówka', 'ż'], ['ró_a', 'ż'], ['no_yczki', 'ż'],
];

const List<List<String>> _ch = [
  ['_leb', 'ch'], ['_mura', 'ch'], ['mu_a', 'ch'], ['u_o', 'ch'], ['_omik', 'ch'],
  ['du_', 'ch'], ['ku_nia', 'ch'], ['_łopiec', 'ch'], ['da_', 'ch'], ['ru_', 'ch'],
  ['_erbata', 'h'], ['_amak', 'h'], ['_ipopotam', 'h'], ['_ałas', 'h'], ['_uśtawka', 'h'],
  ['_otel', 'h'], ['bo_ater', 'h'], ['_elikopter', 'h'], ['_okej', 'h'], ['_ejnał', 'h'],
];

Task _ortho(Random r, String skill, List<List<String>> data, List<String> opts, String rule) {
  final d = pick(r, data);
  final full = d[0].replaceAll('_', d[1]);
  return choice(skill, _p, 'Wstaw brakującą literę', opts, d[1],
      speak: 'Jak napiszesz słowo: $full?',
      visual: d[0].replaceAll('_', '__'),
      hint: rule,
      explain: full);
}

Task p2Ou(Random r) => _ortho(r, 'p2_ou', _ou, const ['ó', 'u'],
    'Ó często wymienia się na o: stół – stoły, król – królowa.');

Task p2Rz(Random r) => _ortho(r, 'p2_rz', _rz, const ['rz', 'ż'],
    'Rz często wymienia się na r (morze – morski), a ż na g (noga – nóżka).');

Task p2Ch(Random r) => _ortho(r, 'p2_ch', _ch, const ['ch', 'h'],
    'Na końcu słowa piszemy zwykle ch: dach, duch, ruch.');

const List<String> _sentences2 = [
  'Ala ma kota.',
  'Kot pije mleko.',
  'Tata czyta gazetę.',
  'Mama piecze ciasto.',
  'Ola jedzie rowerem.',
  'Pies biega po łące.',
  'Słońce mocno świeci.',
  'Zimą pada śnieg.',
  'Lubię czytać książki.',
  'Ptaki śpiewają rano.',
  'Babcia robi pyszne pierogi.',
  'Janek gra w piłkę.',
];

const List<String> _sentences3 = [
  'W lesie mieszka mały jeż.',
  'Dzieci bawią się na podwórku.',
  'Latem jedziemy nad morze.',
  'Mój brat lubi grać w szachy.',
  'Na drzewie siedzi kolorowy ptak.',
  'Babcia upiekła pyszne ciasto z jabłkami.',
  'Jesienią liście spadają z drzew.',
  'Po lekcjach odrabiam pracę domową.',
  'Wieczorem tata czyta mi bajkę.',
  'Kasia narysowała piękną tęczę.',
];

Task _sentence(Random r, String skill, List<String> list) {
  final s = pick(r, list);
  return Task(
    skill: skill,
    subject: _p,
    kind: TaskKind.order,
    prompt: 'Ułóż zdanie z wyrazów',
    speak: 'Ułóż zdanie z wyrazów.',
    pieces: s.split(' '),
    hint: 'Zdanie zaczyna się wielką literą, a kończy kropką.',
    explain: s,
  );
}

Task p2Sentence(Random r) => _sentence(r, 'p2_sentence', _sentences2);

Task p2Abc(Random r) {
  final byLetter = <String, W>{};
  for (final w in shuffled(r, words)) {
    byLetter.putIfAbsent(w.w[0], () => w);
  }
  final chosen = pickN(r, byLetter.values.toList(), 4).map((w) => w.w).toList();
  chosen.sort(plCompare);
  return Task(
    skill: 'p2_abc',
    subject: _p,
    kind: TaskKind.order,
    prompt: 'Ułóż słowa w kolejności alfabetycznej',
    pieces: chosen,
    hint: 'Patrz na pierwszą literę: a, b, c, d, e, f, g, h, i, j, k, l, ł, m, n, o, p, r, s, t, u, w, z…',
    explain: chosen.join(' → '),
  );
}

Task p2Build(Random r) {
  final pool = words.where((w) => w.w.length >= 5 && w.w.length <= 8).toList();
  final w = pick(r, pool);
  return Task(
    skill: 'p2_build',
    subject: _p,
    kind: TaskKind.order,
    prompt: 'Ułóż słowo z liter',
    speak: 'Ułóż słowo: ${w.w}',
    visual: w.e,
    pieces: w.w.split(''),
    hint: 'Podziel słowo na sylaby: ${w.syl.replaceAll('-', ' – ')}',
    explain: w.w,
  );
}

// ───────────────────────── KLASA 3 ─────────────────────────

const Map<String, List<String>> _pos = {
  'rzeczownik': ['kot', 'dom', 'szkoła', 'drzewo', 'książka', 'rower', 'miasto', 'chleb', 'rzeka', 'okno'],
  'czasownik': ['biega', 'czyta', 'śpiewa', 'pisze', 'skacze', 'rysuje', 'gotuje', 'pływa', 'śpi', 'liczy'],
  'przymiotnik': ['zielony', 'wesoły', 'duży', 'mały', 'szybki', 'ciepły', 'kolorowy', 'mądry', 'wysoki', 'słodki'],
};

Task p3Pos(Random r) {
  final kind = pick(r, _pos.keys.toList());
  final word = pick(r, _pos[kind]!);
  return choice('p3_pos', _p, 'Jaką częścią mowy jest to słowo?', const ['rzeczownik', 'czasownik', 'przymiotnik'], kind,
      speak: 'Jaką częścią mowy jest słowo: $word?',
      visual: word,
      hint: 'Rzeczownik: kto? co?   Czasownik: co robi?   Przymiotnik: jaki?',
      explain: '„$word” to $kind');
}

const List<List<String>> _opposites = [
  ['duży', 'mały'], ['wysoki', 'niski'], ['ciepły', 'zimny'], ['szybki', 'wolny'],
  ['dzień', 'noc'], ['wesoły', 'smutny'], ['jasny', 'ciemny'], ['stary', 'młody'],
  ['góra', 'dół'], ['otwarty', 'zamknięty'], ['pełny', 'pusty'], ['długi', 'krótki'],
  ['czysty', 'brudny'], ['mokry', 'suchy'], ['głośny', 'cichy'],
];

Task p3Opposites(Random r) {
  final ps = pickN(r, _opposites, 4);
  return Task(
    skill: 'p3_opposites',
    subject: _p,
    kind: TaskKind.match,
    prompt: 'Połącz słowa o przeciwnym znaczeniu',
    pairs: ps.map((e) => Pair(e[0], e[1])).toList(),
    hint: 'Przeciwieństwo: gorący – zimny, dzień – noc.',
  );
}

const List<List<String>> _plural = [
  ['kot', 'koty', 'kota', 'kotem'],
  ['pies', 'psy', 'piesy', 'psa'],
  ['dziecko', 'dzieci', 'dziecka', 'dzieckowie'],
  ['człowiek', 'ludzie', 'człowieki', 'człowieka'],
  ['oko', 'oczy', 'oki', 'okiem'],
  ['ucho', 'uszy', 'uchy', 'uchem'],
  ['ręka', 'ręce', 'rękę', 'ręką'],
  ['dom', 'domy', 'domu', 'domem'],
  ['drzewo', 'drzewa', 'drzewu', 'drzewem'],
  ['książka', 'książki', 'książkę', 'książką'],
  ['ptak', 'ptaki', 'ptakowie', 'ptaka'],
  ['ryba', 'ryby', 'rybę', 'rybą'],
  ['krzesło', 'krzesła', 'krzesłem', 'krzesłu'],
  ['kwiat', 'kwiaty', 'kwiatem', 'kwiatu'],
  ['brat', 'bracia', 'braty', 'bratem'],
  ['rower', 'rowery', 'rowerem', 'roweru'],
];

Task p3Plural(Random r) {
  final d = pick(r, _plural);
  return choice('p3_plural', _p, 'Jak będzie w liczbie mnogiej?', shuffled(r, d.sublist(1)), d[1],
      speak: 'Jak będzie w liczbie mnogiej słowo: ${d[0]}?',
      visual: '${d[0]} ➜ ?',
      hint: 'Liczba mnoga mówi o wielu rzeczach albo osobach.',
      explain: '${d[0]} ➜ ${d[1]}');
}

Task p3Ortho(Random r) {
  switch (r.nextInt(3)) {
    case 0:
      return _ortho(r, 'p3_ortho', _ou, const ['ó', 'u'], 'Spróbuj wymienić: stół – stoły, góra – górski.');
    case 1:
      return _ortho(r, 'p3_ortho', _rz, const ['rz', 'ż'], 'Rz wymienia się na r: morze – morski.');
    default:
      return _ortho(r, 'p3_ortho', _ch, const ['ch', 'h'], 'Na końcu słowa piszemy zwykle ch.');
  }
}

Task p3Sentence(Random r) => _sentence(r, 'p3_sentence', _sentences3);

Task p3Abc(Random r) {
  final chosen = pickN(r, words, 5).map((w) => w.w).toList();
  chosen.sort(plCompare);
  return Task(
    skill: 'p3_abc',
    subject: _p,
    kind: TaskKind.order,
    prompt: 'Ułóż słowa w kolejności alfabetycznej',
    pieces: chosen,
    hint: 'Gdy pierwsze litery są takie same, patrz na drugą literę.',
    explain: chosen.join(' → '),
  );
}
