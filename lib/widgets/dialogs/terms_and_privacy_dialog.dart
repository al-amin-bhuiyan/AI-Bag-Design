import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_fonts.dart';

/// TermsAndPrivacyDialog - Popup dialog for displaying terms and privacy policy
/// Follows OOP principles with clean composition
class TermsAndPrivacyDialog extends StatelessWidget {
  const TermsAndPrivacyDialog({super.key});

  /// Shows the dialog as a popup
  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const Material(
          type: MaterialType.transparency,
          child: TermsAndPrivacyDialog(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 360.w,
        height: 600.h, // Constrained height for a nice popup size
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            _Header(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: const _Content(),
              ),
            ),
            
            // Footer Actions
            _Footer(),
          ],
        ),
      ),
    );
  }
}

/// Private widget for dialog header
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24.h, left: 24.w, right: 20.w, bottom: 16.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Terms & Privacy',
              style: AppFonts.poppinsSemiBold(
                fontSize: 20.sp,
                color: const Color(0xFF0F0F0F),
              ).copyWith(height: 1.3),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 20.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Private widget for dialog textual content
class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          title: '1. Acceptance of Terms',
          body: 'By accessing or using this application, you agree to comply with and be bound by these Terms & Conditions.\nIf you do not agree, please do not use the app.',
        ),
        _Section(
          title: '2. User Responsibilities',
          body: 'By using this app, you agree to:\n• Provide accurate account information\n• Upload only content you own or have rights to use\n• Ensure your designs do not violate copyright, trademark, or legal regulations.',
        ),
        _Section(
          title: '3. Privacy Policy',
          body: 'We respect your privacy. All logos, images, and design elements uploaded by users remain the property of their respective owners. We will not share your personal data with third parties without your consent, except as required by law.',
        ),
        _Section(
          title: '4. Orders & Downloads',
          body: 'Once a design is finalized or exported, it is your responsibility to review all details carefully. We are not liable for printing errors or dissatisfaction resulting from files submitted by users.',
        ),
        _Section(
          title: '5. Updates to Terms',
          body: 'We may update these Terms & Privacy Conditions at any time. Continued use of the app after updates indicates your acceptance of the revised conditions.',
        ),
      ],
    );
  }
}

/// Private widget for a single text section
class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.poppinsSemiBold(
              fontSize: 16.sp,
              color: const Color(0xFF1F7CD5),
            ).copyWith(height: 1.3),
          ),
          SizedBox(height: 8.h),
          Text(
            body,
            style: AppFonts.poppinsRegular(
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
            ).copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

/// Private widget for the footer actions
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F7CD5),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'Understood & Close',
            style: AppFonts.poppinsMedium(
              fontSize: 15.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}