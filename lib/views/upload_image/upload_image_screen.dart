import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/upload_image_controller/upload_image_controller.dart';
import '../../controllers/create_controller/create_controller.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/dotted_border.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_assets.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/mockup_dialog.dart';
import '../../widgets/ai_generation_loading_widget.dart';
import '../../routes/app_path.dart';

/// UploadImageScreen - Screen for uploading images to create bag design
/// Follows OOP principles with clean separation of UI and business logic
class UploadImageScreen extends StatelessWidget {
  const UploadImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UploadImageController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          // Check if image is selected
          final hasImage = controller.selectedImagePath != null;
          
          return Column(
            children: [
              // App Bar
              _AppBar(),
              
              // Body Content
              Expanded(
                child: hasImage
                    ? _ImagePreviewContent(controller: controller)
                    : Center(child: _UploadCard(controller: controller)),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// App Bar Widget
class _AppBar extends StatefulWidget {
  const _AppBar();

  @override
  State<_AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    // Start rotation animation
    _rotationController.repeat();
    
    // Get controller and refresh
    final controller = Get.find<UploadImageController>();
    await controller.refresh();
    
    // Stop rotation after refresh completes
    _rotationController.stop();
    _rotationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.white),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              CustomBackButton(
                onPressed: () => context.go(AppPath.create),
              ),
              
              // Title
              Text(
                'Create',
                textAlign: TextAlign.center,
                style: AppFonts.poppinsSemiBold(
                  fontSize: 18.sp,
                  color: const Color(0xFF0F0F0F),
                ).copyWith(height: 1.22),
              ),
              
              // Refresh Button with Rotation Animation
              CircleFadeAnimation(
                onPressed: _handleRefresh,
                borderRadius: BorderRadius.circular(100),
                splashColor: Colors.black,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: RotationTransition(
                      turns: _rotationController,
                      child: Icon(
                        Icons.refresh,
                        size: 24.sp,
                        color: const Color(0xFF0F0F0F),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Upload Card Widget
class _UploadCard extends StatelessWidget {
  final UploadImageController controller;

  const _UploadCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderWidth: 1.5,
      borderColor: Colors.black.withValues(alpha: 0.50),
      radius: 10.r,
      child: Container(
        width: 330.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x3FC1C1C1),
              blurRadius: 30,
              offset: const Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title Section
            _TitleSection(),
            
            SizedBox(height: 20.h),
            
            // Upload Button
            _UploadButton(controller: controller),
          ],
        ),
      ),
    );
  }
}

/// Title Section Widget
class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 182.w,
      child: Column(
        children: [
          Text(
            'Start Designing',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF0F0F0F),
              fontSize: 18.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 1.22,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            'Select an image to add to your label',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF0F0F0F),
              fontSize: 12.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.17,
            ),
          ),
        ],
      ),
    );
  }
}

/// Upload Button Widget
class _UploadButton extends StatelessWidget {
  final UploadImageController controller;

  const _UploadButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: controller.isLoading.value ? null : () => controller.pickImage(context),
      child: Container(
        width: 230.w,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.5,
              color: Colors.black.withValues(alpha: 0.40),
            ),
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gallery Icon
            Icon(
              Icons.photo_library_outlined,
              size: 16.sp,
              color: const Color(0xFF0F0F0F),
            ),
            
            SizedBox(width: 4.w),
            
            // Text
            Text(
              controller.isLoading.value
                  ? 'Uploading...'
                  : 'Upload from your Gallery',
              style: TextStyle(
                color: const Color(0xFF0F0F0F),
                fontSize: 10.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.40,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

/// Image Preview Content - Shows after image is selected
class _ImagePreviewContent extends StatelessWidget {
  final UploadImageController controller;
  
  const _ImagePreviewContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      height: 400.h,
      color: const Color(0xFFF0F0F0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            
            // Save Button
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: GestureDetector(
                  onTap: () async {
                    controller.saveImage();
                    // Wait a tiny moment for the save to register
                    await Future.delayed(const Duration(milliseconds: 100));
                    // Show success toast message
                    if (context.mounted) {
                      CustomSnackBar.showSuccess(
                        context,
                        message: 'Design saved to Your Design!',
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 80.h),
            
            // Selected Image
            Container(
              width: double.infinity,
              height: 358.h,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: FileImage(File(controller.selectedImagePath!)),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            
            SizedBox(height: 80.h),
            
            // Show Bag Design Button
            GestureDetector(
              onTap: () async {
                // Show AI generation loading → real API call → MockupDialog
                await _showAIGenerationLoading(context, controller);
              },
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 16.r,
                      spreadRadius: 0,
                      offset: Offset(0, 6.h),
                    ),
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.06),
                      blurRadius: 6.r,
                      spreadRadius: 0,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.50,
                      color: Colors.white.withValues(alpha: 0.40),
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      CustomAssets.showbagdesign,
                      width: 32.w,
                      height: 32.h,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Show Bag Design',
                      style: AppFonts.interMedium(
                        fontSize: 20.sp,
                        color: const Color(0xFF0F0F0F),
                      ).copyWith(height: 1.50),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show AI generation loading animation,
/// call the real API inside onGenerate, then show MockupDialog with results.
Future<void> _showAIGenerationLoading(
  BuildContext context,
  UploadImageController controller,
) async {
  // ─── Resolve bag_type from CreateController selection ─────────────────────
  // CreateController holds which bag type + product row the user selected.
  // BagTypeMapper converts that combination to the API bag_type string.
  String bagType;
  try {
    final createController = Get.find<CreateController>();
    bagType = createController.resolvedBagType;
  } catch (_) {
    // CreateController not in scope — use default
    bagType = 'gusset_fullwrap';
  }
  print('🎒 Using bag_type: $bagType');
  var generationSucceeded = false;

  // Show loading animation as a full-screen dialog
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AIGenerationLoadingWidget(
        onGenerate: () async {
          // ─── REAL API CALL with resolved bag_type ────────────────────
          generationSucceeded = await controller.generateBagDesign(
            bagType: bagType,
          );
        },
        onClose: () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        },
      );
    },
  );

  // ─── After loading dialog is fully dismissed ──────────────────────────────
  if (!context.mounted) return;
  if (!generationSucceeded || !controller.hasGeneratedImages) {
    return;
  }

  // Show MockupDialog with generated network images.
  await MockupDialog.show(
    context,
    images: controller.mockupImages,
    isNetworkImage: true,
    onSaveImages: () async {
      return await controller.saveGeneratedLogoToYourDesign();
    },
    onAddToCollections: () async {
      return await controller.addMockupToCollections();
    },
  );
}