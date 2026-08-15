// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const AbacusMasterApp());
}

enum AppLanguage { english, telugu, hindi }

class AbacusLesson {
  final String titleEn;
  final String titleTe;
  final String titleHi;
  final String speechEn;
  final String speechTe;
  final String speechHi;
  final int targetValue;

  const AbacusLesson({
    required this.titleEn,
    required this.titleTe,
    required this.titleHi,
    required this.speechEn,
    required this.speechTe,
    required this.speechHi,
    required this.targetValue,
  });

  String getTitle(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.telugu:
        return titleTe;
      case AppLanguage.hindi:
        return titleHi;
      case AppLanguage.english:
        return titleEn;
    }
  }

  String getSpeechText(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.telugu:
        return speechTe;
      case AppLanguage.hindi:
        return speechHi;
      case AppLanguage.english:
        return speechEn;
    }
  }

  String getTtsCode(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.telugu:
        return 'te-IN';
      case AppLanguage.hindi:
        return 'hi-IN';
      case AppLanguage.english:
        return 'en-US';
    }
  }
}

final List<AbacusLesson> lessonList = [
  const AbacusLesson(
    titleEn: "Class 6: Basics & Direct Addition",
    titleTe: "క్లాస్ 6: అబాకస్ ప్రాథమికాలు మరియు సాధారణ కూడిక",
    titleHi: "कक्षा 6: अबेकस मूल बातें और सरल जोड़",
    speechEn: "Welcome to Abacus. The upper bead equals 5, and each lower bead equals 1. Tap lower beads to count up to 4.",
    speechTe: "అబాకస్ కు స్వాగతం. పై పూస విలువ 5, ప్రతి క్రింది పూస విలువ 1. పూసలను పైకి జరిపి లెక్కించండి.",
    speechHi: "अबेकस में आपका स्वागत है। ऊपरी मनके का मान 5 है और प्रत्येक निचले मनके का मान 1 है।",
    targetValue: 4,
  ),
  const AbacusLesson(
    titleEn: "Class 7: Small Friends (+4 = +5 - 1)",
    titleTe: "క్లాస్ 7: చిన్న మిత్రుల కూడిక (+4 = +5 - 1)",
    titleHi: "कक्षा 7: छोटे मित्र जोड़ (+4 = +5 - 1)",
    speechEn: "To add 4 using small friends, bring down the upper bead for plus 5, then pull down one lower bead for minus 1.",
    speechTe: "చిన్న మిత్రుల సూత్రం ప్రకారం 4 కలపడానికి: పై పూసను కిందకు జరిపి 5 కలిపి, ఒక క్రింది పూసను కిందకు జరిపి 1 తీసివేయండి.",
    speechHi: "छोटे मित्र सूत्र से 4 जोड़ने के लिए: ऊपर का मनका नीचे करके 5 जोड़ें, फिर नीचे का 1 मनका हटाकर 1 घटाएं।",
    targetValue: 4,
  ),
  const AbacusLesson(
    titleEn: "Class 8: Big Friends (+9 = +10 - 1)",
    titleTe: "క్లాస్ 8: పెద్ద మిత్రుల కూడిక (+9 = +10 - 1)",
    titleHi: "कक्षा 8: बड़े मित्र जोड़ (+9 = +10 - 1)",
    speechEn: "To add 9, add 1 on the tens rod and subtract 1 on the units rod.",
    speechTe: "9 కలపడానికి, పదుల స్థానంలో 1 పూసను కలిపి, ఒకట్ల స్థానంలో 1 పూసను తీసివేయండి.",
    speechHi: "9 जोड़ने के लिए, दहाई की रॉड पर 1 जोड़ें और इकाई की रॉड पर 1 घटाएं।",
    targetValue: 9,
  ),
];

class AbacusMasterApp extends StatelessWidget {
  const AbacusMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abacus Learning App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF13151B),
      ),
      home: const AbacusMainScreen(),
    );
  }
}

class AbacusMainScreen extends StatefulWidget {
  const AbacusMainScreen({super.key});

  @override
  State<AbacusMainScreen> createState() => _AbacusMainScreenState();
}

class _AbacusMainScreenState extends State<AbacusMainScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  AppLanguage _currentLanguage = AppLanguage.telugu;
  int _currentLessonIndex = 0;

  // 4 Rods representing: [1000s, 100s, 10s, 1s]
  final List<bool> _upperActive = [false, false, false, false];
  final List<int> _lowerActiveCount = [0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text, String langCode) async {
    await _flutterTts.stop();
    await _flutterTts.setLanguage(langCode);
    await _flutterTts.speak(text);
  }

  int get _totalScore {
    int total = 0;
    int place = 1000;
    for (int i = 0; i < 4; i++) {
      int rodValue = (_upperActive[i] ? 5 : 0) + _lowerActiveCount[i];
      total += rodValue * place;
      place ~/= 10;
    }
    return total;
  }

  void _resetBoard() {
    setState(() {
      for (int i = 0; i < 4; i++) {
        _upperActive[i] = false;
        _lowerActiveCount[i] = 0;
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeLesson = lessonList[_currentLessonIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Abacus / అబాకస్ / अबेकस', style: TextStyle(fontSize: 18)),
        backgroundColor: const Color(0xFF1F222E),
        actions: [
          DropdownButton<AppLanguage>(
            value: _currentLanguage,
            dropdownColor: const Color(0xFF1F222E),
            underline: const SizedBox(),
            icon: const Icon(Icons.language, color: Colors.amberAccent),
            items: const [
              DropdownMenuItem(value: AppLanguage.english, child: Text('English', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: AppLanguage.telugu, child: Text('తెలుగు', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: AppLanguage.hindi, child: Text('हिन्दी', style: TextStyle(color: Colors.white))),
            ],
            onChanged: (lang) {
              if (lang != null) setState(() => _currentLanguage = lang);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.amberAccent),
            onPressed: _resetBoard,
            tooltip: 'Clear Abacus',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Lesson Navigation & Text Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F222E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amberAccent.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            activeLesson.getTitle(_currentLanguage),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: Colors.amberAccent, size: 28),
                          onPressed: () => _speak(
                            activeLesson.getSpeechText(_currentLanguage),
                            activeLesson.getTtsCode(_currentLanguage),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activeLesson.getSpeechText(_currentLanguage),
                      style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _currentLessonIndex > 0
                              ? () => setState(() => _currentLessonIndex--)
                              : null,
                          child: const Text('Previous'),
                        ),
                        ElevatedButton(
                          onPressed: _currentLessonIndex < lessonList.length - 1
                              ? () => setState(() => _currentLessonIndex++)
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Real-time Number Display
              Text(
                'Count: $_totalScore',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),

              const SizedBox(height: 16),

              // Abacus Wooden Frame
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF432818),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2B1704), width: 6),
                ),
                child: Container(
                  color: const Color(0xFF0C0D11),
                  height: 310,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) => _buildAbacusRod(index)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAbacusRod(int rodIndex) {
    bool isUpperActive = _upperActive[rodIndex];
    int lowerCount = _lowerActiveCount[rodIndex];

    return SizedBox(
      width: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Vertical Steel Wire
          Container(width: 4, height: double.infinity, color: Colors.grey.shade600),

          Column(
            children: [
              // UPPER DECK (Value = 5)
              SizedBox(
                height: 80,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      top: isUpperActive ? 32 : 0,
                      left: 6,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _upperActive[rodIndex] = !_upperActive[rodIndex]);
                        },
                        child: _buildBead(Colors.deepOrangeAccent),
                      ),
                    ),
                  ],
                ),
              ),

              // SEPARATOR BEAM
              Container(
                height: 12,
                width: double.infinity,
                color: const Color(0xFFD4AF37),
                alignment: Alignment.center,
                child: rodIndex == 3
                    ? const CircleAvatar(radius: 2, backgroundColor: Colors.black)
                    : null,
              ),

              // LOWER DECK (4 Beads, Value = 1 each)
              Expanded(
                child: Stack(
                  children: List.generate(4, (beadIndex) {
                    bool isActive = beadIndex < lowerCount;
                    double defaultPos = (3 - beadIndex) * 26.0;
                    double activePos = (3 - beadIndex) * 26.0 + 70.0;

                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      bottom: isActive ? activePos : defaultPos,
                      left: 6,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isActive) {
                              _lowerActiveCount[rodIndex] = beadIndex;
                            } else {
                              _lowerActiveCount[rodIndex] = beadIndex + 1;
                            }
                          });
                        },
                        child: _buildBead(
                          isActive ? Colors.cyanAccent.shade400 : Colors.blueGrey.shade600,
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
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.elliptical(48, 24)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0, 3),
            blurRadius: 3,
          )
        ],
      ),
    );
  }
}
