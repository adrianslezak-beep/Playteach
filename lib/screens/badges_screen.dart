import 'package:flutter/material.dart';

import '../badges.dart';
import '../models.dart';

class BadgesScreen extends StatelessWidget {
  final Profile profile;
  const BadgesScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final earned = allBadges.where((b) => profile.badges.containsKey(b.id)).length;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8E1),
        title: Text('Moje odznaki ($earned)', style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('⭐ ${profile.stars} gwiazdek',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFFF57F17))),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(12),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.78,
              children: [
                for (final b in allBadges) _tile(context, b, profile.badges.containsKey(b.id)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, BadgeDef b, bool has) {
    return GestureDetector(
      onTap: () => showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('${b.emoji}  ${b.name}'),
          content: Text(has ? '${b.desc}\n\nZdobyta! 🎉' : '${b.desc}\n\nJeszcze przed Tobą – dasz radę! 💪'),
          actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: has ? Colors.white : Colors.white.withAlpha(110),
          borderRadius: BorderRadius.circular(20),
          boxShadow: has ? const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 3))] : null,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(opacity: has ? 1 : 0.25, child: Text(b.emoji, style: const TextStyle(fontSize: 46))),
            const SizedBox(height: 6),
            Text(
              b.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: has ? Colors.black87 : Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}
