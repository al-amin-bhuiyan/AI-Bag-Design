import 'package:flutter/material.dart';

/// Custom Page Transition Builder
/// Provides smooth transitions without white flick
class NoTransitionPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    // Return child directly without any animation
    // This eliminates the white flick during navigation
    return child;
  }
}

/// Fade Transition Page Transitions Builder
/// Provides smooth fade transition without white flick
class FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    // Use fade transition for smooth navigation
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
