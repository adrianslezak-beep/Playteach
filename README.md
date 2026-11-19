# Playteach ⭐

Nauka przez zabawę dla szkoły podstawowej, w formie przewijanego feedu jak TikTok. Każda karta to interaktywne zadanie.

## Wersja 0.2 – klasy 1–8

- **Matematyka**: liczenie, dodawanie i odejmowanie, porównywanie, figury, ciągi, mnożenie i dzielenie, zadania z treścią, miary.
- **Polski**: litery, sylaby, układanie słów, czytanie, ortografia (ó/u, rz/ż, ch/h), alfabet, zdania, części mowy, przeciwieństwa, liczba mnoga.
- **Plastyka** (klasy 1–3): rysowanie palcem po śladzie i kolorowanie kredkami.
- **Klasy 4–8**: matematyka (generatory zadań bez końca), polski, angielski, przyroda, biologia, geografia, historia (z układaniem chronologii), fizyka, chemia i WOS. Od klasy 5 dochodzą powtórki z wcześniejszych lat.
- **Odznaki i gwiazdki**, bez punktów ujemnych. Przy błędzie jest delikatna podpowiedź.
- **Wyzwania** (dnia i tygodnia) układa sama aplikacja.
- **Kilka profili** na jednym urządzeniu.
- **Panel rodzica** za PIN-em: czas nauki, umiejętności i to, co warto poćwiczyć.
- Polecenia czytane na głos (klasa 1 automatycznie).
- Działa offline. Bez reklam, bez kont, dane zostają w telefonie.

## Instalacja

Każdy push na `main` buduje APK w GitHub Actions. Plik pojawia się w zakładce **Releases**.
Kolejne wersje instalują się jako aktualizacja, bez utraty postępów (stały klucz w `signing/`).

## Struktura

- `lib/content/` – generatory zadań wg podstawy programowej (`math.dart`, `polish.dart`), kształty do rysowania, rejestr umiejętności i adaptacyjny generator feedu (`skills.dart`)
- `lib/widgets/` – typy kart: wybór, układanie, łączenie w pary, rysowanie
- `lib/screens/` – profile, feed, wyzwania, odznaki, panel rodzica
