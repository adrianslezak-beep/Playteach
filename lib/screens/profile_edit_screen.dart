import 'package:flutter/material.dart';

import '../models.dart';
import '../state.dart';

const List<String> avatars = ['🦊', '🐼', '🐯', '🦁', '🐸', '🐵', '🐰', '🐻', '🐨', '🦄', '🐙', '🐧', '🐶', '🐱', '🦖', '🐝'];

/// Dodawanie nowego ucznia albo edycja istniejącego (z panelu rodzica).
class ProfileEditScreen extends StatefulWidget {
  final AppState state;
  final Profile? profile;
  const ProfileEditScreen({super.key, required this.state, this.profile});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final TextEditingController name = TextEditingController(text: widget.profile?.name ?? '');
  late String avatar = widget.profile?.avatar ?? avatars.first;
  late int grade = widget.profile?.grade ?? 1;

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  void _save() {
    final n = name.text.trim();
    if (n.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wpisz imię 🙂')));
      return;
    }
    final p = widget.profile;
    if (p == null) {
      widget.state.addProfile(n, avatar, grade);
    } else {
      p.name = n;
      p.avatar = avatar;
      p.grade = grade;
      widget.state.touch();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.profile != null;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF3E0),
        title: Text(editing ? 'Edytuj ucznia' : 'Nowy uczeń', style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(child: Text(avatar, style: const TextStyle(fontSize: 90))),
              const SizedBox(height: 12),
              TextField(
                controller: name,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(fontSize: 22),
                decoration: InputDecoration(
                  labelText: 'Imię',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Wybierz zwierzaka', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final a in avatars)
                    GestureDetector(
                      onTap: () => setState(() => avatar = a),
                      child: Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: a == avatar ? const Color(0xFFFFCC80) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: a == avatar ? const Color(0xFFEF6C00) : Colors.transparent, width: 3),
                        ),
                        child: Text(a, style: const TextStyle(fontSize: 34)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Do której klasy chodzisz?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int g = 1; g <= 8; g++)
                    ChoiceChip(
                      label: Text(g <= 3 ? 'Klasa $g' : 'Klasa $g (wkrótce)', style: const TextStyle(fontSize: 16)),
                      selected: grade == g,
                      onSelected: g <= 3 ? (_) => setState(() => grade = g) : null,
                    ),
                ],
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _save,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Zapisz', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
