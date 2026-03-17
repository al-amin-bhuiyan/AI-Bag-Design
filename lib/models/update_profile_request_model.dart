/// UpdateProfileRequestModel - Request body for PATCH /accounts/user/profile/
/// Supports partial update (name/email only, or with image)
class UpdateProfileRequestModel {
  final String? name;
  final String? email;

  const UpdateProfileRequestModel({
    this.name,
    this.email,
  });

  /// Converts to JSON for PATCH without image
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (name != null && name!.isNotEmpty) json['name'] = name;
    if (email != null && email!.isNotEmpty) json['email'] = email;
    return json;
  }

  /// Converts to form fields for multipart PATCH (with image)
  Map<String, String> toFormFields() {
    final Map<String, String> fields = {};
    if (name != null && name!.isNotEmpty) fields['name'] = name!;
    if (email != null && email!.isNotEmpty) fields['email'] = email!;
    return fields;
  }

  @override
  String toString() =>
      'UpdateProfileRequestModel(name: $name, email: $email)';
}
