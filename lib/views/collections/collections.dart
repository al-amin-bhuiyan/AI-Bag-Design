import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jeebz_bag_design_app/widgets/custom_nav_bar_widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../controllers/collections_controller/collections_controller.dart';
import '../../models/save_collection_response_model.dart';
import '../../routes/app_path.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_fonts.dart';

/// Collections Screen - Displays collection designs from backend API
class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CollectionsController>()
        ? Get.find<CollectionsController>()
        : Get.put(CollectionsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(controller: controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF1F7CD5),
                    ),
                  );
                }

                final items = controller.collectionDesigns;
                if (items.isEmpty) {
                  return const _EmptyCollectionsView();
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      _BagGridContent(items: items),
                      SizedBox(height: 12.h),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1,
        onTap: (index) => _handleNavigation(context, index, controller),
      ),
    );
  }

  void _handleNavigation(
    BuildContext context,
    int index,
    CollectionsController controller,
  ) {
    switch (index) {
      case 0:
        context.go(AppPath.create);
        break;
      case 1:
        // Re-hit GET /api/collections/ when collections tab is tapped.
        controller.refresh();
        break;
      case 2:
        context.go(AppPath.yourdesign);
        break;
      case 3:
        context.go(AppPath.profile);
        break;
    }
  }
}

class _BagGridContent extends StatelessWidget {
  final List<SaveCollectionResponseModel> items;

  const _BagGridContent({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: List.generate((items.length / 2).ceil(), (rowIndex) {
          final leftIndex = rowIndex * 2;
          final rightIndex = leftIndex + 1;

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _CollectionCard(item: items[leftIndex])),
                SizedBox(width: 12.w),
                Expanded(
                  child: rightIndex < items.length
                      ? _CollectionCard(item: items[rightIndex])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _CollectionCard extends StatefulWidget {
  final SaveCollectionResponseModel item;

  const _CollectionCard({required this.item});

  @override
  State<_CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<_CollectionCard> {
  List<String> _sliderImageUrls = <String>[];
  int _currentImageIndex = 0;

  static const Map<String, String> _bagTypeDisplayNames = {
    'gusset_fullwrap': 'Gusset Full Bag',
    'gusset_label': 'Gusset Label Bag',
    'foil_fullwrap': 'Foil Full Bag',
    'foil_label': 'Foil Label Bag',
    'quad_fullwrap': 'Quad Full Bag',
    'quad_label': 'Quad Label Bag',
  };

  @override
  void initState() {
    super.initState();
    debugPrint(
      '[_CollectionCardState] initState for item id=${widget.item.id}',
    );
    _syncImageStateFromItem();
  }

  @override
  void didUpdateWidget(covariant _CollectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id ||
        oldWidget.item.previewUrl != widget.item.previewUrl ||
        oldWidget.item.dielineUrl != widget.item.dielineUrl) {
      debugPrint('[_CollectionCardState] didUpdateWidget id=${widget.item.id}');
      debugPrint('  old.previewUrl=${oldWidget.item.previewUrl}');
      debugPrint('  new.previewUrl=${widget.item.previewUrl}');
      debugPrint('  old.dielineUrl=${oldWidget.item.dielineUrl}');
      debugPrint('  new.dielineUrl=${widget.item.dielineUrl}');
      _syncImageStateFromItem();
    }
  }

  void _syncImageStateFromItem() {
    debugPrint(
      '[_CollectionCardState] _syncImageStateFromItem id=${widget.item.id}',
    );
    debugPrint('  raw.previewUrl=${widget.item.previewUrl}');
    debugPrint('  raw.dielineUrl=${widget.item.dielineUrl}');

    final orderedUniqueUrls = <String>[];
    for (final rawUrl in widget.item.sliderImageUrls) {
      final resolved = _resolveImageUrl(rawUrl);
      if (resolved.isNotEmpty && !orderedUniqueUrls.contains(resolved)) {
        orderedUniqueUrls.add(resolved);
      }
    }

    _sliderImageUrls = orderedUniqueUrls;
    debugPrint('  _sliderImageUrls=$_sliderImageUrls');
    if (_currentImageIndex >= _sliderImageUrls.length) {
      _currentImageIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bagDisplayName = _getBagDisplayName(widget.item.bagType);
    debugPrint(
      '[_CollectionCardState] build id=${widget.item.id} sliderUrls=$_sliderImageUrls currentIndex=$_currentImageIndex',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 248.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
          child: _buildImageSlider(),
        ),
        if (_sliderImageUrls.length > 1) SizedBox(height: 8.h),
        if (_sliderImageUrls.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_sliderImageUrls.length, (index) {
              final isActive = _currentImageIndex == index;
              return Container(
                width: isActive ? 10.w : 5.w,
                height: 5.h,
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF1F7CD5)
                      : const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              );
            }),
          ),
        SizedBox(height: 8.h),
        Text(
          bagDisplayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppFonts.interSemiBold(
            fontSize: 16.sp,
            color: const Color(0xFF101727),
          ).copyWith(height: 1.43),
        ),
      ],
    );
  }

  String _resolveImageUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final resolved =
        '${AppConstants.baseUrl}${url.startsWith('/') ? '' : '/'}$url';
    debugPrint(
      '[_CollectionCardState] _resolveImageUrl input=$url resolved=$resolved',
    );
    return resolved;
  }

  Widget _buildImageSlider() {
    debugPrint(
      '[_CollectionCardState] _buildImageSlider id=${widget.item.id} urls=$_sliderImageUrls',
    );
    if (_sliderImageUrls.isEmpty) {
      return const Icon(Icons.image_not_supported_outlined);
    }

    if (_sliderImageUrls.length == 1) {
      return _buildNetworkImage(_sliderImageUrls.first, imageIndex: 0);
    }

    return CarouselSlider.builder(
      itemCount: _sliderImageUrls.length,
      itemBuilder: (context, index, realIndex) {
        debugPrint(
          '[_CollectionCardState] Carousel item index=$index url=${_sliderImageUrls[index]}',
        );
        return _buildNetworkImage(_sliderImageUrls[index], imageIndex: index);
      },
      options: CarouselOptions(
        height: 248.h,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          if (!mounted) return;
          debugPrint(
            '[_CollectionCardState] onPageChanged index=$index reason=$reason',
          );
          setState(() {
            _currentImageIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildNetworkImage(String url, {required int imageIndex}) {
    debugPrint(
      '[_CollectionCardState] _buildNetworkImage index=$imageIndex url=$url',
    );
    return GestureDetector(
      onTap: () {
        debugPrint(
          '[_CollectionCardState] image tapped index=$imageIndex url=$url',
        );
        _openZoomGallery(imageIndex);
      },
      child: Image.network(
        url,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
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
          debugPrint(
            '[_CollectionCardState] Image.network error at index=$imageIndex url=$url error=$error',
          );
          return const Icon(Icons.broken_image_outlined);
        },
      ),
    );
  }

  void _openZoomGallery(int initialIndex) {
    if (_sliderImageUrls.isEmpty) {
      debugPrint(
        '[_CollectionCardState] _openZoomGallery called with empty _sliderImageUrls',
      );
      return;
    }

    debugPrint(
      '[_CollectionCardState] _openZoomGallery initialIndex=$initialIndex urls=$_sliderImageUrls',
    );

    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 24.h),
        child: _CollectionZoomGallery(
          imageUrls: _sliderImageUrls,
          initialIndex: initialIndex,
          fallbackUrl: _sliderImageUrls.isNotEmpty
              ? _sliderImageUrls.first
              : '',
        ),
      ),
    );
  }

  String _getBagDisplayName(String bagTypeId) {
    final normalized = bagTypeId.trim().toLowerCase();
    return _bagTypeDisplayNames[normalized] ?? bagTypeId;
  }
}

class _CollectionZoomGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String fallbackUrl;

  const _CollectionZoomGallery({
    required this.imageUrls,
    required this.initialIndex,
    required this.fallbackUrl,
  });

  @override
  State<_CollectionZoomGallery> createState() => _CollectionZoomGalleryState();
}

class _CollectionZoomGalleryState extends State<_CollectionZoomGallery> {
  late final PageController _pageController;
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
    debugPrint(
      '[_CollectionZoomGalleryState] build initialIndex=${widget.initialIndex} imageUrls=${widget.imageUrls}',
    );
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.imageUrls.length,
          onPageChanged: (index) {
            if (!mounted) return;
            debugPrint(
              '[_CollectionZoomGalleryState] onPageChanged index=$index',
            );
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final imageUrl = widget.imageUrls[index];
            debugPrint(
              '[_CollectionZoomGalleryState] page index=$index url=$imageUrl',
            );
            return _DoubleTapZoomableNetworkImage(
              imageUrl: imageUrl,
              fallbackUrl: widget.fallbackUrl,
            );
          },
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ),
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: Text(
              '${_currentIndex + 1}/${widget.imageUrls.length}',
              textAlign: TextAlign.center,
              style: AppFonts.interSemiBold(
                fontSize: 13.sp,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}

class _DoubleTapZoomableNetworkImage extends StatefulWidget {
  final String imageUrl;
  final String fallbackUrl;

  const _DoubleTapZoomableNetworkImage({
    required this.imageUrl,
    required this.fallbackUrl,
  });

  @override
  State<_DoubleTapZoomableNetworkImage> createState() =>
      _DoubleTapZoomableNetworkImageState();
}

class _DoubleTapZoomableNetworkImageState
    extends State<_DoubleTapZoomableNetworkImage> {
  static const double _minScale = 1.0;
  static const double _maxScale = 4.0;
  static const double _doubleTapScale = 2.5;

  final TransformationController _transformationController =
      TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final tapPosition = _doubleTapDetails?.localPosition;
    debugPrint(
      '[_DoubleTapZoomableNetworkImageState] _handleDoubleTap tapPosition=$tapPosition',
    );
    if (tapPosition == null) return;

    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    debugPrint(
      '[_DoubleTapZoomableNetworkImageState] currentScale=$currentScale',
    );
    if (currentScale > _minScale) {
      _transformationController.value = Matrix4.identity();
      return;
    }

    final dx = -tapPosition.dx * (_doubleTapScale - 1);
    final dy = -tapPosition.dy * (_doubleTapScale - 1);
    debugPrint(
      '[_DoubleTapZoomableNetworkImageState] applying translate dx=$dx dy=$dy scale=$_doubleTapScale',
    );
    _transformationController.value = Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(_doubleTapScale, _doubleTapScale, _doubleTapScale, 1);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '[_DoubleTapZoomableNetworkImageState] build imageUrl=${widget.imageUrl} fallbackUrl=${widget.fallbackUrl}',
    );
    return GestureDetector(
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: _minScale,
        maxScale: _maxScale,
        child: Center(
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.contain,
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
              debugPrint(
                '[_DoubleTapZoomableNetworkImageState] Image.network error url=${widget.imageUrl} error=$error',
              );
              if (widget.fallbackUrl.isNotEmpty &&
                  widget.imageUrl != widget.fallbackUrl) {
                debugPrint(
                  '[_DoubleTapZoomableNetworkImageState] attempting fallbackUrl=${widget.fallbackUrl}',
                );
                return Image.network(
                  widget.fallbackUrl,
                  fit: BoxFit.contain,
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
                    debugPrint(
                      '[_DoubleTapZoomableNetworkImageState] fallbackUrl also failed error=$error',
                    );
                    return const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white,
                      size: 64,
                    );
                  },
                );
              }
              return const Icon(
                Icons.broken_image_outlined,
                color: Colors.white,
                size: 64,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final CollectionsController controller;

  const _AppBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 8.h, left: 45.w, right: 26.w, bottom: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          SizedBox(width: 24.w),
        ],
      ),
    );
  }
}

class _EmptyCollectionsView extends StatelessWidget {
  const _EmptyCollectionsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            'No Collections Yet',
            style: AppFonts.poppinsSemiBold(
              fontSize: 20.sp,
              color: const Color(0xFF0F0F0F),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your first bag design to collections',
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
