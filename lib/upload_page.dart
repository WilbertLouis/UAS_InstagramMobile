import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  final VoidCallback onPublish;
  final Function(File image, String caption) onPublishImage;

  UploadPage({required this.onPublish, required this.onPublishImage});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _image;
  final TextEditingController _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isPublishing = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _publish(BuildContext context) {
    if (_image != null) {
      setState(() {
        _isPublishing = true;
      });
      widget.onPublishImage(_image!, _captionController.text);
      // Simulate a delay for demonstration purposes
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushNamed(
            context, '/profile'); // Navigate to profile page after publishing
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please choose an image first')),
      );
    }
  }

  Widget _buildIcon(IconData icon, int index) {
    double iconSize = index == 2 ? 30.0 : 24.0;
    Color? iconColor = index == 2 ? Colors.black : Colors.grey[700];

    return Icon(
      icon,
      color: iconColor,
      size: iconSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _image == null
                ? Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Icon(Icons.image, size: 100, color: Colors.grey),
                    ),
                  )
                : Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: kIsWeb
                            ? NetworkImage(_image!.path)
                            : FileImage(_image!) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            SizedBox(height: 20),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Write a caption...',
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            _isPublishing
                ? CircularProgressIndicator() // Show a loading indicator while publishing
                : ElevatedButton(
                    onPressed: () {
                      if (_image != null) {
                        _publish(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Please choose an image first')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      foregroundColor: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text('Publish', style: TextStyle(fontSize: 16)),
                  ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300], // Background color
                foregroundColor: Colors.black, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('Choose Image From Gallery',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home, 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.search, 1),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.camera_alt, 2),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.account_circle, 3),
            label: 'Profile',
          ),
        ],
        currentIndex: 2, // Indeks diatur ke 2 untuk halaman upload
        onTap: (index) {
          setState(() {});
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/search');
              break;
            case 2:
              // Tetap di halaman upload
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        type:
            BottomNavigationBarType.fixed, // Menampilkan label untuk semua item
      ),
    );
  }
}
