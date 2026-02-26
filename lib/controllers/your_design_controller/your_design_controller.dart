import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// YourDesignController - Manages state and logic for Your Design screen
/// Follows OOP principles with encapsulation and separation of concerns
class YourDesignController extends GetxController {
  // Private constructor to enforce singleton pattern
  YourDesignController._();
  
  // Singleton instance
  static final YourDesignController _instance = YourDesignController._();
  
  // Factory constructor returns singleton instance
  factory YourDesignController() => _instance;

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
    _initializeProjects();
  }

  @override
  void onClose() {
    debugPrint('YourDesignController disposed');
    super.onClose();
  }

  /// Initializes sample projects with the 6 generic images
  void _initializeProjects() {
    _projects.value = [
      DesignProject(
        id: '1',
        title: 'Untitled Design',
        imagePath: 'assets/images/image_first.png',
        isPrivate: true,
        category: 'Whiteboard',
      ),
      DesignProject(
        id: '2',
        title: 'Coffee Bag Design',
        imagePath: 'assets/images/image_second.png',
        isPrivate: true,
      ),
      DesignProject(
        id: '3',
        title: 'AI Coffee Bag Design',
        imagePath: 'assets/images/image_third.png',
        isPrivate: true,
      ),
      DesignProject(
        id: '4',
        title: 'Coffee Bag Design',
        imagePath: 'assets/images/image_fourth.png',
        isPrivate: true,
      ),
      DesignProject(
        id: '5',
        title: 'AI Coffee Bag Design',
        imagePath: 'assets/images/image_fiveth.png',
        isPrivate: true,
      ),
      DesignProject(
        id: '6',
        title: 'Coffee Bag Design',
        imagePath: 'assets/images/image_six.png',
        isPrivate: true,
      ),
    ];
    _filteredProjects.value = _projects;
  }

  /// Toggles between grid and list view
  void toggleView() {
    _isGridView.value = !_isGridView.value;
    debugPrint('View toggled: ${_isGridView.value ? "Grid" : "List"}');
  }

  /// Updates search query and filters projects
  void updateSearchQuery(String query) {
    _searchQuery.value = query;
    if (query.isEmpty) {
      _filteredProjects.value = _projects;
    } else {
      _filteredProjects.value = _projects
          .where((project) =>
              project.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    debugPrint('Search query updated: $query, Found ${_filteredProjects.length} projects');
  }

  /// Shows popup menu for a project (Download/Delete)
  void showProjectOptions(BuildContext context, DesignProject project) {
    debugPrint('Showing options for project: ${project.title}');
    // This will be handled by the UI with PopupMenuButton
  }

  /// Downloads a project
  Future<void> downloadProject(DesignProject project) async {
    debugPrint('Downloading project: ${project.title}');
    _isLoading.value = true;
    
    try {
      // Simulate download delay
      await Future.delayed(const Duration(seconds: 2));
      
      Get.snackbar(
        'Success',
        'Project "${project.title}" downloaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF009966),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download project',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Deletes a project
  Future<void> deleteProject(DesignProject project) async {
    debugPrint('Deleting project: ${project.title}');
    _isLoading.value = true;
    
    try {
      // Simulate delete delay
      await Future.delayed(const Duration(seconds: 1));
      
      _projects.removeWhere((p) => p.id == project.id);
      _filteredProjects.removeWhere((p) => p.id == project.id);
      
      Get.snackbar(
        'Success',
        'Project "${project.title}" deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF009966),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete project',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Opens a project for editing
  void openProject(DesignProject project) {
    debugPrint('Opening project: ${project.title}');
    Get.snackbar(
      'Opening Project',
      project.title,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Refreshes the projects list
  @override
  Future<void> refresh() async {
    debugPrint('Refreshing projects...');
    _isLoading.value = true;
    
    try {
      // Simulate refresh delay
      await Future.delayed(const Duration(seconds: 1));
      _initializeProjects();
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
    _filteredProjects.insert(0, newProject);
    
    // Success message will be shown in UI layer with custom snackbar
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
