import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../models/user_profile_model.dart';
import '../utils/app_constants.dart';
import 'token_storage_service.dart';

/// UserSessionService - Single source of truth for the logged-in user's data
///
/// Real-life pattern (Instagram, Twitter, etc.):
///   All screens read from ONE reactive store.
///   When profile is updated → update the store → ALL widgets rebuild instantly.
///
/// Any controller that needs user data reads:
///   UserSessionService.instance.name
///   UserSessionService.instance.email
///   UserSessionService.instance.imageUrl
///
/// Follows 100% OOP: singleton, encapsulation, observer pattern via GetX Rx
class UserSessionService {
  // ─── Singleton ────────────────────────────────────────────────────────────
  UserSessionService._();
  static final UserSessionService _instance = UserSessionService._();
  static UserSessionService get instance => _instance;

  // ─── Reactive State — single source of truth ──────────────────────────────
  final RxInt id = 0.obs;
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString imageUrl = ''.obs;   // full URL
  final RxBool isAdmin = false.obs;
  final RxBool isLoaded = false.obs;  // true once data is fetched at least once

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Loads from SharedPreferences cache (instant, called on app start)
  Future<void> loadFromCache() async {
    final storage = TokenStorageService.instance;
    final cachedId    = await storage.getUserId();
    final cachedName  = await storage.getUserName();
    final cachedEmail = await storage.getUserEmail();
    final cachedImage = await storage.getUserImage();

    if (cachedId    != null) id.value    = cachedId;
    if (cachedName  != null && cachedName.isNotEmpty)  name.value  = cachedName;
    if (cachedEmail != null && cachedEmail.isNotEmpty) email.value = cachedEmail;
    if (cachedImage != null && cachedImage.isNotEmpty) {
      imageUrl.value = _buildFullUrl(cachedImage);
    }
    debugPrint('📦 UserSession: loaded from cache — ${name.value}');
  }

  /// Updates session from a freshly fetched/updated UserProfileModel
  /// Call after GET /profile or PATCH /profile success
  Future<void> updateFromProfile(UserProfileModel profile) async {
    id.value       = profile.id;
    name.value     = profile.name;
    email.value    = profile.email;
    imageUrl.value = profile.fullImageUrl(AppConstants.baseUrl);
    isAdmin.value  = profile.isAdmin;
    isLoaded.value = true;

    // Persist to cache so next launch is instant
    await TokenStorageService.instance.saveUserInfo(
      id: profile.id,
      email: profile.email,
      name: profile.name,
      image: profile.image,
    );

    debugPrint('✅ UserSession: updated — ${profile.name} | ${profile.email}');
  }

  /// Clears all session data (called on logout)
  void clear() {
    id.value       = 0;
    name.value     = '';
    email.value    = '';
    imageUrl.value = '';
    isAdmin.value  = false;
    isLoaded.value = false;
    debugPrint('🔓 UserSession: cleared');
  }

  // ─── Private ──────────────────────────────────────────────────────────────

  String _buildFullUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${AppConstants.baseUrl}$path';
  }
}
