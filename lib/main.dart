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
      title: 'Abacus Master Deluxe',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0F14),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFB300),
          secondary: Color(0xFF00E676),
          surface: Color(0xFF161922),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// LOCALIZATION REPOSITORY
// ---------------------------------------------------------------------------
class AppStrings {
  static String tr(String key, AppLanguage lang) {
    final Map<String, Map<AppLanguage, String>> data = {
      'app_title': {
        AppLanguage.english: 'Abacus Master Pro',
        AppLanguage.telugu: 'అబాకస్ మాస్టర్ ప్రో',
        AppLanguage.hindi: 'अबेकस मास्टर प्रो',
      },
      'tab_demo': {
        AppLanguage.english: 'Operations Demo',
        AppLanguage.telugu: 'ఆపరేషన్స్ డెమో',
        AppLanguage.hindi: 'क्रियाएं व डेमो',
      },
      'tab_practice': {
        AppLanguage.english: 'Free Board',
        AppLanguage.telugu: 'ఫ్రీ బోర్డు',
        AppLanguage.hindi: 'फ्री बोर्ड',
      },
      'tab_assessment': {
        AppLanguage.english: 'Smart Test',
        AppLanguage.telugu: 'స్మార్ట్ టెస్ట్',
        AppLanguage.hindi: 'स्मार्ट परीक्षा',
      },
      'tab_help': {
        AppLanguage.english: 'Rules & FAQ',
        AppLanguage.telugu: 'సందేహాలు & సూత్రాలు',
        AppLanguage.hindi: 'नियम व समाधान',
      },
      'reset': {
        AppLanguage.english: 'Clear Rods',
        AppLanguage.telugu: 'బోర్డు క్లియర్ చేయండి',
        AppLanguage.hindi: 'बोर्ड साफ़ करें',
      },
      'voice_btn': {
        AppLanguage.english: 'Listen Explanation',
        AppLanguage.telugu: 'వాయిస్ వివరణ వినండి',
        AppLanguage.hindi: 'आवाज़ में समझें',
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
    await _tts.setSpeechRate(0.43);
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
      InteractiveLessonDemoScreen(lang: _selectedLanguage, onSpeak: _speak),
      InteractivePracticeScreen(lang: _selectedLanguage, onSpeak: _speak),
      AssessmentScreen(lang: _selectedLanguage, onSpeak: _speak),
      RichHelpSectionScreen(lang: _selectedLanguage, onSpeak: _speak),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        backgroundColor: const Color(0xFF161922),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0x33FFB300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.calculate, color: Color(0xFFFFB300), size: 22),
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.tr('app_title', _selectedLanguage),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2E3D), Color(0xFF1E212B)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x80FFB300)),
            ),
            child: DropdownButton<AppLanguage>(
              value: _selectedLanguage,
              dropdownColor: const Color(0xFF1E212B),
              underline: const SizedBox(),
              icon: const Icon(Icons.translate, color: Color(0xFFFFB300), size: 18),
              items: const [
                DropdownMenuItem(value: AppLanguage.english, child: Text(' English')),
                DropdownMenuItem(value: AppLanguage.telugu, child: Text(' తెలుగు')),
                DropdownMenuItem(value: AppLanguage.hindi, child: Text(' हिन्दी')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedLanguage = val);
              },
            ),
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF252936), width: 1.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF13151D),
          selectedItemColor: const Color(0xFFFFB300),
          unselectedItemColor: Colors.white54,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.auto_stories),
              label: AppStrings.tr('tab_demo', _selectedLanguage),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.touch_app),
              label: AppStrings.tr('tab_practice', _selectedLanguage),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.emoji_events),
              label: AppStrings.tr('tab_assessment', _selectedLanguage),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.help_center),
              label: AppStrings.tr('tab_help', _selectedLanguage),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. STEP-BY-STEP OPERATION DEMOS (Addition 37+49, Subtraction, Mul, Div)
// ---------------------------------------------------------------------------
class StepDetail {
  final String textEn, textTe, textHi;
  final List<bool> upper;
  final List<int> lower;

  const StepDetail({
    required this.textEn,
    required this.textTe,
    required this.textHi,
    required this.upper,
    required this.lower,
  });

  String getText(AppLanguage l) =>
      l == AppLanguage.telugu ? textTe : (l == AppLanguage.hindi ? textHi : textEn);
}

class OperationDemoLesson {
  final String titleEn, titleTe, titleHi;
  final String summaryEn, summaryTe, summaryHi;
  final List<StepDetail> steps;

  const OperationDemoLesson({
    required this.titleEn,
    required this.titleTe,
    required this.titleHi,
    required this.summaryEn,
    required this.summaryTe,
    required this.summaryHi,
    required this.steps,
  });

  String getTitle(AppLanguage l) =>
      l == AppLanguage.telugu ? titleTe : (l == AppLanguage.hindi ? titleHi : titleEn);
  String getSummary(AppLanguage l) =>
      l == AppLanguage.telugu ? summaryTe : (l == AppLanguage.hindi ? summaryHi : summaryEn);
}

final List<OperationDemoLesson> detailedDemoLessons = [
  OperationDemoLesson(
    titleEn: 'Addition Demo: 37 + 49 = 86',
    titleTe: 'కూడిక డెమో: 37 + 49 = 86',
    titleHi: 'जोड़ डेमो: 37 + 49 = 86',
    summaryEn: 'Learn Small Friends and Big Friends together on Tens and Units rods.',
    summaryTe: 'పదులు మరియు ఒకట్ల స్థానాల్లో చిన్న మరియు పెద్ద మిత్రుల సూత్రాల ద్వారా కూడిక విధానం.',
    summaryHi: 'दहाई और इकाई रॉड पर मित्र सूत्रों का उपयोग करके जोड़ना सीखें।',
    steps: [
      StepDetail(
        textEn: 'Step 1: Set 37 on Abacus. Tens rod = 3 lower beads. Units rod = Upper bead (5) + 2 lower beads (7).',
        textTe: 'దశ 1: బోర్డు పై 37 సెట్ చేయండి. పదుల కడ్డీ పై 3 క్రింది పూసలు, ఒకట్ల కడ్డీ పై 1 పై పూస (5) మరియు 2 క్రింది పూసలు (7).',
        textHi: 'चरण 1: अबेकस पर 37 सेट करें। दहाई पर 3 मनके और इकाई पर ऊपरी मनका (5) + 2 निचले मनके।',
        upper: [false, false, false, true],
        lower: [0, 0, 3, 2],
      ),
      StepDetail(
        textEn: 'Step 2: Add 40 on Tens Rod using Small Friends: +4 = +5 - 1. (Pull down Upper bead 5, subtract 1 lower bead). Tens is now 70.',
        textTe: 'దశ 2: పదుల స్థానంలో 40 కలపండి (+4 = +5 - 1). పై పూస (5) కిందకు దించి, 1 క్రింది పూసను తీసివేయండి. పదులు ఇప్పుడు 70 అవుతుంది.',
        textHi: 'चरण 2: दहाई रॉड पर 40 जोड़ें (+4 = +5 - 1)। ऊपरी मनका (5) नीचे लाएं और 1 निचला मनका घटाएं।',
        upper: [false, false, true, true],
        lower: [0, 0, 2, 2],
      ),
      StepDetail(
        textEn: 'Step 3: Add 9 on Units Rod using Big Friends: +9 = +10 - 1. Add 1 on Tens rod (+10) and subtract 1 lower bead on Units rod (-1). Final Answer = 86.',
        textTe: 'దశ 3: ఒకట్ల స్థానంలో 9 కలపండి (+9 = +10 - 1). పదుల కడ్డీ పై 1 పూస కలిపి (+10), ఒకట్ల కడ్డీ పై 1 పూస తీసివేయండి (-1). తుది ఫలితం = 86.',
        textHi: 'चरण 3: इकाई पर 9 जोड़ें (+9 = +10 - 1)। दहाई पर 1 मनका जोड़ें और इकाई से 1 मनका घटाएं। कुल उत्तर = 86।',
        upper: [false, false, true, true],
        lower: [0, 0, 3, 1],
      ),
    ],
  ),
  OperationDemoLesson(
    titleEn: 'Subtraction Demo: 85 - 38 = 47',
    titleTe: 'తీసివేత డెమో: 85 - 38 = 47',
    titleHi: 'घटाव डेमो: 85 - 38 = 47',
    summaryEn: 'Subtract tens first, then apply Big Friends subtraction on units.',
    summaryTe: 'ముందుగా పదులను తీసివేసి, తరువాత ఒకట్లలో పెద్ద మిత్రుల సూత్రాన్ని అమలు చేయండి.',
    summaryHi: 'पहले दहाई घटाएं, फिर इकाई पर बड़े मित्र सूत्र से घटाव करें।',
    steps: [
      StepDetail(
        textEn: 'Step 1: Set 85 on the Abacus. Tens = Upper(5) + 3 lower(3). Units = Upper(5).',
        textTe: 'దశ 1: బోర్డు పై 85 సెట్ చేయండి. పదులలో 8 (పై పూస 5 + క్రిందివి 3), ఒకట్లలో 5 (పై పూస).',
        textHi: 'चरण 1: अबेकस पर 85 सेट करें। दहाई पर 8 (ऊपर 5 + नीचे 3) और इकाई पर ऊपर 5।',
        upper: [false, false, true, true],
        lower: [0, 0, 3, 0],
      ),
      StepDetail(
        textEn: 'Step 2: Subtract 30 from Tens rod directly by pulling down 3 lower beads. Tens becomes 50.',
        textTe: 'దశ 2: పదుల స్థానం నుండి 30 తీసివేయండి (3 క్రింది పూసలను కిందకు జరపండి). పదులలో 5 మిగులుతుంది.',
        textHi: 'चरण 2: दहाई से सीधे 30 घटाएं (3 नीचे के मनके हटाएं)। दहाई पर 5 शेष रहेगा।',
        upper: [false, false, true, true],
        lower: [0, 0, 0, 0],
      ),
      StepDetail(
        textEn: 'Step 3: Subtract 8 from Units using formula: -8 = -10 + 2. Tens loses 10 (change 50 to 40), Units gains 2 lower beads. Final Result = 47.',
        textTe: 'దశ 3: ఒకట్లలో 8 తీసివేయడానికి సూత్రం: -8 = -10 + 2. పదులలో 10 తీసివేసి (50 నుండి 40 అవుతుంది), ఒకట్లలో 2 క్రింది పూసలను కలపండి. ఫలితం = 47.',
        textHi: 'चरण 3: इकाई से 8 घटाएं (-8 = -10 + 2)। दहाई से 10 घटाएं और इकाई पर 2 मनके जोड़ें। उत्तर = 47।',
        upper: [false, false, false, true],
        lower: [0, 0, 4, 2],
      ),
    ],
  ),
  OperationDemoLesson(
    titleEn: 'Multiplication Demo: 43 x 6 = 258',
    titleTe: 'గుణకారం డెమో: 43 x 6 = 258',
    titleHi: 'गुणा डेमो: 43 x 6 = 258',
    summaryEn: 'High-speed column multiplication: (40 x 6) + (3 x 6).',
    summaryTe: 'విభజన గుణకారం పద్ధతి: (40 x 6) + (3 x 6).',
    summaryHi: 'सरल गुणा तकनीक: (40 x 6) + (3 x 6)।',
    steps: [
      StepDetail(
        textEn: 'Step 1: Multiply Tens digit first: 4 x 6 = 24. Place 2 on Hundreds rod, 4 on Tens rod (240).',
        textTe: 'దశ 1: ముందుగా పదుల అంకెను గుణించండి: 4 x 6 = 24. వందల కడ్డీ పై 2, పదుల కడ్డీ పై 4 ఉంచండి (240).',
        textHi: 'चरण 1: पहले दहाई अंक से गुणा करें: 4 x 6 = 24। सैकड़ा रॉड पर 2 और दहाई पर 4 सेट करें।',
        upper: [false, false, false, false],
        lower: [0, 2, 4, 0],
      ),
      StepDetail(
        textEn: 'Step 2: Multiply Units digit: 3 x 6 = 18. Add 1 on Tens rod (4 becomes 5 using upper bead) and 8 on Units rod (Upper 5 + Lower 3).',
        textTe: 'దశ 2: ఒకట్ల అంకెను గుణించండి: 3 x 6 = 18. పదులలో 1 కలపండి (4 కాస్తా పై పూస 5 అవుతుంది), ఒకట్లలో 8 (పై పూస 5 + క్రిందివి 3) కలపండి.',
        textHi: 'चरण 2: इकाई अंक से गुणा करें: 3 x 6 = 18। दहाई पर 1 जोड़ें और इकाई पर 8 सेट करें।',
        upper: [false, false, true, true],
        lower: [0, 2, 0, 3],
      ),
      StepDetail(
        textEn: 'Final Step: Read from left to right: Hundreds=2, Tens=5, Units=8 -> Total = 258.',
        textTe: 'తుది దశ: ఎడమ నుండి కుడికి లెక్కించండి: వందలు=2, పదులు=5, ఒకట్లు=8 -> మొత్తం = 258.',
        textHi: 'अंतिम चरण: बाएं से दाएं पढ़ें: सैकड़ा=2, दहाई=5, इकाई=8 -> कुल = 258।',
        upper: [false, false, true, true],
        lower: [0, 2, 0, 3],
      ),
    ],
  ),
  OperationDemoLesson(
    titleEn: 'Division Demo: 96 ÷ 3 = 32',
    titleTe: 'భాగహారం డెమో: 96 ÷ 3 = 32',
    titleHi: 'भाग डेमो: 96 ÷ 3 = 32',
    summaryEn: 'Left-to-right quotient extraction and bead cancellation.',
    summaryTe: 'ఎడమ నుండి కుడికి భాగఫలాన్ని లెక్కిస్తూ పూసలను తీసివేయడం.',
    summaryHi: 'बाएं से दाएं भागफल निकालना और मनकों को सेट करना।',
    steps: [
      StepDetail(
        textEn: 'Step 1: Set Dividend 96. Tens = 9 (Upper 5 + 4 Lower). Units = 6 (Upper 5 + 1 Lower).',
        textTe: 'దశ 1: భాజ్యము 96 ను సెట్ చేయండి. పదులలో 9 (పై పూస 5 + క్రిందివి 4), ఒకట్లలో 6 (పై పూస 5 + క్రిందిది 1).',
        textHi: 'चरण 1: भाज्य 96 सेट करें। दहाई पर 9 और इकाई पर 6।',
        upper: [false, false, true, true],
        lower: [0, 0, 4, 1],
      ),
      StepDetail(
        textEn: 'Step 2: Divide Tens: 9 ÷ 3 = 3. Tens quotient is 3. Set Tens to 3.',
        textTe: 'దశ 2: పదులను భాగించండి: 9 ÷ 3 = 3. పదులలో భాగఫలం 3 అవుతుంది (3 పూసలు ఉంచండి).',
        textHi: 'चरण 2: दहाई को भाग दें: 9 ÷ 3 = 3। दहाई पर 3 मनके सेट करें।',
        upper: [false, false, false, true],
        lower: [0, 0, 3, 1],
      ),
      StepDetail(
        textEn: 'Step 3: Divide Units: 6 ÷ 3 = 2. Set Units to 2. Final Quotient = 32.',
        textTe: 'దశ 3: ఒకట్లను భాగించండి: 6 ÷ 3 = 2. ఒకట్లలో 2 పూసలు ఉంచండి. తుది భాగఫలం = 32.',
        textHi: 'चरण 3: इकाई को भाग दें: 6 ÷ 3 = 2। इकाई पर 2 मनके सेट करें। कुल भागफल = 32।',
        upper: [false, false, false, false],
        lower: [0, 0, 3, 2],
      ),
    ],
  ),
];

class InteractiveLessonDemoScreen extends StatefulWidget {
  final AppLanguage lang;
  final Function(String) onSpeak;

  const InteractiveLessonDemoScreen({super.key, required this.lang, required this.onSpeak});

  @override
  State<InteractiveLessonDemoScreen> createState() => _InteractiveLessonDemoScreenState();
}

class _InteractiveLessonDemoScreenState extends State<InteractiveLessonDemoScreen> {
  int _lessonIndex = 0;
  int _stepIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lesson = detailedDemoLessons[_lessonIndex];
    final step = lesson.steps[_stepIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(detailedDemoLessons.length, (idx) {
                bool isSel = idx == _lessonIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      idx == 0
                          ? '+ Addition'
                          : (idx == 1
                              ? '- Subtraction'
                              : (idx == 2 ? '× Multiplication' : '÷ Division')),
                      style: TextStyle(
                        color: isSel ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: isSel,
                    selectedColor: const Color(0xFFFFB300),
                    backgroundColor: const Color(0xFF1E222D),
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _lessonIndex = idx;
                          _stepIndex = 0;
                        });
                      }
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1D27), Color(0xFF141620)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x59FFB300)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFB300),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: Color(0xFFFFB300), size: 28),
                      onPressed: () => widget.onSpeak(step.getText(widget.lang)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  lesson.getSummary(widget.lang),
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const Divider(color: Colors.white24, height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C0E14),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0x4D00E676)),
                  ),
                  child: Text(
                    step.getText(widget.lang),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFE0E0E0),
                      height: 1.45,
                      fontW
