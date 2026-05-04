import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../collections_controller/collections_controller.dart';
import '../../services/bag_design_service.dart';
import '../../services/network/network_manager.dart';

/// YourDesignController - Manages state and logic for Your Design screen
/// Follows OOP principles with encapsulation and separation of concerns
class YourDesignController extends GetxController {
  YourDesignController();

  final TextEditingController searchTextController = TextEditingController();

  static const Map<String, String> _bagTypeDisplayNames = {
    'gusset_fullwrap': 'Gusset Full Bag',
    'gusset_label': 'Gusset Label Bag',
    'foil_fullwrap': 'Foil Full Bag',
    'foil_label': 'Foil Label Bag',
    'quad_fullwrap': 'Quad Full Bag',
    'quad_label': 'Quad Label Bag',
  };

  // Observable state variables
  final RxBool _isLoading = false.obs;
  final RxBool _isGridView = true.obs;
  final RxString _searchQuery = ''.obs;
  final RxList<DesignProject> _projects = <DesignProject>[].obs;
  final RxList<DesignProject> _filteredProjects = <DesignProject>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isGridView => _isGridView.value;
  String get searchQuery => _searchQuery.value;
  List<DesignProject> get projects => _filteredProjects;

  @override
  void onInit() {
    super.onInit();
    resetState();
    refresh();
    
    // Auto-retry fetching data when internet comes back online
    if (Get.isRegistered<NetworkManager>()) {
      ever(Get.find<NetworkManager>().isConnected, (bool connected) {
        if (connected) {
          debugPrint('🌐 Internet restored: Auto-refreshing YourDesign data...');
          refresh();
        }
      });
    }
  }

  @override
  void onClose() {
    searchTextController.dispose();
    debugPrint('YourDesignController disposed');
    super.onClose();
  }

  /// Clears all in-memory projects so old account data never leaks to another user.
  void resetState() {
    searchTextController.clear();
    _projects.clear();
    _filteredProjects.clear();
    _searchQuery.value = '';
    _isLoading.value = false;
  }

  void _syncFilteredProjects() {
    final query = _normalizeForSearch(_searchQuery.value);
    if (query.isEmpty) {
      _filteredProjects
        ..clear()
        ..addAll(_projects);
      return;
    }

    _filteredProjects
      ..clear()
      ..addAll(
        _projects.where(
          (project) {
            final rawTitle = _normalizeForSearch(project.title);
            final displayTitle = _normalizeForSearch(
              _resolveBagTypeDisplayName(project.title),
            );
            return rawTitle.contains(query) || displayTitle.contains(query);
          },
        ),
      );
  }

  String _resolveBagTypeDisplayName(String bagTypeId) {
    final normalized = bagTypeId.trim().toLowerCase();
    return _bagTypeDisplayNames[normalized] ?? bagTypeId;
  }

  String _normalizeForSearch(String value) {
    return value
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _resolveDesignImagePath({
    required String logoUrl,
    required String previewUrl,
  }) {
    final logo = logoUrl.trim();
    if (logo.isNotEmpty) return logo;

    final preview = previewUrl.trim();
    if (preview.isNotEmpty) return preview;

    return '';
  }

  /// Toggles between grid and list view
  void toggleView() {
    _isGridView.value = !_isGridView.value;
    debugPrint('View toggled: ${_isGridView.value ? "Grid" : "List"}');
  }

  /// Updates search query and filters projects
  void updateSearchQuery(String query) {
    _searchQuery.value = query;
    _syncFilteredProjects();
    debugPrint('Search query updated: $query, Found ${_filteredProjects.length} projects');
  }

  /// Clears search input and immediately restores full design list.
  void clearSearchQuery() {
    searchTextController.clear();
    _searchQuery.value = '';
    _syncFilteredProjects();
  }

  /// Shows popup menu for a project
  void showProjectOptions(BuildContext context, DesignProject project) {
    debugPrint('Showing options for project: ${project.title}');
    // This will be handled by the UI with PopupMenuButton
  }

  /// Deletes a project
  Future<void> deleteProject(DesignProject project) async {
    debugPrint('Deleting project: ${project.title}');
    _isLoading.value = true;
    
    try {
      final response = await BagDesignService.instance
          .deleteCollectionDesignById(project.id);

      if (!response.success) {
        if (!_isSilentAuthError(response.errorMessage, response.statusCode)) {
          _showErrorToast(response.errorMessage ?? 'Failed to delete project');
        }
        return;
      }
      
      _projects.removeWhere((p) => p.id == project.id);
      _syncFilteredProjects();

      if (Get.isRegistered<CollectionsController>()) {
        Get.find<CollectionsController>().removeCollectionDesignById(project.id);
      }
      
      _showSuccessToast(' deleted successfully');
    } catch (e) {
      _showErrorToast('Failed to delete project');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Opens a project for editing
  void openProject(DesignProject project) {
    debugPrint('Opening project: ${project.title}');
    _showInfoToast(project.title);
  }

  /// Refreshes the projects list
  @override
  Future<void> refresh() async {
    debugPrint('Refreshing projects...');
    _isLoading.value = true;

    try {
      final response = await BagDesignService.instance.getSavedDesigns();

      if (response.success && response.data != null) {
        final loadedProjects = response.data!
            .map(
              (item) => DesignProject(
                id: item.id.toString(),
                title: item.bagType,
                imagePath: _resolveDesignImagePath(
                  logoUrl: item.logoUrl,
                  previewUrl: item.previewUrl,
                ),
                isPrivate: true,
                category: 'AI Generated',
                lastModified: DateTime.tryParse(item.createdAt),
              ),
            )
            .toList();

        _projects
          ..clear()
          ..addAll(loadedProjects);
        _syncFilteredProjects();
      } else {
        resetState();
        if (!_isSilentAuthError(response.errorMessage, response.statusCode)) {
          _showErrorToast(response.errorMessage ?? 'Failed to load your designs');
        }
      }
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// Adds a saved image from upload to projects
  void addSavedImage(String imagePath) {
    debugPrint('Adding saved image to projects: $imagePath');
    
    // Create a new project from the uploaded image
    final newProject = DesignProject(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Uploaded Design ${_projects.length + 1}',
      imagePath: imagePath,
      isPrivate: true,
      category: null,
      lastModified: DateTime.now(),
    );
    
    // Add to the beginning of the list
    _projects.insert(0, newProject);
    _syncFilteredProjects();
    
    // Success message will be shown in UI layer with custom snackbar
  }

  /// Saves the generated design to collection using API
  Future<bool> saveDesignToCollection(String previewId) async {
    debugPrint('🔄 YourDesignController: saveDesignToCollection called with previewId: $previewId');
    _isLoading.value = true;
    try {
      final response = await BagDesignService.instance.saveDesignToCollection(previewId);
      
      if (response.success && response.data != null) {
        final data = response.data!;
        debugPrint('✅ Design saved successfully: ${data.bagType}');
        
        // Add to projects list
        final newProject = DesignProject(
          id: data.id.toString(),
          title: data.bagType,
          imagePath: _resolveDesignImagePath(
            logoUrl: data.logoUrl,
            previewUrl: data.previewUrl,
          ),
          isPrivate: true,
          category: 'AI Generated',
          lastModified: DateTime.tryParse(data.createdAt),
        );

        _projects.removeWhere((item) => item.id == newProject.id);
        _projects.insert(0, newProject);
        _syncFilteredProjects();
        debugPrint('✅ Project added to list. Total projects: ${_projects.length}');
        
        _showSuccessToast('Design saved to your collection');
        return true;
      } else {
        debugPrint('❌ Failed to save design: ${response.errorMessage}');
        if (!_isSilentAuthError(response.errorMessage, response.statusCode)) {
          _showErrorToast(response.errorMessage ?? 'Failed to save design');
        }
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error in saveDesignToCollection: $e');
      _showErrorToast('An error occurred: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF009966),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFF44336),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void _showInfoToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF2196F3),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  bool _isSilentAuthError(String? message, int? statusCode) {
    if (statusCode == 401 || statusCode == 403) return true;
    final text = (message ?? '').toLowerCase();
    return text.contains('authentication required') ||
        text.contains('authentication failed') ||
        text.contains('please login') ||
        text.contains('please log in') ||
        text.contains('unauthorized');
  }
}

/// DesignProject model class
/// Encapsulates project data following OOP principles
class DesignProject {
  final String id;
  final String title;
  final String imagePath;
  final bool isPrivate;
  final String? category;
  final DateTime? lastModified;

  DesignProject({
    required this.id,
    required this.title,
    required this.imagePath,
    this.isPrivate = true,
    this.category,
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  /// Creates a copy of the project with updated fields
  DesignProject copyWith({
    String? id,
    String? title,
    String? imagePath,
    bool? isPrivate,
    String? category,
    DateTime? lastModified,
  }) {
    return DesignProject(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      isPrivate: isPrivate ?? this.isPrivate,
      category: category ?? this.category,
      lastModified: lastModified ?? this.lastModified,
    );
  }
}