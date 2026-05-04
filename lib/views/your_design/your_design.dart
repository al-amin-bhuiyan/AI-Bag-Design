import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../controllers/your_design_controller/your_design_controller.dart';
import '../../routes/app_path.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_nav_bar_widgets.dart';

/// YourDesignScreen - Displays user's design projects
/// Follows OOP principles with composition and encapsulation
class YourDesignScreen extends StatelessWidget {
  const YourDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(YourDesignController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _AppBar(),
            
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const _LoadingView();
                }
                
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      
                      // All Projects Title
                      _AllProjectsTitle(),
                      
                      SizedBox(height: 16.h),
                      
                      // Search Bar
                      _SearchBar(controller: controller),
                      
                      SizedBox(height: 24.h),
                      
                      // Recents Header with View Toggle
                      _RecentsHeader(controller: controller),
                      
                      SizedBox(height: 16.h),
                      
                      // Projects List/Grid
                      Obx(() => controller.isGridView
                          ? _ProjectsGridView(controller: controller)
                          : _ProjectsListView(controller: controller)),
                      
                      SizedBox(height: 100.h),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 2, // Your Design is at index 2
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
        // Collections
        context.go(AppPath.collection);
        break;
      case 2:
        // Re-fetch backend data when re-tapping this tab.
        final controller = Get.find<YourDesignController>();
        controller.refresh();
        break;
      case 3:
        // Profile
        context.go(AppPath.profile);
        break;
    }
  }
}

String _resolveProjectImagePath(String imagePath) {
  final path = imagePath.trim();
  if (path.isEmpty) return path;
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  if (path.startsWith('/')) return '${AppConstants.baseUrl}$path';
  return path;
}

ImageProvider _resolveProjectImageProvider(String resolvedImagePath) {
  final isNetworkImage = resolvedImagePath.startsWith('http://') ||
      resolvedImagePath.startsWith('https://');
  final isFileImage = !isNetworkImage &&
      (resolvedImagePath.startsWith('/') ||
          resolvedImagePath.contains('storage') ||
          resolvedImagePath.contains('data/user'));

  if (isNetworkImage) return NetworkImage(resolvedImagePath);
  if (isFileImage) return FileImage(File(resolvedImagePath));
  return AssetImage(resolvedImagePath);
}

void _showProjectImagePreview(BuildContext context, String imagePath) {
  final resolvedImagePath = _resolveProjectImagePath(imagePath);
  if (resolvedImagePath.isEmpty) return;

  final imageProvider = _resolveProjectImageProvider(resolvedImagePath);

  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.85),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 5.0,
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 220.h,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 42.sp,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 8.h,
              right: 8.w,
              child: CircleFadeAnimation(
                onPressed: () => Navigator.of(dialogContext).pop(),
                borderRadius: BorderRadius.circular(100),
                splashColor: Colors.white,
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

const Map<String, String> _bagTypeDisplayNames = {
  'gusset_fullwrap': 'Gusset Full Bag',
  'gusset_label': 'Gusset Label Bag',
  'foil_fullwrap': 'Foil Full Bag',
  'foil_label': 'Foil Label Bag',
  'quad_fullwrap': 'Quad Full Bag',
  'quad_label': 'Quad Label Bag',
};

String _resolveProjectTitle(String rawTitle) {
  final normalized = rawTitle.trim().toLowerCase();
  return _bagTypeDisplayNames[normalized] ?? rawTitle;
}

/// App Bar Widget
class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 8.h,
        left: 26.w,
        right: 26.w,
        bottom: 24.h,
      ),
      child: Center(
        child: Text(
          'Your Design',
          textAlign: TextAlign.center,
          style: AppFonts.poppinsSemiBold(
            fontSize: 18.sp,
            color: const Color(0xFF0F0F0F),
          ).copyWith(height: 1.22),
        ),
      ),
    );
  }
}

/// All Projects Title
class _AllProjectsTitle extends StatelessWidget {
  const _AllProjectsTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'All Projects',
      style: AppFonts.poppinsSemiBold(
        fontSize: 18.sp,
        color: const Color(0xFF101727),
      ).copyWith(height: 1.33),
    );
  }
}

/// Search Bar Widget
class _SearchBar extends StatelessWidget {
  final YourDesignController controller;
  
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black.withValues(alpha: 0.40),
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 24.sp,
            color: const Color(0xFF0F0F0F),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller.searchTextController,
              onChanged: controller.updateSearchQuery,
              style: AppFonts.interRegular(
                fontSize: 14.sp,
                color: const Color(0xFF0F0F0F),
              ),
              decoration: InputDecoration(
                hintText: 'Search across all content',
                hintStyle: AppFonts.interRegular(
                  fontSize: 14.sp,
                  color: const Color(0xFF0F0F0F),
                ).copyWith(height: 1.43),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          Obx(() {
            final hasQuery = controller.searchQuery.trim().isNotEmpty;
            if (!hasQuery) return const SizedBox.shrink();
            return GestureDetector(
              onTap: controller.clearSearchQuery,
              child: Icon(
                Icons.close,
                size: 20.sp,
                color: const Color(0xFF6B7280),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Recents Header with View Toggle
class _RecentsHeader extends StatelessWidget {
  final YourDesignController controller;
  
  const _RecentsHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recents',
          style: AppFonts.poppinsSemiBold(
            fontSize: 18.sp,
            color: const Color(0xFF0F0F0F),
          ).copyWith(height: 1.33),
        ),
        Obx(() => CircleFadeAnimation(
          onPressed: controller.toggleView,
          borderRadius: BorderRadius.circular(4.r),
          splashColor: AppColors.primary,
          child: Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              controller.isGridView ? Icons.view_list_sharp : Icons.grid_view_outlined,
              size: 18.sp,
              color: AppColors.primary,
            ),
          ),
        )),
      ],
    );
  }
}

/// Projects Grid View
class _ProjectsGridView extends StatelessWidget {
  final YourDesignController controller;
  
  const _ProjectsGridView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final projects = controller.projects;

      if (projects.isEmpty) {
        return const _EmptyView();
      }

      return Column(
        children: List.generate(
          (projects.length / 2).ceil(),
          (rowIndex) {
            final leftIndex = rowIndex * 2;
            final rightIndex = leftIndex + 1;

            return Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leftIndex < projects.length)
                    Expanded(
                      child: _ProjectGridItem(
                        controller: controller,
                        project: projects[leftIndex],
                      ),
                    ),
                  if (rightIndex < projects.length) ...[
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _ProjectGridItem(
                        controller: controller,
                        project: projects[rightIndex],
                      ),
                    ),
                  ] else
                    const Expanded(child: SizedBox()),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}

/// Project Grid Item with lazy loading
class _ProjectGridItem extends StatefulWidget {
  final YourDesignController controller;
  final DesignProject project;
  
  const _ProjectGridItem({
    required this.controller,
    required this.project,
  });

  @override
  State<_ProjectGridItem> createState() => _ProjectGridItemState();
}

class _ProjectGridItemState extends State<_ProjectGridItem> {
  bool _isVisible = false;
  bool _hasBeenVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('project_grid_${widget.project.id}'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.1 && !_hasBeenVisible) {
          setState(() {
            _isVisible = true;
            _hasBeenVisible = true;
          });
          debugPrint('📦 Grid project loaded: ${widget.project.title}');
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
              ? _ProjectGridItemContent(
                  controller: widget.controller,
                  project: widget.project,
                )
              : SizedBox(
                  height: 220.h,
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

/// Project Grid Item Content
class _ProjectGridItemContent extends StatelessWidget {
  final YourDesignController controller;
  final DesignProject project;
  
  const _ProjectGridItemContent({
    required this.controller,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedImagePath = _resolveProjectImagePath(project.imagePath);
    final imageProvider = _resolveProjectImageProvider(resolvedImagePath);
    
    return GestureDetector(
      onTap: () => controller.openProject(project),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Image with More Button
          Stack(
            children: [
              GestureDetector(
                onTap: () => _showProjectImagePreview(context, project.imagePath),
                child: Container(
                  width: double.infinity,
                  height: 150.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: LoadingAnimationWidget.inkDrop(
                          color: const Color(0xFF1F7CD5),
                          size: 30.sp,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(Icons.broken_image_outlined, color: Colors.grey[600]),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 2.h,
                right: 2.w,
                child: _ProjectOptionsButton(
                  controller: controller,
                  project: project,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8.h),
          
          // Project Title
          Text(
            _resolveProjectTitle(project.title),
            style: AppFonts.poppinsSemiBold(
              fontSize: 14.sp,
              color: const Color(0xFF0F0F0F),
            ).copyWith(height: 1.50),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 6.h),
          
          // Private Badge
          _PrivateBadge(project: project),
        ],
      ),
    );
  }
}

/// Projects List View
class _ProjectsListView extends StatelessWidget {
  final YourDesignController controller;
  
  const _ProjectsListView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final projects = controller.projects;

      if (projects.isEmpty) {
        return const _EmptyView();
      }

      return Column(
        children: projects.map((project) {
          return Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: _ProjectListItem(
              controller: controller,
              project: project,
            ),
          );
        }).toList(),
      );
    });
  }
}

/// Project List Item with lazy loading
class _ProjectListItem extends StatefulWidget {
  final YourDesignController controller;
  final DesignProject project;
  
  const _ProjectListItem({
    required this.controller,
    required this.project,
  });

  @override
  State<_ProjectListItem> createState() => _ProjectListItemState();
}

class _ProjectListItemState extends State<_ProjectListItem> {
  bool _isVisible = false;
  bool _hasBeenVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('project_list_${widget.project.id}'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.1 && !_hasBeenVisible) {
          setState(() {
            _isVisible = true;
            _hasBeenVisible = true;
          });
          debugPrint('📦 List project loaded: ${widget.project.title}');
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
              ? _ProjectListItemContent(
                  controller: widget.controller,
                  project: widget.project,
                )
              : SizedBox(
                  height: 5.h,
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

/// Project List Item Content
class _ProjectListItemContent extends StatelessWidget {
  final YourDesignController controller;
  final DesignProject project;
  
  const _ProjectListItemContent({
    required this.controller,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedImagePath = _resolveProjectImagePath(project.imagePath);
    final imageProvider = _resolveProjectImageProvider(resolvedImagePath);
    
    return GestureDetector(
      onTap: () => controller.openProject(project),
      child: Row(
        children: [
          // Project Thumbnail
          GestureDetector(
            onTap: () => _showProjectImagePreview(context, project.imagePath),
            child: Container(
              width: 70.w,
              height: 70.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: const Color(0xFF1F7CD5),
                      size: 20.sp,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(Icons.broken_image_outlined, color: Colors.grey[600]),
                    ),
                  );
                },
              ),
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Project Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Title
                Text(
                  _resolveProjectTitle(project.title),
                  style: AppFonts.poppinsSemiBold(
                    fontSize: 16.sp,
                    color: const Color(0xFF0F0F0F),
                  ).copyWith(height: 1.50),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 6.h),
                
                // Badges Row
                Row(
                  children: [
                    _PrivateBadge(project: project),
                    if (project.category != null) ...[
                      SizedBox(width: 8.w),
                      _CategoryBadge(category: project.category!),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Options Button
          _ProjectOptionsButton(
            controller: controller,
            project: project,
          ),
        ],
      ),
    );
  }
}

/// Private Badge Widget
class _PrivateBadge extends StatelessWidget {
  final DesignProject project;
  
  const _PrivateBadge({required this.project});

  @override
  Widget build(BuildContext context) {
    if (!project.isPrivate) return const SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: ShapeDecoration(
        color: const Color(0xFFEDEDED),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock,
            size: 12.sp,
            color: const Color(0xFF0F0F0F),
          ),
          SizedBox(width: 2.w),
          Text(
            'Private',
            style: AppFonts.interRegular(
              fontSize: 12.sp,
              color: const Color(0xFF0F0F0F),
            ).copyWith(height: 1.50),
          ),
        ],
      ),
    );
  }
}

/// Category Badge Widget
class _CategoryBadge extends StatelessWidget {
  final String category;
  
  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Container(
        //   width: 22.w,
        //   height: 22.h,
        //   decoration: const ShapeDecoration(
        //     color: Color(0xFF009966),
        //     shape: CircleBorder(),
        //   ),
        //   child: Center(
        //     child: Container(
        //       width: 14.w,
        //       height: 14.h,
        //       decoration: ShapeDecoration(
        //         color: Colors.white,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(2.r),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(width: 4.w),
        // Text(
        //   category,
        //   style: AppFonts.poppinsRegular(
        //     fontSize: 12.sp,
        //     color: const Color(0xFF0F0F0F),
        //   ).copyWith(height: 1.50),
        // ),
      ],
    );
  }
}

/// Project Options Button (Three Dots)
class _ProjectOptionsButton extends StatelessWidget {
  final YourDesignController controller;
  final DesignProject project;
  
  const _ProjectOptionsButton({
    required this.controller,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(
        Icons.more_vert,
        size: 24.sp,
        color: const Color(0xFF0F0F0F),
      ),
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      onSelected: (value) {
        if (value == 'delete') {
          _showDeleteConfirmation(context, controller, project);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 20.sp,
                color: Colors.red,
              ),
              SizedBox(width: 12.w),
              Text(
                'Delete',
                style: AppFonts.interRegular(
                  fontSize: 14.sp,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Shows delete confirmation dialog
  void _showDeleteConfirmation(
    BuildContext context,
    YourDesignController controller,
    DesignProject project,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Project',
          style: AppFonts.poppinsSemiBold(
            fontSize: 18.sp,
            color: const Color(0xFF0F0F0F),
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${_resolveProjectTitle(project.title)}"? This action cannot be undone.',
          style: AppFonts.interRegular(
            fontSize: 14.sp,
            color: const Color(0xFF0F0F0F),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppFonts.poppinsMedium(
                fontSize: 14.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteProject(project);
            },
            child: Text(
              'Delete',
              style: AppFonts.poppinsMedium(
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty View with Lottie Animation
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 60.h),
          
          // Lottie Animation - using a simple animation
          SizedBox(
            width: 200.w,
            height: 200.h,
            child: Icon(
              Icons.folder_open_outlined,
              size: 100.sp,
              color: Colors.grey[300],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          Text(
            'No Projects Yet',
            style: AppFonts.poppinsSemiBold(
              fontSize: 20.sp,
              color: const Color(0xFF0F0F0F),
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            'Start creating your first design',
            style: AppFonts.interRegular(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading View with Animation
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading your designs...',
            style: AppFonts.interRegular(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}