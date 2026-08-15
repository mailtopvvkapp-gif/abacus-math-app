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
        AppLanguage.english: 'Abacus Master Pro 3D',
        AppLanguage.telugu: 'అబాకస్ మాస్టర్ ప్రో',
        AppLanguage.hindi: 'अबेकस मास्टर प्रो 3D',
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
// MAIN NAVIGATION WRAPPER
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
                color: const Color(0xFFFFB300).withValues(alpha: 0.2),
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
              border: Border.all(color: const Color(0xFFFFB300).withValues(alpha: 0.5)),
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
  // ADDITION (37 + 49 = 86)
  OperationDemoLesson(
    titleEn: 'Addition Demo: 37 + 49 = 86',
    titleTe: 'కూడిక డెమో: 37 + 49 = 86',
    titleHi: 'जोड़ डेमो: 37 + 49 = 86',
    summaryEn: 'Learn how to handle Small Friends and Big Friends together on Tens and Units rods.',
    summaryTe: 'పదులు మరియు ఒకట్ల స్థానాల్లో చిన్న మరియు పెద్ద మిత్రుల సూత్రాల ద్వారా కూడిక ఎలా చేయాలో నేర్చుకోండి.',
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

  // SUBTRACTION (85 - 38 = 47)
  OperationDemoLesson(
    titleEn: 'Subtraction Demo: 85 - 38 = 47',
    titleTe: 'తీసివేత డెమో: 85 - 38 = 47',
    titleHi: 'घटाव डेमो: 85 - 38 = 47',
    summaryEn: 'Subtract tens first, then apply Big Friends subtraction on units.',
    summaryTe: 'మొదట పదులను తీసివేసి, తరువాత ఒకట్లలో పెద్ద మిత్రుల సూత్రాన్ని అమలు చేయండి.',
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

  // MULTIPLICATION (43 x 6 = 258)
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

  // DIVISION (96 / 3 = 32)
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
          // Lesson Switcher Chips
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

          // Main Lesson Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1D27), Color(0xFF141620)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFB300).withValues(alpha: 0.35)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                    border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    step.getText(widget.lang),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFE0E0E0),
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Luxury Abacus Board Visualization
          LuxuryAbacusBoard(
            upperActive: step.upper,
            lowerActiveCount: step.lower,
            isInteractive: false,
            lang: widget.lang,
          ),
          const SizedBox(height: 16),

          // Step Controllers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B313F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: _stepIndex > 0 ? () => setState(() => _stepIndex--) : null,
                icon: const Icon(Icons.skip_previous),
                label: const Text('Prev Step'),
              ),
              Text(
                'Step ${_stepIndex + 1} of ${lesson.steps.length}',
                style: const TextStyle(
                  color: Color(0xFFFFB300),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB300),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: _stepIndex < lesson.steps.length - 1
                    ? () => setState(() => _stepIndex++)
                    : null,
                icon: const Icon(Icons.skip_next),
                label: const Text('Next Step', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. FREE INTERACTIVE BOARD & PLACE VALUE BREAKDOWN
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

  String _formatBreakdown() {
    int th = (upper[0] ? 5 : 0) + lower[0];
    int h = (upper[1] ? 5 : 0) + lower[1];
    int t = (upper[2] ? 5 : 0) + lower[2];
    int u = (upper[3] ? 5 : 0) + lower[3];

    if (widget.lang == AppLanguage.telugu) {
      return 'మొత్తం విలువ: $total\nవేలు (1000s): $th  |  వందలు (100s): $h  |  పదులు (10s): $t  |  ఒకట్లు (1s): $u';
    } else if (widget.lang == AppLanguage.hindi) {
      return 'कुल मूल्य: $total\nहज़ार (1000s): $th  |  सैकड़ा (100s): $h  |  दहाई (10s): $t  |  इकाई (1s): $u';
    } else {
      return 'Total Value: $total\nThousands: $th  |  Hundreds: $h  |  Tens: $t  |  Units: $u';
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
              gradient: const LinearGradient(
                colors: [Color(0xFF1F2330), Color(0xFF161922)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFB300).withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(
                  _formatBreakdown(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFFB300),
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _clear,
                  icon: const Icon(Icons.refresh),
                  label: Text(AppStrings.tr('reset', widget.lang)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          LuxuryAbacusBoard(
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
// 3. SMART ASSESSMENT & DETAILED ERROR DIAGNOSTICS
// ---------------------------------------------------------------------------
class QuizItem {
  final int n1, n2, ans;
  final OperationType op;
  final String formulaEn, formulaTe, formulaHi;

  QuizItem({
    required this.n1,
    required this.n2,
    required this.ans,
    required this.op,
    required this.formulaEn,
    required this.formulaTe,
    required this.formulaHi,
  });

  String getFormula(AppLanguage l) =>
      l == AppLanguage.telugu ? formulaTe : (l == AppLanguage.hindi ? formulaHi : formulaEn);
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
  final Set<String> _history = {};
  SkillLevel _level = SkillLevel.beginner;
  QuizItem? _currentQ;
  List<int> _options = [];
  int _score = 0;
  int _totalAttempts = 0;
  String? _feedback;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _loadNextProblem();
  }

  void _loadNextProblem() {
    setState(() {
      _answered = false;
      _feedback = null;
      _currentQ = _generateNonRepeatingProblem();
      _generateOptions();
    });
  }

  QuizItem _generateNonRepeatingProblem() {
    for (int loop = 0; loop < 100; loop++) {
      int a = 0, b = 0, answer = 0;
      OperationType op = OperationType.addition;
      String fEn = "", fTe = "", fHi = "";

      if (_level == SkillLevel.beginner) {
        op = _rnd.nextBool() ? OperationType.addition : OperationType.subtraction;
        if (op == OperationType.addition) {
          a = _rnd.nextInt(20) + 5;
          b = _rnd.nextInt(15) + 3;
          answer = a + b;
          fEn = "Direct calculation or simple 5-complement.";
          fTe = "ప్రత్యక్ష కూడిక లేదా సాధారణ 5-మిత్రుల సహాయంతో పూర్తి చేయండి.";
          fHi = "सीधा जोड़ या सरल 5-मित्र विधि का उपयोग करें।";
        } else {
          a = _rnd.nextInt(30) + 15;
          b = _rnd.nextInt(12) + 2;
          answer = a - b;
          fEn = "Move beads downwards away from reckoning beam.";
          fTe = "మధ్య పట్టీ నుండి పూసలను కిందకు జరపండి.";
          fHi = "मोतियों को बीच की पट्टी से दूर नीचे करें।";
        }
      } else if (_level == SkillLevel.intermediate) {
        op = _rnd.nextBool() ? OperationType.addition : OperationType.subtraction;
        if (op == OperationType.addition) {
          a = 37 + _rnd.nextInt(30);
          b = 49;
          answer = a + b;
          fEn = "Apply Small Friends on Tens (+40 = +50 - 10), Big Friends on Units (+9 = +10 - 1).";
          fTe = "పదులలో చిన్న మిత్రులు (+40 = +50 - 10), ఒకట్లలో పెద్ద మిత్రుల సూత్రం (+9 = +10 - 1) వాడండి.";
          fHi = "दहाई पर (+40 = +50 - 10) और इकाई पर (+9 = +10 - 1) लागू करें।";
        } else {
          a = 85 + _rnd.nextInt(10);
          b = 38;
          answer = a - b;
          fEn = "Subtract Tens first, then use -8 = -10 + 2 on Units rod.";
          fTe = "ముందుగా పదులను తీసివేసి, ఒకట్లలో -8 = -10 + 2 సూత్రాన్ని అమలు చేయండి.";
          fHi = "पहले दहाई घटाएं, फिर इकाई पर -8 = -10 + 2 सूत्र लगाएं।";
        }
      } else {
        op = _rnd.nextBool() ? OperationType.multiplication : OperationType.division;
        if (op == OperationType.multiplication) {
          a = _rnd.nextInt(40) + 20;
          b = _rnd.nextInt(8) + 3;
          answer = a * b;
          fEn = "Multiply Tens place first, then Units place, and sum both rods.";
          fTe = "ముందుగా పదుల స్థానాన్ని గుణించి, ఆపై ఒకట్లను గుణించి కలపండి.";
          fHi = "पहले दहाई और फिर इकाई का गुणा करके जोड़ें।";
        } else {
          int q = _rnd.nextInt(25) + 4;
          b = _rnd.nextInt(6) + 3;
          a = q * b;
          answer = q;
          fEn = "Divide from highest rod on the left and assign quotient directly.";
          fTe = "ఎడమ వైపు పెద్ద స్థానం నుండి భాగించి భాగఫలాన్ని నమోదు చేయండి.";
          fHi = "बाईं ओर सबसे बड़े मान से भाग देना शुरू करें।";
        }
      }

      String hash = '$a-$op-$b';
      if (!_history.contains(hash)) {
        _history.add(hash);
        return QuizItem(n1: a, n2: b, ans: answer, op: op, formulaEn: fEn, formulaTe: fTe, formulaHi: fHi);
      }
    }
    return QuizItem(
      n1: 37,
      n2: 49,
      ans: 86,
      op: OperationType.addition,
      formulaEn: '+4 = +5 - 1 and +9 = +10 - 1',
      formulaTe: '+4 = +5 - 1 మరియు +9 = +10 - 1',
      formulaHi: '+4 = +5 - 1 और +9 = +10 - 1',
    );
  }

  void _generateOptions() {
    if (_currentQ == null) return;
    Set<int> opts = {_currentQ!.ans};
    while (opts.length < 4) {
      int shift = _rnd.nextInt(9) - 4;
      int fake = _currentQ!.ans + (shift == 0 ? 6 : shift);
      if (fake >= 0) opts.add(fake);
    }
    _options = opts.toList()..shuffle();
  }

  void _verifyChoice(int pick) {
    if (_answered || _currentQ == null) return;
    setState(() {
      _answered = true;
      _totalAttempts++;
      if (pick == _currentQ!.ans) {
        _score++;
        _feedback = widget.lang == AppLanguage.telugu
            ? 'అద్భుతం! సరైన సమాధానం.'
            : (widget.lang == AppLanguage.hindi ? 'शाबाश! सही उत्तर।' : 'Correct! Well calculated.');
      } else {
        _feedback = '${widget.lang == AppLanguage.telugu ? 'తప్పు సమాధానం!' : (widget.lang == AppLanguage.hindi ? 'गलत उत्तर!' : 'Incorrect!')}\n${_currentQ!.getFormula(widget.lang)}';
      }
      widget.onSpeak(_feedback!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQ == null) return const SizedBox();
    String opLabel = _currentQ!.op == OperationType.addition
        ? '+'
        : (_currentQ!.op == OperationType.subtraction
            ? '-'
            : (_currentQ!.op == OperationType.multiplication ? '×' : '÷'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Level selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: const Text('Beginner'),
                selected: _level == SkillLevel.beginner,
                onSelected: (v) => setState(() {
                  _level = SkillLevel.beginner;
                  _loadNextProblem();
                }),
              ),
              ChoiceChip(
                label: const Text('Intermediate'),
                selected: _level == SkillLevel.intermediate,
                onSelected: (v) => setState(() {
                  _level = SkillLevel.intermediate;
                  _loadNextProblem();
                }),
              ),
              ChoiceChip(
                label: const Text('Advanced'),
                selected: _level == SkillLevel.advanced,
                onSelected: (v) => setState(() {
                  _level = SkillLevel.advanced;
                  _loadNextProblem();
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Score Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2330),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFFFB300).withValues(alpha: 0.4)),
            ),
            child: Text(
              'Score: $_score / $_totalAttempts',
              style: const TextStyle(fontSize: 16, color: Color(0xFFFFB300), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          // Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF222634), Color(0xFF171A24)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFB300).withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Text(
              '${_currentQ!.n1}  $opLabel  ${_currentQ!.n2}  =  ?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),

          // Multi-Choice Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            children: _options.map((opt) {
              Color btnBg = const Color(0xFF242938);
              if (_answered) {
                btnBg = opt == _currentQ!.ans ? const Color(0xFF00C853) : const Color(0xFF374151);
              }
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnBg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 4,
                ),
                onPressed: _answered ? null : () => _verifyChoice(opt),
                child: Text('$opt', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Feedback Diagnostic Box
          if (_feedback != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _feedback!.contains('Correct') || _feedback!.contains('అద్భుతం') || _feedback!.contains('शाबाश')
                    ? const Color(0xFF00E676).withValues(alpha: 0.15)
                    : const Color(0xFFFF5252).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _feedback!.contains('Correct') || _feedback!.contains('అద్భుతం') || _feedback!.contains('शाबाश')
                      ? const Color(0xFF00E676)
                      : const Color(0xFFFF5252),
                ),
              ),
              child: Text(
                _feedback!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
              ),
            ),
          const SizedBox(height: 16),

          if (_answered)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _loadNextProblem,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next Problem', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. RICH HELP & FORMULA ASSISTANT
// ---------------------------------------------------------------------------
class RichHelpSectionScreen extends StatelessWidget {
  final AppLanguage lang;
  final Function(String) onSpeak;

  const RichHelpSectionScreen({super.key, required this.lang, required this.onSpeak});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2415), Color(0xFF171A24)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFFB300).withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.live_help, color: Color(0xFFFFB300), size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lang == AppLanguage.telugu
                        ? 'అబాకస్ సూత్రాలు & సహాయ కేంద్రం'
                        : (lang == AppLanguage.hindi ? 'अबेकस सूत्र व सहायता केंद्र' : 'Formula Guide & Help Center'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFFB300)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          _buildCategoryHeader(
            lang == AppLanguage.telugu ? 'చిన్న మిత్రుల సూత్రాలు (+5 / -5)' : (lang == AppLanguage.hindi ? 'छोटे मित्र सूत्र (+5 / -5)' : 'Small Friends Rules (+5 / -5)'),
          ),
          _buildFormulaCard('+4 = +5 - 1', '-4 = -5 + 1'),
          _buildFormulaCard('+3 = +5 - 2', '-3 = -5 + 2'),
          _buildFormulaCard('+2 = +5 - 3', '-2 = -5 + 3'),
          _buildFormulaCard('+1 = +5 - 4', '-1 = -5 + 4'),
          const SizedBox(height: 18),

          _buildCategoryHeader(
            lang == AppLanguage.telugu ? 'పెద్ద మిత్రుల సూత్రాలు (+10 / -10)' : (lang == AppLanguage.hindi ? 'बड़े मित्र सूत्र (+10 / -10)' : 'Big Friends Rules (+10 / -10)'),
          ),
          _buildFormulaCard('+9 = +10 - 1', '-9 = -10 + 1'),
          _buildFormulaCard('+8 = +10 - 2', '-8 = -10 + 2'),
          _buildFormulaCard('+7 = +10 - 3', '-7 = -10 + 3'),
          _buildFormulaCard('+6 = +10 - 4', '-6 = -10 + 4'),
          _buildFormulaCard('+5 = +10 - 5', '-5 = -10 + 5'),
          const SizedBox(height: 18),

          _buildCategoryHeader(
            lang == AppLanguage.telugu ? 'తరచుగా అడిగే ప్రశ్నలు (FAQ)' : (lang == AppLanguage.hindi ? 'अक्सर पूछे जाने वाले प्रश्न (FAQ)' : 'Frequently Asked Questions'),
          ),
          _buildFaqTile(
            q: lang == AppLanguage.telugu ? 'పూసలను ఎలా తీసివేయాలి (Subtract)?' : (lang == AppLanguage.hindi ? 'मनकों को कैसे घटाएं?' : 'How to remove/subtract beads?'),
            a: lang == AppLanguage.telugu
                ? 'క్రింది పూసలను కిందకు జరపాలి. పై పూస (5) ను తీసివేయడానికి పైకి జరపాలి. మధ్య పట్టీకి దూరంగా జరపడమే తీసివేత.'
                : (lang == AppLanguage.hindi
                    ? 'नीचे के मनकों को नीचे खींचें और ऊपर के 5 वाले मनके को ऊपर करें। बीच की पट्टी से दूर करना ही घटाव है।'
                    : 'Push lower beads down and upper bead up away from the center reckoning beam.'),
          ),
          _buildFaqTile(
            q: lang == AppLanguage.telugu ? '37 + 49 లో 40 ని ఎలా కలపాలి?' : (lang == AppLanguage.hindi ? '37 + 49 में 40 कैसे जोड़ें?' : 'How to add 40 in 37 + 49?'),
            a: lang == AppLanguage.telugu
                ? 'పదుల కడ్డీ పై చిన్న మిత్రుల సూత్రం (+4 = +5 - 1) వాడండి. పై పూస (50) ను కిందకు దించి, ఒక క్రింది పూస (10) ను తీసివేయండి.'
                : (lang == AppLanguage.hindi
                    ? 'दहाई पर छोटा मित्र सूत्र लगाएं (+4 = +5 - 1)। ऊपर का 50 नीचे लाएं और नीचे से 10 घटाएं।'
                    : 'Use Small Friends (+4 = +5 - 1) on the Tens rod: Pull down Upper bead (50) and remove 1 lower bead (10).'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(title, style: const TextStyle(color: Color(0xFFFFB300), fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFormulaCard(String f1, String f2) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF161922),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(f1, style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 14)),
          Text(f2, style: const TextStyle(color: Color(0xFFFF7043), fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFaqTile({required String q, required String a}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF161922),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        iconColor: const Color(0xFFFFB300),
        collapsedIconColor: Colors.white54,
        title: Text(q, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(a, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. LUXURY 3D METALLIC & MAHOGANY ABACUS BOARD
// ---------------------------------------------------------------------------
class LuxuryAbacusBoard extends StatelessWidget {
  final List<bool> upperActive;
  final List<int> lowerActiveCount;
  final bool isInteractive;
  final AppLanguage lang;
  final Function(List<bool>, List<int>)? onChanged;

  const LuxuryAbacusBoard({
    super.key,
    required this.upperActive,
    required this.lowerActiveCount,
    required this.isInteractive,
    required this.lang,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final labels = lang == AppLanguage.telugu
        ? ['వేలు (1000s)', 'వందలు (100s)', 'పదులు (10s)', 'ఒకట్లు (1s)']
        : (lang == AppLanguage.hindi
            ? ['हज़ार (1000s)', 'सैकड़ा (100s)', 'दहाई (10s)', 'इकाई (1s)']
            : ['Thousands', 'Hundreds', 'Tens', 'Units']);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF42220E), Color(0xFF241105)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A0A02), width: 7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.7),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF090A0E),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black54, width: 2),
            ),
            height: 310,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (i) => _buildLuxuryRod(i)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (i) => SizedBox(
                width: 70,
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFFFB300),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLuxuryRod(int rodIdx) {
    bool isUpperOn = upperActive[rodIdx];
    int lowerCount = lowerActiveCount[rodIdx];

    return SizedBox(
      width: 65,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Brass Wire
          Container(
            width: 5,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFBDBDBD), Color(0xFF757575), Color(0xFFE0E0E0)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Column(
            children: [
              // UPPER DECK (Value = 5)
              SizedBox(
                height: 80,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      top: isUpperOn ? 35 : 0,
                      left: 6,
                      child: GestureDetector(
                        onTap: isInteractive
                            ? () {
                                List<bool> u = List.from(upperActive);
                                u[rodIdx] = !u[rodIdx];
                                onChanged?.call(u, lowerActiveCount);
                              }
                            : null,
                        child: _buildBead3D(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF8A65), Color(0xFFD84315), Color(0xFFBF360C)],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // RECKONING BEAM (Brass beam with alignment dot)
              Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD54F), Color(0xFFFFB300), Color(0xFFFF8F00)],
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black80, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
                alignment: Alignment.center,
                child: rodIdx == 3
                    ? Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),

              // LOWER DECK (4 Lower Beads)
              Expanded(
                child: Stack(
                  children: List.generate(4, (beadIdx) {
                    bool active = beadIdx < lowerCount;
                    double defPos = (3 - beadIdx) * 26.0;
                    double actPos = (3 - beadIdx) * 26.0 + 72.0;

                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      bottom: active ? actPos : defPos,
                      left: 6,
                      child: GestureDetector(
                        onTap: isInteractive
                            ? () {
                                List<int> l = List.from(lowerActiveCount);
                                l[rodIdx] = active ? beadIdx : beadIdx + 1;
                                onChanged?.call(upperActive, l);
                              }
                            : null,
                        child: _buildBead3D(
                          gradient: active
                              ? const LinearGradient(
                                  colors: [Color(0xFF80D8FF), Color(0xFF00B0FF), Color(0xFF0091EA)],
                                )
                              : const LinearGradient(
                                  colors: [Color(0xFF546E7A), Color(0xFF37474F), Color(0xFF263238)],
                                ),
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

  Widget _buildBead3D({required Gradient gradient}) {
    return Container(
      width: 52,
      height: 24,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.all(Radius.elliptical(52, 24)),
        border: Border.all(color: Colors.white24, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            offset: const Offset(0, 3),
            blurRadius: 3,
          )
        ],
      ),
    );
  }
}
