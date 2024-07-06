//image_detail_page.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app_state.dart';
import 'package:flutter_app/uploaded_image.dart';
import 'package:provider/provider.dart';

class ImageDetailPage extends StatelessWidget {
  final UploadedImage image;

  ImageDetailPage({required this.image});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Image'),
        actions: [
          Tooltip(
            message: 'Delete Post',
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                appState.removeImage(image);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: kIsWeb
                ? Image.network(image.path,
                    fit: BoxFit.cover, width: double.infinity)
                : Image.file(File(image.path),
                    fit: BoxFit.cover, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              image.caption,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    image.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: image.isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    appState.toggleLike(image);
                  },
                ),
                Text('${image.likes} likes'),
                IconButton(
                  icon: Icon(Icons.comment_outlined),
                  onPressed: () {
                    // Logic for comment button
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share_outlined),
                  onPressed: () {
                    // Logic for share button
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
