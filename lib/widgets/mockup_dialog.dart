import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../routes/app_path.dart';
import 'custom_button.dart';
import 'custom_assets.dart';

/// MockupDialog - Popup dialog displaying bag mockup with different angles
/// Follows OOP principles with clean separation and reusability
class MockupDialog {
  // Private constructor to prevent instantiation
  MockupDialog._();

  /// Shows the mockup dialog as a popup with overlay
  static Future<void> show(
    BuildContext context, {
    List<String>? images,
    bool isNetworkImage = false,
    Future<bool> Function()? onSaveImages,
    Future<bool> Function()? onAddToCollections,
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
            images: images,
            isNetworkImage: isNetworkImage,
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
  final List<String>? images;
  final bool isNetworkImage;
  final Future<bool> Function()? onSaveImages;
  final Future<bool> Function()? onAddToCollections;

  const _MockupDialogContent({
    this.images,
    this.isNetworkImage = false,
    this.onSaveImages,
    this.onAddToCollections,
  });

  @override
  Widget build(BuildContext context) {
    final displayImages = (images ?? <String>[])
        .where((url) => url.trim().isNotEmpty)
        .toList();

    if (displayImages.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Fluttertoast.showToast(
          msg: 'Bag design deos not successfull',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xFFF44336),
          textColor: Colors.white,
          fontSize: 14.sp,
        );
        Navigator.of(context).pop();
      });
      return const SizedBox.shrink();
    }

    return Center(
      child: Container(
        width: 350.w,
        constraints: BoxConstraints(
          maxHeight: 700.h, // Set dialog height to 800
        ),
        margin: EdgeInsets.symmetric(horizontal: 26.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 20,
              offset: const Offset(10, 10),
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

              SizedBox(height: 10.h),

              // Mockup section with images
              _MockupSection(
                title: 'Whole bag design',
                images: displayImages,
                isNetworkImage: isNetworkImage,
              ),

              SizedBox(height: 15.h), // Increased spacing

              // Action buttons
              _ActionButtons(
                onSaveImages: () async {
                  bool saved = true;
                  if (onSaveImages != null) {
                    saved = await onSaveImages!.call();
                  }

                  if (!context.mounted) return;

                  // Toasts are handled by the callback owner (controller/screen).
                  // This avoids duplicate or misleading hardcoded messages here.
                  if (!saved) return;

                  if (onSaveImages == null) {
                    Fluttertoast.showToast(
                      msg: 'Saved successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: const Color(0xFF1F7CD5),
                      textColor: Colors.white,
                      fontSize: 14.sp,
                    );
                  }
                },
                onAddToCollections: () async {
                  FocusScope.of(context).unfocus();
           //       Navigator.of(context).pop();

                  bool shouldNavigate = true;
                  if (onAddToCollections != null) {
                    shouldNavigate = await onAddToCollections!.call();
                  }

                  if (context.mounted && shouldNavigate) {
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
        CustomCloseButton(
          onPressed: () {
            FocusScope.of(context).unfocus(); // Unfocus any open keyboard
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted) {
                Navigator.of(context).pop(); // Close the dialog or screen
              }
            });
          },
          backgroundColor: Colors.red, // Red background for the close button
          iconColor: Colors.white, // White icon color
          size: 30.w, // Size of the button
          iconSize: 24.sp, // Size of the icon
          splashColor: Colors.grey, // Splash color when pressed
        ),
      ],
    );
  }
}

/// Mockup section with title and carousel slider with zoom
class _MockupSection extends StatefulWidget {
  final String title;
  final List<String> images;
  final bool isNetworkImage;

  const _MockupSection({
    required this.title,
    required this.images,
    this.isNetworkImage = false,
  });

  @override
  State<_MockupSection> createState() => _MockupSectionState();
}

class _MockupSectionState extends State<_MockupSection> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Section title
        Text(
          widget.title,
          style: AppFonts.interSemiBold(
            fontSize: 16.sp,
            color: const Color(0xFF0F0F0F),
          ).copyWith(height: 1.25),
        ),

        SizedBox(height: 24.h),

        // Carousel Slider with PhotoView for zoom
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                // Open fullscreen zoom view
                _openFullscreenGallery(context, index);
              },
              child: _MockupImage(
                imagePath: widget.images[index],
                isActive: _currentIndex == index,
                isNetworkImage: widget.isNetworkImage,
              ),
            );
          },
          options: CarouselOptions(
            height: 400.h,
            viewportFraction: 0.75,
            enlargeCenterPage: true,
            enlargeFactor: 0.25,
            enableInfiniteScroll: false,
            initialPage: 0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),

        SizedBox(height: 16.h),

        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            return Container(
              width: _currentIndex == entry.key ? 24.w : 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: _currentIndex == entry.key
                    ? const Color(0xFF1F7CD5)
                    : const Color(0xFFD9D9D9),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Opens fullscreen photo gallery with zoom capability
  void _openFullscreenGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullscreenGallery(
          images: widget.images,
          initialIndex: initialIndex,
          isNetworkImage: widget.isNetworkImage,
        ),
      ),
    );
  }
}

/// Single mockup image widget
/// Optimized for bag mockup images with network and asset support
class _MockupImage extends StatelessWidget {
  final String imagePath;
  final bool isActive;
  final bool isNetworkImage;

  const _MockupImage({
    required this.imagePath,
    this.isActive = true,
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Image - Network or Asset
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: isNetworkImage
                ? Image.network(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                    color: const Color(0xFF1F7CD5),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                // Remove background color, leave it transparent when error
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 32.sp),
                        SizedBox(height: 8.h),
                        Text(
                          'Failed to load image',
                          style: AppFonts.interRegular(
                            fontSize: 12.sp,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Zoom hint overlay
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6), // Semi-transparent background for hint
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.zoom_in,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Tap to zoom',
                    style: AppFonts.interRegular(
                      fontSize: 10.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Action buttons at the bottom
class _ActionButtons extends StatelessWidget {
  final Future<void> Function()? onSaveImages;
  final Future<void> Function()? onAddToCollections;

  const _ActionButtons({
    this.onSaveImages,
    this.onAddToCollections,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Merged Single Button: Save it
        _ActionButton(
          text: 'Save it',
          backgroundColor: AppColors.googlebuttonColor,
          textColor: Colors.white,
          onPressed: () async {
            // 1. Perform Save Images logic
            if (onSaveImages != null) {
              await onSaveImages!.call();
            }

            if (!context.mounted) return;

            // 2. Show the pop-up dialog
            AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              // 1. Keep noHeader but disable the native asset loop constraint
              dialogType: DialogType.noHeader,
              headerAnimationLoop: false,
              // 2. Reduce the top padding from 60.h to 16.h so the custom header doesn't push down the body layout
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              customHeader: Container(
                width: 100.r,
                height: 100.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Protects image bounds if asset has a white background
                ),
                // 3. Use ClipOval with BoxFit.contain to stop all four sides from being clipped
                child: ClipOval(
                  child: Padding(
                    padding: EdgeInsets.all(4.r), // Small breathing room inside the circle boundary
                    child: Image.asset(
                      CustomAssets.imageLoggss,
                      fit: BoxFit.contain, // Prevents stretching and shows the full scale image
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // This matches your original spacing configuration smoothly
                      SizedBox(height: 12.h),
                      Text(
                        'Design Saved!',
                        style: AppFonts.poppinsSemiBold(
                          fontSize: 24.sp,
                          color: const Color(0xFF4A4A4A),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Bag design saved. Contact us to claim:',
                        textAlign: TextAlign.center,
                        style: AppFonts.interSemiBold(
                          fontSize: 14.sp,
                          color: const Color(0xFF3B4094),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText.rich(
                              TextSpan(
                                style: AppFonts.interRegular(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF4B4B4B),
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Phone: ',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                  TextSpan(text: '1-909-902-5777'),
                                ],
                              ),
                              cursorColor: const Color(0xFF1F7CD5),
                              showCursor: true,
                            ),
                            SizedBox(height: 8.h),
                            SelectableText.rich(
                              TextSpan(
                                style: AppFonts.interRegular(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF4B4B4B),
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Email: ',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                  TextSpan(
                                    text: 'info@Soesternpackaging.com',
                                    style: TextStyle(
                                      color: Color(0xFF1F60D6),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              cursorColor: const Color(0xFF1F7CD5),
                              showCursor: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Please contact us for further process.',
                        textAlign: TextAlign.center,
                        style: AppFonts.interRegular(
                          fontSize: 13.sp,
                          color: const Color(0xFF5A5A5A),
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
              btnOkText: 'Close',
              btnOkColor: const Color(0xFF6E60DB),
              buttonsBorderRadius: BorderRadius.all(Radius.circular(6.r)),
              buttonsTextStyle: AppFonts.interMedium(
                fontSize: 14.sp,
                color: Colors.white,
              ),
              btnOkOnPress: () async {
                await onAddToCollections?.call();
              },
            ).show();
          },
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
  final Future<void> Function()? onPressed;

  const _ActionButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleFadeAnimation(
      onPressed: () {
        Future.delayed(const Duration(milliseconds: 100), () async {
          await onPressed?.call();
        });
      },
      borderRadius: BorderRadius.circular(8.r),
      splashColor: Colors.white,
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
            ).copyWith(height: 2.50),
          ),
        ),
      ),
    );
  }
}

/// Fullscreen gallery with zoom capability using PhotoViewGallery
class _FullscreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final bool isNetworkImage;

  const _FullscreenGallery({
    required this.images,
    required this.initialIndex,
    this.isNetworkImage = false,
  });

  @override
  State<_FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<_FullscreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // PhotoViewGallery for zoom
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: widget.isNetworkImage
                    ? NetworkImage(widget.images[index]) as ImageProvider
                    : AssetImage(widget.images[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 3.0,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.images[index]),
              );
            },
            itemCount: widget.images.length,
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                color: const Color(0xFF1F7CD5),
              ),
            ),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          // Top bar with close button
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Image counter
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: AppFonts.interSemiBold(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Close button
                  CircleFadeAnimation(
                    onPressed: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20.r),
                    splashColor: Colors.white,
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom instruction
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Pinch to zoom • Swipe to navigate',
                  style: AppFonts.interRegular(
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}