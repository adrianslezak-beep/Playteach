import 'package:flutter/material.dart';

import '../badges.dart';
import '../speaker.dart';

Future<void> showBadgeDialog(BuildContext context, BadgeDef b) {
  Speaker.speak('Nowa odznaka! ${b.name}');
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nowa odznaka!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF6C5CE7))),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.2, end: 1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.elasticOut,
              builder: (c, v, ch) => Transform.scale(scale: v, child: ch),
              child: Text(b.emoji, style: const TextStyle(fontSize: 110)),
            ),
            const SizedBox(height: 8),
            Text(b.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(b.desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Hura! 🎉', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
