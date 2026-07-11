import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_colors.dart';
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
            ? const _LoadingContent()
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

class _LoadingContentState extends State<_LoadingContent> {
  late final VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/loading_logo.mp4')
      ..initialize().then((_) {
        if (mounted) setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
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
                ClipRect(
                  child: Container(
                    width: double.infinity,
                    height: 350.h,
                    child: _videoController.value.isInitialized
                        ? Builder(
                            builder: (context) {
                              final size = MediaQuery.of(context).size;
                              final videoAspectRatio = _videoController.value.aspectRatio;
                              final deviceAspectRatio = size.width / size.height;

                              double responsiveScale = videoAspectRatio / deviceAspectRatio;
                              if (responsiveScale < 1.0) {
                                responsiveScale = 1.0 / responsiveScale;
                              }
                              responsiveScale *= 0.30;

                              return Transform.scale(
                                scale: responsiveScale,
                                child: SizedBox.expand(
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _videoController.value.size.width,
                                      height: _videoController.value.size.height,
                                      child: VideoPlayer(_videoController),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
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
                        text: '1-2 Minutes .',
                        style: AppFonts.interSemiBold(
                          fontSize: 16.sp,
                          color: const Color(0xFF0F0F0F),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40.h),

                LoadingAnimationWidget.discreteCircle(
                  color: AppColors.primary,
                  secondRingColor: AppColors.secondary,
                  thirdRingColor: AppColors.primaryLight,
                  size: 40.r,
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
                    'Congrats! "Logo Generate Perfectly.Ready to Bag Design?',
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
                            'Make your Bag Design',
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