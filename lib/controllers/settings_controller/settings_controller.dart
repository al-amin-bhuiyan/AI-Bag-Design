import 'package:get/get.dart';

/// SettingsController - Manages settings screen state and business logic
/// Follows OOP principles with encapsulation and state management
class SettingsController extends GetxController {
  // Private reactive state variables
  final RxBool _notificationsEnabled = true.obs;
  final RxBool _autoApplyMockup = true.obs;
  final RxBool _highQualityExport = true.obs;

  // Public getters for reactive state
  RxBool get notificationsEnabled => _notificationsEnabled;
  RxBool get autoApplyMockup => _autoApplyMockup;
  RxBool get highQualityExport => _highQualityExport;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// Load settings from storage/preferences
  void _loadSettings() {
    // TODO: Load from SharedPreferences or database
    // For now, using default values
  }

  /// Toggle notifications setting
  void toggleNotifications(bool value) {
    _notificationsEnabled.value = value;
    _saveSettings();
  }

  /// Toggle auto apply mockup setting
  void toggleAutoApplyMockup(bool value) {
    _autoApplyMockup.value = value;
    _saveSettings();
  }

  /// Toggle high quality export setting
  void toggleHighQualityExport(bool value) {
    _highQualityExport.value = value;
    _saveSettings();
  }

  /// Save settings to storage/preferences
  void _saveSettings() {
    // TODO: Save to SharedPreferences or database
    print('Settings saved:');
    print('  Notifications: ${_notificationsEnabled.value}');
    print('  Auto Apply Mockup: ${_autoApplyMockup.value}');
    print('  High Quality Export: ${_highQualityExport.value}');
  }

  @override
  void onClose() {
    _saveSettings();
    super.onClose();
  }
}
