import 'dart:io';
import 'package:flutter/material.dart';
import 'package:folio/generated/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/features/home/home_page.dart';

class _Slide {
  final String tag;
  final String title;
  final String desc;
  final String emoji;
  final Color color;
  const _Slide({
    required this.tag,
    required this.title,
    required this.desc,
    required this.emoji,
    required this.color,
  });
}

Future<bool> isFirstLaunch() async {
  final dir = await getApplicationDocumentsDirectory();
  final flag = File('${dir.path}/.onboarding_done');
  return !flag.existsSync();
}

Future<void> markOnboardingDone() async {
  final dir = await getApplicationDocumentsDirectory();
  final flag = File('${dir.path}/.onboarding_done');
  await flag.writeAsString('done');
}

Future<void> resetOnboarding() async {
  final dir = await getApplicationDocumentsDirectory();
  final flag = File('${dir.path}/.onboarding_done');
  if (flag.existsSync()) await flag.delete();
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _current = 0;
  static const _slidesCount = 3;

  List<_Slide> _buildSlides(AppLocalizations l10n) => [
    _Slide(tag: l10n.onboardingSlide1Tag, title: l10n.onboardingSlide1Title, desc: l10n.onboardingSlide1Desc, emoji: '📚', color: AppColors.primaryLight),
    _Slide(tag: l10n.onboardingSlide2Tag, title: l10n.onboardingSlide2Title, desc: l10n.onboardingSlide2Desc, emoji: '⭐', color: AppColors.accent),
    _Slide(tag: l10n.onboardingSlide3Tag, title: l10n.onboardingSlide3Title, desc: l10n.onboardingSlide3Desc, emoji: '🚀', color: const Color(0xFF9B5DE5)),
  ];

  void _next() {
    if (_current < _slidesCount - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() async {
    await markOnboardingDone();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, _, _) => const HomePage(),
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (_, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final slides = _buildSlides(l10n);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => _SlidePage(slide: slides[i]),
          ),

          if (_current < slides.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 24,
              child: TextButton(
                onPressed: _finish,
                child: Text(l10n.onboardingSkip, style: const TextStyle(color: Colors.grey, fontSize: 13, letterSpacing: 1)),
              ),
            ),

          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            left: 28,
            right: 28,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(slides.length, (i) {
                    final isActive = i == _current;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 24 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: isActive ? slides[_current].color : Colors.white12,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [slides[_current].color, AppColors.accent],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: slides[_current].color.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _next,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            _current == slides.length - 1 ? l10n.onboardingStart : l10n.onboardingNext,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlidePage extends StatelessWidget {
  final _Slide slide;
  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),

          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  slide.color.withValues(alpha: 0.35),
                  slide.color.withValues(alpha: 0.05),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: slide.color.withValues(alpha: 0.3),
                  blurRadius: 60,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(slide.emoji, style: const TextStyle(fontSize: 80)),
            ),
          ),

          const SizedBox(height: 52),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: slide.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              slide.tag.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: slide.color,
                letterSpacing: 3,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            slide.desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF9E9E9E),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
