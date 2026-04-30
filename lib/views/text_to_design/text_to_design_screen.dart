import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/text_to_design_controller/text_to_design_controller.dart';
import '../../controllers/create_controller/create_controller.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_nav_bar_widgets.dart' show CustomNavBar;
import '../../routes/app_path.dart';

/// TextToDesignScreen - Screen for generating designs using AI text prompts
/// Follows OOP principles with clean separation of UI and business logic
class TextToDesignScreen extends StatelessWidget {
  const TextToDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TextToDesignController());

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside TextField
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false, // Prevent keyboard from affecting layout
        body: SafeArea(
          child: Column(
            children: [
              // App Bar
              _AppBar(),
              
              // Body Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: Column(
                    children: [
                      SizedBox(height: 42.h),
                      
                      // Action Buttons (Top Right)
                   //   _ActionButtons(),
                      
                      SizedBox(height: 20.h),
                      
                      // Main Content
                      _ContentSection(controller: controller),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomNavBar(
          currentIndex: 0,
          onTap: (index) => _handleNavigation(context, index),
        ),
      ),
    );
  }
  
  /// Handles navigation bar tap events
  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Create - Navigate back to main Create screen
        context.go(AppPath.create);
        break;
      case 1:
        // Collections
        context.go(AppPath.collection);
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

/// App Bar Widget
class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          SizedBox(width: 48.w),

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
            onPressed: () => Navigator.pop(context),
            backgroundColor: Colors.transparent,
            iconColor: const Color(0xFF0F0F0F),
            size: 32.w,
            iconSize: 24.sp,
            splashColor: Colors.black,
          ),
        ],
      ),
    );
  }
}

/// Action Buttons Widget (Top Right)
// class _ActionButtons extends StatelessWidget {
//   const _ActionButtons();
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Light Green Button
//           Container(
//             width: 30.w,
//             height: 30.h,
//             decoration: ShapeDecoration(
//               color: const Color(0xFFECFDF5),
//               shape: RoundedRectangleBorder(
//                 side: BorderSide(
//                   width: 1,
//                   color: const Color(0xFFD0FAE4),
//                 ),
//                 borderRadius: BorderRadius.circular(33554400.r),
//               ),
//               shadows: const [
//                 BoxShadow(
//                   color: Color(0x19000000),
//                   blurRadius: 2,
//                   offset: Offset(0, 1),
//                   spreadRadius: -1,
//                 ),
//                 BoxShadow(
//                   color: Color(0x19000000),
//                   blurRadius: 3,
//                   offset: Offset(0, 1),
//                   spreadRadius: 0,
//                 ),
//               ],
//             ),
//
//           ),
//
//           SizedBox(width: 8.w),
//
//           // Green Button (Active)
//           Container(
//             width: 30.w,
//             height: 30.h,
//             decoration: ShapeDecoration(
//               color: const Color(0xFF009966),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(33554400.r),
//               ),
//               shadows: const [
//                 BoxShadow(
//                   color: Color(0x19000000),
//                   blurRadius: 2,
//                   offset: Offset(0, 1),
//                   spreadRadius: -1,
//                 ),
//                 BoxShadow(
//                   color: Color(0x19000000),
//                   blurRadius: 3,
//                   offset: Offset(0, 1),
//                   spreadRadius: 0,
//                 ),
//               ],
//             ),
//             child: Icon(
//               Icons.auto_awesome,
//               size: 16.sp,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

/// Content Section Widget
class _ContentSection extends StatelessWidget {
  final TextToDesignController controller;

  const _ContentSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with Help Icon
        _SectionTitle(),
        
        SizedBox(height: 12.h),
        
        // Text Input Field with Action Buttons
        Stack(
          children: [
            _TextInputField(controller: controller),
            
            // Action Buttons positioned at bottom right corner
            // Positioned(
            //   right: 12.w,
            //   bottom: 12.h,
            //   child: _ActionButtons(),
            // ),
          ],
        ),
        
        SizedBox(height: 191.h),
        
        // Create Image Button
        _CreateImageButton(controller: controller),
      ],
    );
  }
}

/// Section Title Widget
class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'What would you like to create?',
          style: TextStyle(
            color: const Color(0xFF354152),
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            height: 1.43,
          ),
        ),
        Icon(
          Icons.help_outline,
          size: 18.sp,
          color: const Color(0xFF354152),
        ),
      ],
    );
  }
}

/// Text Input Field Widget
class _TextInputField extends StatelessWidget {
  final TextToDesignController controller;

  const _TextInputField({required this.controller});

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 182.h,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0),  // updated to withOpacity for correct alpha
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.5,
            color: const Color(0xFFE5E7EB),
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        shadows: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: controller.textController,
        maxLines: null,
        expands: true,
        textAlign: TextAlign.start,  // Added horizontal alignment
        textAlignVertical: TextAlignVertical.top,  // Keeps text at the top vertically
        style: TextStyle(
          color: const Color(0xFF0F0F0F),
          fontSize: 16.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
        decoration: InputDecoration(
          hintText: 'Enter 5+ words to describe',
          hintStyle: TextStyle(
            color: const Color(0xFF99A1AE),
            fontSize: 16.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

/// Create Image Button Widget
class _CreateImageButton extends StatelessWidget {
  final TextToDesignController controller;

  const _CreateImageButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomButton(
      label: 'Create Image',
      onPressed: controller.isLoading.value
          ? null
          : () async {
              // ─── Resolve bag_type from CreateController selection ─────────────────────
              String bagType;
              try {
                final createController = Get.find<CreateController>();
                bagType = createController.resolvedBagType;
              } catch (_) {
                bagType = 'gusset_fullwrap';
              }
              
              print('🎒 Text To Design Button Clicked - Using bag_type: $bagType');
              
              // Proceed with generation
              controller.generateDesign(context);
            },
      isLoading: controller.isLoading.value,
      backgroundColor: const Color(0xFF1F7CD5),
      textColor: Colors.white,
      fontSize: 16,
      height: 52,
      width: double.infinity,
    ));
  }
}