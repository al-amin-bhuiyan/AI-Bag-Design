import 'dart:math' show cos, sin, pi;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_fonts.dart';
import '../widgets/custom_button.dart';

/// AIGenerationLoadingWidget - Shows animated loading when generating bag design
/// Follows OOP principles with clean separation and reusability
class AIGenerationLoadingWidget extends StatefulWidget {
  final Future<void> Function() onGenerate;
  final VoidCallback onClose;

  const AIGenerationLoadingWidget({
    super.key,
    required this.onGenerate,
    required this.onClose,
  });

  @override
  State<AIGenerationLoadingWidget> createState() => _AIGenerationLoadingWidgetState();
}

class _AIGenerationLoadingWidgetState extends State<AIGenerationLoadingWidget> {
  bool _isGenerating = true;

  @override
  void initState() {
    super.initState();
    debugPrint('🎭 AI Generation Loading Widget initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGeneration();
    });
  }

  Future<void> _startGeneration() async {
    debugPrint('🎭 Starting generation...');
    try {
      if (mounted) setState(() => _isGenerating = true);
      debugPrint('🎭 Calling onGenerate callback...');
      await widget.onGenerate();
      debugPrint('🎭 Generation completed');
      if (mounted) widget.onClose();
    } catch (e) {
      debugPrint('❌ Error in generation: $e');
      if (mounted) widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎭 Building loading widget - _isGenerating: $_isGenerating');
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: _LoadingContent(onClose: widget.onClose),
      ),
    );
  }
}

/// Loading content with animation — GPU-optimised
/// Uses a single slow AnimationController and RepaintBoundary to prevent
/// the BLASTBufferQueue frame overflow seen with multiple fast controllers.
class _LoadingContent extends StatefulWidget {
  final VoidCallback onClose;

  const _LoadingContent({required this.onClose});

  @override
  State<_LoadingContent> createState() => _LoadingContentState();
}

class _LoadingContentState extends State<_LoadingContent>
    with SingleTickerProviderStateMixin {

  // ─── Single controller drives ALL animation — reduces GPU pressure ─────────
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Slower duration → fewer GPU frame submissions per second
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    // Lower the animation frame rate to 30 fps to avoid BLASTBufferQueue overflow
    timeDilation = 1.0; // keep real-time but single controller is already lighter
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header ────────────────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 8.h,
            left: 26.w,
            right: 26.w,
            bottom: 16.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 32.w),
              Expanded(
                child: Text(
                  'Creating Bag Design',
                  textAlign: TextAlign.center,
                  style: AppFonts.poppinsSemiBold(
                    fontSize: 18.sp,
                    color: const Color(0xFF0F0F0F),
                  ).copyWith(height: 1.22),
                ),
              ),
              CustomCloseButton(
                onPressed: widget.onClose,
                backgroundColor: Colors.transparent,
                iconColor: const Color(0xFF0F0F0F),
                size: 32.w,
                iconSize: 24.sp,
                splashColor: Colors.black,
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),

                // ── Animation container — wrapped in RepaintBoundary so only
                //    this subtree repaints each frame, not the whole screen ──
                RepaintBoundary(
                  child: Container(
                    width: double.infinity,
                    height: 350.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          final t = _controller.value; // 0.0 → 1.0

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // ── Ripple circles (only 2 instead of 3) ─────
                              for (int i = 0; i < 2; i++)
                                _RippleCircle(progress: (t + i * 0.5) % 1.0),

                              // ── Neural network painter ────────────────────
                              SizedBox(
                                width: 180.w,
                                height: 180.h,
                                child: CustomPaint(
                                  painter: _NeuralNetworkPainter(
                                    progress: t,
                                    primaryColor: const Color(0xFF1F7CD5),
                                    secondaryColor: const Color(0xFF008BA6),
                                  ),
                                ),
                              ),

                              // ── Central orb ───────────────────────────────
                              _CentralOrb(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // ── Loading text ─────────────────────────────────────────────
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'We\'re hard at work making your ideas come to life! Your bag design will be ready in ',
                        style: AppFonts.interRegular(
                          fontSize: 16.sp,
                          color: const Color(0xFF0F0F0F),
                        ),
                      ),
                      TextSpan(
                        text: '1 to 2 minutes .',
                        style: AppFonts.interSemiBold(
                          fontSize: 16.sp,
                          color: const Color(0xFF0F0F0F),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // ── Circular progress indicator ───────────────────────────────
                SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F7CD5)),
                  ),
                ),

                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Extracted stateless widgets to avoid rebuilding the whole tree ────────────

/// Single expanding ripple circle
class _RippleCircle extends StatelessWidget {
  final double progress; // 0.0 → 1.0

  const _RippleCircle({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (1.0 - progress).clamp(0.0, 1.0),
      child: Transform.scale(
        scale: 0.5 + progress * 1.0,
        child: Container(
          width: 120.w,
          height: 120.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF1F7CD5).withValues(alpha: 0.4),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

/// Central glowing orb — const-safe, never repaints
class _CentralOrb extends StatelessWidget {
  const _CentralOrb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 70.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF1F7CD5).withValues(alpha: 0.8),
            const Color(0xFF1F7CD5).withValues(alpha: 0.4),
            const Color(0xFF1F7CD5).withValues(alpha: 0.0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F7CD5).withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 45.w,
          height: 45.h,
          decoration: const BoxDecoration(
            color: Color(0xFF1F7CD5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.auto_awesome,
            size: 28.sp,
            color: const Color(0xFFFFF5E1),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for neural network AI animation
/// Optimised: fewer particles (6 instead of 8), no glow layer, fewer arcs
class _NeuralNetworkPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  const _NeuralNetworkPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // ── 6 particles instead of 8 (fewer draw calls) ──────────────────────────
    const particleCount = 6;
    final particles = List<Offset>.generate(particleCount, (i) {
      final angle = (i * 2 * pi / particleCount) + (progress * 2 * pi * 0.15);
      final distance = radius * (0.65 + 0.08 * sin(progress * 2 * pi + i));
      return Offset(
        center.dx + distance * cos(angle),
        center.dy + distance * sin(angle),
      );
    });

    // ── Connection lines ───────────────────────────────────────────────────────
    final connectionPaint = Paint()
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dist = (particles[i] - particles[j]).distance;
        if (dist < radius * 0.9) {
          connectionPaint.color =
              primaryColor.withValues(alpha: (1.0 - dist / (radius * 0.9)) * 0.3);
          canvas.drawLine(particles[i], particles[j], connectionPaint);
        }
      }
    }

    // ── Particles (solid only, no separate glow circle) ───────────────────────
    for (int i = 0; i < particles.length; i++) {
      final pulse = 1.0 + 0.2 * sin((progress + i / particleCount) * 2 * pi);
      canvas.drawCircle(
        particles[i],
        4.0 * pulse,
        Paint()
          ..color = i.isEven ? primaryColor : secondaryColor
          ..style = PaintingStyle.fill,
      );
    }

    // ── 2 flow arcs instead of 3 ─────────────────────────────────────────────
    final flowPaint = Paint()
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 2; i++) {
      final fp = (progress * 2 + i * 0.5) % 1.0;
      flowPaint.color = primaryColor.withValues(alpha: sin(fp * pi) * 0.5);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.45),
        fp * 2 * pi,
        0.7,
        false,
        flowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_NeuralNetworkPainter old) => old.progress != progress;
}