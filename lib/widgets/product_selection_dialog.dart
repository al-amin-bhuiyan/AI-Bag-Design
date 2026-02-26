import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/create_controller/create_controller.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_assets.dart';
import '../../widgets/custom_button.dart';

/// ProductSelectionDialog - Popup for selecting bag product type
/// Follows OOP principles with clean widget composition
class ProductSelectionDialog extends StatelessWidget {
  final CreateController controller;
  final VoidCallback onProductSelected;
  final bool isFullGraphic; // true = full graphic, false = label bag

  const ProductSelectionDialog({
    super.key,
    required this.controller,
    required this.onProductSelected,
    required this.isFullGraphic,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.20),
      child: Center(
        child: Container(
          width: 350.w,
          margin: EdgeInsets.symmetric(horizontal: 26.w),
          padding: EdgeInsets.all(24.w),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button in top-right corner
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    // Reset selection state
                    controller.resetSelection();
                    // Close dialog
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              // Title (centered)
              Text(
                'Pick your product',
                textAlign: TextAlign.center,
                style: AppFonts.poppinsSemiBold(
                  fontSize: 20.sp,
                  color: Colors.black,
                ).copyWith(height: 1.30),
              ),
              
              SizedBox(height: 10.h),
              
              // Product Grid (conditional based on bag type)
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
    );
  }
}

/// Product grid with 2 columns x 3 rows
class _ProductGrid extends StatelessWidget {
  final CreateController controller;
  final bool isFullGraphic;

  const _ProductGrid({
    required this.controller,
    required this.isFullGraphic,
  });

  @override
  Widget build(BuildContext context) {
    // If Full Graphic is selected, show only full graphic bags
    if (isFullGraphic) {
      return Column(
        children: [
          // Row 0: Full Graphics
          _SingleProductRow(
            controller: controller,
            row: 0,
            image: CustomAssets.fullGraphics,
            title: 'Full Graphics',
          ),
          
          SizedBox(height: 10.h),
          
          // Row 1: Full Graphics (Gusset Bag Full)
          _SingleProductRow(
            controller: controller,
            row: 1,
            image: CustomAssets.gussetBagFull,
            title: 'Full Graphics',
          ),
          
          SizedBox(height: 10.h),
          
          // Row 2: Full Graphics (Stand Up Pouch Full)
          _SingleProductRow(
            controller: controller,
            row: 2,
            image: CustomAssets.standUpPouchFull,
            title: 'Full Graphics',
          ),
        ],
      );
    } 
    // If Label Bag is selected, show label bags (Quad Seal, Gusset, Stand Up Pouch)
    else {
      return Column(
        children: [
          // Row 0: Quad Seal Bag
          _SingleProductRow(
            controller: controller,
            row: 0,
            image: CustomAssets.quadSealBag,
            title: 'Quad Seal Bag',
          ),
          
          SizedBox(height: 10.h),
          
          // Row 1: Gusset Bag
          _SingleProductRow(
            controller: controller,
            row: 1,
            image: CustomAssets.gussetBag,
            title: 'Gusset Bag',
          ),
          
          SizedBox(height: 10.h),
          
          // Row 2: Stand Up Pouch
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

/// Single product row for label bags (one product per row)
class _SingleProductRow extends StatelessWidget {
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
            // Calculate animation values
            final scale = 1.0 - (value * 0.05);
            final borderWidth = (value * 2.0).clamp(0.0, 2.0);
            final shadowSpread = (value * 4.0).clamp(0.0, 4.0);
            
            return Transform.scale(
              scale: scale,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                            color: const Color(0xFF1F7CD5).withValues(alpha: (0.3 * value).clamp(0.0, 0.3)),
                            blurRadius: (12 * value).clamp(0.0, 12.0),
                            spreadRadius: shadowSpread,
                            offset: Offset(0, (4 * value).clamp(0.0, 4.0)),
                          ),
                          BoxShadow(
                            color: const Color(0xFF1F7CD5).withValues(alpha: (0.15 * value).clamp(0.0, 0.15)),
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

/// Individual product card content without border
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
    return Column(
      children: [
        Transform.scale(
          scale: 1.0 + (animationValue * 0.08),
          child: Container(
            width: double.infinity,
            height: 150.h,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),
        
        SizedBox(height: 8.h),
        
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

/// Start Designing button
class _StartDesigningButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _StartDesigningButton({
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: 'Start Designing',
      onPressed: isLoading ? null : onPressed,
      isLoading: isLoading,
      backgroundColor: const Color(0xFF1F7CD5),
      textColor: Colors.white,
      fontSize: 16.sp,
      height: 52.h,
      width: 296.w,
    );
  }
}
