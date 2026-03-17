/// UserProfileModel - Response from GET /accounts/user/profile/
/// {
///   "id": 4,
///   "email": "satipog496@medevsa.com",
///   "name": "mds",
///   "is_admin": false,
///   "image": "/media/profile_images/default_avatar.png"
/// }
class UserProfileModel {
  final int id;
  final String email;
  final String name;
  final bool isAdmin;
  final String image; // relative path e.g. /media/profile_images/xxx.png

  const UserProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.isAdmin,
    required this.image,
  });

  /// Creates model from JSON response
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isAdmin: json['is_admin'] as bool? ?? false,
      image: json['image'] as String? ?? '',
    );
  }

  /// Returns full image URL using the base URL
  /// e.g. /media/profile_images/default_avatar.png
  ///    → http://10.10.7.74:8000/media/profile_images/default_avatar.png
  String fullImageUrl(String baseUrl) {
    if (image.isEmpty) return '';
    if (image.startsWith('http')) return image;
    return '$baseUrl$image';
  }

  @override
  String toString() =>
      'UserProfileModel(id: $id, email: $email, name: $name)';
}
