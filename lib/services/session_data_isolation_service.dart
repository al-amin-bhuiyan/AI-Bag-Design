import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../controllers/collections_controller/collections_controller.dart';
import '../controllers/your_design_controller/your_design_controller.dart';
import 'user_session_service.dart';

/// Clears user-scoped in-memory state when account changes.
class SessionDataIsolationService {
  SessionDataIsolationService._();
  static final SessionDataIsolationService _instance =
      SessionDataIsolationService._();

  static SessionDataIsolationService get instance => _instance;

  void clearUserScopedState() {
    UserSessionService.instance.clear();

    if (Get.isRegistered<YourDesignController>()) {
      Get.find<YourDesignController>().resetState();
      Get.delete<YourDesignController>(force: true);
    }

    if (Get.isRegistered<CollectionsController>()) {
      Get.find<CollectionsController>().resetState();
      Get.delete<CollectionsController>(force: true);
    }

    debugPrint('🧹 Cleared user-scoped runtime state');
  }
}
