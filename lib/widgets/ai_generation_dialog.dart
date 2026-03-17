import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_fonts.dart';
import '../widgets/custom_assets.dart';
import '../widgets/custom_button.dart';

/// AIGenerationDialog - Shows AI generation progress and result
/// Follows OOP principles with clean separation and reusability
class AIGenerationDialog {
  // Private constructor to prevent instantiation
  AIGenerationDialog._();

  /// Shows the AI generation dialog with loading and result
  static Future<void> show(
    BuildContext context, {
    required Future<void> Function() onGenerate,
    VoidCallback? onAddToDesign,
    VoidCallback? onRegenerate,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AIGenerationDialogContent(
        onGenerate: onGenerate,
        onAddToDesign: onAddToDesign,
        onRegenerate: onRegenerate,
      ),
    );
  }
}

/// Internal dialog content widget with state management
class _AIGenerationDialogContent extends StatefulWidget {
  final Future<void> Function() onGenerate;
  final VoidCallback? onAddToDesign;
  final VoidCallback? onRegenerate;

  const _AIGenerationDialogContent({
    required this.onGenerate,
    this.onAddToDesign,
    this.onRegenerate,
  });

  @override
  State<_AIGenerationDialogContent> createState() =>
      _AIGenerationDialogContentState();
}

class _AIGenerationDialogContentState
    extends State<_AIGenerationDialogContent> {
  bool _isGenerating = true;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    print('🎭 Dialog initState - Starting generation');
    // Use addPostFrameCallback to ensure generation starts after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGeneration();
    });
  }

  Future<void> _startGeneration() async {
    print('🎭 _startGeneration called');
    try {
      print('🎭 Showing loading state...');
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

      print('🎭 Generation completed, waiting 500ms...');
      // Wait a bit to show the animation
      await Future.delayed(const Duration(milliseconds: 500));

      print('🎭 Transitioning to result state...');
      // Show result
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _showResult = true;
        });
        print('🎭 Result state active - _isGenerating: $_isGenerating, _showResult: $_showResult');
      } else {
        print('❌ Widget not mounted, cannot show result');
      }
    } catch (e) {
      print('❌ Error in _startGeneration: $e');
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🎭 Building dialog - _isGenerating: $_isGenerating, _showResult: $_showResult');
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 26.w),
      child: Container(
        width: 350.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: _isGenerating
            ? _LoadingContent()
            : _showResult
                ? _ResultContent(
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
class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with title and close button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Text to Design',
                textAlign: TextAlign.center,
                style: AppFonts.poppinsSemiBold(
                  fontSize: 18.sp,
                  color: const Color(0xFF0F0F0F),
                ),
              ),
            ),
            // Close button hidden during loading
            SizedBox(width: 24.w),
          ],
        ),

        SizedBox(height: 24.h),

        // AI Generation Animation Icon
        Container(
          width: 280.w,
          height: 280.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Icon(
              Icons.auto_awesome,
              size: 80.sp,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ),

        SizedBox(height: 24.h),

        // Loading text with animation
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'We\'re hard at work making your ideas come to life! Your media will be ready in ',
                style: AppFonts.interRegular(
                  fontSize: 14.sp,
                  color: const Color(0xFF0F0F0F),
                ),
              ),
              TextSpan(
                text: '10-20 seconds.',
                style: AppFonts.interSemiBold(
                  fontSize: 14.sp,
                  color: const Color(0xFF0F0F0F),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 16.h),

        // Loading indicator
        SizedBox(
          width: 30.w,
          height: 30.h,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              const Color(0xFF1F7CD5),
            ),
          ),
        ),
      ],
    );
  }
}

/// Result content showing generated design
class _ResultContent extends StatelessWidget {
  final VoidCallback? onAddToDesign;
  final VoidCallback? onRegenerate;
  final VoidCallback onClose;

  const _ResultContent({
    this.onAddToDesign,
    this.onRegenerate,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with title and close button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Text to Design',
                textAlign: TextAlign.center,
                style: AppFonts.poppinsSemiBold(
                  fontSize: 18.sp,
                  color: const Color(0xFF0F0F0F),
                ),
              ),
            ),
            CustomCloseButton(
              onPressed: onClose,
              backgroundColor: Colors.transparent,
              iconColor: const Color(0xFF0F0F0F),
              iconSize: 24.sp,
              size: 32.w,
              splashColor: Colors.black,
            ),
          ],
        ),

        SizedBox(height: 24.h),

        // Generated image
        Container(
          width: 280.w,
          height: 280.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            CustomAssets.texttodesignimage,
            fit: BoxFit.contain,
          ),
        ),

        SizedBox(height: 16.h),

        // Success message with emoji
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1F7CD5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '😊',
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Congrats! "I need a logo for SparkTech Name" is ready to use.',
                  style: AppFonts.interRegular(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Add to design button
        CustomButton(
          label: 'Add image to your design',
          onPressed: () {
            onClose();
            onAddToDesign?.call();
          },
          backgroundColor: const Color(0xFF1F7CD5),
          textColor: Colors.white,
          fontSize: 16,
          height: 52,
          width: double.infinity,
        ),

        SizedBox(height: 12.h),

        // Regenerate button
        GestureDetector(
          onTap: () {
            onClose();
            onRegenerate?.call();
          },
          child: Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFF1F7CD5),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                'Regenerate your Design',
                style: AppFonts.interMedium(
                  fontSize: 16.sp,
                  color: const Color(0xFF1F7CD5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
