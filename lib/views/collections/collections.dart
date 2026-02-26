import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jeebz_bag_design_app/widgets/custom_nav_bar_widgets.dart';
import '../../controllers/collections_controller/collections_controller.dart';
import '../../routes/app_path.dart';
import '../../utils/app_fonts.dart';

/// Collections Screen - Displays collection of bag designs
/// Follows OOP principles with composition and encapsulation
class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(CollectionsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _AppBar(controller: controller),
            
            // Scrollable Bag Grid Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 26.w),
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    _BagGridContent(controller: controller),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1, // Collections is at index 1
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }
  
  /// Handles navigation bar tap events
  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Create
        context.go(AppPath.create);
        break;
      case 1:
        // Collections - Already here, do nothing
        break;
      case 2:
        // Your Design
        context.go(AppPath.yourdesign);
        break;
      case 3:
        // Profile
        context.go(AppPath.profile);
        break;
    }
  }
}


/// Private widget for bag grid content
/// Encapsulates the grid of bag images
class _BagGridContent extends StatelessWidget {
  final CollectionsController controller;

  const _BagGridContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Get saved images and default collection items
      final savedImages = controller.savedImages;
      final items = controller.getCollectionItems();
      
      // Combine saved images with default items
      final allItems = <dynamic>[];
      
      // Add saved images first
      for (var imagePath in savedImages) {
        allItems.add({
          'type': 'saved',
          'imagePath': imagePath,
        });
      }
      
      // Add default collection items
      for (var item in items) {
        allItems.add({
          'type': 'default',
          'item': item,
        });
      }

      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate((allItems.length / 2).ceil(), (rowIndex) {
            final leftIndex = rowIndex * 2;
            final rightIndex = leftIndex + 1;

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left item
                  if (leftIndex < allItems.length)
                    _buildBagItem(context, controller, allItems[leftIndex]),
                  
                  if (leftIndex < allItems.length && rightIndex >= allItems.length)
                    Expanded(child: SizedBox()),
                  
                  // Right item
                  if (rightIndex < allItems.length)
                    _buildBagItem(context, controller, allItems[rightIndex]),
                ],
              ),
            );
          }),
        ),
      );
    });
  }
  
  Widget _buildBagItem(BuildContext context, CollectionsController controller, dynamic itemData) {
    final itemWidth = (MediaQuery.of(context).size.width - 52.w - 30.w) / 2;
    
    if (itemData['type'] == 'saved') {
      // Display saved image from file
      return _SavedBagItem(
        controller: controller,
        imagePath: itemData['imagePath'],
        width: itemWidth,
      );
    } else {
      // Display default collection item
      return _BagItem(
        controller: controller,
        item: itemData['item'],
      );
    }
  }
}

/// Private widget for individual bag item
class _BagItem extends StatelessWidget {
  final CollectionsController controller;
  final CollectionBagItem item;

  const _BagItem({
    required this.controller,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate item width: (screen width - left padding - right padding - spacing) / 2
    final itemWidth = (MediaQuery.of(context).size.width - 52.w - 30.w) / 2;
    
    return GestureDetector(
      onTap: () => controller.onBagTap(item.index, item.isLabelBag),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: itemWidth,
            height: 248.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.contain,
              width: itemWidth,
              height: 248.h,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            item.isLabelBag ? 'Label Bag' : 'Full Graphic Bag',
            style: AppFonts.interRegular(
              fontSize: 14.sp,
              color: const Color(0xFF101727),
            ).copyWith(height: 1.43),
          ),
        ],
      ),
    );
  }
}

/// Private widget for saved bag item (from user uploads)
class _SavedBagItem extends StatelessWidget {
  final CollectionsController controller;
  final String imagePath;
  final double width;

  const _SavedBagItem({
    required this.controller,
    required this.imagePath,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the image is from assets or file system
    final isAssetImage = imagePath.startsWith('assets/') || 
                        !imagePath.startsWith('/') && 
                        !imagePath.contains('storage') && 
                        !imagePath.contains('data/user');
    
    return GestureDetector(
      onTap: () {
        // Show saved design details
        Get.snackbar(
          'Saved Design',
          'Your uploaded design',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: 248.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: isAssetImage
                ? Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: width,
                    height: 248.h,
                  )
                : Image.file(
                    File(imagePath),
                    fit: BoxFit.contain,
                    width: width,
                    height: 248.h,
                  ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Saved Design',
            style: AppFonts.interRegular(
              fontSize: 14.sp,
              color: const Color(0xFF101727),
            ).copyWith(height: 1.43),
          ),
        ],
      ),
    );
  }
}

/// Private widget for app bar
class _AppBar extends StatelessWidget {
  final CollectionsController controller;

  const _AppBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 8.h,
        left: 45.w,
        right: 26.w,
        bottom: 14.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // CustomBackButton(
          //   onPressed: () => controller.navigateBack(context),
          // ),
          //
          Expanded(
            child: Text(
              'Collections',
              textAlign: TextAlign.center,
              style: AppFonts.poppinsSemiBold(
                fontSize: 18.sp,
                color: const Color(0xFF0F0F0F),
              ).copyWith(height: 1.22),
            ),
          ),
          
          // Placeholder for symmetry
          SizedBox(width: 24.w),
        ],
      ),
    );
  }
}
