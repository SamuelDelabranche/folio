import 'dart:math';
import 'package:flutter/material.dart';
import 'package:folio/features/home/home_page.dart';
import 'package:folio/features/onboarding/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _introController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _glowRadius;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<double> _barProgress;

  late AnimationController _particleController;
  late AnimationController _exitController;
  late Animation<double> _exitOpacity;

  final List<_Particle> _particles = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _spawnParticles();

    // ── Intro ─────────────────────────────────────────
    _introController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.0, 0.4, curve: Curves.easeOut)));

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.0, 0.55, curve: Curves.elasticOut)));

    _glowRadius = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.2, 0.7, curve: Curves.easeOut)));

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.45, 0.68, curve: Curves.easeOut)));

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.45, 0.68, curve: Curves.easeOut)));

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.62, 0.82, curve: Curves.easeOut)));

    _barProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _introController,
          curve: const Interval(0.68, 1.0, curve: Curves.easeOut)));

    // ── Particules ─────────────────────────────────────
    _particleController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    // ── Sortie ─────────────────────────────────────────
    _exitController = AnimationController(
      duration: const Duration(milliseconds: 650),
      vsync: this,
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInCubic));

    _introController.forward();
    Future.delayed(const Duration(milliseconds: 3400), _navigate);
  }

  void _spawnParticles() {
    for (int i = 0; i < 28; i++) {
      _particles.add(_Particle(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        size: _rng.nextDouble() * 3.5 + 1.0,
        opacity: _rng.nextDouble() * 0.45 + 0.1,
        speed: _rng.nextDouble() * 0.25 + 0.1,
        phase: _rng.nextDouble(),
      ));
    }
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    await _exitController.forward();
    if (!mounted) return;
    final firstLaunch = await isFirstLaunch();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) =>
          firstLaunch ? const OnboardingPage() : const HomePage(),
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    ));
  }

  @override
  void dispose() {
    _introController.dispose();
    _particleController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF);
    final glowColor = isDark ? const Color(0xFF2A0A4A) : const Color(0xFFF3E8FF);
    final subtitleColor = isDark ? const Color(0xFF9E9E9E) : const Color(0xFFAAAAAA);

    return FadeTransition(
      opacity: _exitOpacity,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [

            // ── Fond dégradé radial subtil ─────────────────
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2),
                    radius: 0.9,
                    colors: [glowColor, bgColor],
                  ),
                ),
              ),
            ),

            // ── Particules ─────────────────────────────────
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _particleController,
                builder: (_, __) => CustomPaint(
                  painter: _ParticlePainter(_particles, _particleController.value),
                  size: MediaQuery.of(context).size,
                ),
              ),
            ),

            // ── Contenu ────────────────────────────────────
            Center(
              child: AnimatedBuilder(
                animation: _introController,
                builder: (_, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Glow + F lettre
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Halo violet (opacité dans la couleur, pas via Opacity widget)
                        Container(
                          width: 200 * _glowRadius.value,
                          height: 200 * _glowRadius.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFBB86FC).withOpacity(_glowRadius.value * 0.6),
                                blurRadius: 90,
                                spreadRadius: 30,
                              ),
                            ],
                          ),
                        ),

                        // Logo PNG (FadeTransition évite l'Opacity widget)
                        FadeTransition(
                          opacity: _logoOpacity,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Image.asset(
                              'assets/splash/logo.png',
                              width: 160,
                              height: 160,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // FOLIO
                    SlideTransition(
                      position: _titleSlide,
                      child: FadeTransition(
                        opacity: _titleOpacity,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFFBB86FC), Color(0xFFE91E8C)],
                          ).createShader(bounds),
                          child: const Text(
                            'FOLIO',
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 14,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // MANGA TRACKER
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

                    const SizedBox(height: 32),

                    // Barre de progression
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: 100,
                        height: 2,
                        child: LinearProgressIndicator(
                          value: _barProgress.value,
                          backgroundColor: Colors.white10,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFBB86FC)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Particule ─────────────────────────────────────────────
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
      final x = size.width * p.x + sin(t * pi * 2 + p.phase * pi) * 18;
      final pulse = (sin(progress * pi * 6 + p.phase * pi * 2) + 1) / 2;
      final opacity = p.opacity * (0.3 + 0.7 * pulse);

      canvas.drawCircle(
        Offset(x, y),
        p.size,
        Paint()
          ..color = Color.lerp(
            const Color(0xFFBB86FC),
            const Color(0xFFE91E8C),
            p.phase,
          )!.withOpacity(opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
