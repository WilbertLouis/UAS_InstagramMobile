// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'upload_page.dart';
import 'search_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(secondary: Colors.white),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/upload': (context) => UploadPage(
              onPublish: () {
                // Navigasi ke halaman profil setelah publish
                Navigator.pushNamed(context, '/profile');
              },
              onPublishImage: (image, caption) {
                Provider.of<AppState>(context, listen: false)
                    .uploadImage(image, caption);
              },
            ),
        '/profile': (context) => ProfilePage(),
        '/search': (context) => ImageSearchPage(),
      },
    );
  }
}
