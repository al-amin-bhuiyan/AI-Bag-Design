import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

/// EditProfileController - Manages edit profile screen state and business logic
/// Follows OOP principles with single responsibility and separation of concerns
class EditProfileController extends GetxController {
  // ============ Form Controllers ============
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  // ============ Observables ============
  
  final RxString profileImagePath = ''.obs;
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString selectedLanguage = 'English'.obs;
  final RxBool isEditingName = false.obs;
  final RxBool isEditingEmail = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  
  // Language options
  final List<String> languages = ['English', 'Bangla'];
  
  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();
  
  // ============ Lifecycle Methods ============
  
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
  
  // ============ Private Methods ============
  
  /// Loads user data from storage or API
  void _loadUserData() {
    // TODO: Load from actual data source
    userName.value = 'Mohammad Shobuj';
    userEmail.value = 'example@gmail.com';
    selectedLanguage.value = 'English';
    
    nameController.text = userName.value;
    emailController.text = userEmail.value;
  }
  
  /// Sets loading state
  void _setLoading(bool value) {
    isLoading.value = value;
  }
  
  /// Sets saving state
  void _setSaving(bool value) {
    isSaving.value = value;
  }
  
  /// Shows error message
  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// Shows success message
  void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.withValues(alpha: 0.9),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  // ============ Public Methods ============
  
  /// Handles profile photo selection
  Future<void> selectProfilePhoto(BuildContext context) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        profileImagePath.value = image.path;
        print('✅ Profile photo selected: ${image.path}');
      }
    } catch (e) {
      print('❌ Error selecting photo: $e');
      if (context.mounted) {
        showError(context, 'Failed to select photo');
      }
    }
  }
  
  /// Opens camera to take profile photo
  Future<void> takeProfilePhoto(BuildContext context) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        profileImagePath.value = image.path;
        print('✅ Profile photo captured: ${image.path}');
      }
    } catch (e) {
      print('❌ Error taking photo: $e');
      if (context.mounted) {
        showError(context, 'Failed to take photo');
      }
    }
  }
  
  /// Shows photo selection options
  void showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(bottomSheetContext).pop();
                selectProfilePhoto(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.of(bottomSheetContext).pop();
                takeProfilePhoto(context);
              },
            ),
            if (profileImagePath.value.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.of(bottomSheetContext).pop();
                  removeProfilePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }
  
  /// Removes profile photo
  void removeProfilePhoto() {
    profileImagePath.value = '';
    print('✅ Profile photo removed');
  }
  
  /// Enables name editing mode
  void startEditingName() {
    isEditingName.value = true;
    nameController.text = userName.value;
  }
  
  /// Cancels name editing
  void cancelNameEdit() {
    isEditingName.value = false;
    nameController.text = userName.value;
  }
  
  /// Saves name changes
  void saveNameEdit(BuildContext context) {
    if (nameController.text.trim().isEmpty) {
      showError(context, 'Name cannot be empty');
      return;
    }
    
    userName.value = nameController.text.trim();
    isEditingName.value = false;
    print('✅ Name saved: ${userName.value}');
  }
  
  /// Enables email editing mode
  void startEditingEmail() {
    isEditingEmail.value = true;
    emailController.text = userEmail.value;
  }
  
  /// Cancels email editing
  void cancelEmailEdit() {
    isEditingEmail.value = false;
    emailController.text = userEmail.value;
  }
  
  /// Saves email changes
  void saveEmailEdit(BuildContext context) {
    if (emailController.text.trim().isEmpty) {
      showError(context, 'Email cannot be empty');
      return;
    }
    
    if (!GetUtils.isEmail(emailController.text.trim())) {
      showError(context, 'Please enter a valid email address');
      return;
    }
    
    userEmail.value = emailController.text.trim();
    isEditingEmail.value = false;
    print('✅ Email saved: ${userEmail.value}');
  }
  
  /// Changes selected language
  void changeLanguage(String? language) {
    if (language != null && languages.contains(language)) {
      selectedLanguage.value = language;
      print('✅ Language changed to: $language');
    }
  }
  
  /// Saves all profile changes
  Future<void> saveProfile(BuildContext context) async {
    _setSaving(true);
    
    try {
      // TODO: Implement API call to save profile
      await Future.delayed(const Duration(seconds: 2));
      
      if (context.mounted) {
        showSuccess(context, 'Profile updated successfully');
        print('✅ Profile saved successfully');
        
        // Navigate back using GoRouter
        context.pop();
      }
      
    } catch (e) {
      print('❌ Error saving profile: $e');
      if (context.mounted) {
        showError(context, 'Failed to save profile');
      }
    } finally {
      _setSaving(false);
    }
  }
  
  /// Disconnects social account
  void disconnectSocialAccount(BuildContext context, String provider) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Disconnect $provider?'),
        content: Text('Are you sure you want to disconnect your $provider account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _performDisconnect(context, provider);
            },
            child: const Text('Disconnect', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  /// Performs social account disconnect
  Future<void> _performDisconnect(BuildContext context, String provider) async {
    try {
      // TODO: Implement actual disconnect logic
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) {
        showSuccess(context, '$provider account disconnected');
      }
      print('✅ Disconnected from $provider');
    } catch (e) {
      print('❌ Error disconnecting: $e');
      if (context.mounted) {
        showError(context, 'Failed to disconnect account');
      }
    }
  }
  
  /// Validates all fields before saving
  bool validateFields(BuildContext context) {
    if (userName.value.trim().isEmpty) {
      showError(context, 'Name is required');
      return false;
    }
    
    if (userEmail.value.trim().isEmpty) {
      showError(context, 'Email is required');
      return false;
    }
    
    if (!GetUtils.isEmail(userEmail.value.trim())) {
      showError(context, 'Please enter a valid email');
      return false;
    }
    
    return true;
  }
}
