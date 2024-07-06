import 'dart:io';
import 'dart:ui'; // tambahkan import ini
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'image_detail_page.dart';
import 'uploaded_image.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    final profileImage = UploadedImage(
      path: 'assets/gambar_pp.jpg',
      caption: 'Profile Picture',
      isLiked: false,
      likes: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile Page'),
        automaticallyImplyLeading: false, // Menghilangkan tombol back
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageDetailPage(
                                image: profileImage,
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/gambar_pp.jpg'),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wilbert Louis',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Honesty, Integrity, and Loyalty that's what we stand for.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Logout and navigate to login page
                          appState.logout();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 245, 245, 245)),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            return states.contains(MaterialState.hovered)
                                ? Colors.red
                                : Colors.black;
                          }),
                        ),
                        child: MouseRegion(
                          child: Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Post, Followers, Following stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatColumn("Post", appState.uploadedImages.length),
                      _buildStatColumn("Followers", 9999),
                      _buildStatColumn("Following", 6),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Uploaded Images:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: appState.uploadedImages.length,
              itemBuilder: (context, index) {
                final reversedIndex =
                    appState.uploadedImages.length - 1 - index;
                final image = appState.uploadedImages[reversedIndex];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailPage(
                          image: image,
                        ),
                      ),
                    );
                  },
                  child: kIsWeb
                      ? Image.network(image.path, fit: BoxFit.cover)
                      : Image.file(File(image.path), fit: BoxFit.cover),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: _buildProfileIcon(
                Icons.account_circle), // Gunakan fungsi baru untuk ikon profile
            label: 'Profile',
          ),
        ],
        currentIndex: 3, // Indeks yang sesuai dengan halaman profil
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/search');
              break;
            case 2:
              Navigator.pushNamed(context, '/upload');
              break;
            // No action needed for case 3 (Profile)
          }
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildProfileIcon(IconData icon) {
    return Icon(
      icon,
      color: Colors.black, // Mengatur warna ikon menjadi hitam
      size: 30, // Mengatur ukuran ikon sesuai kebutuhan Anda
    );
  }
}
