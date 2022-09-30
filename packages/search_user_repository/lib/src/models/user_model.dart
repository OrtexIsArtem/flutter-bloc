class UserModel {
  final String? username;
  final String? url;
  final String? images;

  UserModel({
    this.username,
    this.url,
    this.images,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      images: json['images']?['jpg']?['image_url'],
      url: json['url'],
    );
  }
}
