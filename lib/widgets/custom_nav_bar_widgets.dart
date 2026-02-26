import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'custom_assets.dart';

/// CustomNavBar - Modern bottom navigation bar with icon states
/// Follows OOP principles with encapsulation and composition
class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                iconWithoutHover: CustomAssets.createWithoutHover,
                iconWithHover: CustomAssets.createWithHover,
                label: 'Create',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavBarItem(
                iconWithoutHover: CustomAssets.collectionsWithoutHover,
                iconWithHover: CustomAssets.collectionsWithHover,
                label: 'Collections',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavBarItem(
                iconWithoutHover: CustomAssets.yourDesignWithoutHover,
                iconWithHover: CustomAssets.yourDesignWithHover,
                label: 'Your Design',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavBarItem(
                iconWithoutHover: CustomAssets.profileWithoutHover,
                iconWithHover: CustomAssets.profileWithHover,
                label: 'Profile',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Private widget for individual navigation bar item
class _NavBarItem extends StatelessWidget {
  final String iconWithoutHover;
  final String iconWithHover;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.iconWithoutHover,
    required this.iconWithHover,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 6.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with state
            _NavBarIcon(
              iconWithoutHover: iconWithoutHover,
              iconWithHover: iconWithHover,
              isSelected: isSelected,
            ),
            
            SizedBox(height: 4.h),
            
            // Label with state
            _NavBarLabel(
              label: label,
              isSelected: isSelected,
            ),
          ],
        ),
      ),
    );
  }
}

/// Private widget for navigation bar icon with states
class _NavBarIcon extends StatelessWidget {
  final String iconWithoutHover;
  final String iconWithHover;
  final bool isSelected;

  const _NavBarIcon({
    required this.iconWithoutHover,
    required this.iconWithHover,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: SvgPicture.asset(
        isSelected ? iconWithHover : iconWithoutHover,
        key: ValueKey(isSelected),
        width: 24.w,
        height: 24.h,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Private widget for navigation bar label with states
class _NavBarLabel extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _NavBarLabel({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      style: TextStyle(
        fontSize: isSelected ? 11.sp : 10.sp,
        fontFamily: 'Poppins',
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        color: isSelected ? const Color(0xFF1F7CD5) : const Color(0xFF9DA4AE),
        height: 1.2,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// CustomNavBarController - Manages navigation bar state
/// Follows OOP principles with encapsulation
class CustomNavBarController {
  int _currentIndex = 1; // Default to Collections
  final List<VoidCallback> _listeners = [];

  /// Gets current index
  int get currentIndex => _currentIndex;

  /// Updates current index and notifies listeners
  void updateIndex(int index) {
    if (index >= 0 && index < 4) {
      _currentIndex = index;
      _notifyListeners();
    }
  }

  /// Adds a listener for index changes
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Removes a listener
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Notifies all listeners of state change
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  /// Navigates to Create tab (index 0)
  void navigateToCreate() => updateIndex(0);

  /// Navigates to Collections tab (index 1)
  void navigateToCollections() => updateIndex(1);

  /// Navigates to Your Design tab (index 2)
  void navigateToYourDesign() => updateIndex(2);

  /// Navigates to Profile tab (index 3)
  void navigateToProfile() => updateIndex(3);

  /// Disposes the controller
  void dispose() {
    _listeners.clear();
  }
}

/// NavBarConfig - Configuration for navigation bar items
/// Follows OOP principles with data encapsulation
class NavBarConfig {
  final String iconWithoutHover;
  final String iconWithHover;
  final String label;
  final int index;

  const NavBarConfig({
    required this.iconWithoutHover,
    required this.iconWithHover,
    required this.label,
    required this.index,
  });

  /// Default navigation items configuration
  static List<NavBarConfig> get defaultItems => [
        const NavBarConfig(
          iconWithoutHover: CustomAssets.createWithoutHover,
          iconWithHover: CustomAssets.createWithHover,
          label: 'Create',
          index: 0,
        ),
        const NavBarConfig(
          iconWithoutHover: CustomAssets.collectionsWithoutHover,
          iconWithHover: CustomAssets.collectionsWithHover,
          label: 'Collections',
          index: 1,
        ),
        const NavBarConfig(
          iconWithoutHover: CustomAssets.yourDesignWithoutHover,
          iconWithHover: CustomAssets.yourDesignWithHover,
          label: 'Your Design',
          index: 2,
        ),
        const NavBarConfig(
          iconWithoutHover: CustomAssets.profileWithoutHover,
          iconWithHover: CustomAssets.profileWithHover,
          label: 'Profile',
          index: 3,
        ),
      ];
}

/// CustomNavBarBuilder - Builder widget for advanced nav bar usage
/// Follows OOP principles with builder pattern
class CustomNavBarBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, int currentIndex) builder;
  final int initialIndex;

  const CustomNavBarBuilder({
    super.key,
    required this.builder,
    this.initialIndex = 1, // Default to Collections
  });

  @override
  State<CustomNavBarBuilder> createState() => _CustomNavBarBuilderState();
}

class _CustomNavBarBuilderState extends State<CustomNavBarBuilder> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.builder(context, _currentIndex),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
