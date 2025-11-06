import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'quotes_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shake Quote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({Key? key}) : super(key: key);

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen>
    with SingleTickerProviderStateMixin {
  // EventChannel للتواصل مع الكوتلن
  static const EventChannel _shakeChannel = EventChannel('shake_detection');

  String currentQuote = "🤳 هز التليفون للحصول على quote تحفيزي!";
  bool isAnimating = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // تجهيز الـ Animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // الاستماع لـ shake events من الكوتلن
    _shakeChannel.receiveBroadcastStream().listen(
      (event) {
        _onShakeDetected();
      },
      onError: (error) {
        print('Error receiving shake event: $error');
      },
    );
  }

  void _onShakeDetected() {
    if (!isAnimating) {
      setState(() {
        isAnimating = true;
        // اختيار quote عشوائي
        final random = Random();
        currentQuote =
            QuotesData.motivationalQuotes[random.nextInt(
              QuotesData.motivationalQuotes.length,
            )];
      });

      // تشغيل الـ Animation
      _animationController.forward(from: 0.0).then((_) {
        setState(() {
          isAnimating = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color.fromARGB(255, 202, 206, 210), Colors.purple.shade400],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // أيقونة
                  Icon(
                    Icons.format_quote,
                    size: 60,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(height: 40),

                  // الـ Quote مع Animation
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            currentQuote,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // رسالة إرشادية
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.vibration, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'هز التليفون للحصول على quote جديد',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
