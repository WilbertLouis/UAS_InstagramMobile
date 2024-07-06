import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/image_detail_page.dart';
import 'package:flutter_app/upload_page.dart';
import 'package:flutter_app/uploaded_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi ke halaman lain berdasarkan indeks
    switch (index) {
      case 0:
        // Home
        break;
      case 1:
        Navigator.pushNamed(context, '/search');
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadPage(
              onPublish: _onPublish,
              onPublishImage: _onPublishImage,
            ),
          ),
        );
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  void _onPublish() {
    // Implement your publish logic here
  }

  Future<void> _onPublishImage(File file, String caption) async {
    // Implement your image publishing logic here
  }

  @override
  Widget build(BuildContext context) {
    List<String> usernames = [
      'Captain America',
      'Iron Man',
      'Thor',
      'Hulk',
      'Black Panther',
      'Deadpool'
    ];
    List<String> captions = [
      'I can do this all day!',
      'I Love you 3000',
      'You are big. I have fought bigger',
      'Dont make me angry',
      'Wakanda Forever!',
      'Never change to be accepted by others'
    ];
    List<String> fotoPaths = [
      'assets/gambar_captainamerica.jpg',
      'assets/gambar_ironman.jpg',
      'assets/gambar_thor.jpg',
      'assets/gambar_hulk.jpg',
      'assets/gambar_blackpanther.jpg',
      'assets/gambar_deadpool.jpg'
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/logo_instagram.jpg',
          height: 25,
        ),
      ),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          String fotoPath = fotoPaths[index];
          String username = usernames[index];
          String captionFoto = captions[index];
          int likes = (index + 1) * 10;
          return LikeablePost(
            fotoPath: fotoPath,
            username: username,
            captionFoto: captionFoto,
            likes: likes,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageDetailPage(
                    image: UploadedImage(
                      path: fotoPath,
                      caption: captionFoto,
                      likes: likes,
                      isLiked: false,
                    ),
                  ),
                ),
              );
            },
          );
        },
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type:
            BottomNavigationBarType.fixed, // Menampilkan label pada semua item
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        unselectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
        selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedIconTheme: IconThemeData(color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    Color iconColor = const Color.fromARGB(
        255, 92, 92, 92); // Warna default untuk ikon yang tidak dipilih
    double iconSize = 24.0; // Ukuran default untuk ikon yang tidak dipilih

    if (_selectedIndex == index) {
      // Ganti warna dan ukuran ikon yang dipilih
      iconColor = Colors.black;
      iconSize = 30.0;
    }

    return Icon(
      icon,
      color: iconColor,
      size: iconSize,
    );
  }
}

// Widget LikeablePost dan kode terkait lainnya dipertahankan

class LikeablePost extends StatefulWidget {
  final String fotoPath;
  final String username;
  final String captionFoto;
  int likes;
  final VoidCallback onPressed;

  LikeablePost({
    required this.fotoPath,
    required this.username,
    required this.captionFoto,
    required this.likes,
    required this.onPressed,
  });

  @override
  _LikeablePostState createState() => _LikeablePostState();
}

class _LikeablePostState extends State<LikeablePost> {
  bool _isLiked = false;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        widget.likes += 1;
      } else {
        widget.likes -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset(
                widget.fotoPath,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onPressed,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  icon: _isLiked
                      ? Icon(Icons.favorite, color: Colors.red)
                      : Icon(Icons.favorite_border),
                  onPressed: _toggleLike,
                ),
                SizedBox(width: 4),
                Text(
                  '${widget.likes} likes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(widget.captionFoto),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
