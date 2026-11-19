import 'package:flutter/material.dart';

import '../badges.dart';
import '../content/skills.dart';
import '../models.dart';
import '../state.dart';
import '../subjects.dart';
import '../util.dart';
import 'profile_edit_screen.dart';

// ───────────────────────── PIN ─────────────────────────

class PinPad extends StatelessWidget {
  final String value;
  final void Function(String digit) onDigit;
  final VoidCallback onBack;
  const PinPad({super.key, required this.value, required this.onDigit, required this.onBack});

  @override
  Widget build(BuildContext context) {
    Widget key(String label, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: 76,
            height: 76,
            child: FilledButton.tonal(
              onPressed: onTap,
              style: FilledButton.styleFrom(shape: const CircleBorder()),
              child: Text(label, style: const TextStyle(fontSize: 28)),
            ),
          ),
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 4; i++)
              Container(
                margin: const EdgeInsets.all(8),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < value.length ? const Color(0xFF5E35B1) : Colors.black12,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [for (final d in row) key(d, () => onDigit(d))]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 92),
            key('0', () => onDigit('0')),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 76,
                height: 76,
                child: IconButton(onPressed: onBack, icon: const Icon(Icons.backspace_outlined, size: 28)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ParentGateScreen extends StatefulWidget {
  final AppState state;
  final bool changePin;
  const ParentGateScreen({super.key, required this.state, this.changePin = false});

  @override
  State<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends State<ParentGateScreen> {
  String entry = '';
  String? firstPin;
  String message = '';

  bool get settingPin => widget.state.pin == null || widget.changePin;

  void _digit(String d) {
    if (entry.length >= 4) return;
    setState(() => entry += d);
    if (entry.length == 4) Future<void>.delayed(const Duration(milliseconds: 150), _complete);
  }

  void _complete() {
    if (!mounted) return;
    if (settingPin) {
      if (firstPin == null) {
        setState(() {
          firstPin = entry;
          entry = '';
          message = 'Powtórz PIN';
        });
      } else if (firstPin == entry) {
        widget.state.setPin(entry);
        if (widget.changePin) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => ParentDashboard(state: widget.state)));
        }
      } else {
        setState(() {
          firstPin = null;
          entry = '';
          message = 'PIN-y się różnią. Spróbuj od nowa.';
        });
      }
    } else {
      if (entry == widget.state.pin) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => ParentDashboard(state: widget.state)));
      } else {
        setState(() {
          entry = '';
          message = 'Nieprawidłowy PIN';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = settingPin
        ? (firstPin == null ? 'Ustaw 4-cyfrowy PIN rodzica' : 'Powtórz PIN')
        : 'Podaj PIN rodzica';
    return Scaffold(
      appBar: AppBar(title: const Text('Panel rodzica')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: Color(0xFF5E35B1)),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              if (message.isNotEmpty && !(settingPin && firstPin != null && message == 'Powtórz PIN'))
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(message, style: const TextStyle(color: Color(0xFFD84315))),
                ),
              const SizedBox(height: 16),
              PinPad(
                value: entry,
                onDigit: _digit,
                onBack: () {
                  if (entry.isNotEmpty) setState(() => entry = entry.substring(0, entry.length - 1));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── PANEL ─────────────────────────

class ParentDashboard extends StatelessWidget {
  final AppState state;
  const ParentDashboard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Panel rodzica'),
          actions: [
            IconButton(
              tooltip: 'Zmień PIN',
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ParentGateScreen(state: state, changePin: true))),
              icon: const Icon(Icons.pin_outlined),
            ),
          ],
        ),
        body: state.profiles.isEmpty
            ? const Center(child: Text('Nie ma jeszcze żadnego ucznia.'))
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (final p in state.profiles) _summary(context, p),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Dziecko widzi tylko gwiazdki i odznaki. Statystyki trudniejszych tematów są widoczne wyłącznie tutaj, '
                      'a aplikacja sama częściej podsuwa zadania, które idą słabiej. Wszystkie dane zostają na tym telefonie.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _summary(BuildContext context, Profile p) {
    final week = _lastDays(p, 7);
    final minutes = (week.fold<int>(0, (a, e) => a + e.$2) / 60).round();
    final activeDays = week.where((e) => e.$2 > 0 || (p.dayCorrect[e.$1] ?? 0) > 0).length;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Text(p.avatar, style: const TextStyle(fontSize: 40)),
        title: Text('${p.name} • klasa ${p.grade}', style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('Ostatnie 7 dni: $minutes min, aktywne dni: $activeDays\n'
            'Zadania: ${p.correct} • odznaki: ${p.badges.length}/${allBadges.length}'),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => ProfileStatsScreen(state: state, profile: p))),
      ),
    );
  }
}

/// (klucz dnia, sekundy) dla ostatnich n dni, od najstarszego.
List<(String, int)> _lastDays(Profile p, int n) {
  final now = DateTime.now();
  final out = <(String, int)>[];
  for (int i = n - 1; i >= 0; i--) {
    final k = dayKey(DateTime(now.year, now.month, now.day - i));
    out.add((k, p.daySeconds[k] ?? 0));
  }
  return out;
}

class ProfileStatsScreen extends StatelessWidget {
  final AppState state;
  final Profile profile;
  const ProfileStatsScreen({super.key, required this.state, required this.profile});

  static const _wd = ['pn', 'wt', 'śr', 'cz', 'pt', 'sb', 'nd'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final p = profile;
        final seen = <String>{};
        final skillRows = <SkillDef>[
          for (final s in allSkills)
            if ((s.grade == p.grade || p.skills.containsKey(s.id)) && seen.add(s.id)) s,
        ]..sort((a, b) => a.subject.compareTo(b.subject));
        final subjectTiles = p.subjectCorrect.entries.where((e) => e.value > 0).toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final weak = skillRows
            .where((s) => (p.skills[s.id]?.attempts ?? 0) >= 3 && (p.skills[s.id]?.rate ?? 1) < 0.6)
            .toList()
          ..sort((a, b) => p.skills[a.id]!.rate.compareTo(p.skills[b.id]!.rate));
        return Scaffold(
          appBar: AppBar(
            title: Text('${p.avatar} ${p.name}'),
            actions: [
              IconButton(
                tooltip: 'Edytuj',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ProfileEditScreen(state: state, profile: p))),
              ),
              IconButton(
                tooltip: 'Usuń',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _stat('Klasa', '${p.grade}'),
                  _stat('Gwiazdki', '⭐ ${p.stars}'),
                  _stat('Zadania', '${p.correct}'),
                  for (final e in subjectTiles) _stat(subjectMeta(e.key).name, '${subjectMeta(e.key).emoji} ${e.value}'),
                  _stat('Dni z rzędu', '🔥 ${p.streak}'),
                  _stat('Odznaki', '${p.badges.length}/${allBadges.length}'),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Czas nauki – ostatnie 7 dni', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _weekChart(p),
              const SizedBox(height: 20),
              if (weak.isNotEmpty) ...[
                const Text('Warto poćwiczyć', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                for (final s in weak.take(3))
                  ListTile(
                    dense: true,
                    leading: const Text('🔁', style: TextStyle(fontSize: 22)),
                    title: Text(s.name),
                    subtitle: Text('Za pierwszym razem: ${(p.skills[s.id]!.rate * 100).round()}% '
                        '(${p.skills[s.id]!.attempts} zadań). Aplikacja podsuwa to częściej.'),
                  ),
                const SizedBox(height: 12),
              ],
              const Text('Umiejętności', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              for (final s in skillRows) _skillRow(s, p.skills[s.id]),
            ],
          ),
        );
      },
    );
  }

  Widget _stat(String label, String value) => Container(
        width: 104,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFFEDE7F6), borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      );

  Widget _weekChart(Profile p) {
    final days = _lastDays(p, 7);
    final maxS = days.fold<int>(60, (a, e) => e.$2 > a ? e.$2 : a);
    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final d in days)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${(d.$2 / 60).round()}', style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 2),
                  Container(
                    height: 80 * d.$2 / maxS + 2,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7E57C2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(_wd[DateTime.parse(d.$1).weekday - 1], style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _skillRow(SkillDef s, SkillStat? st) {
    final attempts = st?.attempts ?? 0;
    final rate = st?.rate ?? 0;
    String label;
    Color color;
    if (attempts < 3) {
      label = attempts == 0 ? 'jeszcze nie ćwiczone' : 'za mało zadań';
      color = Colors.black26;
    } else if (rate >= 0.8) {
      label = 'opanowane ✅';
      color = const Color(0xFF43A047);
    } else if (rate >= 0.6) {
      label = 'ćwiczy 🙂';
      color = const Color(0xFFFFA000);
    } else {
      label = 'warto powtórzyć 🔁';
      color = const Color(0xFFE64A19);
    }
    final subj = subjectMeta(s.subject).emoji;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('$subj ${s.name}', style: const TextStyle(fontWeight: FontWeight.w600))),
              Text(label, style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: attempts == 0 ? 0 : rate,
              minHeight: 8,
              backgroundColor: Colors.black12,
              color: color,
            ),
          ),
          if (attempts > 0)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('$attempts zadań, ${(rate * 100).round()}% za pierwszym razem',
                  style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usunąć profil?'),
        content: Text('Profil „${profile.name}” i wszystkie jego postępy zostaną usunięte.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Anuluj')),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              state.deleteProfile(profile);
            },
            child: const Text('Usuń'),
          ),
        ],
      ),
    );
  }
}
