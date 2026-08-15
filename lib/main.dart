// File: lib/main.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const AbacusMasterApp());
}

enum AppLanguage { english, telugu, hindi }
enum SkillLevel { beginner, intermediate, advanced }
enum OperationType { addition, subtraction, multiplication, division }

class AbacusMasterApp extends StatelessWidget {
  const AbacusMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abacus Master Pro',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111318),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF59E0B),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E222D),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// LOCALIZED STRINGS & KNOWLEDGE BASE
// ---------------------------------------------------------------------------
class AppStrings {
  static String tr(String key, AppLanguage lang) {
    final Map<String, Map<AppLanguage, String>> data = {
      'app_title': {
        AppLanguage.english: 'Abacus Master Pro',
        AppLanguage.telugu: 'అబాకస్ మాస్టర్ ప్రో',
        AppLanguage.hindi: 'अबेकस मास्टर प्रो',
      },
      'tab_learn': {
        AppLanguage.english: 'Learn & Demo',
        AppLanguage.telugu: 'పాఠాలు & డెమో',
        AppLanguage.hindi: 'सीखें और डेमो',
      },
      'tab_practice': {
        AppLanguage.english: 'Free Board',
        AppLanguage.telugu: 'ఉచిత బోర్డు',
        AppLanguage.hindi: 'फ्री बोर्ड',
      },
      'tab_quiz': {
        AppLanguage.english: 'Assessment',
        AppLanguage.telugu: 'పరీక్ష & క్విజ్',
        AppLanguage.hindi: 'परीक्षा और क्विज',
      },
      'tab_help': {
        AppLanguage.english: 'Formulas & Help',
        AppLanguage.telugu: 'సూత్రాలు & సహాయం',
        AppLanguage.hindi: 'सूत्र और सहायता',
      },
      'beginner': {
        AppLanguage.english: 'Beginner (Basics & Direct)',
        AppLanguage.telugu: 'ప్రారంభ స్థాయి (ప్రాథమికాలు)',
        AppLanguage.hindi: 'शुरुआती (मूल बातें)',
      },
      'intermediate': {
        AppLanguage.english: 'Intermediate (Friends Formulas)',
        AppLanguage.telugu: 'మధ్యస్థ స్థాయి (మిత్రుల సూత్రాలు)',
        AppLanguage.hindi: 'मध्यम (मित्र सूत्र)',
      },
      'advanced': {
        AppLanguage.english: 'Advanced (Mul, Div & Speed)',
        AppLanguage.telugu: 'ఉన్నత స్థాయి (గుణకారం & భాగహారం)',
        AppLanguage.hindi: 'उन्नत (गुणा और भाग)',
      },
      'reset': {
        AppLanguage.english: 'Clear / Zero',
        AppLanguage.telugu: 'క్లియర్ / సున్నా',
        AppLanguage.hindi: 'साफ़ करें / शून्य',
      },
      'voice_guide': {
        AppLanguage.english: 'Voice Explanation',
        AppLanguage.telugu: 'వాయిస్ వివరణ',
        AppLanguage.hindi: 'आवाज़ से समझें',
      },
    };
    return data[key]?[lang] ?? key;
  }
}

// ---------------------------------------------------------------------------
// MAIN NAVIGATION SCREEN
// ---------------------------------------------------------------------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  AppLanguage _selectedLanguage = AppLanguage.telugu;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  Future<void> _initTTS() async {
    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(1.0);
  }

  void _speak(String text) async {
    await _tts.stop();
    String langCode = _selectedLanguage == AppLanguage.telugu
        ? 'te-IN'
        : (_selectedLanguage == AppLanguage.hindi ? 'hi-IN' : 'en-US');
    await _tts.setLanguage(langCode);
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      LearnModuleScreen(lang: _selectedLanguage, onSpeak: _speak),
      InteractivePracticeScreen(lang: _selectedLanguage, onSpeak: _speak),
      AssessmentScreen(lang: _selectedLanguage, onSpeak: _speak),
      HelpFormulasScreen(lang: _selectedLanguage),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.tr('app_title', _selectedLanguage),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF1E222D),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2B313F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<AppLanguage>(
              value: _selectedLanguage,
              dropdownColor: const Color(0xFF2B313F),
              underline: const SizedBox(),
              icon: const Icon(Icons.language, color: Colors.amber, size: 20),
              items: const [
                DropdownMenuItem(value: AppLanguage.english, child: Text('English')),
                DropdownMenuItem(value: AppLanguage.telugu, child: Text('తెలుగు')),
                DropdownMenuItem(value: AppLanguage.hindi, child: Text('हिन्दी')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedLanguage = val);
              },
            ),
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E222D),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.school),
            label: AppStrings.tr('tab_learn', _selectedLanguage),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calculate),
            label: AppStrings.tr('tab_practice', _selectedLanguage),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.quiz),
            label: AppStrings.tr('tab_quiz', _selectedLanguage),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book),
            label: AppStrings.tr('tab_help', _selectedLanguage),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. STRUCTURED LEARN & INTERACTIVE DEMO MODULE
// ---------------------------------------------------------------------------
class LessonItem {
  final String titleEn, titleTe, titleHi;
  final String descEn, descTe, descHi;
  final String actionEn, actionTe, actionHi;
  final SkillLevel level;
  final List<bool> targetUpper;
  final List<int> targetLower;

  const LessonItem({
    required this.titleEn,
    required this.titleTe,
    required this.titleHi,
    required this.descEn,
    required this.descTe,
    required this.descHi,
    required this.actionEn,
    required this.actionTe,
    required this.actionHi,
    required this.level,
    required this.targetUpper,
    required this.targetLower,
  });

  String getTitle(AppLanguage l) =>
      l == AppLanguage.telugu ? titleTe : (l == AppLanguage.hindi ? titleHi : titleEn);
  String getDesc(AppLanguage l) =>
      l == AppLanguage.telugu ? descTe : (l == AppLanguage.hindi ? descHi : descEn);
  String getAction(AppLanguage l) =>
      l == AppLanguage.telugu ? actionTe : (l == AppLanguage.hindi ? actionHi : actionEn);
}

final List<LessonItem> comprehensiveLessons = [
  // Beginner
  LessonItem(
    level: SkillLevel.beginner,
    titleEn: '1. Anatomy & Place Values (1s, 10s, 100s, 1000s)',
    titleTe: '1. అబాకస్ నిర్మాణం & స్థాన విలువలు (ఒకట్లు, పదులు, వందలు, వేలు)',
    titleHi: '1. अबेकस संरचना और स्थानीय मान (इकाई, दहाई, सैकड़ा, हज़ार)',
    descEn: 'From right to left: Rod 1 is Units, Rod 2 is Tens, Rod 3 is Hundreds, Rod 4 is Thousands. Top bead is value 5. Each bottom bead is value 1.',
    descTe: 'కుడి నుండి ఎడమకు: 1వ కడ్డీ ఒకట్లు, 2వది పదులు, 3వది వందలు, 4వది వేల స్థానం. పై పూస విలువ 5. క్రింది ప్రతి పూస విలువ 1.',
    descHi: 'दाएं से बाएं: पहली रॉड इकाई, दूसरी दहाई, तीसरी सैकड़ा, चौथी हज़ार है। ऊपर का मनका 5 का है और नीचे का प्रत्येक मनका 1 का है।',
    actionEn: 'Demo: Showing 1,234 (1 Thousand, 2 Hundreds, 3 Tens, 4 Units).',
    actionTe: 'డెమో: 1,234 ను సూచిస్తుంది (1 వేయి, 2 వందలు, 3 పదులు, 4 ఒకట్లు).',
    actionHi: 'डेमो: 1,234 प्रदर्शित (1 हज़ार, 2 सैकड़ा, 3 दहाई, 4 इकाई)।',
    targetUpper: [false, false, false, false],
    targetLower: [1, 2, 3, 4],
  ),
  LessonItem(
    level: SkillLevel.beginner,
    titleEn: '2. Direct Subtraction in Units & Tens',
    titleTe: '2. ఒకట్లు మరియు పదుల స్థానాల్లో తీసివేత విధానం',
    titleHi: '2. इकाई और दहाई में सीधी घटाव विधि',
    descEn: 'To subtract lower beads, move them DOWN away from the center beam. To subtract upper bead (5), move it UP away from the beam.',
    descTe: 'తీసివేయడానికి (Subtract): క్రింది పూసలను కిందకు జరపాలి. పై పూస (5) ను తీసివేయడానికి పైకి జరపాలి.',
    descHi: 'घटाने के लिए: नीचे के मोतियों को बीच की पट्टी से दूर नीचे करें। ऊपर के मोती (5) को ऊपर करें।',
    actionEn: 'Demo: Setting 50 (Tens upper bead active).',
    actionTe: 'డెమో: పదుల స్థానంలో 50 సెట్ చేయబడింది.',
    actionHi: 'डेमो: दहाई स्थान पर 50 सेट है।',
    targetUpper: [false, false, true, false],
    targetLower: [0, 0, 0, 0],
  ),
  // Intermediate
  LessonItem(
    level: SkillLevel.intermediate,
    titleEn: '3. Small Friends Addition (+4 = +5 - 1)',
    titleTe: '3. చిన్న మిత్రుల కూడిక సూత్రం (+4 = +5 - 1)',
    titleHi: '3. छोटे मित्र जोड़ सूत्र (+4 = +5 - 1)',
    descEn: 'When lower beads are not enough to add 4: Push down upper bead (+5) and pull down 1 lower bead (-1).',
    descTe: '4 కలపడానికి క్రింది పూసలు సరిపోనప్పుడు: పై పూసను కిందకు దించి (+5), ఒక క్రింది పూసను తీసివేయండి (-1).',
    descHi: '4 जोड़ने के लिए जब नीचे मनके न हों: ऊपर का मनका नीचे लाएं (+5) और नीचे का 1 मनका हटाएं (-1)।',
    actionEn: 'Rule Applied: +4 = +5 - 1 on Units Rod.',
    actionTe: 'సూత్రం: ఒకట్ల స్థానంలో +4 = +5 - 1 అమలు చేయబడింది.',
    actionHi: 'नियम: इकाई रॉड पर +4 = +5 - 1 लागू किया गया।',
    targetUpper: [false, false, false, true],
    targetLower: [0, 0, 0, 0],
  ),
  LessonItem(
    level: SkillLevel.intermediate,
    titleEn: '4. Big Friends Subtraction (-9 = -10 + 1)',
    titleTe: '4. పెద్ద మిత్రుల తీసివేత సూత్రం (-9 = -10 + 1)',
    titleHi: '4. बड़े मित्र घटाव सूत्र (-9 = -10 + 1)',
    descEn: 'To subtract 9 when not enough beads: Remove 1 bead on Tens rod (-10) and add 1 bead on Units rod (+1).',
    descTe: '9 తీసివేయడానికి: పదుల స్థానంలో 1 పూసను తీసివేసి (-10), ఒకట్ల స్థానంలో 1 పూసను కలపండి (+1).',
    descHi: '9 घटाने के लिए: दहाई से 1 मनका हटाएं (-10) और इकाई पर 1 मनका जोड़ें (+1)।',
    actionEn: 'Value showing 1 after subtracting 9 from 10.',
    actionTe: '10 నుండి 9 తీసివేసిన తర్వాత మిగిలిన విలువ 1.',
    actionHi: '10 में से 9 घटाने के बाद शेष मान 1।',
    targetUpper: [false, false, false, false],
    targetLower: [0, 0, 0, 1],
  ),
  // Advanced
  LessonItem(
    level: SkillLevel.advanced,
    titleEn: '5. Fast Multiplication Tricks (2D x 1D)',
    titleTe: '5. వేగవంతమైన గుణకారం పద్ధతులు (2 అంకెలు x 1 అంకె)',
    titleHi: '5. तेज़ गुणा तकनीक (2D x 1D)',
    descEn: 'Example: 24 x 3. Step 1: Multiply 20 x 3 = 60 (Set on Tens). Step 2: Multiply 4 x 3 = 12 (Set 1 on Tens, 2 on Units). Total = 72.',
    descTe: 'ఉదాహరణ: 24 x 3. దశ 1: 20 x 3 = 60 (పదులలో 6). దశ 2: 4 x 3 = 12 (పదులలో 1, ఒకట్లలో 2). మొత్తం = 72.',
    descHi: 'उदाहरण: 24 x 3। चरण 1: 20 x 3 = 60 (दहाई पर 6)। चरण 2: 4 x 3 = 12 (दहाई पर 1, इकाई पर 2)। कुल = 72।',
    actionEn: 'Target Result: 72 on Abacus.',
    actionTe: 'అబాకస్ పై ఫలితం: 72.',
    actionHi: 'अबेकस पर परिणाम: 72.',
    targetUpper: [false, false, true, false],
    targetLower: [0, 0, 2, 2],
  ),
  LessonItem(
    level: SkillLevel.advanced,
    titleEn: '6. Division & Remainder Placement (84 / 4)',
    titleTe: '6. భాగహారం మరియు శేషం కేటాయింపు (84 / 4)',
    titleHi: '6. भाग विधि और परिणाम (84 / 4)',
    descEn: 'Divide left to right: 8 / 4 = 2 (Set 2 on Tens). 4 / 4 = 1 (Set 1 on Units). Quotient = 21.',
    descTe: 'ఎడమ నుండి కుడికి: 8 / 4 = 2 (పదులలో 2). 4 / 4 = 1 (ఒకట్లలో 1). సమాధానం = 21.',
    descHi: 'बाएं से दाएं: 8 / 4 = 2 (दहाई पर 2)। 4 / 4 = 1 (इकाई पर 1)। भागफल = 21।',
    actionEn: 'Target Result: 21.',
    actionTe: 'అబాకస్ పై భాగఫలం: 21.',
    actionHi: 'अबेकस पर उत्तर: 21.',
    targetUpper: [false, false, false, false],
    targetLower: [0, 0, 2, 1],
  ),
];

class LearnModuleScreen extends StatefulWidget {
  final AppLanguage lang;
  final Function(String) onSpeak;

  const LearnModuleScreen({super.key, required this.lang, required this.onSpeak});

  @override
  State<LearnModuleScreen> createState() => _LearnModuleScreenState();
}

class _LearnModuleScreenState extends State<LearnModuleScreen> {
  int _lessonIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lesson = comprehensiveLessons[_lessonIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Lesson Selector Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222D),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lesson.getTitle(widget.lang),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.amber),
                      onPressed: () => widget.onSpeak('${lesson.getTitle(widget.lang)}. ${lesson.getDesc(widget.lang)}'),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  lesson.getDesc(widget.lang),
                  style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    lesson.getAction(widget.lang),
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Abacus Board Demo
          AbacusBoardWidget(
            upperActive: lesson.targetUpper,
            lowerActiveCount: lesson.targetLower,
            isInteractive: false,
            lang: widget.lang,
          ),

          const SizedBox(height: 16),

          // Navigation Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _lessonIndex > 0
                    ? () => setState(() => _lessonIndex--)
                    : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
              ),
              Text(
                '${_lessonIndex + 1} / ${comprehensiveLessons.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
              ),
              ElevatedButton.icon(
                onPressed: _lessonIndex < comprehensiveLessons.length - 1
                    ? () => setState(() => _lessonIndex++)
                    : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. FREE INTERACTIVE PRACTICE & REAL-TIME DECONSTRUCTION
// ---------------------------------------------------------------------------
class InteractivePracticeScreen extends StatefulWidget {
  final AppLanguage lang;
  final Function(String) onSpeak;

  const InteractivePracticeScreen({super.key, required this.lang, required this.onSpeak});

  @override
  State<InteractivePracticeScreen> createState() => _InteractivePracticeScreenState();
}

class _InteractivePracticeScreenState extends State<InteractivePracticeScreen> {
  List<bool> upper = [false, false, false, false];
  List<int> lower = [0, 0, 0, 0];

  int get total {
    int sum = 0;
    int mult = 1000;
    for (int i = 0; i < 4; i++) {
      sum += ((upper[i] ? 5 : 0) + lower[i]) * mult;
      mult ~/= 10;
    }
    return sum;
  }

  void _clear() {
    setState(() {
      upper = [false, false, false, false];
      lower = [0, 0, 0, 0];
    });
  }

  String _getDeconstructionText() {
    int th = (upper[0] ? 5 : 0) + lower[0];
    int h = (upper[1] ? 5 : 0) + lower[1];
    int t = (upper[2] ? 5 : 0) + lower[2];
    int u = (upper[3] ? 5 : 0) + lower[3];

    if (widget.lang == AppLanguage.telugu) {
      return 'విలువ: $total\nవేలు (1000s): $th | వందలు (100s): $h | పదులు (10s): $t | ఒకట్లు (1s): $u';
    } else if (widget.lang == AppLanguage.hindi) {
      return 'कुल मान: $total\nहज़ार (1000s): $th | सैकड़ा (100s): $h | दहाई (10s): $t | इकाई (1s): $u';
    } else {
      return 'Value: $total\nThousands: $th | Hundreds: $h | Tens: $t | Units: $u';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  _getDeconstructionText(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.amber, fontWeight: FontWeight.bold, height: 1.5),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: _clear,
                  icon: const Icon(Icons.refresh),
                  label: Text(AppStrings.tr('reset', widget.lang)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AbacusBoardWidget(
            upperActive: upper,
            lowerActiveCount: lower,
            isInteractive: true,
            lang: widget.lang,
            onChanged: (u, l) {
              setState(() {
                upper = u;
                lower = l;
              });
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. DYNAMIC ASSESSMENT & PROCEDURAL QUIZ (NO REPEATS)
// ---------------------------------------------------------------------------
class QuizQuestion {
  final int num1;
  final int num2;
  final OperationType op;
  final int answer;
  final String formulaKey;

  QuizQuestion({
    required this.num1,
    required this.num2,
    required this.op,
    required this.answer,
    required this.formulaKey,
  });

  String getExplanation(AppLanguage l) {
    String opSym = op == OperationType.addition ? '+' : (op == OperationType.subtraction ? '-' : (op == OperationType.multiplication ? 'x' : '/'));
    if (l == AppLanguage.telugu) {
      return 'వివరణ: $num1 $opSym $num2 = $answer.\nసూత్రం/ట్రిక్: $formulaKey';
    } else if (l == AppLanguage.hindi) {
      return 'स्पष्टीकरण: $num1 $opSym $num2 = $answer।\nसूत्र / ट्रिक: $formulaKey';
    } else {
      return 'Explanation: $num1 $opSym $num2 = $answer.\nRule/Trick: $formulaKey';
    }
  }
}

class AssessmentScreen extends StatefulWidget {
  final AppLanguage lang;
  final Function(String) onSpeak;

  const AssessmentScreen({super.key, required this.lang, required this.onSpeak});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final Random _rnd = Random();
  final Set<String> _usedQuestions = {};
  SkillLevel _level = SkillLevel.beginner;
  QuizQuestion? _currentQ;
  List<int> _options = [];
  int _score = 0;
  int _totalAnswered = 0;
  String? _feedbackText;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      _isAnswered = false;
      _feedbackText = null;
      _currentQ = _generateUniqueQuestion();
      _generateOptions();
    });
  }

  QuizQuestion _generateUniqueQuestion() {
    int n1 = 0, n2 = 0, ans = 0;
    OperationType op = OperationType.addition;
    String trick = "";

    for (int attempts = 0; attempts < 100; attempts++) {
      if (_level == SkillLevel.beginner) {
        op = _rnd.nextBool() ? OperationType.addition : OperationType.subtraction;
        if (op == OperationType.addition) {
          n1 = _rnd.nextInt(5) + 1;
          n2 = _rnd.nextInt(4) + 1;
          ans = n1 + n2;
          trick = ans >= 5 ? 'Direct lower beads + Upper bead (5)' : 'Direct move lower beads up.';
        } else {
          n1 = _rnd.nextInt(8) + 2;
          n2 = _rnd.nextInt(n1) + 1;
          ans = n1 - n2;
          trick = 'Direct move beads away from beam.';
        }
      } else if (_level == SkillLevel.intermediate) {
        op = _rnd.nextBool() ? OperationType.addition : OperationType.subtraction;
        if (op == OperationType.addition) {
          n1 = _rnd.nextInt(20) + 5;
          n2 = 4; // Small friends focus
          ans = n1 + n2;
          trick = '+4 = +5 - 1 (Push +5 down, subtract 1).';
        } else {
          n1 = _rnd.nextInt(30) + 10;
          n2 = 9; // Big friends focus
          ans = n1 - n2;
          trick = '-9 = -10 + 1 (Tens rod -1, Units rod +1).';
        }
      } else {
        op = _rnd.nextBool() ? OperationType.multiplication : OperationType.division;
        if (op == OperationType.multiplication) {
          n1 = _rnd.nextInt(40) + 11;
          n2 = _rnd.nextInt(7) + 2;
          ans = n1 * n2;
          trick = 'Split Multiply: ($n1 x $n2) = (${(n1 ~/ 10) * 10} x $n2) + (${n1 % 10} x $n2).';
        } else {
          int quotient = _rnd.nextInt(20) + 2;
          n2 = _rnd.nextInt(5) + 2;
          n1 = quotient * n2;
          ans = quotient;
          trick = 'Divide highest rod first and place quotient on left.';
        }
      }

      String qKey = '$n1-$op-$n2';
      if (!_usedQuestions.contains(qKey)) {
        _usedQuestions.add(qKey);
        return QuizQuestion(num1: n1, num2: n2, op: op, answer: ans, formulaKey: trick);
      }
    }
    return QuizQuestion(num1: 12, num2: 4, op: OperationType.addition, answer: 16, formulaKey: '+4 = +5 - 1');
  }

  void _generateOptions() {
    if (_currentQ == null) return;
    Set<int> opts = {_currentQ!.answer};
    while (opts.length < 4) {
      int offset = _rnd.nextInt(9) - 4;
      int fake = _currentQ!.answer + (offset == 0 ? 5 : offset);
      if (fake >= 0) opts.add(fake);
    }
    _options = opts.toList()..shuffle();
  }

  void _checkAnswer(int selected) {
    if (_isAnswered || _currentQ == null) return;
    setState(() {
      _isAnswered = true;
      _totalAnswered++;
      if (selected == _currentQ!.answer) {
        _score++;
        _feedbackText = widget.lang == AppLanguage.telugu
            ? 'సరైన సమాధానం! అద్భుతం.'
            : (widget.lang == AppLanguage.hindi ? 'सही उत्तर! बहुत बढ़िया।' : 'Correct! Excellent speed.');
      } else {
        _feedbackText = '${widget.lang == AppLanguage.telugu ? 'తప్పు సమాధానం!' : (widget.lang == AppLanguage.hindi ? 'गलत उत्तर!' : 'Incorrect!')}\n${_currentQ!.getExplanation(widget.lang)}';
      }
      widget.onSpeak(_feedbackText!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQ == null) return const SizedBox();
    String opSym = _currentQ!.op == OperationType.addition ? '+' : (_currentQ!.op == OperationType.subtraction ? '-' : (_currentQ!.op == OperationType.multiplication ? '×' : '÷'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Level Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: const Text('Beginner'),
                selected: _level == SkillLevel.beginner,
                onSelected: (s) => setState(() { _level = SkillLevel.beginner; _nextQuestion(); }),
              ),
              ChoiceChip(
                label: const Text('Intermediate'),
                selected: _level == SkillLevel.intermediate,
                onSelected: (s) => setState(() { _level = SkillLevel.intermediate; _nextQuestion(); }),
              ),
              ChoiceChip(
                label: const Text('Advanced'),
                selected: _level == SkillLevel.advanced,
                onSelected: (s) => setState(() { _level = SkillLevel.advanced; _nextQuestion(); }),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Score Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222D),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Score: $_score / $_totalAnswered',
              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          // Question Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Text(
              '${_currentQ!.num1}  $opSym  ${_currentQ!.num2} = ?',
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),

          // Options Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: _options.map((opt) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAnswered
                      ? (opt == _currentQ!.answer ? Colors.green : Colors.grey.shade800)
                      : const Color(0xFF2B313F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isAnswered ? null : () => _checkAnswer(opt),
                child: Text('$opt', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Feedback Box
          if (_feedbackText != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _feedbackText!.startsWith('Correct') || _feedbackText!.startsWith('సరైన') || _feedbackText!.startsWith('सही')
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Text(
                _feedbackText!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.white),
              ),
            ),

          const SizedBox(height: 16),
          if (_isAnswered)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              onPressed: _nextQuestion,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next Problem', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. FORMULAS, HELP & RULES REFERENCE
// ---------------------------------------------------------------------------
class HelpFormulasScreen extends StatelessWidget {
  final AppLanguage lang;

  const HelpFormulasScreen({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            lang == AppLanguage.telugu ? 'చిన్న మిత్రుల సూత్రాలు (+5 / -5)' : (lang == AppLanguage.hindi ? 'छोटे मित्र सूत्र (+5 / -5)' : 'Small Friends Rules (+5 / -5)'),
          ),
          _buildRuleTile('+4 = +5 - 1', '-4 = -5 + 1'),
          _buildRuleTile('+3 = +5 - 2', '-3 = -5 + 2'),
          _buildRuleTile('+2 = +5 - 3', '-2 = -5 + 3'),
          _buildRuleTile('+1 = +5 - 4', '-1 = -5 + 4'),
          const SizedBox(height: 16),

          _buildSectionHeader(
            lang == AppLanguage.telugu ? 'పెద్ద మిత్రుల సూత్రాలు (+10 / -10)' : (lang == AppLanguage.hindi ? 'बड़े मित्र सूत्र (+10 / -10)' : 'Big Friends Rules (+10 / -10)'),
          ),
          _buildRuleTile('+9 = +10 - 1', '-9 = -10 + 1'),
          _buildRuleTile('+8 = +10 - 2', '-8 = -10 + 2'),
          _buildRuleTile('+7 = +10 - 3', '-7 = -10 + 3'),
          _buildRuleTile('+6 = +10 - 4', '-6 = -10 + 4'),
          _buildRuleTile('+5 = +10 - 5', '-5 = -10 + 5'),
          const SizedBox(height: 16),

          _buildSectionHeader(
            lang == AppLanguage.telugu ? 'గుణకారం & భాగహారం ట్రిక్స్' : (lang == AppLanguage.hindi ? 'गुणा और भाग ट्रिक्स' : 'Speed Multiplication & Division Tricks'),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222D),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              lang == AppLanguage.telugu
                  ? '• గుణకారం: ఎల్లప్పుడూ పదుల స్థానాన్ని ముందుగా గుణించి, ఆ తర్వాత ఒకట్లను కలపండి.\n• భాగహారం: ఎడమ వైపు (అత్యధిక స్థానం) నుండి భాగించి భాగఫలాన్ని ఎడమ కడ్డీలపై నమోదు చేయండి.'
                  : (lang == AppLanguage.hindi
                      ? '• गुणा: हमेशा पहले दहाई के अंक से गुणा करें और फिर इकाई का मान जोड़ें।\n• भाग: बाईं ओर से शुरू करें और भागफल को बाईं रॉड पर सेट करें।'
                      : '• Multiplication: Multiply highest place value first, add units product subsequently.\n• Division: Process from left to right; set quotient on left side rods.'),
              style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber),
      ),
    );
  }

  Widget _buildRuleTile(String r1, String r2) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E222D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(r1, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
          Text(r2, style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. REUSABLE ANIMATED ABACUS BOARD WIDGET
// ---------------------------------------------------------------------------
class AbacusBoardWidget extends StatelessWidget {
  final List<bool> upperActive;
  final List<int> lowerActiveCount;
  final bool isInteractive;
  final AppLanguage lang;
  final Function(List<bool>, List<int>)? onChanged;

  const AbacusBoardWidget({
    super.key,
    required this.upperActive,
    required this.lowerActiveCount,
    required this.isInteractive,
    required this.lang,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> rodLabels = lang == AppLanguage.telugu
        ? ['వేలు', 'వందలు', 'పదులు', 'ఒకట్లు']
        : (lang == AppLanguage.hindi ? ['हज़ार', 'सैकड़ा', 'दहाई', 'इकाई'] : ['1000s', '100s', '10s', '1s']);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B2313),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF261407), width: 6),
      ),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF0C0D11),
            height: 290,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (rodIdx) => _buildRod(rodIdx)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (i) => SizedBox(
                width: 60,
                child: Text(
                  rodLabels[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRod(int rodIdx) {
    bool isUpperOn = upperActive[rodIdx];
    int lowerCount = lowerActiveCount[rodIdx];

    return SizedBox(
      width: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Metal Rod
          Container(width: 4, height: double.infinity, color: Colors.grey.shade600),

          Column(
            children: [
              // UPPER DECK
              SizedBox(
                height: 75,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      top: isUpperOn ? 32 : 0,
                      left: 6,
                      child: GestureDetector(
                        onTap: isInteractive
                            ? () {
                                List<bool> newUpper = List.from(upperActive);
                                newUpper[rodIdx] = !newUpper[rodIdx];
                                onChanged?.call(newUpper, lowerActiveCount);
                              }
                            : null,
                        child: _buildBead(Colors.deepOrangeAccent),
                      ),
                    ),
                  ],
                ),
              ),

              // BEAM
              Container(
                height: 10,
                width: double.infinity,
                color: const Color(0xFFD4AF37),
                alignment: Alignment.center,
                child: rodIdx == 3
                    ? const CircleAvatar(radius: 2, backgroundColor: Colors.black)
                    : null,
              ),

              // LOWER DECK
              Expanded(
                child: Stack(
                  children: List.generate(4, (beadIdx) {
                    bool isActive = beadIdx < lowerCount;
                    double defaultPos = (3 - beadIdx) * 25.0;
                    double activePos = (3 - beadIdx) * 25.0 + 65.0;

                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      bottom: isActive ? activePos : defaultPos,
                      left: 6,
                      child: GestureDetector(
                        onTap: isInteractive
                            ? () {
                                List<int> newLower = List.from(lowerActiveCount);
                                newLower[rodIdx] = isActive ? beadIdx : beadIdx + 1;
                                onChanged?.call(upperActive, newLower);
                              }
                            : null,
                        child: _buildBead(
                          isActive ? Colors.cyanAccent.shade400 : Colors.blueGrey.shade700,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBead(Color color) {
    return Container(
      width: 48,
      height: 22,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.elliptical(48, 22)),
        boxShadow: const [
          BoxShadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 2)
        ],
      ),
    );
  }
}
