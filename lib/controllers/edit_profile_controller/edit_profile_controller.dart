import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../models/api_response_model.dart';
import '../../models/user_profile_model.dart';
import '../../models/update_profile_request_model.dart';
import '../../services/auth_service.dart';
import '../../services/network/network_manager.dart';
import '../../services/token_storage_service.dart';
import '../../services/user_session_service.dart';
import '../../utils/app_constants.dart';


/// EditProfileController - Manages edit profile screen state and business logic
/// Loads real user profile from API using Bearer token
/// Follows 100% OOP: encapsulation, single responsibility, composition
class EditProfileController extends GetxController {
  // ─── Dependencies (Composition) ───────────────────────────────────────────
  final AuthService _authService = AuthService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  /// Single source of truth — same instance as ProfileController reads from
  final UserSessionService _session = UserSessionService.instance;
  final ImagePicker _imagePicker = ImagePicker();

  // ─── Form Controllers ─────────────────────────────────────────────────────
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // ─── Observable State ─────────────────────────────────────────────────────
  /// Local file path — set when user picks a new photo from gallery/camera
  final RxString profileImagePath = ''.obs;

  /// Full network URL — loaded from API (e.g. http://host/media/profile_images/x.png)
  final RxString networkImageUrl = ''.obs;

  final RxString selectedLanguage = 'English'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  final List<String> languages = ['English', 'Bangla'];

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadCachedThenFetch();
    
    if (Get.isRegistered<NetworkManager>()) {
      ever(Get.find<NetworkManager>().isConnected, (bool connected) {
        if (connected) {
          debugPrint('🌐 Internet restored: Auto-refreshing profile data...');
          _fetchFromApi();
        }
      });
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // ─── Private Methods ──────────────────────────────────────────────────────

  /// Step 1: Instantly fill fields from SharedPreferences cache (no flash)
  /// Step 2: Re-fetch from API to get latest data
  Future<void> _loadCachedThenFetch() async {
    await _loadFromCache();
    await _fetchFromApi();
  }

  /// Loads cached user data — uses live session if available, else SharedPreferences
  Future<void> _loadFromCache() async {
    // If session already has data (user was on profile screen before), use it instantly
    if (_session.isLoaded.value) {
      nameController.text  = _session.name.value;
      emailController.text = _session.email.value;
      networkImageUrl.value = _session.imageUrl.value;
      debugPrint('👤 EditProfile: loaded from live session');
      return;
    }

    // Fallback: read SharedPreferences cache
    final name  = await _tokenStorage.getUserName();
    final email = await _tokenStorage.getUserEmail();
    final image = await _tokenStorage.getUserImage();

    if (name  != null && name.isNotEmpty)  nameController.text  = name;
    if (email != null && email.isNotEmpty) emailController.text = email;
    if (image != null && image.isNotEmpty) networkImageUrl.value = _buildImageUrl(image);
    debugPrint('👤 EditProfile: loaded from cache');
  }

  /// Fetches latest profile from GET /accounts/user/profile/ with Bearer token
  Future<void> _fetchFromApi() async {
    isLoading.value = true;
    try {
      final String? accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) return;

      final ApiResponse<UserProfileModel> response =
          await _authService.getProfile(accessToken: accessToken);

      if (response.success && response.data != null) {
        final UserProfileModel profile = response.data!;

        // Update session (single source of truth) — also persists to cache
        await _session.updateFromProfile(profile);

        // Sync local form fields
        nameController.text   = profile.name;
        emailController.text  = profile.email;
        networkImageUrl.value = profile.fullImageUrl(AppConstants.baseUrl);

        debugPrint('✅ EditProfile: API data loaded for ${profile.name}');
      }
    } catch (e) {
      debugPrint('❌ EditProfile fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Converts relative image path to full URL
  String _buildImageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${AppConstants.baseUrl}$path';
  }

  // ─── Photo Selection ──────────────────────────────────────────────────────

  /// Shows bottom sheet with photo options
  void showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () { Navigator.of(ctx).pop(); _pickImage(ImageSource.gallery, context); },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () { Navigator.of(ctx).pop(); _pickImage(ImageSource.camera, context); },
            ),
            if (profileImagePath.value.isNotEmpty || networkImageUrl.value.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () { Navigator.of(ctx).pop(); _removePhoto(); },
              ),
          ],
        ),
      ),
    );
  }

  /// Picks image from gallery or camera
  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        profileImagePath.value = image.path;
        debugPrint('📷 Photo selected: ${image.path}');
      }
    } catch (e) {
      debugPrint('❌ Photo pick error: $e');
      _showError('Failed to select photo');
    }
  }

  /// Removes selected photo — falls back to network image or placeholder
  void _removePhoto() {
    profileImagePath.value = '';
    debugPrint('🗑 Photo removed');
  }

  // ─── Language ─────────────────────────────────────────────────────────────

  void changeLanguage(String? language) {
    if (language != null && languages.contains(language)) {
      selectedLanguage.value = language;
    }
  }

  // ─── Save Profile ─────────────────────────────────────────────────────────

  /// Calls PATCH /accounts/user/profile/ with Bearer token
  /// - With new image  → multipart/form-data (name + email + image file)
  /// - Without image   → JSON PATCH          (name + email only)
  ///
  /// On success → updates UserSessionService (single source of truth)
  /// → ProfileCard, NavBar, and every widget reading session observables
  ///   rebuild instantly across the whole app
  Future<void> saveProfile(BuildContext context) async {
    final name  = nameController.text.trim();
    final email = emailController.text.trim();

    // ── Validate ──────────────────────────────────────────────────────────
    if (name.isEmpty)              { _showError('Name is required');              return; }
    if (email.isEmpty)             { _showError('Email is required');             return; }
    if (!GetUtils.isEmail(email))  { _showError('Please enter a valid email');    return; }

    isSaving.value = true;
    try {
      final String? accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        _showError('Session expired. Please log in again.');
        return;
      }

      // ── Build request ──────────────────────────────────────────────────
      final UpdateProfileRequestModel request =
          UpdateProfileRequestModel(name: name, email: email);

      final File? imageFile = profileImagePath.value.isNotEmpty
          ? File(profileImagePath.value)
          : null;

      debugPrint('📤 Saving profile — name: $name, email: $email, hasImage: ${imageFile != null}');

      // ── Call API ───────────────────────────────────────────────────────
      final ApiResponse<UserProfileModel> response =
          await _authService.updateProfile(
        accessToken: accessToken,
        request: request,
        imageFile: imageFile,
      );

      if (response.success && response.data != null) {
        final UserProfileModel updated = response.data!;

        // ── Update UserSessionService ──────────────────────────────────
        // This is the ONLY thing needed — every Obx reading session.*
        // observables (ProfileCard, NavBar, etc.) rebuilds automatically
        await _session.updateFromProfile(updated);

        // ── Sync this controller's local observables ───────────────────
        networkImageUrl.value  = updated.fullImageUrl(AppConstants.baseUrl);
        profileImagePath.value = ''; // clear local file — network image is now active

        debugPrint('✅ Profile saved & session updated: ${updated.name}');
        _showSuccess('Profile updated successfully');
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) context.pop();
      } else {
        _showError(response.errorMessage ?? 'Failed to update profile. Please try again.');
      }
    } catch (e) {
      debugPrint('❌ Save profile error: $e');
      _showError('Failed to update profile. Please try again.');
    } finally {
      isSaving.value = false;
    }
  }

  // ─── Social Accounts ──────────────────────────────────────────────────────

  void disconnectSocialAccount(BuildContext context, String provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Disconnect $provider?'),
        content: Text('Are you sure you want to disconnect your $provider account?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () { Navigator.of(ctx).pop(); _showError('$provider disconnect coming soon'); },
            child: const Text('Disconnect', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ─── Toast Helpers ────────────────────────────────────────────────────────

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFF44336),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }

  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }
}