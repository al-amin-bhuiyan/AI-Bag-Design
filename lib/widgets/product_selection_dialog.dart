import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../controllers/create_controller/create_controller.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_assets.dart';
import '../../widgets/custom_button.dart';

/// ProductSelectionDialog - Popup for selecting bag product type
/// Follows OOP principles with clean widget composition
class ProductSelectionDialog extends StatelessWidget {
  final CreateController controller;
  final VoidCallback onProductSelected;
  final bool isFullGraphic;

  const ProductSelectionDialog({
    super.key,
    required this.controller,
    required this.onProductSelected,
    required this.isFullGraphic,
  });

  @override
  Widget build(BuildContext context) {
    // Get safe area padding (accounts for gesture nav bar + status bar)
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.black.withValues(alpha: 0.20),
      child: SafeArea(
        child: Center(
          child: Container(
            width: 350.w,
            // Max height constraint prevents overflow on small screens
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.85,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 26.w,
              vertical: 16.h + bottomPadding,
            ),
            padding: EdgeInsets.all(20.w),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button in top-right corner
                  Align(
                    alignment: Alignment.topRight,
                    child: CustomCloseButton(
                      onPressed: () {
                        controller.resetSelection();
                        Navigator.of(context).pop();
                      },
                      size: 32.w,
                      iconSize: 24.sp,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Title
                  Text(
                    'Pick your product',
                    textAlign: TextAlign.center,
                    style: AppFonts.poppinsSemiBold(
                      fontSize: 20.sp,
                      color: Colors.black,
                    ).copyWith(height: 1.30),
                  ),

                  SizedBox(height: 10.h),

                  // Product Grid
                  _ProductGrid(
                    controller: controller,
                    isFullGraphic: isFullGraphic,
                  ),

                  SizedBox(height: 10.h),

                  // Start Designing Button
                  Obx(() => _StartDesigningButton(
                        onPressed: onProductSelected,
                        isLoading: controller.isLoading,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Product grid with conditional rows based on bag type
class _ProductGrid extends StatelessWidget {
  final CreateController controller;
  final bool isFullGraphic;

  const _ProductGrid({
    required this.controller,
    required this.isFullGraphic,
  });

  @override
  Widget build(BuildContext context) {
    if (isFullGraphic) {
      return Column(
        children: [
          _SingleProductRow(
            controller: controller,
            row: 0,
            image: CustomAssets.fullGraphics,
            title: 'Quad Seal Bag',
          ),
          SizedBox(height: 10.h),
          _SingleProductRow(
            controller: controller,
            row: 1,
            image: CustomAssets.gussetBagFull,
            title: 'Gusset Bag',
          ),
          SizedBox(height: 10.h),
          _SingleProductRow(
            controller: controller,
            row: 2,
            image: CustomAssets.standUpPouchFull,
            title: 'Stand Up Pouch',
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _SingleProductRow(
            controller: controller,
            row: 0,
            image: CustomAssets.quadSealBag,
            title: 'Quad Seal Bag',
          ),
          SizedBox(height: 10.h),
          _SingleProductRow(
            controller: controller,
            row: 1,
            image: CustomAssets.gussetBag,
            title: 'Gusset Bag',
          ),
          SizedBox(height: 10.h),
          _SingleProductRow(
            controller: controller,
            row: 2,
            image: CustomAssets.standUpPouch,
            title: 'Stand Up Pouch',
          ),
        ],
      );
    }
  }
}

/// Single product row with selection animation and visibility detection
class _SingleProductRow extends StatefulWidget {
  final CreateController controller;
  final int row;
  final String image;
  final String title;

  const _SingleProductRow({
    required this.controller,
    required this.row,
    required this.image,
    required this.title,
  });

  @override
  State<_SingleProductRow> createState() => _SingleProductRowState();
}

class _SingleProductRowState extends State<_SingleProductRow> {
  bool _isVisible = false;
  bool _hasBeenVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('product_row_${widget.row}'),
      onVisibilityChanged: (VisibilityInfo info) {
        // Trigger when item becomes visible (>10% visible)
        if (info.visibleFraction > 0.1 && !_hasBeenVisible) {
          setState(() {
            _isVisible = true;
            _hasBeenVisible = true; // Load once, keep loaded
          });
          debugPrint('📦 Product row ${widget.row} loaded (${widget.title})');
        }
      },
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        child: AnimatedSlide(
          offset: _isVisible ? Offset.zero : const Offset(0, 0.1),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          child: _isVisible
              ? _ProductRowContent(
                  controller: widget.controller,
                  row: widget.row,
                  image: widget.image,
                  title: widget.title,
                )
              : SizedBox(
                  height: 150.h, // Placeholder height to prevent layout shift
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF1F7CD5),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

/// Product row content with selection animation
class _ProductRowContent extends StatelessWidget {
  final CreateController controller;
  final int row;
  final String image;
  final String title;

  const _ProductRowContent({
    required this.controller,
    required this.row,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.isRowSelected(row);

      return GestureDetector(
        onTap: () => controller.selectProductRow(row),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            final scale = 1.0 - (value * 0.05);
            final borderWidth = (value * 2.0).clamp(0.0, 2.0);
            final shadowSpread = (value * 4.0).clamp(0.0, 4.0);

            return Transform.scale(
              scale: scale,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: isSelected ? borderWidth : 0.5,
                      color: isSelected
                          ? const Color(0xFF1F7CD5)
                          : Colors.black.withValues(alpha: 0.28),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  shadows: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF1F7CD5).withValues(
                                alpha: (0.3 * value).clamp(0.0, 0.3)),
                            blurRadius: (12 * value).clamp(0.0, 12.0),
                            spreadRadius: shadowSpread,
                            offset: Offset(0, (4 * value).clamp(0.0, 4.0)),
                          ),
                          BoxShadow(
                            color: const Color(0xFF1F7CD5).withValues(
                                alpha: (0.15 * value).clamp(0.0, 0.15)),
                            blurRadius: (20 * value).clamp(0.0, 20.0),
                            spreadRadius: (shadowSpread * 1.5).clamp(0.0, 6.0),
                            offset: Offset(0, (6 * value).clamp(0.0, 6.0)),
                          ),
                        ]
                      : [],
                ),
                child: _ProductCardContent(
                  image: image,
                  title: title,
                  isSelected: isSelected,
                  animationValue: value,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

/// Individual product card content
class _ProductCardContent extends StatelessWidget {
  final String image;
  final String title;
  final bool isSelected;
  final double animationValue;

  const _ProductCardContent({
    required this.image,
    required this.title,
    required this.isSelected,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive image height — avoids overflow on small screens
    final imageHeight = MediaQuery.of(context).size.height * 0.12;

    return Column(
      children: [
        Transform.scale(
          scale: 1.0 + (animationValue * 0.08),
          child: SizedBox(
            width: double.infinity,
            height: imageHeight,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

/// Start Designing button with validation
class _StartDesigningButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _StartDesigningButton({
    required this.onPressed,
    required this.isLoading,
  });

  /// Handles button press with validation
  void _handlePress(BuildContext context, CreateController controller) {
    // Check if a product is selected
    if (controller.selectedProductRow == null) {
      // Show error toast if no product selected
      Fluttertoast.showToast(
        msg: 'Please select a product first',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFFF44336), // Red for error
        textColor: Colors.white,
        fontSize: 15.0,
      );
      return;
    }
    
    // Product is selected, proceed with action
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    // Get controller from parent context
    final controller = Get.find<CreateController>();
    
    return CustomButton(
      label: 'Start Designing',
      onPressed: isLoading ? null : () => _handlePress(context, controller),
      isLoading: isLoading,
      backgroundColor: const Color(0xFF1F7CD5),
      textColor: Colors.white,
      fontSize: 16.sp,
      height: 52.h,
      width: 296.w,
    );
  }
}