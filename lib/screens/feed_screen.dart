import 'package:flutter/material.dart';

import '../content/skills.dart';
import '../models.dart';
import '../speaker.dart';
import '../state.dart';
import '../widgets/badge_dialog.dart';
import '../widgets/task_host.dart';
import 'badges_screen.dart';
import 'challenge_screen.dart';

/// Główny feed – przewijane w pionie karty z zadaniami.
class FeedScreen extends StatefulWidget {
  final AppState state;
  final Profile profile;
  const FeedScreen({super.key, required this.state, required this.profile});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final TaskGenerator gen = TaskGenerator(widget.profile);
  final List<Task> tasks = [];
  final Set<int> done = {};
  final Set<int> skipped = {};
  final PageController pc = PageController();
  int current = 0;
  DateTime last = DateTime.now();

  Profile get p => widget.profile;

  @override
  void initState() {
    super.initState();
    _taskAt(0);
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoSpeak(0));
  }

  @override
  void dispose() {
    widget.state.addSecondsSilently(p, _seconds());
    pc.dispose();
    Speaker.stop();
    super.dispose();
  }

  Task _taskAt(int i) {
    while (tasks.length <= i) {
      tasks.add(gen.next());
    }
    return tasks[i];
  }

  int _seconds() {
    final now = DateTime.now();
    final s = now.difference(last).inSeconds;
    last = now;
    return s.clamp(0, 120);
  }

  bool get _locked =>
      _taskAt(current).kind == TaskKind.trace && !done.contains(current) && !skipped.contains(current);

  void _autoSpeak(int i) {
    if (p.grade <= 1 && !done.contains(i)) {
      Speaker.speak(_taskAt(i).speak);
    } else {
      Speaker.stop();
    }
  }

  Future<void> _solved(int i, int mistakes) async {
    if (done.contains(i)) return;
    setState(() => done.add(i));
    final badges = widget.state.recordResult(p, tasks[i], mistakes, _seconds());
    if (badges.isNotEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      for (final b in badges) {
        if (!mounted) return;
        await showBadgeDialog(context, b);
      }
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 1700));
    }
    if (!mounted) return;
    if (current == i && pc.hasClients) {
      pc.nextPage(duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic);
    }
  }

  void _skip(int i) {
    setState(() => skipped.add(i));
    pc.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: pc,
            scrollDirection: Axis.vertical,
            physics: _locked ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
            onPageChanged: (i) {
              setState(() => current = i);
              _autoSpeak(i);
            },
            itemBuilder: (ctx, i) => TaskHost(
              key: ValueKey('task$i'),
              task: _taskAt(i),
              grade: p.grade,
              index: i,
              done: done.contains(i),
              onSolved: (m) => _solved(i, m),
              onSkip: () => _skip(i),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: ListenableBuilder(
                listenable: widget.state,
                builder: (context, _) => Row(
                  children: [
                    _pill(
                      onTap: () => Navigator.of(context).pop(),
                      child: Row(children: [
                        const Icon(Icons.arrow_back_rounded, size: 20),
                        const SizedBox(width: 4),
                        Text(p.avatar, style: const TextStyle(fontSize: 22)),
                      ]),
                    ),
                    const SizedBox(width: 8),
                    _pill(
                      child: Text('⭐ ${p.stars}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    ),
                    const Spacer(),
                    _pill(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ChallengeScreen(state: widget.state, profile: p))),
                      child: const Text('🎯 Wyzwania', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 8),
                    _pill(
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => BadgesScreen(profile: p))),
                      child: Text('🏅 ${p.badges.length}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill({required Widget child, VoidCallback? onTap}) {
    return Material(
      color: Colors.white.withAlpha(230),
      borderRadius: BorderRadius.circular(24),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: child),
      ),
    );
  }
}
