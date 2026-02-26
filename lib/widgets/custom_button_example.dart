import 'package:flutter/material.dart';

import 'custom_button.dart';

/// CustomButtonExample - Demonstrates usage of CustomButton widget
/// This file shows various ways to use the button following OOP principles
class CustomButtonExample extends StatelessWidget {
  const CustomButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Button Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Primary button (matches your design)
            _ExampleSection(
              title: '1. Primary Button (Your Design)',
              child: CustomButton.primary(
                label: 'Next',
                onPressed: () {
                  debugPrint('Primary button pressed');
                },
              ),
            ),

            // Example 2: Primary button with loading state
            _ExampleSection(
              title: '2. Primary Button with Loading',
              child: CustomButton.primary(
                label: 'Loading...',
                isLoading: true,
                onPressed: () {},
              ),
            ),

            // Example 3: Primary button with custom width
            _ExampleSection(
              title: '3. Primary Button - Full Width',
              child: CustomButton.primary(
                label: 'Continue',
                width: double.infinity,
                onPressed: () {
                  debugPrint('Continue pressed');
                },
              ),
            ),

            // Example 4: Disabled button
            _ExampleSection(
              title: '4. Disabled Button',
              child: CustomButton.primary(
                label: 'Disabled',
                isDisabled: true,
                onPressed: () {},
              ),
            ),

            // Example 5: Button with prefix icon
            _ExampleSection(
              title: '5. Button with Prefix Icon',
              child: CustomButton.primary(
                label: 'Next',
                prefixIcon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),

            // Example 6: Button with suffix icon
            _ExampleSection(
              title: '6. Button with Suffix Icon',
              child: CustomButton.primary(
                label: 'Next',
                suffixIcon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),

            // Example 7: Secondary button
            _ExampleSection(
              title: '7. Secondary Button',
              child: CustomButton.secondary(
                label: 'Cancel',
                onPressed: () {},
              ),
            ),

            // Example 8: Outlined button
            _ExampleSection(
              title: '8. Outlined Button',
              child: CustomButton.outlined(
                label: 'Skip',
                onPressed: () {},
              ),
            ),

            // Example 9: Custom button with all options
            _ExampleSection(
              title: '9. Fully Customized Button',
              child: CustomButton(
                label: 'Custom',
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                borderRadius: 20,
                width: 250,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Private widget for example sections
/// Encapsulates section layout and styling
class _ExampleSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _ExampleSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 24),
      ],
    );
  }
}
