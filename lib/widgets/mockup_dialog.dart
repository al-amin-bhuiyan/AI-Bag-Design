import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../routes/app_path.dart';
import 'custom_assets.dart';

/// MockupDialog - Popup dialog displaying bag mockup with different angles
/// Follows OOP principles with clean separation and reusability
class MockupDialog {
  // Private constructor to prevent instantiation
  MockupDialog._();

  /// Shows the mockup dialog as a popup with overlay
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onSaveImages,
    VoidCallback? onAddToCollections,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: _MockupDialogContent(
            onSaveImages: onSaveImages,
            onAddToCollections: onAddToCollections,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Fade and scale animation
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }
}

/// Internal dialog content widget
class _MockupDialogContent extends StatelessWidget {
  final VoidCallback? onSaveImages;
  final VoidCallback? onAddToCollections;

  const _MockupDialogContent({
    this.onSaveImages,
    this.onAddToCollections,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350.w,
        margin: EdgeInsets.symmetric(horizontal: 26.w),
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and close button
              _Header(),

              SizedBox(height: 24.h),

              // Mockup sections
              _MockupSection(
                title: 'Whole bag design',
                images: [
                  CustomAssets.mockupImage1,
                  CustomAssets.mockupImage2,
                  CustomAssets.mockupImage3,
                  CustomAssets.mockupImage4,
                ],
              ),

              SizedBox(height: 32.h),

              _MockupSection(
                title: 'Whole bag design',
                images: [
                  CustomAssets.mockupImage5,
                  CustomAssets.mockupImage6,
                  CustomAssets.mockupImage7,
                  CustomAssets.mockupImage8,
                ],
              ),

              SizedBox(height: 32.h),

              // Action buttons
              _ActionButtons(
                onSaveImages: () {
                  Navigator.of(context).pop();
                  onSaveImages?.call();
                },
                onAddToCollections: () async {
                  // Dismiss keyboard immediately
                  FocusScope.of(context).unfocus();
                  
                  // Close dialog
                  Navigator.of(context).pop();
                  
                  // Call the save callback
                  onAddToCollections?.call();
                  
                  // Navigate to collections immediately using go (replaces entire stack)
                  // No delay to prevent text-to-design screen from becoming visible
                  if (context.mounted) {
                    context.go(AppPath.collection);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header with title and close button
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'Mockup with different Angle',
            style: AppFonts.poppinsSemiBold(
              fontSize: 18.sp,
              color: const Color(0xFF0F0F0F),
            ).copyWith(height: 1.11),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {
            // Dismiss keyboard before closing
            FocusScope.of(context).unfocus();
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            });
          },
          child: Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              Icons.close,
              size: 20.sp,
              color: const Color(0xFF0F0F0F),
            ),
          ),
        ),
      ],
    );
  }
}

/// Mockup section with title and images
class _MockupSection extends StatelessWidget {
  final String title;
  final List<String> images;

  const _MockupSection({
    required this.title,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          title,
          style: AppFonts.interSemiBold(
            fontSize: 16.sp,
            color: const Color(0xFF0F0F0F),
          ).copyWith(height: 1.25),
        ),

        SizedBox(height: 16.h),

        // Images row
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: images.map((imagePath) {
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: _MockupImage(imagePath: imagePath),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Single mockup image widget
class _MockupImage extends StatelessWidget {
  final String imagePath;

  const _MockupImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 162.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

/// Action buttons at the bottom
class _ActionButtons extends StatelessWidget {
  final VoidCallback? onSaveImages;
  final VoidCallback? onAddToCollections;

  const _ActionButtons({
    this.onSaveImages,
    this.onAddToCollections,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Save Images Button
        _ActionButton(
          text: 'Save Images',
          backgroundColor: AppColors.googlebuttonColor,
          textColor: Colors.white,
          onPressed: onSaveImages,
        ),

        SizedBox(height: 16.h),

        // Add to Collections Button
        _ActionButton(
          text: 'Add to Collections',
          backgroundColor: AppColors.addtocollectionbuttonbackground,
          textColor: const Color(0xFF0F0F0F),
          onPressed: onAddToCollections,
        ),
      ],
    );
  }
}

/// Single action button widget
class _ActionButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard before any action
        FocusScope.of(context).unfocus();
        // Small delay to ensure keyboard dismissal
        Future.delayed(const Duration(milliseconds: 100), () {
          onPressed?.call();
        });
      },
      child: Container(
        width: 296.w,
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: AppFonts.interRegular(
              fontSize: 16.sp,
              color: textColor,
            ).copyWith(height: 1.50),
          ),
        ),
      ),
    );
  }
}
