// app_state.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/uploaded_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppState extends ChangeNotifier {
  String username = 'Wilbert Louis';
  List<UploadedImage> uploadedImages = [];

  AppState() {
    _loadData();
  }

  void addImage(String path, String caption) {
    uploadedImages.add(
        UploadedImage(path: path, caption: caption, isLiked: false, likes: 0));
    _saveData();
    notifyListeners();
  }

  void login(String username) {
    this.username = username;
    _saveData();
    notifyListeners();
  }

  void logout() {
    username = '';
    uploadedImages = [];
    _saveData();
    notifyListeners();
  }

  void removeImage(UploadedImage image) {
    uploadedImages.remove(image);
    _saveData();
    notifyListeners();
  }

  void toggleLike(UploadedImage image) {
    image.isLiked = !image.isLiked;
    image.likes += image.isLiked ? 1 : -1;
    _saveData();
    notifyListeners();
  }

  void uploadImage(File image, String caption) {
    final newImage = UploadedImage(
      path: kIsWeb ? image.path : image.path.replaceAll('/', '\\'),
      caption: caption,
      isLiked: false,
      likes: 0,
    );
    uploadedImages.add(newImage);
    _saveData();
    print('Gambar diunggah: ${newImage.path}');
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('uploadedImages',
        jsonEncode(uploadedImages.map((image) => image.toJson()).toList()));
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? 'Wilbert Louis';
    final imagesJson = prefs.getString('uploadedImages') ?? '[]';
    uploadedImages = (jsonDecode(imagesJson) as List)
        .map((data) => UploadedImage.fromJson(data))
        .toList();
    notifyListeners();
  }
}
