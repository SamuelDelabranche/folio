import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/features/home/home_page.dart';
import 'package:folio/features/onboarding/onboarding_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _introController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<double> _versionOpacity;

  late AnimationController _breathController;
  late AnimationController _particleController;
  late AnimationController _exitController;
  late Animation<double> _exitOpacity;

  Timer? _navTimer;
  bool _navigationLancee = false;

  final List<_Particle> _particles = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _spawnParticles();

    _introController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.0, 0.45, curve: Curves.easeOut)));

    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic)));

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.35, 0.65, curve: Curves.easeOut)));

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic)));

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.55, 0.85, curve: Curves.easeOut)));

    _versionOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.7, 1.0, curve: Curves.easeOut)));

    _breathController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _exitController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInCubic));

    _introController.forward();
    _navTimer = Timer(const Duration(milliseconds: 2200), _navigate);
  }

  void _spawnParticles() {
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        size: _rng.nextDouble() * 3.0 + 1.0,
        opacity: _rng.nextDouble() * 0.35 + 0.08,
        speed: _rng.nextDouble() * 0.2 + 0.08,
        phase: _rng.nextDouble(),
      ));
    }
  }

  void _passer() {
    _navTimer?.cancel();
    _navigate();
  }

  Future<void> _navigate() async {
    if (!mounted || _navigationLancee) return;
    _navigationLancee = true;
    await _exitController.forward();
    if (!mounted) return;
    final firstLaunch = await isFirstLaunch();
    if (!mounted) return;
    unawaited(Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, _, _) =>
          firstLaunch ? const OnboardingPage() : const HomePage(),
      transitionDuration: const Duration(milliseconds: 450),
      transitionsBuilder: (_, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
    )));
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _introController.dispose();
    _breathController.dispose();
    _particleController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFFFFFFF);
    final glowColor = isDark ? const Color(0xFF241640) : const Color(0xFFF3E8FF);
    final subtitleColor = isDark ? AppColors.textSecondary : const Color(0xFFAAAAAA);

    return FadeTransition(
      opacity: _exitOpacity,
      child: Scaffold(
        backgroundColor: bgColor,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _passer,
          child: Stack(
            children: [

              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.25),
                      radius: 0.9,
                      colors: [glowColor, bgColor],
                    ),
                  ),
                ),
              ),

              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _particleController,
                  builder: (_, _) => CustomPaint(
                    painter: _ParticlePainter(_particles, _particleController.value),
                    size: MediaQuery.of(context).size,
                  ),
                ),
              ),

              Center(
                child: AnimatedBuilder(
                  animation: Listenable.merge([_introController, _breathController]),
                  builder: (_, _) {
                    final breath = _breathController.value;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        FadeTransition(
                          opacity: _logoOpacity,
                          child: Transform.scale(
                            scale: _logoScale.value * (1 + 0.015 * breath),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                        alpha: (0.35 + 0.2 * breath) * _logoOpacity.value),
                                    blurRadius: 60 + 20 * breath,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  'assets/splash/logo.png',
                                  width: 132,
                                  height: 132,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 44),

                        SlideTransition(
                          position: _titleSlide,
                          child: FadeTransition(
                            opacity: _titleOpacity,
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [AppColors.primaryLight, AppColors.accent],
                              ).createShader(bounds),
                              child: const Text(
                                'FOLIO',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 13,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        FadeTransition(
                          opacity: _subtitleOpacity,
                          child: Text(
                            'MANGA TRACKER',
                            style: TextStyle(
                              fontSize: 11,
                              color: subtitleColor,
                              letterSpacing: 6,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).padding.bottom + 28,
                child: FadeTransition(
                  opacity: _versionOpacity,
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) => Text(
                      snapshot.hasData ? 'v${snapshot.data!.version}' : '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: subtitleColor.withValues(alpha: 0.7),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Particle {
  final double x, y, size, opacity, speed, phase;
  const _Particle({
    required this.x, required this.y, required this.size,
    required this.opacity, required this.speed, required this.phase,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  const _ParticlePainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final y = size.height * (1.0 - t);
      final x = size.width * p.x + sin(t * pi * 2 + p.phase * pi) * 16;
      final pulse = (sin(progress * pi * 4 + p.phase * pi * 2) + 1) / 2;
      final opacity = p.opacity * (0.35 + 0.65 * pulse);

      canvas.drawCircle(
        Offset(x, y),
        p.size,
        Paint()
          ..color = Color.lerp(
            AppColors.primaryLight,
            AppColors.accent,
            p.phase,
          )!.withValues(alpha: opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
