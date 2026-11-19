import 'package:flutter/material.dart';

class SubjectMeta {
  final String name;
  final String emoji;
  final Color color;
  const SubjectMeta(this.name, this.emoji, this.color);
  String get label => '$emoji $name';
}

const Map<String, SubjectMeta> subjects = {
  'math': SubjectMeta('Matematyka', '🔢', Color(0xFF1E88E5)),
  'polish': SubjectMeta('Polski', '📝', Color(0xFFD81B60)),
  'art': SubjectMeta('Plastyka', '🎨', Color(0xFF8E24AA)),
  'english': SubjectMeta('Angielski', '🇬🇧', Color(0xFF3949AB)),
  'nature': SubjectMeta('Przyroda', '🌿', Color(0xFF43A047)),
  'biology': SubjectMeta('Biologia', '🧬', Color(0xFF2E7D32)),
  'geography': SubjectMeta('Geografia', '🌍', Color(0xFF00897B)),
  'history': SubjectMeta('Historia', '🏛️', Color(0xFF8D6E63)),
  'physics': SubjectMeta('Fizyka', '⚡', Color(0xFFF57C00)),
  'chemistry': SubjectMeta('Chemia', '⚗️', Color(0xFF6D4C41)),
  'civics': SubjectMeta('WOS', '⚖️', Color(0xFF546E7A)),
};

SubjectMeta subjectMeta(String id) => subjects[id] ?? const SubjectMeta('Nauka', '📚', Color(0xFF607D8B));
