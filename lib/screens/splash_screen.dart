import 'package:flutter/material.dart';
import 'package:rakbuku/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
          ),
          (route) => false);
    });
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/backround.png',
            fit: BoxFit.cover, // Agar background memenuhi layar
            width: double.infinity, // Mengambil seluruh lebar layar
            height: double.infinity, // Mengambil seluruh tinggi layar
          ),
          SafeArea(
            child: Center( // Menempatkan konten di tengah layar
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center, // Menyelaraskan konten ke tengah secara vertikal
                crossAxisAlignment: CrossAxisAlignment.center, // Menyelaraskan konten ke tengah secara horizontal
                children: [
                  const SizedBox(
                    height: 150, // Jarak antara atas layar dan gambar
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icon-buku.png',
                      ),
                      Positioned(
                        top: 114,
                        child: Image.asset(
                          'assets/images/text-rakbuku.png',
                          width: 173,
                          height: 65,
                        ) 
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}