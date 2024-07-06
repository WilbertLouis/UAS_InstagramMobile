//uploaded_image.dart

class UploadedImage {
  final String path;
  final String caption;
  int likes;
  bool isLiked;

  UploadedImage({
    required this.path,
    required this.caption,
    this.likes = 0,
    this.isLiked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'caption': caption,
      'likes': likes,
      'isLiked': isLiked,
    };
  }

  factory UploadedImage.fromJson(Map<String, dynamic> json) {
    return UploadedImage(
      path: json['path'],
      caption: json['caption'],
      likes: json['likes'],
      isLiked: json['isLiked'],
    );
  }
}
