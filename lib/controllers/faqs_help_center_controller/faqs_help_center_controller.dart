import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// FAQsHelpCenterController manages FAQs screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class FAQsHelpCenterController extends GetxController {
  // ============ OBSERVABLE PROPERTIES ============
  
  /// List of expanded FAQ indices
  final RxList<int> _expandedIndices = <int>[].obs;
  
  /// Loading state
  final RxBool _isLoading = false.obs;
  
  // ============ GETTERS ============
  
  List<int> get expandedIndices => _expandedIndices;
  bool get isLoading => _isLoading.value;
  
  /// Checks if a specific FAQ is expanded
  bool isExpanded(int index) => _expandedIndices.contains(index);
  
  // ============ LIFECYCLE METHODS ============
  
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }
  
  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }
  
  // ============ INITIALIZATION ============
  
  /// Initializes the controller
  void _initialize() {
    // Load FAQs data if needed
    _loadFAQs();
  }
  
  /// Loads FAQ data
  Future<void> _loadFAQs() async {
    _setLoading(true);
    try {
      // TODO: Load FAQs from API or local storage
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      _handleError('Failed to load FAQs: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // ============ PUBLIC METHODS ============
  
  /// Toggles FAQ expansion state
  void toggleFAQ(int index) {
    if (_expandedIndices.contains(index)) {
      _expandedIndices.remove(index);
      print('🔵 Collapsed FAQ at index: $index');
    } else {
      _expandedIndices.add(index);
      print('🔵 Expanded FAQ at index: $index');
    }
  }
  
  /// Expands all FAQs
  void expandAll() {
    _expandedIndices.clear();
    for (int i = 0; i < _getFAQsData().length; i++) {
      _expandedIndices.add(i);
    }
    print('✅ Expanded all FAQs');
  }
  
  /// Collapses all FAQs
  void collapseAll() {
    _expandedIndices.clear();
    print('✅ Collapsed all FAQs');
  }
  
  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    if (context.mounted) {
      context.pop();
      print('🔵 Navigated back from FAQs');
    }
  }
  
  // ============ PRIVATE METHODS ============
  
  /// Sets loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }
  
  /// Handles errors
  void _handleError(String message) {
    print('❌ Error: $message');
    _showMessage(message);
  }
  
  /// Cleanup resources
  void _cleanup() {
    _expandedIndices.clear();
  }
  
  // ============ UTILITY METHODS ============
  
  /// Shows a message to the user
  void _showMessage(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
  
  /// Refreshes FAQ data
  Future<void> refresh() async {
    await _loadFAQs();
  }
  
  // ============ DATA METHODS ============
  
  /// Returns FAQ data list
  List<FAQItem> _getFAQsData() {
    return [
      FAQItem(
        question: 'How to upload a design?',
        answer: 'PropShare is a space to explore shared and private living options in Dublin at your own pace. '
            'It\'s designed to help you look through rooms, apartments, and potential housemates, and notice what feels right for you—without pressure or obligation.\n\n'
            'There\'s no rush to decide and no forced conversations. You can browse, save, and return anytime, continuing from where you left off, as you figure out the living situation that suits you best.',
      ),
      FAQItem(
        question: 'What file format is supported?',
        answer: 'The experience guides you through simple steps to explore listings and people based on your needs.\n\n'
            'You can view details, read profiles, and express interest when something feels relevant—using your own judgment and timing.\n\n'
            'For shared living, conversations begin only after both sides are comfortable moving forward.\n\n'
            'For apartments, you can reach out directly to ask questions or clarify details.\n\n'
            'You\'re free to pause, step away, and return later—everything stays where you left it, without evaluation or pressure.',
      ),
      FAQItem(
        question: 'Print size requirements',
        answer: 'For printed listings and documents, please ensure the text is clear and legible. '
            'The required print size is at least 10pt for the body text to ensure readability.\n\n'
            'Larger text sizes may be preferred for titles or headings, but consistency in style is key. '
            'Always double-check print dimensions to fit the content properly on the page.',
      ),
      FAQItem(
        question: 'Safe area & bleed guidelines',
        answer: 'When designing content for shared living or apartment listings, make sure the text and key images are within a safe area.\n\n'
            'Avoid placing important details too close to the edge of the document to prevent cropping.\n\n'
            'For bleed, extend the background colors or images slightly beyond the document edge (usually by 3mm or so) to ensure the design is printed edge-to-edge without a white border.',
      ),
      FAQItem(
        question: 'How to place an order?',
        answer: 'To place an order, simply follow the guided steps in the app or website.\n\n'
            'First, select the listing you\'re interested in, then choose whether you want to contact the housemate directly or save the listing for future reference.\n\n'
            'When you\'re ready, proceed with any necessary steps based on your selected service.\n\n'
            'You can always pause and come back later without commitment, so feel free to explore at your own pace.',
      ),
    ];
  }
  
  /// Public getter for FAQ data
  List<FAQItem> get faqItems => _getFAQsData();
}

/// FAQ Item Model - Encapsulates FAQ data structure
/// Follows OOP principles with data encapsulation
class FAQItem {
  final String question;
  final String answer;
  
  const FAQItem({
    required this.question,
    required this.answer,
  });
  
  /// Factory constructor from JSON
  factory FAQItem.fromJson(Map<String, dynamic> json) {
    return FAQItem(
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }
  
  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
  
  /// Creates a copy with modified fields
  FAQItem copyWith({
    String? question,
    String? answer,
  }) {
    return FAQItem(
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }
}
