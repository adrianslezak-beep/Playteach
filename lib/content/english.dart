import 'dart:math';

import '../models.dart';
import '../util.dart';
import 'bank.dart';
import 'common.dart';

const _e = 'english';

/// Słówka: grupa → klasa, od której obowiązują, i pary "angielski=polski".
class VocabGroup {
  final String name;
  final int grade;
  final List<String> words;
  const VocabGroup(this.name, this.grade, this.words);
}

const List<VocabGroup> vocab = [
  VocabGroup('zwierzęta', 4, [
    'dog=pies', 'cat=kot', 'horse=koń', 'cow=krowa', 'pig=świnia', 'sheep=owca', 'mouse=mysz', 'bird=ptak',
    'fish=ryba', 'rabbit=królik', 'duck=kaczka', 'hen=kura', 'frog=żaba', 'bear=niedźwiedź', 'lion=lew',
    'elephant=słoń', 'monkey=małpa', 'snake=wąż', 'tiger=tygrys', 'giraffe=żyrafa', 'wolf=wilk', 'fox=lis',
  ]),
  VocabGroup('kolory', 4, [
    'red=czerwony', 'blue=niebieski', 'green=zielony', 'yellow=żółty', 'black=czarny', 'white=biały',
    'orange=pomarańczowy', 'pink=różowy', 'purple=fioletowy', 'brown=brązowy', 'grey=szary',
  ]),
  VocabGroup('rodzina', 4, [
    'mother=mama', 'father=tata', 'sister=siostra', 'brother=brat', 'grandmother=babcia', 'grandfather=dziadek',
    'aunt=ciocia', 'uncle=wujek', 'cousin=kuzyn', 'son=syn', 'daughter=córka', 'parents=rodzice', 'baby=niemowlę',
  ]),
  VocabGroup('szkoła', 4, [
    'pen=długopis', 'pencil=ołówek', 'book=książka', 'rubber=gumka', 'ruler=linijka', 'desk=ławka',
    'board=tablica', 'bag=torba', 'notebook=zeszyt', 'teacher=nauczyciel', 'classroom=klasa (sala)',
    'scissors=nożyczki', 'pencil case=piórnik', 'glue=klej',
  ]),
  VocabGroup('jedzenie', 4, [
    'apple=jabłko', 'banana=banan', 'bread=chleb', 'milk=mleko', 'water=woda', 'cheese=ser', 'egg=jajko',
    'cake=ciasto', 'butter=masło', 'juice=sok', 'soup=zupa', 'chicken=kurczak', 'potato=ziemniak',
    'carrot=marchewka', 'tomato=pomidor', 'orange=pomarańcza', 'sandwich=kanapka', 'ice cream=lody',
  ]),
  VocabGroup('ciało', 4, [
    'head=głowa', 'eye=oko', 'ear=ucho', 'nose=nos', 'mouth=usta', 'hand=dłoń', 'arm=ramię', 'leg=noga',
    'foot=stopa', 'hair=włosy', 'tooth=ząb', 'finger=palec', 'knee=kolano', 'back=plecy', 'neck=szyja',
  ]),
  VocabGroup('dni i miesiące', 4, [
    'Monday=poniedziałek', 'Tuesday=wtorek', 'Wednesday=środa', 'Thursday=czwartek', 'Friday=piątek',
    'Saturday=sobota', 'Sunday=niedziela', 'January=styczeń', 'March=marzec', 'May=maj', 'July=lipiec',
    'September=wrzesień', 'December=grudzień',
  ]),
  VocabGroup('dom', 5, [
    'kitchen=kuchnia', 'bedroom=sypialnia', 'bathroom=łazienka', 'living room=salon', 'garden=ogród',
    'window=okno', 'door=drzwi', 'table=stół', 'chair=krzesło', 'bed=łóżko', 'sofa=kanapa', 'wardrobe=szafa',
    'fridge=lodówka', 'lamp=lampa', 'stairs=schody', 'roof=dach', 'floor=podłoga', 'wall=ściana',
  ]),
  VocabGroup('ubrania', 5, [
    'shirt=koszula', 'T-shirt=koszulka', 'trousers=spodnie', 'skirt=spódnica', 'dress=sukienka', 'shoes=buty',
    'socks=skarpetki', 'hat=kapelusz', 'cap=czapka z daszkiem', 'jacket=kurtka', 'coat=płaszcz',
    'sweater=sweter', 'scarf=szalik', 'gloves=rękawiczki', 'boots=kozaki',
  ]),
  VocabGroup('pogoda', 5, [
    'sunny=słonecznie', 'rainy=deszczowo', 'cloudy=pochmurno', 'windy=wietrznie', 'snowy=śnieżnie',
    'foggy=mglisto', 'hot=gorąco', 'cold=zimno', 'warm=ciepło', 'storm=burza', 'rainbow=tęcza',
  ]),
  VocabGroup('sport i czas wolny', 5, [
    'swim=pływać', 'run=biegać', 'jump=skakać', 'ride a bike=jeździć na rowerze', 'play football=grać w piłkę',
    'dance=tańczyć', 'sing=śpiewać', 'draw=rysować', 'read=czytać', 'skate=jeździć na łyżwach',
    'climb=wspinać się', 'ski=jeździć na nartach',
  ]),
  VocabGroup('miasto', 5, [
    'shop=sklep', 'school=szkoła', 'hospital=szpital', 'church=kościół', 'park=park', 'library=biblioteka',
    'post office=poczta', 'cinema=kino', 'bank=bank', 'bakery=piekarnia', 'station=dworzec', 'street=ulica',
    'bridge=most', 'museum=muzeum', 'swimming pool=basen',
  ]),
  VocabGroup('zawody', 6, [
    'doctor=lekarz', 'nurse=pielęgniarka', 'farmer=rolnik', 'police officer=policjant', 'firefighter=strażak',
    'cook=kucharz', 'driver=kierowca', 'pilot=pilot', 'vet=weterynarz', 'dentist=dentysta', 'engineer=inżynier',
    'shop assistant=sprzedawca', 'hairdresser=fryzjer', 'builder=budowlaniec', 'waiter=kelner',
  ]),
  VocabGroup('transport', 6, [
    'car=samochód', 'bus=autobus', 'train=pociąg', 'plane=samolot', 'ship=statek', 'bike=rower',
    'motorbike=motocykl', 'tram=tramwaj', 'underground=metro', 'taxi=taksówka', 'helicopter=helikopter',
    'ticket=bilet', 'airport=lotnisko',
  ]),
  VocabGroup('przyroda', 6, [
    'mountain=góra', 'river=rzeka', 'lake=jezioro', 'sea=morze', 'forest=las', 'island=wyspa', 'beach=plaża',
    'desert=pustynia', 'field=pole', 'hill=wzgórze', 'sky=niebo', 'star=gwiazda', 'moon=księżyc', 'sun=słońce',
    'tree=drzewo', 'flower=kwiat', 'leaf=liść',
  ]),
  VocabGroup('uczucia i cechy', 6, [
    'happy=szczęśliwy', 'sad=smutny', 'angry=zły', 'tired=zmęczony', 'scared=przestraszony', 'bored=znudzony',
    'excited=podekscytowany', 'brave=odważny', 'shy=nieśmiały', 'friendly=przyjazny', 'lazy=leniwy',
    'clever=mądry', 'funny=zabawny', 'kind=miły',
  ]),
  VocabGroup('podróże', 7, [
    'luggage=bagaż', 'passport=paszport', 'journey=podróż', 'trip=wycieczka', 'hotel=hotel',
    'sightseeing=zwiedzanie', 'map=mapa', 'guide=przewodnik', 'tent=namiot', 'abroad=za granicą',
    'border=granica', 'departure=odjazd/odlot', 'arrival=przyjazd/przylot', 'delay=opóźnienie',
  ]),
  VocabGroup('zdrowie', 7, [
    'headache=ból głowy', 'cold=przeziębienie', 'fever=gorączka', 'cough=kaszel', 'medicine=lekarstwo',
    'injury=uraz', 'broken leg=złamana noga', 'sore throat=ból gardła', 'healthy=zdrowy', 'ill=chory',
    'prescription=recepta', 'chemist=apteka',
  ]),
  VocabGroup('technologia', 7, [
    'computer=komputer', 'keyboard=klawiatura', 'screen=ekran', 'mouse=myszka', 'download=pobierać',
    'upload=przesyłać', 'password=hasło', 'website=strona internetowa', 'app=aplikacja', 'charger=ładowarka',
    'printer=drukarka', 'message=wiadomość',
  ]),
  VocabGroup('zakupy', 7, [
    'price=cena', 'cheap=tani', 'expensive=drogi', 'sale=wyprzedaż', 'receipt=paragon', 'cash=gotówka',
    'customer=klient', 'change=reszta', 'size=rozmiar', 'try on=przymierzać', 'pay=płacić', 'buy=kupować',
  ]),
  VocabGroup('środowisko', 8, [
    'pollution=zanieczyszczenie', 'environment=środowisko', 'recycle=przetwarzać (recykling)', 'rubbish=śmieci',
    'climate=klimat', 'flood=powódź', 'drought=susza', 'earthquake=trzęsienie ziemi', 'endangered=zagrożony',
    'protect=chronić', 'waste=marnować', 'energy=energia', 'solar panel=panel słoneczny',
  ]),
  VocabGroup('praca i nauka', 8, [
    'job=praca', 'salary=pensja', 'boss=szef', 'interview=rozmowa kwalifikacyjna', 'skill=umiejętność',
    'exam=egzamin', 'grade=ocena', 'subject=przedmiot', 'homework=praca domowa', 'degree=stopień naukowy',
    'experience=doświadczenie', 'career=kariera',
  ]),
  VocabGroup('media i społeczeństwo', 8, [
    'newspaper=gazeta', 'news=wiadomości', 'advertisement=reklama', 'headline=nagłówek', 'journalist=dziennikarz',
    'government=rząd', 'law=prawo', 'crime=przestępstwo', 'vote=głosować', 'citizen=obywatel',
    'volunteer=wolontariusz', 'charity=organizacja charytatywna',
  ]),
];

List<String> _pool(int grade) {
  final out = <String>[];
  for (final g in vocab) {
    if (g.grade <= grade) out.addAll(g.words);
  }
  return out;
}

VocabGroup _group(Random r, int grade) {
  final groups = vocab.where((g) => g.grade <= grade).toList();
  // Częściej grupy z bieżącej klasy.
  final current = groups.where((g) => g.grade == grade).toList();
  if (current.isNotEmpty && r.nextInt(3) > 0) return pick(r, current);
  return pick(r, groups);
}

Task Function(Random) vocabMatch(int grade) => (Random r) {
      final g = _group(r, grade);
      return pairMatch(
        PairBank('e${grade}_vocab', 'Słówka', _e, grade, 'Połącz słówka: ${g.name}', g.words),
        r,
      );
    };

Task Function(Random) vocabChoice(int grade) => (Random r) {
      final g = _group(r, grade);
      final w = pick(r, g.words);
      final en = w.split('=')[0];
      final pl = w.split('=')[1];
      final others = <String>{};
      for (final o in shuffled(r, g.words.length >= 4 ? g.words : _pool(grade))) {
        final e = o.split('=')[0];
        if (e != en) others.add(e);
        if (others.length >= 3) break;
      }
      if (r.nextBool()) {
        return choice('e${grade}_vocab', _e, 'Jak to powiesz po angielsku?', shuffled(r, [en, ...others]), en,
            speak: 'Jak po angielsku powiesz: $pl?', visual: pl, explain: '$pl = $en');
      }
      final plOthers = <String>{};
      for (final o in shuffled(r, g.words)) {
        final p = o.split('=')[1];
        if (p != pl) plOthers.add(p);
        if (plOthers.length >= 3) break;
      }
      return choice('e${grade}_vocab', _e, 'Co to znaczy po polsku?', shuffled(r, [pl, ...plOthers]), pl,
          speak: 'Co znaczy po polsku słowo: $en?', visual: en, explain: '$en = $pl');
    };

// Czasowniki nieregularne: bezokolicznik, past simple, past participle, znaczenie.
const List<List<String>> irregular = [
  ['be', 'was/were', 'been', 'być'], ['go', 'went', 'gone', 'iść'], ['have', 'had', 'had', 'mieć'],
  ['do', 'did', 'done', 'robić'], ['see', 'saw', 'seen', 'widzieć'], ['eat', 'ate', 'eaten', 'jeść'],
  ['drink', 'drank', 'drunk', 'pić'], ['write', 'wrote', 'written', 'pisać'], ['take', 'took', 'taken', 'brać'],
  ['come', 'came', 'come', 'przychodzić'], ['buy', 'bought', 'bought', 'kupować'], ['bring', 'brought', 'brought', 'przynosić'],
  ['think', 'thought', 'thought', 'myśleć'], ['speak', 'spoke', 'spoken', 'mówić'], ['swim', 'swam', 'swum', 'pływać'],
  ['sing', 'sang', 'sung', 'śpiewać'], ['run', 'ran', 'run', 'biegać'], ['give', 'gave', 'given', 'dawać'],
  ['make', 'made', 'made', 'robić, tworzyć'], ['find', 'found', 'found', 'znaleźć'], ['know', 'knew', 'known', 'wiedzieć'],
  ['fly', 'flew', 'flown', 'latać'], ['sleep', 'slept', 'slept', 'spać'], ['read', 'read', 'read', 'czytać'],
  ['begin', 'began', 'begun', 'zaczynać'], ['break', 'broke', 'broken', 'łamać'], ['choose', 'chose', 'chosen', 'wybierać'],
  ['forget', 'forgot', 'forgotten', 'zapominać'], ['get', 'got', 'got', 'dostawać'], ['leave', 'left', 'left', 'opuszczać'],
  ['meet', 'met', 'met', 'spotykać'], ['pay', 'paid', 'paid', 'płacić'], ['sell', 'sold', 'sold', 'sprzedawać'],
  ['teach', 'taught', 'taught', 'uczyć'], ['catch', 'caught', 'caught', 'łapać'], ['wear', 'wore', 'worn', 'nosić (ubranie)'],
  ['win', 'won', 'won', 'wygrywać'], ['lose', 'lost', 'lost', 'gubić, przegrywać'], ['tell', 'told', 'told', 'opowiadać'],
  ['understand', 'understood', 'understood', 'rozumieć'],
];

Task Function(Random) irregularTask(int grade) => (Random r) {
      final v = pick(r, irregular);
      final participle = grade >= 7 && r.nextBool();
      final idx = participle ? 2 : 1;
      final correct = v[idx];
      final regular = '${v[0]}ed';
      final others = <String>{regular, v[participle ? 1 : 2], '${v[0]}s', v[0]}..remove(correct);
      final wrong = shuffled(r, others.toList()).take(3);
      return choice('e${grade}_irregular', _e,
          participle ? 'Podaj trzecią formę (past participle)' : 'Jaka jest forma przeszła (past simple)?',
          shuffled(r, [correct, ...wrong]), correct,
          visual: '${v[0]} (${v[3]})', explain: '${v[0]} – ${v[1]} – ${v[2]}');
    };

const List<String> _aNouns = ['cat', 'dog', 'book', 'pen', 'banana', 'house', 'car', 'bike', 'teacher', 'table', 'university', 'uniform'];
const List<String> _anNouns = ['apple', 'egg', 'orange', 'elephant', 'umbrella', 'ice cream', 'owl', 'hour', 'eye', 'animal'];

Task aAn(Random r) {
  final an = r.nextBool();
  final n = an ? pick(r, _anNouns) : pick(r, _aNouns);
  final c = an ? 'an' : 'a';
  return choice('e4_aan', _e, 'Wstaw a lub an', const ['a', 'an'], c,
      visual: '___ $n',
      hint: '„an” piszemy przed samogłoską w wymowie (an apple, an hour), „a” przed spółgłoską (a university).',
      explain: '$c $n');
}

const List<List<String>> _plurals = [
  ['child', 'children', 'childs'], ['man', 'men', 'mans'], ['woman', 'women', 'womans'], ['mouse', 'mice', 'mouses'],
  ['tooth', 'teeth', 'tooths'], ['foot', 'feet', 'foots'], ['box', 'boxes', 'boxs'], ['bus', 'buses', 'buss'],
  ['baby', 'babies', 'babys'], ['city', 'cities', 'citys'], ['leaf', 'leaves', 'leafs'], ['knife', 'knives', 'knifes'],
  ['sheep', 'sheep', 'sheeps'], ['goose', 'geese', 'gooses'], ['person', 'people', 'peoples'], ['watch', 'watches', 'watchs'],
];

Task plurals(Random r) {
  final p = pick(r, _plurals);
  final opts = shuffled(r, <String>{p[1], p[2], '${p[0]}es'}.toList());
  return choice('e4_plural', _e, 'Jaka jest liczba mnoga?', opts, p[1], visual: 'one ${p[0]} → two ___', explain: '${p[0]} → ${p[1]}');
}

const List<List<String>> _adj = [
  ['big', 'bigger', 'the biggest'], ['small', 'smaller', 'the smallest'], ['tall', 'taller', 'the tallest'],
  ['fast', 'faster', 'the fastest'], ['happy', 'happier', 'the happiest'], ['hot', 'hotter', 'the hottest'],
  ['good', 'better', 'the best'], ['bad', 'worse', 'the worst'], ['far', 'farther', 'the farthest'],
  ['beautiful', 'more beautiful', 'the most beautiful'], ['interesting', 'more interesting', 'the most interesting'],
  ['expensive', 'more expensive', 'the most expensive'], ['easy', 'easier', 'the easiest'], ['young', 'younger', 'the youngest'],
];

Task Function(Random) comparatives(int grade) => (Random r) {
      final a = pick(r, _adj);
      final sup = r.nextBool();
      final c = sup ? a[2] : a[1];
      final wrong = <String>{
        sup ? 'the most ${a[0]}' : 'more ${a[0]}',
        sup ? a[1] : a[2],
        sup ? 'the ${a[0]}est' : '${a[0]}er',
      }..remove(c);
      return choice('e${grade}_comparatives', _e, sup ? 'Stopień najwyższy przymiotnika' : 'Stopień wyższy przymiotnika',
          shuffled(r, [c, ...wrong]), c,
          visual: a[0], explain: '${a[0]} – ${a[1]} – ${a[2]}');
    };

/// Gramatyka – pytania zamknięte (cudzysłów w zdaniach: „…”).
const List<BankTopic> englishGrammar = [
  BankTopic('e4_grammar', 'Gramatyka', _e, 4, [
    "I ___ a student.|am|is|are|I am",
    "She ___ my sister.|is|am|are|she is",
    "They ___ from Poland.|are|is|am|they are",
    "We ___ got a dog.|have|has|is|we have got",
    "He ___ got a new bike.|has|have|is|he has got",
    "___ you like pizza?|Do|Does|Are|Do you like…?",
    "___ she like apples?|Does|Do|Is|Does she…?",
    "I can ___ fast.|run|runs|running|po can – bezokolicznik bez „to”",
    "There ___ a cat on the sofa.|is|are|am|there is + liczba pojedyncza",
    "There ___ three books on the desk.|are|is|am|there are + liczba mnoga",
    "This is ___ book.|my|me|I|my = mój",
    "Where ___ your pencil?|is|are|am|Where is…?",
    "How old ___ you?|are|is|do|How old are you?",
    "Look! The dog is ___ the table. (pod)|under|on|in|under = pod",
    "The cat is ___ the box. (w)|in|on|under|in = w",
    "What colour ___ your bag?|is|are|has|What colour is…?",
    "My brother ___ ten years old.|is|has|are|wiek: to be (He is ten.)",
    "I ___ like spiders.|don't|doesn't|isn't|I don't like…",
    "Ten plus five is ___.|fifteen|fifty|five|15 = fifteen",
    "Twenty minus eight is ___.|twelve|twenty|eight|12 = twelve",
  ]),
  BankTopic('e5_grammar', 'Gramatyka', _e, 5, [
    "She ___ to school every day.|goes|go|going|Present Simple: he/she/it + -s/-es",
    "My dad ___ TV in the evening.|watches|watch|watching|watch → watches",
    "He ___ football on Sundays.|plays|play|is play|he plays",
    "I ___ to the cinema now.|am going|go|goes|teraz → Present Continuous",
    "Look! It ___.|is raining|rains|rain|Look! → Present Continuous",
    "They ___ playing computer games at the moment.|are|is|do|they are + -ing",
    "___ he play the guitar?|Does|Do|Is|pytanie: Does he…?",
    "She doesn't ___ meat.|eat|eats|eating|po doesn't – forma podstawowa",
    "I always ___ breakfast at 7.|have|has|having|I have breakfast",
    "We ___ swim very well.|can|cans|are|can – bez zmian w osobach",
    "___ you speak English?|Can|Do can|Are|Can you…?",
    "How ___ apples do you want?|many|much|lot|policzalne → many",
    "How ___ milk is there?|much|many|lot|niepoliczalne → much",
    "There aren't ___ eggs in the fridge.|any|some|a|przeczenie → any",
    "I'd like ___ water, please.|some|any|many|prośba/twierdzenie → some",
    "This is ___ bag. (Toma)|Tom's|Toms|Tom|dopełniacz saksoński: Tom's",
    "She is good ___ maths.|at|in|on|good at",
    "My birthday is ___ May.|in|on|at|in + miesiąc",
    "The lesson starts ___ 8 o'clock.|at|in|on|at + godzina",
    "We go skiing ___ Saturday.|on|in|at|on + dzień tygodnia",
  ]),
  BankTopic('e6_grammar', 'Gramatyka', _e, 6, [
    "Yesterday I ___ to the zoo.|went|go|goes|Past Simple od go → went",
    "Last year we ___ in Spain.|were|was|are|we were",
    "She ___ at home yesterday.|was|were|is|she was",
    "Did you ___ the film?|see|saw|seen|po did – forma podstawowa",
    "I ___ my homework last night.|did|do|done|do → did",
    "They ___ (not) come to the party.|didn't|don't|weren't|przeczenie w Past Simple: didn't",
    "He ___ a letter two days ago.|wrote|writes|written|ago → Past Simple",
    "What ___ you do last weekend?|did|do|were|pytanie w Past Simple: did",
    "I ___ visit my grandma tomorrow.|will|did|was|tomorrow → will",
    "Look at those clouds! It ___ rain.|is going to|will be|did|są oznaki → be going to",
    "My brother is ___ than me.|taller|tall|tallest|stopień wyższy",
    "This is the ___ day of my life!|best|good|better|good – better – the best",
    "You ___ wear a helmet on a bike.|should|shouldn't|can't|rada → should",
    "We ___ go to school on Sunday.|don't have to|mustn't|must|brak obowiązku → don't have to",
    "You ___ smoke here! It's forbidden.|mustn't|don't have to|should|zakaz → mustn't",
    "While I ___ dinner, the phone rang.|was cooking|cooked|am cooking|czynność w toku w przeszłości → Past Continuous",
    "There ___ many people at the concert yesterday.|were|was|are|liczba mnoga w przeszłości → were",
    "I'm ___ in science.|interested|interesting|interest|o uczuciach → -ed",
    "Who ___ the window?|broke|did break|breaks|pytanie o podmiot – bez did",
    "I usually ___ to bed at 10.|go|went|am going|usually → Present Simple",
  ]),
  BankTopic('e7_grammar', 'Gramatyka', _e, 7, [
    "I have ___ been to London.|never|ever|yet|never = nigdy",
    "Have you ___ eaten sushi?|ever|never|already|Have you ever…?",
    "She has ___ finished her homework.|already|yet|ever|already = już (twierdzenie)",
    "I haven't done it ___.|yet|already|never|yet – na końcu przeczeń i pytań",
    "We ___ here since 2015.|have lived|live|lived|since → Present Perfect",
    "He has worked here ___ five years.|for|since|ago|for + okres czasu",
    "I ___ my keys! I can't find them.|have lost|lost|lose|skutek widoczny teraz → Present Perfect",
    "If it rains, we ___ at home.|will stay|stay|stayed|First Conditional: If + Present, will",
    "If you ___ hard, you will pass.|study|will study|studied|po if – Present Simple",
    "The book ___ by Tolkien.|was written|wrote|is writing|strona bierna: was + III forma",
    "English ___ all over the world.|is spoken|speaks|is speaking|strona bierna w czasie teraźniejszym",
    "She ___ play the piano when she was five.|could|can|must|przeszłość od can → could",
    "This is the boy ___ won the race.|who|which|where|osoba → who",
    "This is the house ___ I was born.|where|which|who|miejsce → where",
    "I'm looking forward to ___ you.|seeing|see|saw|look forward to + -ing",
    "She enjoys ___ books.|reading|to read|read|enjoy + -ing",
    "I want ___ a doctor.|to be|being|be|want + to",
    "He is ___ to reach the shelf. (wystarczająco wysoki)|tall enough|enough tall|too tall|przymiotnik + enough",
    "It's ___ cold to swim. (zbyt)|too|enough|very much|too = zbyt",
    "How long ___ you known her?|have|did|are|How long have you…?",
  ]),
  BankTopic('e8_grammar', 'Gramatyka', _e, 8, [
    "If I ___ rich, I would travel the world.|were|am|will be|Second Conditional: If + Past",
    "If I had a dog, I ___ walk it every day.|would|will|did|Second Conditional: would + bezokolicznik",
    "When I arrived, the film ___.|had started|has started|starts|wcześniejsza czynność → Past Perfect",
    "She said that she ___ tired.|was|is|will|mowa zależna – cofamy czas",
    "He asked me where I ___.|lived|do live|live|pytanie zależne – szyk zdania oznajmującego",
    "The bridge ___ next year.|will be built|will build|is built|strona bierna w przyszłości",
    "The letter ___ already ___ sent.|has … been|have … be|was … being|strona bierna Present Perfect",
    "I wish I ___ taller.|were|am|will be|życzenie dot. teraźniejszości → wish + Past",
    "She is used to ___ early.|getting up|get up|got up|be used to + -ing",
    "I ___ to play football every day when I was little.|used|use|was used|used to – dawny zwyczaj",
    "You'd better ___ now.|go|to go|going|had better + bezokolicznik bez to",
    "I've been waiting ___ two hours!|for|since|during|for + okres",
    "She ___ be at home – the lights are on.|must|can't|mustn't|pewność → must",
    "He ___ be French – he speaks only English.|can't|must|mustn't|niemożliwe → can't",
    "Unless you hurry, you ___ miss the bus.|will|would|won't|unless = if not",
    "It's the ___ interesting book I've ever read.|most|more|much|stopień najwyższy",
    "Neither Tom ___ Ann came.|nor|or|and|neither … nor",
    "I'm not used ___ such hot weather.|to|for|with|be used to",
    "By the time we got there, they ___.|had left|left|have left|Past Perfect",
    "She made me ___ the room.|clean|to clean|cleaning|make somebody do",
  ]),
];

Task e4AAnOrPlural(Random r) => r.nextBool() ? aAn(r) : plurals(r);
