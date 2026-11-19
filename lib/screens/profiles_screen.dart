import 'package:flutter/material.dart';

import '../models.dart';
import '../state.dart';
import 'feed_screen.dart';
import 'parent_screen.dart';
import 'profile_edit_screen.dart';

class ProfilesScreen extends StatelessWidget {
  final AppState state;
  const ProfilesScreen({super.key, required this.state});

  static const _tileColors = [
    Color(0xFFFF8A65), Color(0xFF4FC3F7), Color(0xFF81C784), Color(0xFFBA68C8), Color(0xFFFFD54F), Color(0xFFF06292),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8E7CF0), Color(0xFFF48FB1)],
          ),
        ),
        child: SafeArea(
          child: ListenableBuilder(
            listenable: state,
            builder: (context, _) => Column(
              children: [
                const SizedBox(height: 24),
                const Text('Playteach',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                const Text('Nauka przez zabawę ✨', style: TextStyle(fontSize: 18, color: Colors.white)),
                const SizedBox(height: 28),
                Text(state.profiles.isEmpty ? 'Dodaj pierwszego ucznia 👇' : 'Kto dziś się uczy?',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: GridView.count(
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(16),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.95,
                        children: [
                          for (int i = 0; i < state.profiles.length; i++)
                            _profileTile(context, state.profiles[i], _tileColors[i % _tileColors.length]),
                          _addTile(context),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => ParentGateScreen(state: state))),
                    icon: const Icon(Icons.lock_outline, color: Colors.white),
                    label: const Text('Panel rodzica', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileTile(BuildContext context, Profile p, Color color) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => FeedScreen(state: state, profile: p))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: color.withAlpha(70),
                child: Text(p.avatar, style: const TextStyle(fontSize: 48)),
              ),
              const SizedBox(height: 8),
              Text(p.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              Text('klasa ${p.grade}  •  ⭐ ${p.stars}', style: const TextStyle(fontSize: 15, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addTile(BuildContext context) {
    return Material(
      color: Colors.white.withAlpha(90),
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => ProfileEditScreen(state: state))),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 64, color: Colors.white),
            SizedBox(height: 8),
            Text('Dodaj ucznia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
