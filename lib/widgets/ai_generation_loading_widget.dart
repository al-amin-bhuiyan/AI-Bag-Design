import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/app_fonts.dart';
import '../utils/app_colors.dart';
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
        // ── Header ────────────────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 8.h,
           
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),

                // ── Video Animation ─────────────────────────────────────────────
                Container(
                  width: double.infinity,
                  height: 300.h,
                  clipBehavior: Clip.antiAlias, // Prevent overflow from scaling
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
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
                            responsiveScale *= 0.40;

                            return Transform.scale(
                              scale: responsiveScale,
                              child: FittedBox(
                                fit: BoxFit.cover
                                , // Fill the width perfectly
                                child: SizedBox(
                                  width: _videoController.value.size.width,
                                  height: _videoController.value.size.height,
                                  child: VideoPlayer(_videoController),
                                ),
                              ),
                            );
                          },
                        )
                      : SizedBox(
                          height: 100.h,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                ),

                SizedBox(height: 32.h),

                // ── Loading text ─────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: Text.rich(
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
                ),

                SizedBox(height: 40.h),

                LoadingAnimationWidget.discreteCircle(
                  color: AppColors.primary,
                  secondRingColor: AppColors.secondary,
                  thirdRingColor: AppColors.secondaryLight,
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