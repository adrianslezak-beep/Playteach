import 'package:flutter/material.dart';

import '../content/skills.dart';
import '../models.dart';
import '../speaker.dart';
import '../state.dart';
import '../util.dart';
import '../widgets/badge_dialog.dart';
import '../widgets/task_host.dart';

/// Wybór wyzwania: dzienne i tygodniowe (układa je aplikacja).
class ChallengeScreen extends StatelessWidget {
  final AppState state;
  final Profile profile;
  const ChallengeScreen({super.key, required this.state, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final now = DateTime.now();
        final dailyDone = profile.dailyDone.contains(dayKey(now));
        final weeklyDone = profile.weeklyDone.contains(weekKey(now));
        return Scaffold(
          backgroundColor: const Color(0xFFEDE7F6),
          appBar: AppBar(
            backgroundColor: const Color(0xFFEDE7F6),
            title: const Text('Wyzwania', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _card(
                context,
                emoji: '🎯',
                title: 'Wyzwanie dnia',
                desc: dailyDone ? 'Ukończone! Jutro czeka nowe 🎉' : '6 zadań i jeden rysunek. Nagroda: 5 ⭐',
                done: dailyDone,
                colors: const [Color(0xFFFFB74D), Color(0xFFFF8A65)],
                onTap: () => _start(context, false),
              ),
              const SizedBox(height: 16),
              _card(
                context,
                emoji: '👑',
                title: 'Wielkie wyzwanie tygodnia',
                desc: weeklyDone
                    ? 'Ukończone! W poniedziałek nowe 🎉'
                    : '12 zadań z matematyki, polskiego i rysowania. Nagroda: 10 ⭐ i specjalna odznaka',
                done: weeklyDone,
                colors: const [Color(0xFF7E57C2), Color(0xFF5C6BC0)],
                onTap: () => _start(context, true),
              ),
            ],
          ),
        );
      },
    );
  }

  void _start(BuildContext context, bool weekly) {
    final gen = TaskGenerator(profile);
    final tasks = weekly ? gen.weekly() : gen.daily();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChallengeRunScreen(state: state, profile: profile, tasks: tasks, weekly: weekly),
    ));
  }

  Widget _card(BuildContext context,
      {required String emoji,
      required String title,
      required String desc,
      required bool done,
      required List<Color> colors,
      required VoidCallback onTap}) {
    return Material(
      borderRadius: BorderRadius.circular(28),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(colors: colors),
          ),
          child: Row(
            children: [
              Text(done ? '✅' : emoji, style: const TextStyle(fontSize: 56)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(desc, style: const TextStyle(fontSize: 15, color: Colors.white)),
                    if (done)
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text('Możesz zagrać jeszcze raz dla zabawy',
                            style: TextStyle(fontSize: 13, color: Colors.white70)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChallengeRunScreen extends StatefulWidget {
  final AppState state;
  final Profile profile;
  final List<Task> tasks;
  final bool weekly;
  const ChallengeRunScreen({
    super.key,
    required this.state,
    required this.profile,
    required this.tasks,
    required this.weekly,
  });

  @override
  State<ChallengeRunScreen> createState() => _ChallengeRunScreenState();
}

class _ChallengeRunScreenState extends State<ChallengeRunScreen> {
  int idx = 0;
  bool solved = false;
  bool finished = false;
  DateTime last = DateTime.now();

  Profile get p => widget.profile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrent());
  }

  @override
  void dispose() {
    Speaker.stop();
    super.dispose();
  }

  void _speakCurrent() {
    if (p.grade <= 1 && idx < widget.tasks.length) Speaker.speak(widget.tasks[idx].speak);
  }

  int _seconds() {
    final now = DateTime.now();
    final s = now.difference(last).inSeconds;
    last = now;
    return s.clamp(0, 120);
  }

  Future<void> _solved(int mistakes) async {
    setState(() => solved = true);
    final badges = widget.state.recordResult(p, widget.tasks[idx], mistakes, _seconds());
    for (final b in badges) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      await showBadgeDialog(context, b);
    }
  }

  Future<void> _next() async {
    if (idx + 1 < widget.tasks.length) {
      setState(() {
        idx++;
        solved = false;
      });
      _speakCurrent();
      return;
    }
    setState(() => finished = true);
    final key = widget.weekly ? weekKey(DateTime.now()) : dayKey(DateTime.now());
    final already = widget.weekly ? p.weeklyDone.contains(key) : p.dailyDone.contains(key);
    Speaker.speak(widget.weekly ? 'Wielkie wyzwanie ukończone! Jesteś niesamowity!' : 'Wyzwanie ukończone! Brawo!');
    if (!already) {
      final badges = widget.state.recordChallenge(p, widget.weekly);
      for (final b in badges) {
        await Future<void>.delayed(const Duration(milliseconds: 1200));
        if (!mounted) return;
        await showBadgeDialog(context, b);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF176), Color(0xFFFFB74D)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.2, end: 1),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.elasticOut,
                    builder: (c, v, ch) => Transform.scale(scale: v, child: ch),
                    child: Text(widget.weekly ? '👑' : '🏆', style: const TextStyle(fontSize: 140)),
                  ),
                  const SizedBox(height: 12),
                  Text(widget.weekly ? 'Wielkie wyzwanie\nukończone!' : 'Wyzwanie ukończone!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('🎉 🎉 🎉', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text('Super!', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final n = widget.tasks.length;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: TaskHost(
              key: ValueKey('ch$idx'),
              task: widget.tasks[idx],
              grade: p.grade,
              index: idx,
              feedMode: false,
              onSolved: _solved,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (idx + (solved ? 1 : 0)) / n,
                        minHeight: 12,
                        backgroundColor: Colors.white,
                        color: const Color(0xFF7E57C2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${idx + 1}/$n', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: solved
          ? FloatingActionButton.extended(
              onPressed: _next,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(idx + 1 < n ? 'Dalej' : 'Koniec!', style: const TextStyle(fontSize: 18)),
            )
          : null,
    );
  }
}
