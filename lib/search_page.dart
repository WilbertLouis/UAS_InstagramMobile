import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/home_page.dart'; // Import halaman-halaman lain
import 'package:flutter_app/upload_page.dart';
import 'package:flutter_app/profile_page.dart';

class ImageSearchPage extends StatefulWidget {
  @override
  _ImageSearchPageState createState() => _ImageSearchPageState();
}

class _ImageSearchPageState extends State<ImageSearchPage> {
  List images = [];
  bool isLoading = false;
  final Dio _dio = Dio();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    // Anda dapat menambahkan logika lebih lanjut di sini jika diperlukan
  }

  Future<void> fetchImages(String query) async {
    if (query.isEmpty) {
      _showErrorDialog('Silakan masukkan istilah pencarian.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        'https://api.unsplash.com/search/photos',
        queryParameters: {'query': query, 'per_page': 30},
        options: Options(
          headers: {
            'Authorization':
                'Client-ID IqqUPfLdueqsh_hcaKaiQAUlsyMrmDmtqe5Uc6zzOl8',
          },
        ),
      );

      await Future.delayed(Duration(seconds: 1)); // Simulasi delay 1 detik

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['results'] != null) {
        setState(() {
          images = response.data['results'];
          isLoading = false;
        });
      } else {
        setState(() {
          images = [];
          isLoading = false;
        });
        _showErrorDialog(
            images.isEmpty ? 'Tidak ada gambar ditemukan' : 'Error');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    Color? iconColor = index == 1 ? Colors.black : Colors.grey[700];

    return Icon(
      icon,
      color: iconColor,
      size: index == 1 ? 30 : 24, // Ukuran ikon berbeda untuk indeks 1 (search)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Images'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 233, 205, 26),
                        Color.fromARGB(255, 255, 84, 66),
                        Color.fromARGB(255, 233, 205, 26),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(1.5), // Width of the gradient border
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              fetchImages(value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            fetchImages(_searchController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : images.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text('No images found'),
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    imageUrl: images[index]['urls']['regular'],
                                    userName: images[index]['user']['name'],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Hero(
                                        tag: images[index]['id'],
                                        child: Image.network(
                                          images[index]['urls']['small'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(12.0),
                                          ),
                                          color: Colors.black54,
                                        ),
                                        child: Text(
                                          'Photo by ${images[index]['user']['name']}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ],
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
        currentIndex: 1,
        onTap: (index) {
          setState(() {});
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              // Tetap di halaman pencarian
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
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onPublish() {
    // Implementasikan logika publish Anda di sini
  }

  Future<void> _onPublishImage(File file, String caption) async {
    // Implementasikan logika publikasi gambar Anda di sini
  }
}

class DetailPage extends StatelessWidget {
  final String imageUrl;
  final String userName;

  const DetailPage({Key? key, required this.imageUrl, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Photo Detail'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: imageUrl,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.black54,
              child: Text(
                'Photo by $userName',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: '/search',
    routes: {
      '/home': (context) => HomePage(),
      '/search': (context) => ImageSearchPage(),
      '/upload': (context) => UploadPage(
            onPublish: () {
              // Define the onPublish function
            },
            onPublishImage: (file, caption) {
              // Define the onPublishImage function
              return Future.value(); // Placeholder return value
            },
          ),
      '/profile': (context) => ProfilePage(), // Define the ProfilePage
    },
  ));
}
