import 'dart:math' show cos, sin;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_assets.dart';
import '../../widgets/custom_button.dart';

/// AIGenerationScreen - Full page AI generation with loading and result states
/// Follows OOP principles with clean separation and reusability
class AIGenerationScreen extends StatefulWidget {
  final Future<void> Function() onGenerate;
  final String? Function()? getGeneratedImageUrl;
  final VoidCallback? onAddToDesign;
  final VoidCallback? onRegenerate;

  const AIGenerationScreen({
    super.key,
    required this.onGenerate,
    this.getGeneratedImageUrl,
    this.onAddToDesign,
    this.onRegenerate,
  });

  @override
  State<AIGenerationScreen> createState() => _AIGenerationScreenState();
}

class _AIGenerationScreenState extends State<AIGenerationScreen> {
  bool _isGenerating = true;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    print('🎭 AI Generation Screen initState');
    // Start generation after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGeneration();
    });
  }

  Future<void> _startGeneration() async {
    print('🎭 Starting generation...');
    try {
      // Ensure loading state is visible
      if (mounted) {
        setState(() {
          _isGenerating = true;
          _showResult = false;
        });
      }

      print('🎭 Calling onGenerate callback...');
      // Call the generation function
      await widget.onGenerate();

      print('🎭 Generation completed, showing result...');
      // Show result
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _showResult = true;
        });
        print('🎭 Result state active');
      }
    } catch (e) {
      print('❌ Error in generation: $e');
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🎭 Building screen - _isGenerating: $_isGenerating, _showResult: $_showResult');
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isGenerating
            ? _LoadingContent()
            : _showResult
                ? _ResultContent(
                    generatedImageUrl: widget.getGeneratedImageUrl?.call(),
                    onAddToDesign: widget.onAddToDesign,
                    onRegenerate: widget.onRegenerate,
                    onClose: () {
                      print('🎭 Close button pressed');
                      Navigator.of(context).pop();
                    },
                  )
                : const SizedBox(),
      ),
    );
  }
}

/// Loading content with animation
class _LoadingContent extends StatefulWidget {
  const _LoadingContent();

  @override
  State<_LoadingContent> createState() => _LoadingContentState();
}

class _LoadingContentState extends State<_LoadingContent>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Rotation animation
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      _rotationController,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with title and close button
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
              SizedBox(width: 24.w),
              Expanded(
                child: Text(
                  'Text to Design',
                  textAlign: TextAlign.center,
                  style: AppFonts.poppinsSemiBold(
                    fontSize: 18.sp,
                    color: const Color(0xFF0F0F0F),
                  ).copyWith(height: 1.22),
                ),
              ),
              CustomCloseButton(
                onPressed: () => Navigator.of(context).pop(),
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
                
                // AI Generation Animation Container
                Container(
                  width: double.infinity,
                  height: 350.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_pulseController, _rotationController]),
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Animated wave circles (expanding ripples)
                            for (int i = 0; i < 3; i++)
                              Transform.scale(
                                scale: 1.0 + (_pulseAnimation.value + (i * 0.33)) % 1.0,
                                child: Opacity(
                                  opacity: 1.0 - ((_pulseAnimation.value + (i * 0.33)) % 1.0),
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
                              ),
                            
                            // Floating particles with neural connections
                            Container(
                              width: 180.w,
                              height: 180.h,
                              child: CustomPaint(
                                painter: _NeuralNetworkPainter(
                                  progress: _rotationAnimation.value,
                                  primaryColor: const Color(0xFF1F7CD5),
                                  secondaryColor: const Color(0xFF008BA6),
                                ),
                              ),
                            ),
                            
                            // Central glowing orb
                            Container(
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
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1F7CD5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.auto_awesome,
                                    size: 28.sp,
                                    color: const Color(0xFFFFF5E1),
                                    shadows: [
                                      Shadow(
                                        color: const Color(0xFFFFF5E1).withValues(alpha: 0.40),
                                        offset: const Offset(0, 0),
                                        blurRadius: 18,
                                      ),
                                      Shadow(
                                        color: const Color(0xFF60A5FA).withValues(alpha: 0.45),
                                        offset: const Offset(0, 0),
                                        blurRadius: 28,
                                      ),
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.10),
                                        offset: const Offset(1, 2),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Loading text with animation
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'We\'re hard at work making your ideas come to life! Your media will be ready in ',
                        style: AppFonts.interRegular(
                          fontSize: 16.sp,
                          color: const Color(0xFF0F0F0F),
                        ),
                      ),
                      TextSpan(
                        text: '10-20 seconds.',
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

                // Loading indicator
                SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF1F7CD5),
                    ),
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

/// Custom painter for neural network AI animation
class _NeuralNetworkPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  _NeuralNetworkPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Define particle positions (nodes in neural network)
    final particles = <Offset>[];
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * 3.14159 / 8) + (progress * 2 * 3.14159 * 0.2);
      final distance = radius * (0.7 + 0.1 * sin(progress * 2 * 3.14159 + i));
      particles.add(Offset(
        center.dx + distance * cos(angle),
        center.dy + distance * sin(angle),
      ));
    }
    
    // Draw connections between nearby particles
    final connectionPaint = Paint()
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final distance = (particles[i] - particles[j]).distance;
        if (distance < radius * 0.8) {
          final opacity = (1.0 - distance / (radius * 0.8)) * 0.4;
          connectionPaint.color = primaryColor.withValues(alpha: opacity);
          canvas.drawLine(particles[i], particles[j], connectionPaint);
        }
      }
    }
    
    // Draw particles
    for (int i = 0; i < particles.length; i++) {
      final particleProgress = (progress + (i / particles.length)) % 1.0;
      final pulseScale = 1.0 + 0.3 * sin(particleProgress * 2 * 3.14159);
      
      // Glow
      final glowPaint = Paint()
        ..color = (i % 2 == 0 ? primaryColor : secondaryColor).withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(particles[i], 8 * pulseScale, glowPaint);
      
      // Solid particle
      final particlePaint = Paint()
        ..color = i % 2 == 0 ? primaryColor : secondaryColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(particles[i], 4 * pulseScale, particlePaint);
    }
    
    // Draw data flow lines (animated)
    final flowPaint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 3; i++) {
      final flowProgress = (progress * 3 + i * 0.33) % 1.0;
      final startAngle = flowProgress * 2 * 3.14159;
      final endAngle = startAngle + 0.8;
      
      flowPaint.color = primaryColor.withValues(
        alpha: sin(flowProgress * 3.14159) * 0.6,
      );
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.5),
        startAngle,
        endAngle - startAngle,
        false,
        flowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_NeuralNetworkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Result content showing generated design
class _ResultContent extends StatelessWidget {
  final String? generatedImageUrl;
  final VoidCallback? onAddToDesign;
  final VoidCallback? onRegenerate;
  final VoidCallback onClose;

  const _ResultContent({
    this.generatedImageUrl,
    this.onAddToDesign,
    this.onRegenerate,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with title and close button
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 8.h,
            left: 26.w,
            right: 26.w,
            bottom: 24.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Text to Design',
                  textAlign: TextAlign.center,
                  style: AppFonts.poppinsSemiBold(
                    fontSize: 18.sp,
                    color: const Color(0xFF0F0F0F),
                  ).copyWith(height: 1.22),
                ),
              ),
              CustomCloseButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (context.mounted) {
                      onClose();
                    }
                  });
                },
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
              children: [
                // Card container with image and emoji banner
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(1.w),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFE5E7EB),
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                        spreadRadius: -4,
                      ),
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 15,
                        offset: Offset(0, 10),
                        spreadRadius: -3,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image container
                      Container(
                        width: double.infinity,
                        height: 350.h,
                        padding: EdgeInsets.symmetric(vertical: 100.5.h),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Center(
                          child: Container(
                            width: 160.w,
                            height: 160.h,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                            child: _buildGeneratedImage(),
                          ),
                        ),
                      ),
                      
                      // Blue banner with emoji
                      Container(
                        width: double.infinity,
                        height: 72.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F7CD5),
                        ),
                        child: Center(
                          child: Container(
                            width: 40.w,
                            height: 40.h,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(33554400.r),
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                CustomAssets.logoSmall,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Success message text
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Congrats! "i need a logo for SparkTech Name" is ready to use.',
                    style: AppFonts.interRegular(
                      fontSize: 16.sp,
                      color: const Color(0xFF1D2838),
                    ).copyWith(height: 1.38),
                  ),
                ),

                SizedBox(height: 24.h),

                // Action buttons
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add to design button
                    GestureDetector(
                      onTap: () {
                        // Dismiss keyboard first

                        final currentFocus = FocusScope.of(context);
                        if (currentFocus.hasFocus) {
                          currentFocus.unfocus();
                        }
                       // onRegenerate?.call();
                        // Small delay to ensure keyboard is dismissed
                        Future.delayed(const Duration(milliseconds: 1), () {
                          // Call the callback - it will handle showing mockup dialog
                          onAddToDesign?.call();
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50.w,
                          vertical: 14.h,
                        ),
                        decoration: ShapeDecoration(
                          color: const Color(0xFF1F7CD5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                              spreadRadius: -1,
                            ),
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Add image to your design',
                            textAlign: TextAlign.center,
                            style: AppFonts.interMedium(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ).copyWith(height: 1.60),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Regenerate button
                    GestureDetector(
                      onTap: () {
                        // Dismiss keyboard and unfocus any text fields
                        final currentFocus = FocusScope.of(context);
                        if (currentFocus.hasFocus) {
                          currentFocus.unfocus();
                        }
                        
                        // Call onRegenerate immediately without delay
                        // The controller handles navigation with proper keyboard dismissal
                        onRegenerate?.call();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 22.w,
                          vertical: 14.h,
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFD0D5DB),
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                              spreadRadius: -1,
                            ),
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Regenerate your Design',
                            textAlign: TextAlign.center,
                            style: AppFonts.interMedium(
                              fontSize: 16.sp,
                              color: const Color(0xFF0F0F0F),
                            ).copyWith(height: 1.50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneratedImage() {
    final imageUrl = generatedImageUrl?.trim() ?? '';
    if (imageUrl.isEmpty) {
      return Image.asset(
        CustomAssets.texttodesignimage,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          CustomAssets.texttodesignimage,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
