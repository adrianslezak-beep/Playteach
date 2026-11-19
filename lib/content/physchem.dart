import 'dart:math';

import '../models.dart';
import '../util.dart';
import 'bank.dart';
import 'common.dart';

const _f = 'physics';
const _c = 'chemistry';

// ───────── Fizyka – zadania liczbowe ─────────

Task f7Speed(Random r) {
  switch (r.nextInt(3)) {
    case 0:
      final v = pick(r, const [2, 3, 4, 5, 10, 15, 20, 25]);
      final t = rng(r, 2, 12);
      final s = v * t;
      return choice('f7_calc', _f, 'Ciało przebyło $s m w czasie $t s. Jaka była jego prędkość?',
          errOpts(r, v, [s * t, v + 1, s - t, v * 2], 4).map((e) => '$e m/s').toList(), '$v m/s',
          visual: 'v = s / t', hint: 'Prędkość = droga : czas.', explain: '$s m : $t s = $v m/s');
    case 1:
      final v = pick(r, const [40, 50, 60, 80, 90, 100, 120]);
      final t = rng(r, 2, 5);
      final s = v * t;
      return choice('f7_calc', _f, 'Samochód jedzie z prędkością $v km/h. Jaką drogę pokona w $t h?',
          errOpts(r, s, [v + t, s + v, s - v, v * (t + 1)], 4).map((e) => '$e km').toList(), '$s km',
          visual: 's = v · t', hint: 'Droga = prędkość × czas.', explain: '$v km/h × $t h = $s km');
    default:
      final m = rng(r, 2, 20);
      final g = 10;
      final fw = m * g;
      return choice('f7_calc', _f, 'Jaki ciężar ma ciało o masie $m kg? (przyjmij g = 10 N/kg)',
          errOpts(r, fw, [m, fw + 10, fw ~/ 2, m + g], 4).map((e) => '$e N').toList(), '$fw N',
          visual: 'F = m · g', hint: 'Ciężar = masa × przyspieszenie ziemskie.', explain: '$m kg × 10 N/kg = $fw N');
  }
}

Task f7Density(Random r) {
  final d = pick(r, const [1000, 800, 2700, 7800, 900, 500, 11300]);
  final v = rng(r, 1, 5);
  final m = d * v;
  return choice('f7_calc', _f, 'Ciało o objętości $v m³ ma masę $m kg. Jaka jest jego gęstość?',
      errOpts(r, d, [d ~/ 10, d * 10, d + 100, m], 4).map((e) => '$e kg/m³').toList(), '$d kg/m³',
      visual: 'ρ = m / V', hint: 'Gęstość = masa : objętość.', explain: '$m kg : $v m³ = $d kg/m³');
}

Task f8Ohm(Random r) {
  final rr = pick(r, const [2, 4, 5, 10, 20, 50, 100]);
  final i = pick(r, const [1, 2, 3, 4, 5]);
  final u = rr * i;
  switch (r.nextInt(3)) {
    case 0:
      return choice('f8_calc', _f, 'Przez opornik $rr Ω płynie prąd $i A. Jakie jest napięcie?',
          errOpts(r, u, [rr + i, rr, u + rr, u * 2], 4).map((e) => '$e V').toList(), '$u V',
          visual: 'U = R · I', hint: 'Prawo Ohma: U = R · I.', explain: '$rr Ω × $i A = $u V');
    case 1:
      return choice('f8_calc', _f, 'Napięcie wynosi $u V, a natężenie prądu $i A. Jaki jest opór?',
          errOpts(r, rr, [u * i, rr + 1, rr * 2, u], 4).map((e) => '$e Ω').toList(), '$rr Ω',
          visual: 'R = U / I', hint: 'Opór = napięcie : natężenie.', explain: '$u V : $i A = $rr Ω');
    default:
      final p = u * i;
      return choice('f8_calc', _f, 'Urządzenie pracuje przy napięciu $u V, płynie prąd $i A. Jaka jest moc?',
          errOpts(r, p, [u + i, u, p + u, p * 2], 4).map((e) => '$e W').toList(), '$p W',
          visual: 'P = U · I', hint: 'Moc = napięcie × natężenie.', explain: '$u V × $i A = $p W');
  }
}

// ───────── Chemia – masa cząsteczkowa ─────────

const List<List<Object>> _molecules = [
  ['H₂O', 18, 'woda: 2·1 + 16'], ['CO₂', 44, '12 + 2·16'], ['O₂', 32, '2·16'], ['H₂', 2, '2·1'], ['N₂', 28, '2·14'],
  ['NaCl', 58, '23 + 35 (ok. 35,5)'], ['CH₄', 16, '12 + 4·1'], ['NH₃', 17, '14 + 3·1'], ['HCl', 36, '1 + 35 (ok. 35,5)'],
  ['CaO', 56, '40 + 16'], ['MgO', 40, '24 + 16'], ['SO₂', 64, '32 + 2·16'], ['H₂SO₄', 98, '2·1 + 32 + 4·16'],
  ['NaOH', 40, '23 + 16 + 1'], ['CaCO₃', 100, '40 + 12 + 3·16'], ['C₂H₅OH', 46, '2·12 + 6·1 + 16'],
];

Task c7Mass(Random r) {
  final m = pick(r, _molecules);
  final v = m[1] as int;
  return choice('c7_calc', _c, 'Jaka jest masa cząsteczkowa?', errOpts(r, v, [v + 1, v - 2, v + 16, v ~/ 2, v + 12], 4).map((e) => '$e u').toList(), '$v u',
      visual: m[0] as String, hint: 'Masy atomowe: H = 1, C = 12, N = 14, O = 16, Na = 23, Mg = 24, S = 32, Cl ≈ 35,5, Ca = 40.',
      explain: '${m[0]}: ${m[2]} = $v u');
}

// ───────── Bazy pytań ─────────

const List<BankTopic> physchemBanks = [
  BankTopic('f7_basics', 'Wielkości, siły, ruch', _f, 7, [
    "Jednostką siły w układzie SI jest…|niuton (N)|dżul (J)|wat (W)|paskal (Pa)|Od nazwiska Izaaka Newtona.",
    "Jednostką energii i pracy jest…|dżul (J)|niuton (N)|wat (W)|wolt (V)|1 J = 1 N · 1 m.",
    "Jednostką mocy jest…|wat (W)|dżul (J)|niuton (N)|amper (A)|1 W = 1 J/s.",
    "Jednostką ciśnienia jest…|paskal (Pa)|niuton (N)|kilogram (kg)|dżul (J)|1 Pa = 1 N/m².",
    "Jednostką masy w układzie SI jest…|kilogram|gram|niuton|tona|Masa – kg.",
    "Przyrząd do pomiaru siły to…|siłomierz|termometr|barometr|amperomierz|Siłomierz (dynamometr) – sprężyna.",
    "Pierwsza zasada dynamiki Newtona mówi, że ciało, na które nie działają siły (lub się równoważą)…|pozostaje w spoczynku lub porusza się ruchem jednostajnym prostoliniowym|zawsze przyspiesza|zawsze się zatrzymuje|spada|Zasada bezwładności.",
    "Trzecia zasada dynamiki mówi o…|akcji i reakcji|bezwładności|grawitacji Księżyca|tarciu|Siły wzajemnego oddziaływania są równe i przeciwnie skierowane.",
    "Siła przeciwdziałająca ruchowi ciał po powierzchni to…|tarcie|wyporu|ciężkość|sprężystość|Tarcie zależy m.in. od rodzaju powierzchni.",
    "Prawo Archimedesa dotyczy siły…|wyporu|tarcia|ciężkości|magnetycznej|Na ciało zanurzone działa siła wyporu równa ciężarowi wypartej cieczy.",
    "Ciało pływa po wodzie, gdy jego gęstość jest…|mniejsza od gęstości wody|większa od gęstości wody|zawsze równa zero|większa od żelaza|Np. drewno, lód.",
    "Gęstość wody wynosi około…|1000 kg/m³|100 kg/m³|1 kg/m³|7800 kg/m³|1 g/cm³.",
    "Ruch, w którym prędkość jest stała, to ruch…|jednostajny|jednostajnie przyspieszony|drgający|obrotowy zawsze|Prędkość się nie zmienia.",
    "Energia ciała w ruchu to energia…|kinetyczna|potencjalna grawitacji|wewnętrzna|jądrowa|Ek = mv²/2.",
    "Energia ciała podniesionego na wysokość to energia…|potencjalna grawitacji|kinetyczna|elektryczna|świetlna|Ep = mgh.",
    "Ciepło przekazywane przez bezpośredni kontakt ciał (np. łyżka w herbacie) to…|przewodnictwo cieplne|konwekcja|promieniowanie|parowanie|Metale dobrze przewodzą ciepło.",
    "Przekazywanie ciepła przez ruch cieczy lub gazu (np. kaloryfer ogrzewa pokój) to…|konwekcja|przewodnictwo|promieniowanie|topnienie|Ciepłe powietrze unosi się do góry.",
    "Temperatura 0 K (zero bezwzględne) to około…|−273°C|0°C|−100°C|−32°C|Skala Kelvina.",
    "W jakich jednostkach podaje się prędkość w układzie SI?|m/s|km/h|m/s²|N|Metr na sekundę.",
    "Przyspieszenie ziemskie wynosi około…|10 m/s²|1 m/s²|100 m/s²|0,1 m/s²|Dokładniej ok. 9,81 m/s².",
  ]),
  BankTopic('f8_electric', 'Elektryczność, fale, optyka', _f, 8, [
    "Jednostką natężenia prądu jest…|amper (A)|wolt (V)|om (Ω)|wat (W)|Natężenie mierzymy amperomierzem.",
    "Jednostką napięcia jest…|wolt (V)|amper (A)|om (Ω)|dżul (J)|Napięcie mierzymy woltomierzem.",
    "Jednostką oporu elektrycznego jest…|om (Ω)|wolt (V)|amper (A)|wat (W)|Prawo Ohma: R = U/I.",
    "Amperomierz włączamy do obwodu…|szeregowo|równolegle|w ogóle|tylko do baterii|Prąd musi przez niego płynąć.",
    "Woltomierz włączamy do obwodu…|równolegle|szeregowo|nie włączamy|zamiast żarówki|Mierzy różnicę potencjałów.",
    "Ładunki jednoimienne…|odpychają się|przyciągają się|nie oddziałują|znikają|Plus z plusem się odpychają.",
    "Dobrymi przewodnikami prądu są…|metale|guma i plastik|szkło|suche drewno|Mają swobodne elektrony.",
    "Izolatorem jest…|guma|miedź|aluminium|srebro|Izolatory nie przewodzą prądu.",
    "Biegun magnesu, który wskazuje północ geograficzną, to biegun…|północny (N)|południowy (S)|ujemny|dodatni|Igła kompasu to magnes.",
    "Elektromagnes to…|zwojnica z rdzeniem, przez którą płynie prąd|magnes stały|bateria|żarówka|Można go wyłączyć.",
    "Prędkość światła w próżni wynosi około…|300 000 km/s|300 km/s|340 m/s|3000 km/h|Najszybsza możliwa prędkość.",
    "Prędkość dźwięku w powietrzu wynosi około…|340 m/s|300 000 km/s|34 m/s|3400 km/s|Dlatego najpierw widzimy błysk, potem słyszymy grzmot.",
    "Czy dźwięk rozchodzi się w próżni?|nie|tak, najszybciej|tak, jak światło|tylko w nocy|Dźwięk potrzebuje ośrodka.",
    "Dźwięki o częstotliwości powyżej 20 000 Hz to…|ultradźwięki|infradźwięki|echo|szumy|Słyszą je np. nietoperze i psy.",
    "Jednostką częstotliwości jest…|herc (Hz)|dżul (J)|metr (m)|sekunda (s)|1 Hz = 1 drgnienie na sekundę.",
    "Odbicie światła: kąt odbicia jest…|równy kątowi padania|dwa razy większy|zawsze 90°|zawsze 0°|Prawo odbicia.",
    "Soczewka skupiająca (wypukła) jest stosowana w okularach dla…|dalekowidzów|krótkowidzów|daltonistów|każdego|Krótkowidz potrzebuje soczewki rozpraszającej.",
    "Rozszczepienie światła białego w pryzmacie daje…|tęczę barw (widmo)|ciemność|jeden kolor|dźwięk|Światło białe to mieszanina barw.",
    "Kto wynalazł żarówkę (w praktycznej formie)?|Thomas Edison|Isaac Newton|Albert Einstein|Mikołaj Kopernik|Koniec XIX w.",
    "Elektrownia, która zamienia energię wiatru w elektryczną, to elektrownia…|wiatrowa|jądrowa|węglowa|wodna|Odnawialne źródło energii.",
  ]),
  BankTopic('c7_basics', 'Pierwiastki i substancje', _c, 7, [
    "Kto stworzył układ okresowy pierwiastków?|Dmitrij Mendelejew|Maria Skłodowska-Curie|Antoine Lavoisier|Isaac Newton|1869 r.",
    "Jaki ładunek ma proton?|dodatni|ujemny|zerowy|zmienny|Proton +, elektron −, neutron 0.",
    "Jaki ładunek ma elektron?|ujemny|dodatni|zerowy|podwójny|Elektrony krążą wokół jądra.",
    "Co znajduje się w jądrze atomu?|protony i neutrony|tylko elektrony|elektrony i protony|nic|Jądro jest bardzo małe i ciężkie.",
    "Liczba atomowa (Z) oznacza liczbę…|protonów w jądrze|neutronów|wszystkich cząstek|elektronów walencyjnych zawsze|Z = liczba protonów.",
    "Gazy szlachetne (np. hel, neon) są…|bierne chemicznie|bardzo reaktywne|metalami|ciekłe|Mają pełną powłokę walencyjną.",
    "Który metal jest ciekły w temperaturze pokojowej?|rtęć|żelazo|miedź|glin|Symbol Hg.",
    "Mieszanina wody i piasku to mieszanina…|niejednorodna|jednorodna|związek chemiczny|pierwiastek|Widać składniki gołym okiem.",
    "Woda z cukrem (rozpuszczonym) to mieszanina…|jednorodna (roztwór)|niejednorodna|pierwiastek|osad|Składników nie widać.",
    "Jak oddzielić piasek od wody?|sączeniem (filtracją)|destylacją|magnesem|krystalizacją|Piasek zostaje na sączku.",
    "Jak oddzielić opiłki żelaza od piasku?|magnesem|sączeniem|destylacją|odparowaniem|Żelazo przyciąga magnes.",
    "Jak otrzymać czystą wodę z wody morskiej?|destylacją|sączeniem|magnesem|dekantacją|Woda paruje i skrapla się, sól zostaje.",
    "Który gaz stanowi najwięcej (ok. 78%) powietrza?|azot|tlen|dwutlenek węgla|argon|Tlenu jest ok. 21%.",
    "Ile procent powietrza stanowi tlen?|ok. 21%|ok. 78%|ok. 1%|ok. 50%|Tlen podtrzymuje spalanie.",
    "Który gaz mętni wodę wapienną?|dwutlenek węgla|tlen|azot|wodór|Test na obecność CO₂.",
    "Wodór to gaz…|najlżejszy, palny|cięższy od powietrza i niepalny|zielony|trujący jak chlor|Wzór H₂.",
    "Tlenki to związki pierwiastka z…|tlenem|wodorem|azotem|węglem|Np. CO₂, CaO, Fe₂O₃.",
    "Rdza to głównie…|tlenki i wodorotlenki żelaza|tlenek miedzi|chlorek sodu|siarka|Korozja żelaza w obecności wody i tlenu.",
    "Reakcja, w której z dwóch substancji powstaje jedna, to reakcja…|syntezy|analizy (rozkładu)|wymiany|spalania niepełnego|A + B → AB.",
    "Prawo zachowania masy mówi, że…|masa substratów równa się masie produktów|masa zawsze rośnie|masa zawsze maleje|gazy nie mają masy|Lavoisier i Łomonosow.",
  ]),
  BankTopic('c8_compounds', 'Kwasy, zasady, sole, związki organiczne', _c, 8, [
    "Wzór kwasu solnego to…|HCl|H₂SO₄|HNO₃|NaOH|Kwas chlorowodorowy.",
    "Wzór kwasu siarkowego(VI) to…|H₂SO₄|H₂SO₃|HCl|H₂S|Bardzo silny i żrący.",
    "Wzór kwasu azotowego(V) to…|HNO₃|NH₃|HCl|H₃PO₄|Kwas azotowy.",
    "Wzór wodorotlenku sodu to…|NaOH|NaCl|Na₂O|KOH|Silna zasada, tzw. soda kaustyczna.",
    "Sól kuchenna to…|chlorek sodu (NaCl)|węglan wapnia|siarczan miedzi|wodorotlenek sodu|NaCl.",
    "Jaki kolor przyjmuje fenoloftaleina w roztworze zasadowym?|malinowy|bezbarwny|żółty|niebieski|W kwasach i wodzie jest bezbarwna.",
    "Odczyn roztworu o pH = 7 to odczyn…|obojętny|kwasowy|zasadowy|silnie żrący|Np. czysta woda.",
    "Roztwór o pH mniejszym niż 7 ma odczyn…|kwasowy|zasadowy|obojętny|metaliczny|Np. ocet, sok z cytryny.",
    "Reakcja kwasu z zasadą, w której powstaje sól i woda, to…|zobojętnianie|spalanie|fermentacja|elektroliza|Neutralizacja.",
    "Kreda i wapień to głównie…|węglan wapnia (CaCO₃)|chlorek sodu|siarczan żelaza|wodorotlenek wapnia|Reaguje z kwasem, wydzielając CO₂.",
    "Najprostszy węglowodór to…|metan (CH₄)|etan|eten|propan|Główny składnik gazu ziemnego.",
    "Węglowodory nasycone (tylko wiązania pojedyncze) to…|alkany|alkeny|alkiny|alkohole|Np. metan, etan, propan.",
    "Wzór etanolu to…|C₂H₅OH|CH₃OH|CH₃COOH|C₆H₁₂O₆|Alkohol etylowy.",
    "Kwas zawarty w occie to…|kwas octowy (etanowy)|kwas solny|kwas mrówkowy|kwas siarkowy|CH₃COOH.",
    "Wzór glukozy to…|C₆H₁₂O₆|C₁₂H₂₂O₁₁|CH₄|CO₂|Cukier prosty, produkt fotosyntezy.",
    "Białka są zbudowane z…|aminokwasów|glukozy|kwasów tłuszczowych|soli|Aminokwasy łączą się wiązaniami peptydowymi.",
    "Skrobia wobec jodyny barwi się na kolor…|granatowy (ciemnoniebieski)|czerwony|żółty|zielony|Próba jodowa.",
    "Mydło powstaje w reakcji tłuszczu z…|zasadą (np. NaOH)|kwasem solnym|wodą destylowaną|tlenem|Zmydlanie.",
    "Polietylen (PE) to przykład…|tworzywa sztucznego (polimeru)|metalu|soli|kwasu|Folie, torebki.",
    "Twardość wody powodują głównie jony…|wapnia i magnezu|sodu i potasu|chloru|żelaza wyłącznie|Kamień kotłowy.",
  ]),
];

const List<PairBank> physchemPairs = [
  PairBank('c7_symbols', 'Symbole pierwiastków', _c, 7, 'Połącz symbol z nazwą pierwiastka', [
    'H=wodór', 'O=tlen', 'C=węgiel', 'N=azot', 'Na=sód', 'K=potas', 'Ca=wapń', 'Fe=żelazo', 'Cu=miedź', 'Ag=srebro',
    'Au=złoto', 'Zn=cynk', 'Al=glin', 'S=siarka', 'P=fosfor', 'Cl=chlor', 'Mg=magnez', 'He=hel', 'Pb=ołów', 'Hg=rtęć',
  ]),
  PairBank('f7_units', 'Jednostki', _f, 7, 'Połącz wielkość fizyczną z jednostką', [
    'siła=niuton', 'energia=dżul', 'moc=wat', 'ciśnienie=paskal', 'masa=kilogram', 'czas=sekunda', 'droga=metr',
    'temperatura (SI)=kelwin', 'gęstość=kg/m³', 'prędkość=m/s',
  ]),
  PairBank('f8_units', 'Jednostki', _f, 8, 'Połącz wielkość z jednostką', [
    'natężenie prądu=amper', 'napięcie=wolt', 'opór=om', 'moc=wat', 'częstotliwość=herc', 'ładunek=kulomb',
    'energia=dżul',
  ]),
];
